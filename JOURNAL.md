2021/12/02
----------

So the question is: what am I trying to do right now?
I want to FINISH fucking with xferase. There are three different tasks at hand:

1. Debug the video corruption problem.
2. Rewrite `bin/xferase` to use the Photein ruby class internally,
   rather than invoking a system subprocess. (And to eliminate the staging
   directory!)
3. Document a Very Big Bug.

### The video corruption problem

STATUS: Done?

The bug appears to originate upstream: video files are written to disk _as
they’re being taken,_ and right around the 44MB mark, Syncthing renames the
tempfile as the permanent/destination file. (Not sure why it does this, but it
appears to be a deliberate design choice on Syncthing’s part).

This triggers the `IN_CLOSE_WRITE` inotify event that causes xferase’s
premature import, which then borks the whole process. One potential (brittle)
fix would be to hold off on importing any files if a corresponding
`.syncthing.{filename}.tmp` file is present alongside the finished file.
Honestly, this seems to be the most direct way to interrogate syncthing as to
the completion status of the filesync without calling out to the REST API.

Ultimately, what do I want to do? I want to know exactly when a file is
finished being written so that Xferase can get straight to work processing
it. The current approach is to detect `IN_CLOSE_WRITE` inotify events, which
works 100% of the time for images and not very well for videos.

Is there a better way than inotify? The only other way I can think is to poll
the syncthing REST API, which sounds like a terrible idea—the configuration
required to make that work (especially for other users) seems insanely
complex.

So the solution is to refrain from importing files that still have a
corresponding tempfile.

#### Bonus: What happens when an image is no longer present by import time?

Use `files.select(&File.method(:exist?))`

### Rewrite `/bin/xferase` to use the Photein ruby class internally

STATUS: Done

### A Very Big Bug

STATUS: Redacted

It appears the following entry was completely incorrect.
(Reproduce and verify your claims before committing them to writing next time!)

> ~~If you so much as EDIT an image on one machine, syncthing will handle it by
> replacing the file on synced remotes. Xferase will see the disappearance of
> that file, which will trigger the deletion of the corresponding image in the
> alternate library, which will then trigger the re-deletion of the newly edited
> image in the original library.~~
> 
> ~~What to do?~~

2021/12/07
----------

Status: Done

So now I want to get rid of the staging directory. My primary insight here is
to import to both libraries _simultaneously_ using threads. This is tricky
with Photein, because presently, the whole interface to photein is wrapped up
as

    [desktop, web].each do |target_library|
      Photein::Config.set(...)
      Photein.run
    end

I could parallelize this, but then it’d just be _batch_ importing in parallel,
when what I really want to do is import _individual files_ in parallel.

> #### Scratch this—there might be a better way...
>
> This means that in order to make this work, xferase needs to pull the curtain
> back on what Photein does even further. And to make that work, Photein has to
> expose access to its configuration more than it previously had.
> 
> Where before, destination directories and optimization levels were global
> configuration parameters, now, `MediaFile#import` must be able to accept such
> arguments on a per-invocation basis.

What if Photein were built to accept multiple destination directories? Like:

    $ photein --source=<...> --master-library=<...> --web-library=<...>

Then, we could even _simplify_ the Xferase code as:

    Photein::Config.set(...)
    Photein.run

Let photein handle the parallelization.
