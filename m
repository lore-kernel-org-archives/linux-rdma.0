From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 23 Mar 2016 00:23:42 +0200
Message-ID: <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A@mail.gmail.com>
References: <56F1B00F.7010406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F1B00F.7010406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 22, 2016 at 10:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This is a monster pull request.  I held off on the hfi1 driver updates
> (the hfi1 driver is intimately tied to the qib driver and the new rdmavt
> software library that was created to help both of them) in my first pull
> request.  The hfi1/qib/rdmavt update is probably 90% of this pull
> request.  The hfi1 driver is being left in staging so that it can be
> fixed up in regards to the API that Al and yourself didn't like.
[...]
> Round two of 4.6 merge window patches
[...]
> - A huge set of updates to the Intel hfi1 driver.  Of particular interest
>   here is that we have left the driver in staging since it still has an
>   API that people object to.  Intel is working on a fix, but getting
>   these patches in now helps keep me sane as the upstream and Intel's
>   trees were over 300 patches apart.

> Mitko Haralanov (41):
[...]
>       IB/hfi1: Re-factor MMU notification code
>       IB/hfi1: Allow MMU function execution in IRQ context
>       IB/hfi1: Prevent NULL pointer dereference
>       IB/hfi1: Allow remove MMU callbacks to free nodes
>       IB/hfi1: Remove the use of add/remove RB function pointers
>       IB/hfi1: Notify remove MMU/RB callback of calling context
>       IB/hfi1: Use interval RB trees
>       IB/hfi1: Add MMU tracing
>       IB/hfi1: Remove compare callback
>       IB/hfi1: Add filter callback
>       IB/hfi1: Adjust last address values for intervals
>       IB/hfi1: Implement SDMA-side buffer caching
>       IB/hfi1: Add pin query function
>       IB/hfi1: Specify mm when releasing pages
>       IB/hfi1: Switch to using the pin query function
>       IB/hfi1: Add SDMA cache eviction algorithm

Doug, this series is under review and a reviewer (me...) have posted
comments claiming that such pin down cache doesn't belong to kernel
but rather to be part of a user-space library [1]

This comment still hold even though the cache is serving a proprietary
(non verbs) user-space code b/c it claims that code X doesn't belong
to the kernel and we need not load into the kernel what doesn't belong
there.

Could you please comment why not let the discussion converge and/or
hear your maintainer opinion on the matter before this is pushed up to
Linus?

Or.

[1] http://marc.info/?t=145746462200001&r=1&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
