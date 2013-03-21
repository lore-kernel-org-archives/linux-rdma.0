From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Thu, 21 Mar 2013 09:03:57 +0200
Message-ID: <20130321070357.GD28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 20, 2013 at 11:55:54PM -0700, Roland Dreier wrote:
> On Wed, Mar 20, 2013 at 11:18 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > core/umem.c seems to get the arguments to get_user_pages
> > in the reverse order: it sets writeable flag and
> > breaks COW for MAP_SHARED if and only if hardware needs to
> > write the page.
> >
> > This breaks memory overcommit for users such as KVM:
> > each time we try to register a page to send it to remote, this
> > breaks COW.  It seems that for applications that only have
> > REMOTE_READ permission, there is no reason to break COW at all.
> 
> I proposed a similar (but not exactly the same, see below) patch a
> while ago: https://lkml.org/lkml/2012/1/26/7 but read the thread,
> especially https://lkml.org/lkml/2012/2/6/265
> 
> I think this change will break the case where userspace tries to
> register an MR with read-only permission, but intends locally through
> the CPU to write to the memory.

Shouldn't it set LOCAL_WRITE then?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
