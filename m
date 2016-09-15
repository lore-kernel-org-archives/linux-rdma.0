From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 21/28] mlx5: Avoid gcc 5.4 warning -Wempty-body
Date: Thu, 15 Sep 2016 18:15:08 +0300
Message-ID: <a6336efd-af82-1111-899a-e922ba2f915b@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-22-git-send-email-jgunthorpe@obsidianresearch.com>
 <6214bd07-f40c-8458-73a2-c07383c5d85a@dev.mellanox.co.il>
 <20160914165519.GC16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914165519.GC16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/14/2016 7:55 PM, Jason Gunthorpe wrote:
> No compiler we support will leave behind a function call for an empty
> static inline.
>
> I just checked, the assembly is the same before/after modulo compiler
> non-determinism. There are no extra function calls.
>
>>> enum {
>>> diff --git a/libmlx5/src/qp.c b/libmlx5/src/qp.c
>>> index c805fcae4123..23270e50af7a 100644
>>> +++ b/libmlx5/src/qp.c
>>> @@ -356,9 +356,7 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
>>> 	int inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
>>> 	int inl_hdr_copy_size = 0;
>>> 	int j = 0;
>>> -#ifdef MLX5_DEBUG
>>> 	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
>>> -#endif
>>
>> This is data path flow, dropping the #ifdef may cause a redundant assignment
>> for 'fp' here.
>
> Nope:
>
> $ nm --size libmlx4-rdmv2.so
> [before]
> 0000000000001637 t _mlx5_post_send
> [after]
> 0000000000001637 t _mlx5_post_send
>
> The compilers are very smart, you don't need to hand hold them.

Thanks for checking that, will take into our regression system to run on 
before formally taking.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
