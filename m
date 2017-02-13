From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/hfi1: Adjust another size determination in
 hfi1_user_sdma_alloc_queues()
Date: Mon, 13 Feb 2017 10:51:53 +0100
Message-ID: <9ce8c7b1-1ae5-fe15-2740-b4f7653555c4@suse.de>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <0fdf4d81-58d7-c6fc-b37f-41d47675dd83@users.sourceforge.net>
 <fc714096-8534-2231-17fd-8e3ca3f7a87b@suse.de>
 <4dca91c1-488d-120d-bd25-74f400242bd2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4dca91c1-488d-120d-bd25-74f400242bd2-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/13/2017 10:32 AM, SF Markus Elfring wrote:
>>> @@ -443,8 +442,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
>>>  	if (!cq)
>>>  		goto cq_nomem;
>>>  
>>> -	memsize = PAGE_ALIGN(sizeof(*cq->comps) * hfi1_sdma_comp_ring_size);
>>> -	cq->comps = vmalloc_user(memsize);
>>> +	cq->comps = vmalloc_user(PAGE_ALIGN(sizeof(*cq->comps)
>>> +				 * hfi1_sdma_comp_ring_size));
>>>  	if (!cq->comps)
>>>  		goto cq_comps_nomem;
>>>  
>>>
>>
>> IMHO this makes readability worse.
> 
> How often does it really make sense to keep such a product in this local variable?

It depends. Lets take it the other way round. If I this in a review I'd
suggest the submitter to create a local variable for the multiplication
to get rid of the line break. It's avoidable. And again, the compiler
will optimize it away.

Apart from the fact that you haven't tested your patch at all:

jthumshirn@linux-x5ow:linux (test)$ git am ~/\[PATCH\ 3_5\]\ IB_hfi1\:\
Adjust\ another\ size\ determination\ in\
hfi1_user_sdma_alloc_queues\(\).eml
Applying: IB/hfi1: Adjust another size determination in
hfi1_user_sdma_alloc_queues()
jthumshirn@linux-x5ow:linux (test)$ make
drivers/infiniband/hw/hfi1/user_sdma.o  CHK
include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CHK     include/generated/bounds.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/infiniband/hw/hfi1/user_sdma.o
drivers/infiniband/hw/hfi1/user_sdma.c: In function
‘hfi1_user_sdma_alloc_queues’:
drivers/infiniband/hw/hfi1/user_sdma.c:402:2: error: ‘memsize’
undeclared (first use in this function)
  memsize = sizeof(*pq->reqs) * hfi1_sdma_comp_ring_size;
  ^
drivers/infiniband/hw/hfi1/user_sdma.c:402:2: note: each undeclared
identifier is reported only once for each function it appears in
scripts/Makefile.build:294: recipe for target
'drivers/infiniband/hw/hfi1/user_sdma.o' failed
make[1]: *** [drivers/infiniband/hw/hfi1/user_sdma.o] Error 1
Makefile:1640: recipe for target
'drivers/infiniband/hw/hfi1/user_sdma.o' failed
make: *** [drivers/infiniband/hw/hfi1/user_sdma.o] Error 2

With this fixed:

jthumshirn@linux-x5ow:linux (test)$ size
drivers/infiniband/hw/hfi1/user_sdma.o.*
   text	   data	    bss	    dec	    hex	filename
  15393	    212	    292	  15897	   3e19
drivers/infiniband/hw/hfi1/user_sdma.o.old
  15393	    212	    292	  15897	   3e19
drivers/infiniband/hw/hfi1/user_sdma.o.patched


Glancing over the diff of the objdump of these two object files you'll
notice that all your patch is doing is moving the code around in the
.text section of the binary.

So to sum up: there is no evident improvement in the resulting binary
and you introduce a stylistic glitch (the new line break in a function
call).

But all of what I've provided above would have been your job as patch
submitter. You have to reason why your patch is good, it's not our job
to reason why it's bad.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
