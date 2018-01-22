From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Support rq record doorbell for the
 user space
Date: Mon, 22 Jan 2018 21:33:42 +0800
Message-ID: <010ecfad-6546-5366-2f3b-6596e9eb924c@huawei.com>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-2-git-send-email-liuyixian@huawei.com>
 <20180122080852.GI1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122080852.GI1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/22 16:08, Leon Romanovsky wrote:
> On Thu, Jan 18, 2018 at 10:34:28AM +0800, Yixian Liu wrote:
>> This patch adds interfaces and definitions to support the rq record
>> doorbell for the user space.
<---cut--->
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
>> new file mode 100644
>> index 0000000..0908208
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
>> @@ -0,0 +1,94 @@
>> +/*
>> + * Copyright (c) 2017 Hisilicon Limited.
>> + * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
> 
> Good to know
> 
>> + *
>> + * This software is available to you under a choice of one of two
>> + * licenses.  You may choose to be licensed under the terms of the GNU
>> + * General Public License (GPL) Version 2, available from the file
>> + * COPYING in the main directory of this source tree, or the
>> + * OpenIB.org BSD license below:
>> + *
>> + *     Redistribution and use in source and binary forms, with or
>> + *     without modification, are permitted provided that the following
>> + *     conditions are met:
>> + *
>> + *      - Redistributions of source code must retain the above
>> + *        copyright notice, this list of conditions and the following
>> + *        disclaimer.
>> + *
>> + *      - Redistributions in binary form must reproduce the above
>> + *        copyright notice, this list of conditions and the following
>> + *        disclaimer in the documentation and/or other materials
>> + *        provided with the distribution.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
> 
> Please move to use SPDX headers for new files.
> 

Okay, I will add it in next version.

>> +
>> +#include <linux/platform_device.h>
>> +#include <rdma/ib_umem.h>
>> +#include "hns_roce_device.h"
<---cut--->
>>
>> +struct hns_roce_db_pgdir {
>> +	struct list_head	list;
>> +	DECLARE_BITMAP(order0, HNS_ROCE_DB_PER_PAGE);
>> +	DECLARE_BITMAP(order1, HNS_ROCE_DB_PER_PAGE / 2);
>> +	unsigned long		*bits[2];
> 
> I didn't see any usage of the fields from this struct in this patch,
> where did you use them?
> 

They are used in patch [3/4] for kernel space.

>> +	u32			*db_page;
>> +	dma_addr_t		db_dma;
>> +};
>> +
>> +struct hns_roce_user_db_page {
>> +	struct list_head	list;
>> +	struct ib_umem		*umem;
>> +	unsigned long		user_virt;
>> +	int			refcnt;
> 
> refcount_t please.
>

Thanks, will fix it.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
