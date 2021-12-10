# 1. Replace Staging Directory with Crash Log

Date: 2021-07-23

## Status

Superseded

## Context

> The objective of the change described herein
> is to eliminate the need for a **staging directory**.

Xferase calls out to Photein as a third-party CLI program.
As a result, it can only batch-import files on a per-folder basis;
it does not have the fine-grained control to import individual files.

This becomes problematic with two separate libraries (master & web-optimized).
We have to invoke Photein twice (once for each target library);
if the contents of the inbox change from one invocation to the next,
how do we decide which files to delete after import, and when?
If the program terminates prematurely (_e.g.,_ due to a power outage),
how should we resume import when it’s re-launched?

Currently, we handle this problem by using a **staging directory**:
files are duplicated to `desktop/` and `web/` subdirectories therein
and then removed from the inbox;
these subdirectories are used as distinct/separate sources
when invoking Photein to import them into the library.

These directories are then the single-source-of-truth
about which files have been imported to which libraries, but this design
presents two problems:

1. Photos & videos can disappear from the inbox well before import is complete.

   For instance, I might record a 2-min. video that is uploaded to the inbox,
   transferred to staging (and thus deleted from my phone),
   and stuck in a queue for transcoding for the next hour.
   During this time, I can’t access the video that I just shot.

2. It impedes usability.

   Setting up Xferase requires four separate guides in addition to the README.
   Requiring a staging directory (and having to explain what it’s for)
   is a small inconvenience,
   but complexities like this have a compounding deterrent effect on adoption.

## Decision

To eliminate the staging directory, Xferase will be rewritten in two ways:

1. Rather than invoking Photein as a system binary,
   it will use the native Ruby `Photein` module.
2. It will maintain a transient log of program activity
   that can be read when recovering from a crash
   to resume a partial import.
   This log will be deleted after each successful import.

## Consequences

This change should improve the UI and UX of Xferase
at the cost of an increased risk of bugs.

A staging directory is a more foolproof way of resuming from a crash,
but its associated difficulties are significant enough to warrant this change.
The complexity of implementing a program-readable crash log
could introduce bugs, and **testing could be onerous**.
(Xferase uses threads and inotify to detect FS changes,
trying to reproduce bugs in tests will be tricky due to race conditions etc.)

Xferase will now depend on the internal (native Ruby) interface of Photein.
(Not a problem, since they are both maintained by the same individual.)

It will also need to store files on the system
(likely just a single SQLite .db file,
which can be deleted after each successful import).
If this file is deleted between crash and recovery,
it will be impossible to complete the import without manual intervention.
