From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: handling rdma apps using chroot
Date: Wed, 15 Aug 2012 13:58:37 -0600
Message-ID: <20120815195837.GA3880@obsidianresearch.com>
References: <SNT114-DS11B5280C71EEE30408772DADB60@phx.gbl>
 <20120815193214.GB2957@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89506@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89506-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 07:44:38PM +0000, Hefty, Sean wrote:
> > Somehow you need to open the verbs device before doing the choot.. I
> > think once verbs is open there is no further need for sysfs and dev..
> 
> I could hook chroot to force this.  That should fix the /sys issue.
> However, the librdmacm accesses /dev when creating an event channel,
> which occurs after chroot.  (Maybe that call is just hopelessly
> broken trying to support chroot.)

There are lots of issues with using a dev/sysfs interface instead of
system calls and trying to support chroot... Not sure how rdmacm
works, but verbs returns event channel FDs directly 'in-band' which
avoids further use of dev.. 

Even better would be to use eventfd() to have user space create the
event channel and pass that FD up into the kernel for this sort of
stuff, but I'm not sure if eventfd() can replace all the use cases of
event channels, though they are very similar.

> Correct - this is one of the results of supporting fork.  The ftp
> daemon listens on a normal socket, then switches to an rsocket on
> the first data transfer, after any fork presumably has occurred.

Not sure how that switch works, but you could open the relevent ib
devices on a listen?
 
> Btw, I've tried using symlinks and running from '/'.  The symlinks
> don't work, but running from '/' does for rstream.  Neither work for
> vsftpd, likely from other security calls that it makes.

Symlinks? You can bind mount sysfs and create a mini /dev/ in the
chroot and things should work OK, but obviously exposing those items
to the chroot significantly defeats the point of the chroot in the
first place.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
