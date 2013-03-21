From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Thu, 21 Mar 2013 20:16:33 +0200
Message-ID: <20130321181633.GC4366@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
 <20130321085107.GE28328@redhat.com>
 <CAL1RGDVnkLZU2Vge4o3BwDxnAfGv7TQRMqE6ha3MUt39CVp5NQ@mail.gmail.com>
 <20130321093946.GG28328@redhat.com>
 <20130321171115.GA653@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130321171115.GA653-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 11:11:15AM -0600, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 11:39:47AM +0200, Michael S. Tsirkin wrote:
> > On Thu, Mar 21, 2013 at 02:13:38AM -0700, Roland Dreier wrote:
> > > On Thu, Mar 21, 2013 at 1:51 AM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > >> In that case, no, I don't see any reason for LOCAL_WRITE, since the
> > > >> only RDMA operations that will access this memory are remote reads.
> > > >
> > > > What is the meaning of LOCAL_WRITE then? There are no local
> > > > RDMA writes as far as I can see.
> > > 
> > > Umm, it means you're giving the local adapter permission to write to
> > > that memory.  So you can use it as a receive buffer or as the target
> > > for remote data from an RDMA read operation.
> > 
> > Well RDMA read has it's own flag, IB_ACCESS_REMOTE_READ.
> > I don't see why do you need to give adapter permission
> 
> The access flags have to do with what independent access remote nodes
> get. There are four major cases:
> 
> access = IBV_ACCESS_REMOTE_READ says the adaptor will let remote nodes
> read the memory.
> 
> access = 0 (ie IBV_ACCESS_LOCAL_READ) says that only the adaptor, under
> the direct control of the application, can read this memory. Remote
> nodes are barred.
> 
> access = IBV_ACCESS_REMOTE_WRITE|IBV_ACCESS_LOCAL_WRITE says the adaptor
> will let remote nodes write the memory
> 
> access = IBV_ACCESS_LOCAL_WRITE bars remote nodes from writing to that
> memory. Only the adaptor, under the direct control of the application,
> can write the memory.

This is the one I find redundant. Since the write will be done
by the adaptor under direct control by the application,
why does it make sense to declare this beforehand?
If you don't want to allow local write access to memory,
just do not post any receive WRs with this address.
If you posted and regret it, reset the QP to cancel.

But IB spec specified LOCAL_WRITE in this redundant way so I guess
applications expect it to have the semantics defined there, I just
didn't remember what they are.

No way around it then, need another flag.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
