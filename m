From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/hfi1: Adjust another size determination in
 hfi1_user_sdma_alloc_queues()
Date: Mon, 13 Feb 2017 10:32:13 +0100
Message-ID: <4dca91c1-488d-120d-bd25-74f400242bd2@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <0fdf4d81-58d7-c6fc-b37f-41d47675dd83@users.sourceforge.net>
 <fc714096-8534-2231-17fd-8e3ca3f7a87b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc714096-8534-2231-17fd-8e3ca3f7a87b-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> @@ -443,8 +442,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
>>  	if (!cq)
>>  		goto cq_nomem;
>>  
>> -	memsize = PAGE_ALIGN(sizeof(*cq->comps) * hfi1_sdma_comp_ring_size);
>> -	cq->comps = vmalloc_user(memsize);
>> +	cq->comps = vmalloc_user(PAGE_ALIGN(sizeof(*cq->comps)
>> +				 * hfi1_sdma_comp_ring_size));
>>  	if (!cq->comps)
>>  		goto cq_comps_nomem;
>>  
>>
> 
> IMHO this makes readability worse.

How often does it really make sense to keep such a product in this local variable?


> What's the intention behind this patch?

I suggested just another simple omission of an extra variable.

Regards,
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
