From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: add a simple SRQ pool per PD
Date: Fri, 17 Nov 2017 21:12:46 +0200
Message-ID: <c94d2e03-dd32-ff0a-789f-aae4d65f3955@mellanox.com>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
 <1510852885-25519-2-git-send-email-maxg@mellanox.com>
 <20171116181049.GO18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116181049.GO18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> +#ifndef _RDMA_SRQ_POOL_H
>> +#define _RDMA_SRQ_POOL_H 1
>> +
>> +#include <rdma/ib_verbs.h>
>> +
>> +struct ib_srq *ib_srq_pool_get(struct ib_pd *pd);
>> +void ib_srq_pool_put(struct ib_pd *pd, struct ib_srq *srq);
>> +
>> +int ib_srq_pool_init(struct ib_pd *pd, int nr,
>> +		struct ib_srq_init_attr *srq_attr);
>> +void ib_srq_pool_destroy(struct ib_pd *pd);
> 
> Can you please use rdma_ prefix instead of ib_ prefix?
> 
> Thanks
> 

Do you mean rdma_srq_pool_get instead of ib_srq_pool_get ? is this new 
convetion ? this is a pool that contain ib_srq objects and not rdma_srq 
objects..

I can do it if needed.

>> +
>> +#endif /* _RDMA_SRQ_POOL_H */
>> --
>> 1.8.3.1
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
