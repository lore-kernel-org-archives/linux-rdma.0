From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: IB/hfi1: Adjust another size determination in
 hfi1_user_sdma_alloc_queues()
Date: Mon, 13 Feb 2017 11:37:19 +0100
Message-ID: <8ec653df-9d73-3c94-9559-7a732417e578@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <0fdf4d81-58d7-c6fc-b37f-41d47675dd83@users.sourceforge.net>
 <fc714096-8534-2231-17fd-8e3ca3f7a87b@suse.de>
 <4dca91c1-488d-120d-bd25-74f400242bd2@users.sourceforge.net>
 <9ce8c7b1-1ae5-fe15-2740-b4f7653555c4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ce8c7b1-1ae5-fe15-2740-b4f7653555c4-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> How often does it really make sense to keep such a product in this local variable?
> 
> It depends. Lets take it the other way round. If I this in a review I'd
> suggest the submitter to create a local variable for the multiplication
> to get rid of the line break. It's avoidable.

I imagine that there are further possibilities to improve the involved
programming for various arrays.


> And again, the compiler will optimize it away.
> 
> Apart from the fact that you haven't tested your patch at all:

This is true in principle as I could compile the source code adjustment at least.


> jthumshirn@linux-x5ow:linux (test)$ git am ~/\[PATCH\ 3_5\]\ IB_hfi1\:\
> Adjust\ another\ size\ determination\ in\
> hfi1_user_sdma_alloc_queues\(\).eml
> Applying: IB/hfi1: Adjust another size determination in
> hfi1_user_sdma_alloc_queues()
> jthumshirn@linux-x5ow:linux (test)$ make
> drivers/infiniband/hw/hfi1/user_sdma.o  CHK
> include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CHK     include/generated/bounds.h
>   CHK     include/generated/timeconst.h
>   CHK     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/infiniband/hw/hfi1/user_sdma.o
> drivers/infiniband/hw/hfi1/user_sdma.c: In function
> ‘hfi1_user_sdma_alloc_queues’:
> drivers/infiniband/hw/hfi1/user_sdma.c:402:2: error: ‘memsize’
> undeclared (first use in this function)
>   memsize = sizeof(*pq->reqs) * hfi1_sdma_comp_ring_size;
>   ^

How do you think about to apply also the previous update step like “[PATCH 2/5] IB/hfi1:
Use kcalloc() in hfi1_user_sdma_alloc_queues()”?


> So to sum up: there is no evident improvement in the resulting binary

There might not be a remarkable difference with the default software build parameters.


> and you introduce a stylistic glitch (the new line break in a function call).

There are different opinions about this implementation detail, aren't there?

Regards,
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
