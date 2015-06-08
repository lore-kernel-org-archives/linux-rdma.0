From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Get rid of redundant verb ib_destroy_mr
Date: Mon, 8 Jun 2015 22:55:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE5D77@ORSMSX109.amr.corp.intel.com>
References: <1433769283-30541-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433769283-30541-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1174,6 +1174,18 @@ static int clean_mr(struct mlx5_ib_mr *mr)
>  	int umred = mr->umred;
>  	int err;
> 
> +	if (mr->sig) {
> +		if (mlx5_core_destroy_psv(dev->mdev,
> +					  mr->sig->psv_memory.psv_idx))
> +			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
> +				     mr->sig->psv_memory.psv_idx);
> +		if (mlx5_core_destroy_psv(dev->mdev,
> +					  mr->sig->psv_wire.psv_idx))
> +			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
> +				     mr->sig->psv_wire.psv_idx);
> +		kfree(mr->sig);
> +	}
> +
>  	if (!umred) {
>  		err = destroy_mkey(dev, mr);
>  		if (err) {

This patch doesn't introduce this problem, but the err check suggests that deregistration can fail for some reason.  If so, should mr->sig be cleared above, so that a second call to dereg doesn't attempt to free the memory twice?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
