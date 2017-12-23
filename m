From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] Revise eq support for hip06 & hip08
Date: Sat, 23 Dec 2017 16:57:48 +0800
Message-ID: <05c2fddb-5440-488a-fb1f-914ade1f0bf1@huawei.com>
References: <1510651577-20794-1-git-send-email-liuyixian@huawei.com>
 <20171222163732.GA15021@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222163732.GA15021-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/23 0:37, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 05:26:15PM +0800, Yixian Liu wrote:
>> This patch-set refactor eq code for hip06 and add eq
>> support for hip08.
>>
>> Yixian Liu (2):
>>   RDMA/hns: Refactor eq code for hip06
>>   RDMA/hns: Add eq support of hip08
> 
> I read this this whole giant patch and will apply it to for-next.
> 
> I did notice some existing bothersome things:
> 
> 1) Bad commenting around all memory barriers:
> 
>                /* Memory barrier */
>                 rmb();
> 
>    Everyone knows that rmb/wmb/mb are memory barriers.
>    If you use these calls you *MUST* have a comment explaining
>    what the locking situation is. Explain where the *OTHER SIDE* of
>    the barrier is.
> 
> 2) This construct
> 
>   static inline void hns_roce_write64_k(__be32 val[2], void __iomem *dest)
>   {
>         __raw_writeq(*(u64 *) val, dest);
>   }
> 
>   static void set_eq_cons_index_v2(struct hns_roce_eq *eq)
>   {
> 	u32 doorbell[2];
>         [..]
>         hns_roce_write64_k(doorbell, eq->doorbell);
> 
>    Is not OK. doorbell is technically not guarenteed to be 64 bit
>    aligned, and the deref *(u64 *) requires 64 bit alignment in the
>    kernel.
> 
>    I purged this stupid array thing out of the mellanox drivers in
>    userspace some time ago, you might do the same, or minimually a
>    union is needed:
> 
>     union doorbell {
>         u64 doorbell64;
> 	u32 doorbell[2];
>     }
> 
> Plese consider sending followup patches.
> 

Thanks! I will send out bugfix patches according to your suggestions.

> Jason
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
