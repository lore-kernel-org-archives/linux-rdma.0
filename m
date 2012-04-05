From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Thu, 5 Apr 2012 14:40:38 -0600
Message-ID: <20120405204038.GA6575@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
 <4F7DC3F8.2030406@redhat.com>
 <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519B048-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 05, 2012 at 07:10:25PM +0000, Hefty, Sean wrote:
> > > +PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
> > 
> > I'm not very keen on including /usr/local in the search path on system
 
> To say that I'm not sure what autotools and the init scripts are
> doing is an understatement...  The init script finds ibacm in
> /usr/sbin, but not /usr/local/sbin where it ended up being
> installed.  I'm not sure how to fix that.

In this instance you need to have configure variable substitute your
init script as well. You should not manipulate PATH from an init.d
script, and you should use an absolute path to the daemon to avoid
contamination from the invoking user's environment.

So you want:

%prefix$/bin/IBACM_BIN -foo

(use start-stop-daemon if appropriate for RHEL, I'm not sure what
their conventions are...)

There might be a better choice than %prefix% for this, check the
config.sub output for a better substitution.

Also, these days it would be very forward-thinking of you to
contemplate how this will work in a systemd world. Make sure it can be
demand started, have a daemon that has a running mode that is systemd
compatible, etc. I think Doug was saying that the latest FC has IB and
systemd together?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
