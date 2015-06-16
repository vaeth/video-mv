#!/bin/sh
# (C) Martin V\"ath <martin@mvath.de>
# Helper code for dvb-t, sleepto, video{,encode,record}.{mplayer,ffmpeg}
# This script is sourced; the first line is only for editors

set -f

Echo() {
	printf '%s\n' "$*"
}

Verbose() {
	Echo "# $*"
}

Message() {
	Echo "${0##*/}: $*" >&2
}

Warning() {
	Message "warning: $*"
}

Exit() {
	trapret=${1:-$?}
	exit $trapret
}

Fatal() {
	Message "error: $*"
	Exit 1
}

Push() {
	. push.sh
	Push "$@"
}

MyExec() {
	if $verbose || $showonly
	then	Push -c myexec "$@"
		Echo "$myexec"
		! $showonly || return 0
	fi
	"$@"
}

SourceDefaults() {
	if test -r /etc/videodefaults
	then	. /etc/videodefaults
	else	. videodefaults
	fi
}

Calc_cs_sec() {
	cs_arg=${1%%:*}
	while :
	do	case $cs_arg in
		0*)
			cs_arg=${cs_arg#0}
			continue;;
		esac
		break
	done
	if [ "${cs_arg:-0}" -ne 0 ]
	then	[ $# -eq 1 ] || cs_arg=$(( $cs_arg * $2 ))
		cs_sec=$(( $cs_sec + $cs_arg ))
	fi
	unset cs_arg
}

CalcSeconds() {
	cs_sec=${2:-0}
	case $2 in
	*:*)
		cs_sec=0
		cs_cur=$2':'
		Calc_cs_sec "$cs_cur" 3600
		cs_cur=${cs_cur#*:}
		Calc_cs_sec "$cs_cur" 60
		cs_cur=${cs_cur#*:}
		Calc_cs_sec "$cs_cur"
	esac
	eval $1=\$cs_sec
	unset cs_cur cs_sec
}

TitleOpt() {
	case $titleopt in
	*[!pPfHsS-]*)
		Usage;;
	esac
}

Title() {
Title() {
:
}
	case $titleopt in
	*-*)	return;;
	esac
	command -v title >/dev/null 2>&1 || return 0
TitleVerbose() {
:
}
	trapret=130
TitleTrap() {
	trap : EXIT HUP INT TERM
	TitleVerbose
	trap - EXIT HUP INT TERM
	exit $trapret
}
	trap TitleTrap EXIT HUP INT TERM
TitleInit() {
. title "$@"
}
	TitleInit ${titleopt:+"-$titleopt"} -- "$@"
}

titleopt=
trapret=
