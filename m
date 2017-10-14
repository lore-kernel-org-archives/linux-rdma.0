From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 04/13] SoftiWarp object management
Date: Sat, 14 Oct 2017 01:07:20 +0000
Message-ID: <OFE6338618.FEC47E33-ON002581B9.00062A47-002581B9.00062A4B@notes.na.collabserv.com>
References: <20171008122839.GS25829@mtr-leonro.local>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-5-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171008122839.GS25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Leon Romanovsky 
>Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Date: 10/08/2017 02:28PM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 04/13] SoftiWarp object management
>
>On Fri, Oct 06, 2017 at 08:28:44AM -0400, Bernard Metzler wrote:
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_obj.c | 428
>++++++++++++++++++++++++++++++++++++
>>  drivers/infiniband/sw/siw/siw_obj.h | 113 ++++++++++
>>  2 files changed, 541 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_obj.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_obj.h
>>
>> diff --git a/drivers/infiniband/sw/siw/siw_obj.c
>b/drivers/infiniband/sw/siw/siw_obj.c
>> new file mode 100644
>> index 000000000000..a6d28773e09d
>> --- /dev/null
>> +++ b/drivers/infiniband/sw/siw/siw_obj.c
>> @@ -0,0 +1,428 @@
>> +/*
>> + * Software iWARP device driver for Linux
>
>No need to add "Linux" for the Linux Driver code in the Linux Kernel.

good point. I will remove tat.
>
>> + *
>> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> + *
>> + * Copyright (c) 2008-2017, IBM Corporation
>> + *
>> + * This software is available to you under a choice of one of two
>> + * licenses. You may choose to be licensed under the terms of the
>GNU
>> + * General Public License (GPL) Version 2, available from the file
>> + * COPYING in the main directory of this source tree, or the
>> + * BSD license below:
>> + *
>> + *   Redistribution and use in source and binary forms, with or
>> + *   without modification, are permitted provided that the
>following
>> + *   conditions are met:
>> + *
>> + *   - Redistributions of source code must retain the above
>copyright notice,
>> + *     this list of conditions and the following disclaimer.
>> + *
>> + *   - Redistributions in binary form must reproduce the above
>copyright
>> + *     notice, this list of conditions and the following
>disclaimer in the
>> + *     documentation and/or other materials provided with the
>distribution.
>> + *
>> + *   - Neither the name of IBM nor the names of its contributors
>may be
>> + *     used to endorse or promote products derived from this
>software without
>> + *     specific prior written permission.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
>AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
>IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/spinlock.h>
>> +#include <linux/kref.h>
>> +#include <linux/vmalloc.h>
>> +
>> +#include "siw.h"
>> +#include "siw_obj.h"
>> +#include "siw_cm.h"
>> +
>> +
>> +void siw_objhdr_init(struct siw_objhdr *hdr)
>> +{
>> +	kref_init(&hdr->ref);
>> +}
>> +
>> +void siw_idr_init(struct siw_dev *sdev)
>> +{
>> +	spin_lock_init(&sdev->idr_lock);
>> +
>> +	idr_init(&sdev->qp_idr);
>> +	idr_init(&sdev->cq_idr);
>> +	idr_init(&sdev->pd_idr);
>> +	idr_init(&sdev->mem_idr);
>> +}
>> +
>> +void siw_idr_release(struct siw_dev *sdev)
>> +{
>> +	idr_destroy(&sdev->qp_idr);
>> +	idr_destroy(&sdev->cq_idr);
>> +	idr_destroy(&sdev->pd_idr);
>> +	idr_destroy(&sdev->mem_idr);
>> +}
>
>Why do you need need idr_* calls and why can't IB/core idr_*
>management
>be enough? I didn't review the various *_obj functions.

For memory management, I need that. Memory can be referenced
by in progress operations like READ responses. Memory objects
must be protected until those operations finish. I think this
statement is also true for other resources, like QP's etc.
Let me thimk through it again and come back with a more 
detailed answer.

>
>> +
>> +static inline int siw_add_obj(spinlock_t *lock, struct idr *idr,
>> +			      struct siw_objhdr *obj)
>
>Please don't add inline functions in C files.
>

OK, will fix that.
>> +{
>> +	unsigned long flags;
>> +	int id, pre_id;
>> +
>> +	do {
>> +		get_random_bytes(&pre_id, sizeof(pre_id));
>> +		pre_id &= 0xffffff;
>> +	} while (pre_id == 0);
>> +again:
>> +	spin_lock_irqsave(lock, flags);
>> +	id = idr_alloc(idr, obj, pre_id, 0xffffff - 1, GFP_KERNEL);
>> +	spin_unlock_irqrestore(lock, flags);
>> +
>> +	if (id > 0) {
>> +		siw_objhdr_init(obj);
>> +		obj->id = id;
>> +		dprint(DBG_OBJ, "(OBJ%d): IDR New Object\n", id);
>
>Please don't reinvent pr_debug infrastructure. There is no need in
>custom dprint(..) logic.

this whole dprint logic actually came in to debug RDMA applications.
It proofed to be very useful if one wants to understand why an RDMA
operation fails (e.g. a memory access protection error because of
wrong, key, offset, address, etc.). I see I have to remove it.

>
>> +	} else if (id == -ENOSPC && pre_id != 1) {
>> +		pre_id = 1;
>> +		goto again;
>> +	} else {
>> +		BUG_ON(id == 0);
>
>No BUG_ON in new code.
>
OK

>> +		dprint(DBG_OBJ|DBG_ON, "(OBJ??): IDR New Object failed!\n");
>> +	}
>> +	return id > 0 ? 0 : id;
>> +}
>> +
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
