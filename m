From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iwpmd init script does not work on Debian
Date: Wed, 10 May 2017 09:26:21 -0600
Message-ID: <20170510152621.GA1007@obsidianresearch.com>
References: <1494420825.3739.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494420825.3739.4.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 10, 2017 at 02:53:45PM +0200, Benjamin Drung wrote:
> Hi,
> 
> the iwpmd init script specifies:
> 
> if [ -f "/etc/redhat-release" ]; then
>         . /etc/rc.d/init.d/functions
>         STARTD=daemon
>         STOPD=killproc
>         STATUSD=status
>         GETPID=/sbin/pidof
> 
> elif [ -f "/etc/SuSE-release" ]; then
>         . /lib/lsb/init-functions
>         STARTD=start_daemon
>         STOPD=killproc
>         STATUSD=/sbin/checkproc
>         GETPID=/sbin/pidofproc
> fi
> 
> This does not work on Debian/Ubuntu. You can source /lib/lsb/init-
> functions which provides the functions start_daemon, pidofproc,
> killproc, status_of_proc.

Maybe just drop the elif test?

RH does not have the lsb/init-functions in a minimal install.

I guess it needs a lsb-base dependency too?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
