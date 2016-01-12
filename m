From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Tue, 12 Jan 2016 16:44:00 +0200
Message-ID: <56951130.60802@dev.mellanox.co.il>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
 <5694EEAA.3050600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5694EEAA.3050600-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Each time we access each of these arrays, even for a single index
>> we fetch a cacheline. Reduce cacheline bounces by fitting these members
>> in a cacheline aligned struct (swr_ctx) and allocate an array. Accessing
>> this array will fetch all of these members in a single shot.
>>
>> Since the receive queue needs only the wrid we use a nameless union
>> where in the rwr_ctx we only have wrid member.
>
> Have some performance numbers before/after this patch to support the
> proposed change?

I didn't took the time to measure cache hit/miss. I just noticed it
a while ago and it's been bugging me for some time so I figured I'd
send it out...

> Also, I have asked you the same question re the iser remote invalidation
> series [1], this datais needed there too.

I didn't get to it, we had rough initial numbers, but we have yet to do
a full evaluation on different devices.

> +/* Please don't let this exceed a single cacheline */
> +struct swr_ctx {
> +    u64        wrid;
> +    u32        wr_data;
> +    struct wr_list    w_list;
> +    u32        wqe_head;
> +    u8        rsvd[12];
> +}__packed;
>
>
> what the role of the reserved field, is that for alignment purposes? if
> yes, maybe better namewould be "align"

OK. I can change it.

>
> Nit, (same) checkpatch error here and below
>
> ERROR: space required after that close brace '}'
> #111: FILE: drivers/infiniband/hw/mlx5/mlx5_ib.h:139:
> +}__packed;

Will fix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
