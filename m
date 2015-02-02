From: Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 2/2] infiniband: Use unsigned for bit index
Date: Mon, 2 Feb 2015 12:03:31 +0000
Message-ID: <36AE2E863FF33A4F9FBBE296E34DBC8F5A096246@CMEXMB1.ad.emulex.com>
References: <1421419196-4659-1-git-send-email-linux@rasmusvillemoes.dk>
 <1421419196-4659-2-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421419196-4659-2-git-send-email-linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
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
> Subject: [PATCH 2/2] infiniband: Use unsigned for bit index
> 
> In the expressions idx/32 and idx%32, both idx and 32 have signed type, and
> unfortunately the C standard prescribes rounding to 0, so unless gcc can
> prove that idx is non-negative, these cannot be implemented as simple shift
> respectively mask operations. Help gcc by changing the type of idx to
> unsigned - this cuts another few instructions from the generated code.
> 
> Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index eff11e6c6183..61c3047f5170 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1479,10 +1479,10 @@ mbx_err:
>  	return status;
>  }
> 
> -static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
> +static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, unsigned int
> +idx)
>  {
> -	int i = idx / 32;
> -	unsigned int mask = (1 << (idx % 32));
> +	unsigned int i = idx / 32;
> +	u32 mask = (1U << (idx % 32));
> 
>  	srq->idx_bit_fields[i] ^= mask;
>  }
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
