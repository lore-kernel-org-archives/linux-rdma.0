From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Thu, 21 Mar 2013 10:51:07 +0200
Message-ID: <20130321085107.GE28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 12:15:33AM -0700, Roland Dreier wrote:
> >> I think this change will break the case where userspace tries to
> >> register an MR with read-only permission, but intends locally through
> >> the CPU to write to the memory.
> 
> > Shouldn't it set LOCAL_WRITE then?
> 
> We're talking about the permissions for the register MR operation,
> right?  (That's what the kernel RDMA driver code that does
> get_user_pages() sees)
> 
> In that case, no, I don't see any reason for LOCAL_WRITE, since the
> only RDMA operations that will access this memory are remote reads.

What is the meaning of LOCAL_WRITE then? There are no local
RDMA writes as far as I can see.

> The writing (that triggers COW) is coming from normal process access
> triggering a page fault, etc.  This is a pretty standard way of using
> RDMA... For example, I allocate some memory and register it for RDMA
> read (and pass the R_Key to the remote system) with only REMOTE_READ
> permission.  Then I fill in the memory with the results of some
> computation and the remote system does an RDMA read to get those
> results.
> 
>  - R.

OK then what we need is a new flag saying "I really do not
intend to write into this memory please do not break
COW or do anything else just in case I do".

-- 
MST
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
