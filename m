From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] infiniband:cxgb4:Make the function rdma_supported bool
Date: Thu, 16 Jul 2015 13:40:41 -0500
Message-ID: <003901d0bff6$eb0aadb0$c1200910$@opengridcomputing.com>
References: <1437071644-23895-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437071644-23895-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Nicholas Krause' <xerofoify@gmail.com>, swise@chelsio.com
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Is this change really worth the effort?


> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Thursday, July 16, 2015 1:34 PM
> To: swise@chelsio.com
> Cc: dledford@redhat.com; sean.hefty@intel.com; hal.rosenstock@gmail.com; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] infiniband:cxgb4:Make the function rdma_supported bool
> 
> This makes the function rdma_supported have a return type of bool
> due to this particular function's return statement always returning
> either one or zero as its return value.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 1a29739..285f6606 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -912,7 +912,7 @@ static void c4iw_remove(struct uld_ctx *ctx)
>  	c4iw_dealloc(ctx);
>  }
> 
> -static int rdma_supported(const struct cxgb4_lld_info *infop)
> +static bool rdma_supported(const struct cxgb4_lld_info *infop)
>  {
>  	return infop->vr->stag.size > 0 && infop->vr->pbl.size > 0 &&
>  	       infop->vr->rq.size > 0 && infop->vr->qp.size > 0 &&
> --
> 2.1.4
