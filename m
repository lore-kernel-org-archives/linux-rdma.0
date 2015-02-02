From: Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/2] infiniband: Help gcc generate better code for
 ocrdma_srq_toggle_bit
Date: Mon, 2 Feb 2015 12:04:28 +0000
Message-ID: <36AE2E863FF33A4F9FBBE296E34DBC8F5A09725E@CMEXMB1.ad.emulex.com>
References: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421419196-4659-1-git-send-email-linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Thanks!

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Rasmus Villemoes
> Sent: Friday, January 16, 2015 8:10 PM
> To: Roland Dreier; Sean Hefty; Hal Rosenstock
> Cc: Rasmus Villemoes; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH 1/2] infiniband: Help gcc generate better code for
> ocrdma_srq_toggle_bit
> 
> gcc emits a surprising amount of code in order to flip a bit. One would think
> that a single instruction is enough.
> 
> $ scripts/bloat-o-meter /tmp/ocrdma_verbs.o
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.o
> add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-142 (-142)
> function                                     old     new   delta
> ocrdma_post_srq_recv                         498     460     -38
> ocrdma_poll_cq                              2010    1962     -48
> ocrdma_discard_cqes                          495     439     -56
> 
> All three calls of ocrdma_srq_toggle_bit happen within spinlocks, so saving a
> few useless instructions might be worthwhile.
> 
> Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index fb8d8c4dfbb9..eff11e6c6183 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1484,10 +1484,7 @@ static void ocrdma_srq_toggle_bit(struct
> ocrdma_srq *srq, int idx)
>  	int i = idx / 32;
>  	unsigned int mask = (1 << (idx % 32));
> 
> -	if (srq->idx_bit_fields[i] & mask)
> -		srq->idx_bit_fields[i] &= ~mask;
> -	else
> -		srq->idx_bit_fields[i] |= mask;
> +	srq->idx_bit_fields[i] ^= mask;
>  }
> 
>  static int ocrdma_hwq_free_cnt(struct ocrdma_qp_hwq_info *q)
> --
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
