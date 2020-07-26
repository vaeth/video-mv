# video-mv

(C) Martin Väth (martin at mvath.de).
This project is under the BSD license 2.0 (“3-clause BSD license”).
SPDX-License-Identifier: BSD-3-Clause

Frontends for using __mplayer__/__mencoder__, __ffmpeg__/__libav__, or
__tzap__/__czap__ as video recorder.

The POSIX scripts `video{,encode}.{mplayer,ffmpeg}` are wrappers for
__mplayer__/__mencoder__ __ffmpeg__/__libav__ to record from TV or
to improve the encoding (in possibly several passes), respectively.

In addition there are the scripts `sleepto` and `videorecord.{mplayer,ffmpeg}`
which can help you to start `video.{mplayer,ffmpeg}` at an appropriate time.

Finally, there is a `dvb-t`/`dvb-c` script which allows you to start
__tzap__/__czap__ at an appropriate time with appropriate options.

### Usage

To get help, run in a shell e.g.

-	`video.mplayer -\?` (`-h` is reserved for _hue_)
-	`videoencode.mplayer -h`
-	`videorecord.mplayer -h`
-	`dvb-t -h`
-	`dvb-c -h`
-	`sleepto -h`

### zsh completion

If you use `dvb-t`/`dvb-c` with completion,
I recommend to enable case-insensitive matching in __zsh__ by putting the line

`zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'`

into your `~/.zshrc`.

### Requirements

You need `push.sh` from https://github.com/vaeth/push (v2.0 or newer)
in your `$PATH`.
If you want that the hard status line is set, also the `title` script from
https://github.com/vaeth/runtitle (version >=2.3) is required in your `$PATH`.

Since v15.0, a patched czap is supported which can directly output to a file.
The corrsponding patch can be found here:
https://github.com/vaeth/portage-env-mv/raw/master/env/patches/linuxtv-dvb-apps-czap-record.patch
This is safer than the previous workaround to run a cat command.
The script will autodetect whether the patch is available.
Option -P or the poorman variable in etc/videodefaults can be used to force
the old behaviour. Setting poorman=false can be set to skip the test.

### Installation

To install these scripts simply copy the content of bin into your `$PATH`
and the content of `etc` into `/etc` or also into your `$PATH`.
The latter is supposed to be modified to the defaults which you want
(e.g. matching your hardware).
To obtain support for __zsh completion__, you can copy the content of zsh/
into a directory of your zsh's `$fpath`.

For Gentoo, there is an ebuild in the mv overlay (available over layman).
