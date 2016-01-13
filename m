From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Wed, 13 Jan 2016 10:44:12 +0200
Message-ID: <56960E5C.5000607@dev.mellanox.co.il>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
 <1452609431.9500.24.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452609431.9500.24.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hi,

Hi Yann,

>>
>> +/* Please don't let this exceed a single cacheline */
>
> Don't add a comment, add a compile time assert:
>
> BUILD_BUG_ON(sizeof(struct swr_ctx) <= L1_CACHE_BYTES);

Sure, I'll do that.

>> +struct swr_ctx {
>> +	u64		wrid;
>> +	u32		wr_data;
>> +	struct wr_list	w_list;
>> +	u32		wqe_head;
>> +	u8		rsvd[12];
>> +}__packed;
>> +
>
> Packing the structure might make some fields unaligned and, on some
> architecture, unaligned access are likely unwelcomed.

I manually align, so I can remove the packing...

> What about
>
> struct swr_ctx {
> 	u64		wrid;
> 	u32		wr_data;
> 	struct wr_list	w_list;
> 	u32		wqe_head;
> } ____cacheline_aligned;

The reason why I didn't use cacheline_aligned is that in 64B cacheline
architectures I'll get padding to 64B while I can only padd to 32B. With
that I get the benefit of fetching 2 entries which is sorta like an
implicit prefetch (useful for the next post_send).

Do you know any annotation that can do this for me?

>> +struct rwr_ctx {
>> +	u64		       wrid;
>> +}__packed;
>> +
>>   struct mlx5_ib_wq {
>> -	u64		       *wrid;
>> -	u32		       *wr_data;
>> -	struct wr_list	       *w_list;
>> -	unsigned	       *wqe_head;
>> +	union {
>> +		struct swr_ctx *swr_ctx;
>> +		struct rwr_ctx *rwr_ctx;
>> +	};
>>   	u16		        unsig_count;
>
> Check the structure layout is the one you expect with pahole.

I did, given that I simply removed 3 pointers I get the same layout
(2B hole after unsig_count). The nice side effect of this is that
mlx5_ib_wq is now smaller than a 64B cacheline (reduced from 80B to
56B).

>> +	qp->sq.swr_ctx = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.swr_ctx),
>> +				 GFP_KERNEL);
>> +	qp->rq.rwr_ctx = kcalloc(qp->rq.wqe_cnt, sizeof(*qp->sq.rwr_ctx),
>> +				 GFP_KERNEL);
>>
>
> Anyway, I'm not sure about the alignment of the memory returned by
> kcalloc(), I should have known by the time but don't find time to
> figure how it's handled on various SL*B allocator implementation.

Can you explain why should I worry about the alignment of kcalloc
here?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
