From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Wed, 20 Mar 2013 23:55:54 -0700
Message-ID: <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
References: <20130321061838.GA28319@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321061838.GA28319-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 20, 2013 at 11:18 PM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> core/umem.c seems to get the arguments to get_user_pages
> in the reverse order: it sets writeable flag and
> breaks COW for MAP_SHARED if and only if hardware needs to
> write the page.
>
> This breaks memory overcommit for users such as KVM:
> each time we try to register a page to send it to remote, this
> breaks COW.  It seems that for applications that only have
> REMOTE_READ permission, there is no reason to break COW at all.

I proposed a similar (but not exactly the same, see below) patch a
while ago: https://lkml.org/lkml/2012/1/26/7 but read the thread,
especially https://lkml.org/lkml/2012/2/6/265

I think this change will break the case where userspace tries to
register an MR with read-only permission, but intends locally through
the CPU to write to the memory.  If the memory registration is done
while the memory is mapped read-only but has VM_MAYWRITE, then
userspace gets into trouble when COW happens.  In the case you're
describing (although I'm not sure where in KVM we're talking about
using RDMA), what happens if you register memory with only REMOTE_READ
and then COW is triggered because of a local write?  (I'm assuming you
don't want remote access to continue to get the old contents of the
page)

I have to confess that I still haven't had a chance to implement the
proposed FOLL_FOLLOW solution to all of this.

> If the page that is COW has lots of copies, this makes the user process
> quickly exceed the cgroups memory limit.  This makes RDMA mostly useless
> for virtualization, thus the stable tag.

The actual problem description here is a bit too terse for me to
understand.  How do we end up with lots of copies of a COW page?  Why
is RDMA registering the memory any more  special than having everyone
who maps this page actually writing to it and triggering COW?

>                 ret = get_user_pages(current, current->mm, cur_base,
>                                      min_t(unsigned long, npages,
>                                            PAGE_SIZE / sizeof (struct page *)),
> -                                    1, !umem->writable, page_list, vma_list);
> +                                    !umem->writable, 1, page_list, vma_list);

The first two parameters in this line being changed are "write" and "force".

I think if we do change this, then we need to pass umem->writable (as
opposed to !umem->writable) for the "write" parameter.  Not sure
whether "force" makes sense or not.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
