From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Wed, 13 Jan 2016 11:37:19 +0200
Message-ID: <56961ACF.9050600@dev.mellanox.co.il>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
 <1452609431.9500.24.camel@opteya.com> <56960E5C.5000607@dev.mellanox.co.il>
 <1452677194.9500.27.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452677194.9500.27.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>>> Anyway, I'm not sure about the alignment of the memory returned by
>>> kcalloc(), I should have known by the time but don't find time to
>>> figure how it's handled on various SL*B allocator implementation.
>>
>> Can you explain why should I worry about the alignment of kcalloc
>> here?
>
> Say it returns memory aligned on 16 bytes, then accessing some items in
> the array is going to touch 2 cachelines, defeating the purpose of the
> padding or the alignment attribute added to the item structure.

I see, I think the alignment is ARCH_KMALLOC_MINALIGN. I'm not aware
of aligned array allocation. Do you have a suggestion how can I align
the allocation? I can manually pad and align but it would mean I'd need
to save two extra pointers (aligned pointer and orig pointer for kfree)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
