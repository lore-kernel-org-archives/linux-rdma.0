From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 3/6] IB/ipoib: Handle QP in SQE state
Date: Wed, 15 Apr 2015 17:20:31 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD5DC42DB7@CMEXMB1.ad.emulex.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
 <1427971145-26943-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> Sent: Thursday, April 02, 2015 4:09 PM
> To: Roland Dreier; Doug Ledford
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Erez Shitrit; Tal Alon; Amir Vadai; Or Gerlitz
> Subject: [PATCH for-next 3/6] IB/ipoib: Handle QP in SQE state
> 
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> As the result of a completion error the QP can moved to SQE state by the
> hardware. Since it's not the Error state, there are no flushes and hence the
> driver doesn't know about that.

As per spec, QP transition to SQE causes flush completion for subsequent WQEs, the description is telling other way. Am I missing something?

> 
> The fix creates a task that after completion with error which is not a flush
> tracks the QP state and if it is in SQE state moves it back to RTS.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h    |    5 +++
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c |   59
> ++++++++++++++++++++++++++++++-
>  2 files changed, 63 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h
> b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 769044c..2703d9a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -299,6 +299,11 @@ struct ipoib_neigh_table {
>  	struct completion		deleted;
>  };
> 
> +struct ipoib_qp_state_validate {
> +	struct work_struct work;
> +	struct ipoib_dev_priv   *priv;
> +};
> +
>  /*
>   * Device private locking: network stack tx_lock protects members used
>   * in TX fast path, lock protects everything else.  lock nests inside diff --git
> a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 29b376d..63b92cb 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -327,6 +327,51 @@ static void ipoib_dma_unmap_tx(struct ib_device *ca,
>  	}
>  }
> 
> +/*
> + * As the result of a completion error the QP Can be transferred to SQE states.
> + * The function checks if the (send)QP is in SQE state and
> + * moves it back to RTS state, that in order to have it functional again.
> + */
> +static void ipoib_qp_state_validate_work(struct work_struct *work) {
> +	struct ipoib_qp_state_validate *qp_work =
> +		container_of(work, struct ipoib_qp_state_validate, work);
> +
> +	struct ipoib_dev_priv *priv = qp_work->priv;
> +	struct ib_qp_attr qp_attr;
> +	struct ib_qp_init_attr query_init_attr;
> +	int ret;
> +
> +	ret = ib_query_qp(priv->qp, &qp_attr, IB_QP_STATE, &query_init_attr);
> +	if (ret) {
> +		ipoib_warn(priv, "%s: Failed to query QP ret: %d\n",
> +			   __func__, ret);
> +		goto free_res;
> +	}
> +	pr_info("%s: QP: 0x%x is in state: %d\n",
> +		__func__, priv->qp->qp_num, qp_attr.qp_state);
> +
> +	/* currently support only in SQE->RTS transition*/
> +	if (qp_attr.qp_state == IB_QPS_SQE) {
> +		qp_attr.qp_state = IB_QPS_RTS;
> +
> +		ret = ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE);
> +		if (ret) {
> +			pr_warn("failed(%d) modify QP:0x%x SQE->RTS\n",
> +				ret, priv->qp->qp_num);
> +			goto free_res;
> +		}
> +		pr_info("%s: QP: 0x%x moved from IB_QPS_SQE to
> IB_QPS_RTS\n",
> +			__func__, priv->qp->qp_num);
> +	} else {
> +		pr_warn("QP (%d) will stay in state: %d\n",
> +			priv->qp->qp_num, qp_attr.qp_state);
> +	}
> +
> +free_res:
> +	kfree(qp_work);
> +}
> +
>  static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev); @@ -358,10 +403,22
> @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc
> *wc)
>  		netif_wake_queue(dev);
> 
>  	if (wc->status != IB_WC_SUCCESS &&
> -	    wc->status != IB_WC_WR_FLUSH_ERR)
> +	    wc->status != IB_WC_WR_FLUSH_ERR) {
> +		struct ipoib_qp_state_validate *qp_work;
>  		ipoib_warn(priv, "failed send event "
>  			   "(status=%d, wrid=%d vend_err %x)\n",
>  			   wc->status, wr_id, wc->vendor_err);
> +		qp_work = kzalloc(sizeof(*qp_work), GFP_ATOMIC);
> +		if (!qp_work) {
> +			ipoib_warn(priv, "%s Failed alloc
> ipoib_qp_state_validate for qp: 0x%x\n",
> +				   __func__, priv->qp->qp_num);
> +			return;
> +		}
> +
> +		INIT_WORK(&qp_work->work, ipoib_qp_state_validate_work);
> +		qp_work->priv = priv;
> +		queue_work(priv->wq, &qp_work->work);
> +	}
>  }
> 
>  static int poll_tx(struct ipoib_dev_priv *priv)
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
