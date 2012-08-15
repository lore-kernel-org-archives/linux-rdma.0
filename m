From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: handling rdma apps using chroot
Date: Wed, 15 Aug 2012 22:31:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89569@ORSMSX101.amr.corp.intel.com>
References: <SNT114-DS11B5280C71EEE30408772DADB60@phx.gbl>
 <20120815193214.GB2957@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A89506@ORSMSX101.amr.corp.intel.com>
 <20120815195837.GA3880@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120815195837.GA3880-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> There are lots of issues with using a dev/sysfs interface instead of
> system calls and trying to support chroot... Not sure how rdmacm
> works, but verbs returns event channel FDs directly 'in-band' which
> avoids further use of dev..

The rdmacm calls open() in rdma_create_event_channel()...

> Even better would be to use eventfd() to have user space create the
> event channel and pass that FD up into the kernel for this sort of
> stuff, but I'm not sure if eventfd() can replace all the use cases of
> event channels, though they are very similar.

This looks promising as a way to merge together all these different RDMA related FDs.  It's a significant change and more of a long term solution though.  On the surface, it looks like a better approach than trying to fix rdma_create_event_channel directly.

> Symlinks? You can bind mount sysfs and create a mini /dev/ in the
> chroot and things should work OK, but obviously exposing those items
> to the chroot significantly defeats the point of the chroot in the
> first place.

softlinks using 'ln -s'.  bind --mount didn't work either.  I'll have to look deeper into the code.

This is really more about having fork support with rsockets and uncovering/fixing the problems than seriously trying to get vsftp to run.  I'm already forced to use 'one process' mode.  If I can get vsftp to run, that would be great, but I hesitant to intercept and discard chroot calls just to make that happen.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
