#!/bin/sh
# (C) Martin V\"ath <martin@mvath.de>
# Helper code for dvb-t, sleepto, video{,encode,record}.{mplayer,ffmpeg}
# This script is sourced; the first line is only for editors

set -f

Echo() {
	printf '%s\n' "${*}"
}

Verbose() {
	Echo "# ${*}"
}

Message() {
	Echo "${name}: ${*}" >&2
}

Warning() {
	Message "warning: ${*}"
}

Exit() {
	trapret=${1:-${?}}
	exit ${trapret}
}

Fatal() {
	Message "error: ${*}"
	Exit 1
}

Push() {
	. push.sh
	Push "${@}"
}

MyExec() {
	if ${verbose} || ${showonly}
	then	Push -c myexec "${@}"
		Echo "${v}"
		! ${showonly} || return 0
	fi
	"${@}"
}

SourceDefaults() {
	if test -r /etc/videodefaults
	then	. /etc/videodefaults
	else	. videodefaults
	fi
}

CalcSeconds() {
	cs_sec=${2:-0}
	case ${2} in
	*:*)
		cs_cur=${2}':'
		cs_arg=${cs_cur%%:*}
		cs_sec=$(( ${cs_arg:-0} * 3600 ))
		cs_cur=${cs_cur#*:}
		cs_arg=${cs_cur%%:*}
		cs_sec=$(( ${cs_arg:-0} * 60 + ${cs_sec} ))
		cs_cur=${cs_cur#*:}
		cs_arg=${cs_cur%%:*}
		cs_sec=$(( ${cs_arg:-0} + ${cs_sec} ));;
	esac
	eval ${1}=\${cs_sec}
	unset cs_cur cs_arg cs_sec
}

TitleOpt() {
	case ${titleopt} in
	*[!pPfHsS-]*)
		Usage;;
	esac
}

Title() {
Title() {
:
}
	case ${titleopt} in
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
	exit ${trapret}
}
	trap TitleTrap EXIT HUP INT TERM
TitleInit() {
. title "${@}"
}
	TitleInit ${titleopt:+"-${titleopt}"} -- "${@}"
}

titleopt=
trapret=
