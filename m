From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3 06/15] xprtrdma, svcrdma: Convert to ib_alloc_mr
Date: Thu, 6 Aug 2015 10:22:23 -0400
Message-ID: <55C36D9F.1040705@Netapp.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
 <1438241568-3685-7-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438241568-3685-7-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This looks good to me:

	Signed-off-by:  Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

Thanks,
Anna

On 07/30/2015 03:32 AM, Sagi Grimberg wrote:
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/frwr_ops.c           | 6 +++---
>  net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> index 63f282e..d6653f5 100644
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -117,7 +117,7 @@ __frwr_recovery_worker(struct work_struct *work)
>  	if (ib_dereg_mr(r->r.frmr.fr_mr))
>  		goto out_fail;
>  
> -	r->r.frmr.fr_mr = ib_alloc_fast_reg_mr(pd, depth);
> +	r->r.frmr.fr_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, depth);
>  	if (IS_ERR(r->r.frmr.fr_mr))
>  		goto out_fail;
>  
> @@ -148,7 +148,7 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *pd, struct ib_device *device,
>  	struct rpcrdma_frmr *f = &r->r.frmr;
>  	int rc;
>  
> -	f->fr_mr = ib_alloc_fast_reg_mr(pd, depth);
> +	f->fr_mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, depth);
>  	if (IS_ERR(f->fr_mr))
>  		goto out_mr_err;
>  	f->fr_pgl = ib_alloc_fast_reg_page_list(device, depth);
> @@ -158,7 +158,7 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *pd, struct ib_device *device,
>  
>  out_mr_err:
>  	rc = PTR_ERR(f->fr_mr);
> -	dprintk("RPC:       %s: ib_alloc_fast_reg_mr status %i\n",
> +	dprintk("RPC:       %s: ib_alloc_mr status %i\n",
>  		__func__, rc);
>  	return rc;
>  
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> index 6b36279..adcf904 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -738,7 +738,7 @@ static struct svc_rdma_fastreg_mr *rdma_alloc_frmr(struct svcxprt_rdma *xprt)
>  	if (!frmr)
>  		goto err;
>  
> -	mr = ib_alloc_fast_reg_mr(xprt->sc_pd, RPCSVC_MAXPAGES);
> +	mr = ib_alloc_mr(xprt->sc_pd, IB_MR_TYPE_MEM_REG, RPCSVC_MAXPAGES);
>  	if (IS_ERR(mr))
>  		goto err_free_frmr;
>  
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
