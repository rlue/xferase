🔀ferase
========

All your photos under one roof.
-------------------------------

Xferase is an always-on background service
that automatically imports pictures & videos
into your personal photo library as they come in.

When combined with other software,
it can be used as a kind of self-hosted / DIY alternative
to cloud photo services like Google Photos or iCloud.

Why?
----

My photo library has always been a hot mess.
I have photos from my cell phone, photos from my digital camera,
and photos I’ve gotten from other people.
Some live in the cloud, some live on my cell phone, some live on my laptop,
some live on a backup drive in my shoe closet,
and others will sit on my digital camera’s SD card for a couple weeks
before I remember that I wanted to share them with someone.

I got tired of taking lots of photos
and then having to look in three places to find the ones I wanted.
I just wanted my old photos to live in the same place as my new photos,
plus a few other modest requirements:

1. **automatic photo import** from any source[\*](#caveat)

   > “Automatic” means no mouse/keyboard interaction:
   >
   > * 📱 **cell phone** pictures get imported as soon as they’re taken;
   > * 💬 **chat app** downloads, as soon as they’re saved;
   > * 📷 **digital camera** pictures, as soon as it’s plugged into USB.

2. master copy of library **stored locally, on disk**

   > My digital photo/video library belongs to _me._
   > But if I don’t own the pipeline for storing and managing it,
   > then does it really? 🤔
   >
   > Cloud services can raise their prices, go offline,
   > or fall victim to ransomware attacks.
   > My own Internet can fail, too.
   > I’m happy to use the cloud for Netflix & Spotify,
   > but for something as personal and unreplaceable as my photos,
   > I want the master copy in my own hands.

3. automatic syncing of library back to phone[\*](#caveat)

   > Obviously, I don’t just want to _collect_ my personal photos;
   > I want to _use_ them, and to have them with me wherever I go.
   > But your complete photo collection is probably
   > too large to fit on your cell phone,
   > which is why Google and Apple host it in the cloud.
   >
   > Xferase gets around this
   > by maintaining two parallel copies of your library:
   > one master, and one optimized for web.
   > Keep both on your computer and sync the latter to your phone;
   > Xferase will make sure that when a photo is deleted from one,
   > it’s automatically removed from the other, too.

4. clean, consistent, **user-visible directory & filename scheme**

   > Call me obsessive-compulsive, but which would you rather have—
   >
   > ```sh
   > # this?                                 # ...or this?
   >
   > ~/Pictures                              ~/Pictures
   > ├── 1619593208911.jpeg                  ├── 2020
   > ├── DCIM                                │   ├── 2020-08-01_113129.heic
   > │   └── 2021_03_26                      │   └── 2020-05-20_160209.png
   > │       ├── R0014285.MOV                └── 2021
   > │       ├── R0014286.DNG                    ├── 2021-02-12_081933a.jpg
   > │       ├── R0014286.JPG                    ├── 2021-02-12_081933b.jpg
   > │       ├── R0014287.DNG                    ├── 2021-02-12_081939.mp4
   > │       └── R0014287.JPG                    ├── 2021-03-26_161245.mp4
   > ├── IMG_20210212_081933_001.jpg             ├── 2021-03-26_161518.dng
   > ├── IMG_20210212_081933_002.jpg             ├── 2021-03-26_161518.jpg
   > ├── IMG_8953.HEIC                           ├── 2021-03-26_170304.dng
   > ├── Screenshot_20200520_160209.png          ├── 2021-03-26_170304.jpg
   > └── VID_20210212_081939.mp4                 └── 2021-04-28_000008.jpg
   > ```
   >
   > I also want to know where my files are
   > so I can find them in a “Browse...” dialog
   > or mirror them to other devices with Dropbox, Syncthing, or even rsync.

5. available on Linux

   > Xferase has not been tested on macOS,
   > but it should work when run in a Docker container.

#### \*Caveat

For points 1 and 3, Xferase needs the help of additional software
([Syncthing][] & systemd).
If you have no experience (or interest in) tinkering with Linux,
Xferase is **not** for you.

See the next section for more details.

[Syncthing]: https://syncthing.net

What _Exactly_ Does It Do?
--------------------------

Xferase watches a directory of your choosing (its “inbox”),
and whenever any files are placed there,
it automatically optimizes and imports them into your photo library,
like so:

```sh
# Before                                # After

~/Pictures                              ~/Pictures
├── .inbox                              ├── .inbox
│   ├── 1619593208911.jpeg              └── library
│   ├── DCIM                                ├── 2020
│   │   └── 2021_03_26                      │   ├── 2020-08-01_113129.heic
│   │       ├── R0014285.MOV                │   └── 2020-05-20_160209.png
│   │       ├── R0014286.DNG                └── 2021
│   │       ├── R0014286.JPG                    ├── 2021-02-12_081933a.jpg
│   │       ├── R0014287.DNG                    ├── 2021-02-12_081933b.jpg
│   │       └── R0014287.JPG                    ├── 2021-02-12_081939.mp4
│   ├── IMG_20210212_081933_001.jpg             ├── 2021-03-26_161245.mp4
│   ├── IMG_20210212_081933_002.jpg             ├── 2021-03-26_161518.dng
│   ├── IMG_8953.HEIC                           ├── 2021-03-26_161518.jpg
│   ├── Screenshot_20200520_160209.png          ├── 2021-03-26_170304.dng
│   └── VID_20210212_081939.mp4                 ├── 2021-03-26_170304.jpg
└── library                                     └── 2021-04-28_000008.jpg
```

(You may have noticed that this is identical to the snippet from above,
except for the `.inbox` and `library` parent directories.)

How you get those files from your phone or camera into the inbox is up to you.

> ### 🤷 Up to me?? I thought Xferase was supposed to “import from many sources”.
>
> Yes, but only with the help of other software.
> Automatically getting files from other devices onto your computer
> is not a trivial problem,
> and there are existing utilities that already do it better than Xferase could.
>
> Consider that different users may have a different technical requirements:
>
> * Should digital camera photos be transferred over USB,
>   or using a Wi-Fi SD card?
> * Should cell phone photos be transferred over cellular data,
>   or only over Wi-Fi?
> * How many other devices should the library be mirrored/synced to?
>
> Limiting the scope of what Xferase does
> gives you the flexibility to use the best available tools
> for your needs, every step of the way.
>
> Here is a diagram outlining the recommended approach:
>
> <img src="/i/system-diagram.gif" width="480">
>
> For more on each step, see the [guides](#guides) below.

Quick Start
-----------

> 💡 **The examples below assume you have [Docker][] installed.**
>
> Why use Docker? Xferase can be [installed natively as a Ruby gem][],
> but there are lots of external dependencies.
>
> [Docker]: https://docs.docker.com/get-docker/
> [installed natively as a Ruby gem]: guides/ingest.md#option-2-rubygems--systemd

### Basic Usage

```sh
$ docker run -d \
    --name xferase \
    --user $(id -u):$(id -g) \
    --env TZ=$(timedatectl show --property=Timezone --value) \
    --volume $HOME/Pictures:/data \
    --env INBOX=/data/_inbox \
    --env LIBRARY=/data/master \
    --env HOME=/tmp \ # hotfix for https://github.com/janfri/mini_exiftool/issues/51
    rlue/xferase
```

Any photos or videos placed in the **inbox**
will be automatically moved to the **library**,
with videos being compressed to save space on disk.

#### Option: `LIBRARY_WEB`

```sh
$ docker run -d \
    --name xferase \
    --user $(id -u):$(id -g) \
    --env TZ=$(timedatectl show --property=Timezone --value) \
    --volume $HOME/Pictures:/data \
    --env INBOX=/data/.inbox \
    --env LIBRARY=/data/master \
    --env LIBRARY_WEB=/data/web \
    --env HOME=/tmp \ # hotfix for https://github.com/janfri/mini_exiftool/issues/51
    rlue/xferase
```

Xferase will create a separate, lo-res copy of each imported file
and save it to the **web-optimized library**.

**Xferase keeps both libraries in sync**,
meaning that when a photo is deleted from one,
it will be automatically deleted from the other.

> ⚠️ **Warning**
>
> This also applies to copies of the same image in different formats:
> if you shoot RAW+JPEG, deleting a .jpg will cause Xferase to delete the
> corresponding raw image file (and vice versa).

#### Better yet: Using Docker Compose

With [Docker Compose][], you can store your deployment parameters
in a static configuration file:

```yaml
# docker-compose.yml

version: '3.4'

services:
  xferase:
    image: rlue/xferase:latest
    container_name: xferase
    user: 1000:1000
    environment:
      TZ: America/Los_Angeles
      INBOX: /data/.inbox
      LIBRARY: /data/master
      LIBRARY_WEB: /data/web
      HOME: /tmp # hotfix for https://github.com/janfri/mini_exiftool/issues/51
    volumes:
      - $HOME/Pictures:/data
    restart: unless-stopped
```

[Docker Compose]: https://docs.docker.com/compose/

Guides
------

### 1. Upload (with systemd/Syncthing)

* [📷➡️🖥️ Get photos from your camera into Xferase’s inbox](guides/upload-camera.md)
* [📱➡️🖥️ Get photos from your phone into Xferase’s inbox](guides/upload-phone.md)

### 2. Ingest (with Xferase)

* [🖼️➡️📂 Rename, optimize, and move new photos into your library](guides/ingest.md)

### 3. Propagate (with Syncthing)

* [🖥️🔄📱 Sync your library (back) to other devices](guides/propagate.md)

Bonus Features
--------------

Whenever you’re shooting on devices that need their clocks set manually,
the timestamps on all your stuff can end up out of whack. For instance:

* I often forget to adjust the clock on my camera when DST changes,
  or when I fly across time zones.
  In these cases, you will want to **shift timestamps**
  by some fixed number of hours.

  To apply this change automatically during import,
  simply place your files in a directory named `shift-timestamp:<n>h`
  (where `<n>` is an integer number of hours to shift by; _e.g.,_ `4` or `-8`).

* Video timestamps should always be in UTC,
  while photo timestamps should always be in local time.
  (Don’t ask me for a source on this one;
  supposedly it’s in the EXIF and MP4/MOV specs, which I don’t have access to,
  but this fact is repeated all over the place on the Exiftool forums.)

  If your camera doesn’t have GPS capabilities
  or any other way of knowing what time zone it’s in,
  your video timestamps will _not_ be in UTC.
  In these cases, you will want to **backfill the missing time zone data**.

  To apply this change automatically during import,
  simply place your files in a directory named `local-tz:<timezone>`
  (where `<timezone>` is a [valid IANA time zone][], with colons in place of slashes;
  _e.g.,_ `America:Argentina:Buenos_Aires` or `Asia:Calcutta`).

  Xferase is smart enough to make the right adjustments when you do this:
  metadata timestamps will be set to UTC, and filename timestamps will be set to local time.

  [valid IANA time zone]: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List

To apply both changes, simply nest the folders within each other.
If multiple conflicting directories are found,
Xferase will use the one nearest to the file being imported.

License
-------

© 2021 Ryan Lue. This project is licensed under the terms of the MIT License.
