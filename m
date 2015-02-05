From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 1/2] infiniband: cxgb4: Fix some format strings
Date: Thu, 5 Feb 2015 17:44:03 -0600
Message-ID: <008401d0419d$9fb9a8c0$df2cfa40$@opengridcomputing.com>
References: <1423179179-16847-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423179179-16847-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Rasmus Villemoes' <linux@rasmusvillemoes.dk>, 'Steve Wise' <swise@chelsio.com>, 'Roland Dreier' <roland@kernel.org>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise@opengridcomputing.com>

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Rasmus Villemoes
> Sent: Thursday, February 05, 2015 5:33 PM
> To: Steve Wise; Roland Dreier; Sean Hefty; Hal Rosenstock
> Cc: Rasmus Villemoes; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] infiniband: cxgb4: Fix some format strings
> 
> PDBG prepends MOD (which expands to "iw_cxgb4" ":") to the format
> string. So the KERN_INFO just ends up in the middle where it just
> garbles the output. At the same place, there's obviously no reason to
> add MOD explicitly.
> 
> The two other are straight-forward fixes of KERN_ERR KERN_ERR, where
> the second will end up as garbage in the output.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index eb5df4e62703..536356a8c58c 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -979,7 +979,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>  		}
>  	}
> 
> -	PDBG(KERN_INFO MOD "ocq memory: "
> +	PDBG("ocq memory: "
>  	       "hw_start 0x%x size %u mw_pa 0x%lx mw_kva %p\n",
>  	       devp->rdev.lldi.vr->ocq.start, devp->rdev.lldi.vr->ocq.size,
>  	       devp->rdev.oc_mw_pa, devp->rdev.oc_mw_kva);
> @@ -1368,7 +1368,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
>  					  t4_sq_host_wq_pidx(&qp->wq),
>  					  t4_sq_wq_size(&qp->wq));
>  		if (ret) {
> -			pr_err(KERN_ERR MOD "%s: Fatal error - "
> +			pr_err(MOD "%s: Fatal error - "
>  			       "DB overflow recovery failed - "
>  			       "error syncing SQ qid %u\n",
>  			       pci_name(ctx->lldi.pdev), qp->wq.sq.qid);
> @@ -1384,7 +1384,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
>  					  t4_rq_wq_size(&qp->wq));
> 
>  		if (ret) {
> -			pr_err(KERN_ERR MOD "%s: Fatal error - "
> +			pr_err(MOD "%s: Fatal error - "
>  			       "DB overflow recovery failed - "
>  			       "error syncing RQ qid %u\n",
>  			       pci_name(ctx->lldi.pdev), qp->wq.rq.qid);
> --
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
