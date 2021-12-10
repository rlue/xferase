# 2. Remove Staging Directory

Date: 2021-12-09

## Status

Completed

## Context

> The objective of the change described herein
> is to simplify/refine the approach described in ADR #1.

ADR #1 laid out a plan to replace the staging directory with a crash log
under an assumption that photein could only import media files sequentially
(_i.e.,_ one after another):
if the program crashes after a file has been imported to the master library
but before it has been imported to the web library,
Xferase needs some record of its progress to recover from that crash
and know which files still need to be imported to which libraries.

## Decision

Upon further consideration, the author opted to improve Photein
to enable parallel processing/import of individual files
to minimize this potential window of failure
and dispense with the implementation of a crash log entirely.

## Consequences

Previously, the design of the program was to batch-import a set of new files
first to the desktop library, and then to the web library.
The new design imports each individual file as it is detected,
and imports to both libraries simultaneously in separate threads.

Thus, there is still a potential window of failure
that could result in a state requiring manual intervention to recover from.
However, this window is significantly reduced over the previous case,
and no record exists of a program crash occurring _during_ import/encoding.
(Typically, in the past, program crashes would occur
when invalid media files appeared/were transferred to the staging directory.)

This significantly simplifies the design of the program
over the previous design plan.
