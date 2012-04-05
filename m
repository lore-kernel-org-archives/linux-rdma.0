From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Thu, 05 Apr 2012 19:15:47 +0000
Message-ID: <4F7DEF63.70909@acm.org>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com> <4F7DC3F8.2030406@redhat.com> <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519B048-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/05/12 19:10, Hefty, Sean wrote:

> I create a .tar.gz package using 'make dist', copy it to another

> system, then> install it using 'configure && make install'.  When I
> do that, sysconfdir defaults to /usr/local/etc, sbindir /usr/local
> /sbin, and bindir to /usr/local/bin.  I added /usr/local to PATH, so
> that the init script would work.  Otherwise I get a 'command not
> found' error when running the script.  On a side note, my ibacm
> configuration files end up in /usr/local/etc/rdma.

> 
> To say that I'm not sure what autotools and the init scripts are doing

> is an understatement...  The init script finds ibacm in /usr/sbin,
> but not /usr/local/sbin where it ended up being installed.  I'm not
> sure how to fix that.
On an RPM-based system invoking configure as follows helps a lot:

rpm --eval '%configure' |
  sed "s|\(\./configure \)|\1 --disable-static $@|" |
  sh

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
