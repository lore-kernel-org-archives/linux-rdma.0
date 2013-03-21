From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Thu, 21 Mar 2013 21:15:41 +0200
Message-ID: <20130321191541.GB5272@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
 <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
 <20130321093946.GG28328@redhat.com>
 <20130321171115.GA653@obsidianresearch.com>
 <20130321181633.GC4366@redhat.com>
 <20130321184135.GA8044@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130321184135.GA8044-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 12:41:35PM -0600, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 08:16:33PM +0200, Michael S. Tsirkin wrote:
> 
> > This is the one I find redundant. Since the write will be done by
> > the adaptor under direct control by the application, why does it
> > make sense to declare this beforehand?  If you don't want to allow
> > local write access to memory, just do not post any receive WRs with
> > this address.  If you posted and regret it, reset the QP to cancel.
> 
> This is to support your COW scenario - the app declares before hand to
> the kernel that it will write to the memory and the kernel ensures
> pages are dedicated to the app at registration time. Or the app says
> it will only read and the kernel could leave them shared.

Someone here is confused. LOCAL_WRITE/absence of it does not address
COW, it breaks COW anyway.  Are you now saying we should change rdma so
without LOCAL_WRITE it will not break COW?

> The adaptor enforces the access control to prevent a naughty app from
> writing to shared memory - think about mmap'ing libc.so and then using
> RDMA to write to the shared pages. It is necessary to ensure that is
> impossible.
> 
> Jason

That's why it's redundant: we can't trust an application to tell us
'this page is writeable', we must get this info from kernel.  And so
there's apparently no need for application to tell adaptor about
LOCAL_WRITE.

-- 
MST
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
