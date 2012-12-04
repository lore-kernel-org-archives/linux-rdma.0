From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Tue, 4 Dec 2012 08:33:24 -0800
Message-ID: <CAGH67wRNMpLnkw2OcTYt6gNxvyMTgV0hk7Ti_630rWZej=7KDQ@mail.gmail.com>
References: <1354566498-8364-1-git-send-email-jonstanley@gmail.com>
	<20121203223547.GA3410@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121203223547.GA3410-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 3, 2012 at 2:35 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Dec 03, 2012 at 03:28:18PM -0500, Jon Stanley wrote:
>> Future release of Fedora are going to remove /etc/sysconfig/network
>> which we source to get $HOSTNAME. Bash (and sh) set $HOSTNAME in
>> the shell by default, so we should be safe to use that here. This
>> adds the benefit of working across multiple distributions if that
>> is required in the future.
>
> This looks like it is a bashism (ie dash does not do this), so you
> should update the #! to use /bin/bash not /bin/sh...
>
> $ HOSTNAME= /bin/dash
> \h{\u}\w#echo $HOSTNAME
>
> \h{\u}\w#

    Good catch! I forgot about this important subtlety between bash
and the rest of the bourne shells (I'll need to verify that I didn't
leave any "dangling bashisms" in my last patch).
Thanks!
-Garrett

$ set
BASH=/usr/local/bin/bash
BLOCKSIZE=K
EDITOR=vim
ENV=/usr/home/gcooper/.shrc
HOME=/usr/home/gcooper
IFS='
'
LOGNAME=gcooper
MAIL=/var/mail/gcooper
OPTIND=1
P4CLIENT=gcooper-bayonetta
P4PORT=perforce.freebsd.org:1666
P4USER=gcooper
PAGER=more
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/home/gcooper/bin
PPID=9754
PS1='$ '
PS2='> '
PS4='+ '
PWD=/usr/home/gcooper
SHELL=/bin/sh
SHLVL=1
SSH_CLIENT='192.168.20.1 45753 22'
SSH_CONNECTION='192.168.20.1 45753 192.168.20.2 22'
SSH_TTY=/dev/pts/10
TERM=screen
USER=gcooper
_=set
$ bash -c set
BASH=/usr/local/bin/bash
BASHOPTS=cmdhist:colonbreakswords:extquote:force_fignore:hostcomplete:interactive_comments:progcomp:promptvars:sourcepath
BASH_ALIASES=()
BASH_ARGC=()
BASH_ARGV=()
BASH_CMDS=()
BASH_EXECUTION_STRING=set
BASH_LINENO=()
BASH_SOURCE=()
BASH_VERSINFO=([0]="4" [1]="2" [2]="37" [3]="0" [4]="release"
[5]="amd64-portbld-freebsd9.1")
BASH_VERSION='4.2.37(0)-release'
BLOCKSIZE=K
DIRSTACK=()
EDITOR=vim
ENV=/usr/home/gcooper/.shrc
EUID=1000
GROUPS=()
HOME=/usr/home/gcooper
HOSTNAME=bayonetta.local
HOSTTYPE=amd64
IFS=$' \t\n'
LOGNAME=gcooper
MACHTYPE=amd64-portbld-freebsd9.1
MAIL=/var/mail/gcooper
OPTERR=1
OPTIND=1
OSTYPE=freebsd9.1
P4CLIENT=gcooper-bayonetta
P4PORT=perforce.freebsd.org:1666
P4USER=gcooper
PAGER=more
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/home/gcooper/bin
PPID=9758
PS4='+ '
PWD=/usr/home/gcooper
SHELL=/usr/local/bin/bash
SHELLOPTS=braceexpand:hashall:interactive-comments
SHLVL=2
SSH_CLIENT='192.168.20.1 45753 22'
SSH_CONNECTION='192.168.20.1 45753 192.168.20.2 22'
SSH_TTY=/dev/pts/10
TERM=screen
UID=1000
USER=gcooper
_=set
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
