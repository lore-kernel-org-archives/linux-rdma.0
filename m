From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Fri, 29 Dec 2017 18:29:35 +0800
Message-ID: <aa43b6d4-bb56-ed2f-33c9-c047e27a0a59@huawei.com>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-3-git-send-email-liuyixian@huawei.com>
 <20171228155712.GU25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228155712.GU25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/28 23:57, Jason Gunthorpe wrote:
> 
> On Thu, Dec 28, 2017 at 10:18:03PM +0800, Yixian Liu wrote:
> 
>> -	hns_roce_write64_k(doorbell, eq->doorbell);
>> +	hns_roce_write64_k(db.doorbell, eq->doorbell);
> 
> You need to pass &db to hns_roce_write64_k and have it deref the 64
> bit value using the union. The point here is to eliminate the cast inside
> hns_roce_write64_k.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Jason,

I know exactly what you mean, but the interface also called by lots of
other places in our driver, I plan to leave this revision in future work.
With db.doorbell input, we could get the correct value (64 bit) w/o *(u64 *).
Thus, this patch will not be updated in patch v4.

Thank you very much for clarify your solution.

> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
