From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/2] RDMA/hns: Add detailed comments for mb()
 call
Date: Thu, 28 Dec 2017 21:13:19 +0800
Message-ID: <e81ee2ac-b844-a875-6151-87a77e556b0f@huawei.com>
References: <1514372644-171663-1-git-send-email-liuyixian@huawei.com>
 <1514372644-171663-2-git-send-email-liuyixian@huawei.com>
 <20171227164551.GC25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227164551.GC25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/28 0:45, Jason Gunthorpe wrote:
> On Wed, Dec 27, 2017 at 07:04:03PM +0800, Yixian Liu wrote:
>> This patch adds more detailed comments when we call the
>> memory barrier function, such as rmb, wmb and mb. Three
>> mb() callers are deleted since they are unnecessary.
> 
> Are you sure none of these need to be dma_*mb ?
> 
> Jason
> 

Thanks for your reminder, I will update in patch v3.

> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
