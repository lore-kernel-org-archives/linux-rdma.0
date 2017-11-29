From: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] IB/ipoib: Replace printk with pr_warn
Date: Wed, 29 Nov 2017 17:29:23 +0800
Message-ID: <2dc6b60d-837b-45c1-376f-d858d51b6b6d@oracle.com>
References: <20171129092429.10293-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171129092429.10293-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/11/29 17:24, Yuval Shaia wrote:
> pr_* is the preferred way to print messages, replace all
> printk(KERN_WARN, ...) with pr_warn.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  8 ++++----
>   drivers/infiniband/ulp/ipoib/ipoib_main.c  | 23 +++++++++++------------
>   drivers/infiniband/ulp/ipoib/ipoib_verbs.c |  6 +++---
>   3 files changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 87f4bd99cdf7..c0a596e4c258 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -876,7 +876,7 @@ int ipoib_cm_dev_open(struct net_device *dev)
>   
>   	priv->cm.id = ib_create_cm_id(priv->ca, ipoib_cm_rx_handler, dev);
>   	if (IS_ERR(priv->cm.id)) {
> -		printk(KERN_WARNING "%s: failed to create CM ID\n", priv->ca->name);
> +		pr_warn("%s: failed to create CM ID\n", priv->ca->name);
>   		ret = PTR_ERR(priv->cm.id);
>   		goto err_cm;
>   	}
> @@ -884,8 +884,8 @@ int ipoib_cm_dev_open(struct net_device *dev)
>   	ret = ib_cm_listen(priv->cm.id, cpu_to_be64(IPOIB_CM_IETF_ID | priv->qp->qp_num),
>   			   0);
>   	if (ret) {
> -		printk(KERN_WARNING "%s: failed to listen on ID 0x%llx\n", priv->ca->name,
> -		       IPOIB_CM_IETF_ID | priv->qp->qp_num);
> +		pr_warn("%s: failed to listen on ID 0x%llx\n", priv->ca->name,
> +			IPOIB_CM_IETF_ID | priv->qp->qp_num);
>   		goto err_listen;
>   	}
>   
> @@ -1562,7 +1562,7 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
>   	priv->cm.srq = ib_create_srq(priv->pd, &srq_init_attr);
>   	if (IS_ERR(priv->cm.srq)) {
>   		if (PTR_ERR(priv->cm.srq) != -ENOSYS)
> -			printk(KERN_WARNING "%s: failed to allocate SRQ, error %ld\n",
> +			pr_warn("%s: failed to allocate SRQ, error %ld\n",
>   			       priv->ca->name, PTR_ERR(priv->cm.srq));
>   		priv->cm.srq = NULL;
>   		return;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 12b7f911f0e5..6930ee0d63cf 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1663,8 +1663,8 @@ static int ipoib_dev_init_default(struct net_device *dev)
>   
>   	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
>   	if (!priv->tx_ring) {
> -		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
> -		       priv->ca->name, ipoib_sendq_size);
> +		pr_warn("%s: failed to allocate TX ring (%d entries)\n",
> +			priv->ca->name, ipoib_sendq_size);
>   		goto out_rx_ring_cleanup;
>   	}
>   
> @@ -2204,8 +2204,7 @@ static struct net_device *ipoib_add_port(const char *format,
>   
>   	result = ib_query_port(hca, port, &attr);
>   	if (result) {
> -		printk(KERN_WARNING "%s: ib_query_port %d failed\n",
> -		       hca->name, port);
> +		pr_warn("%s: ib_query_port %d failed\n", hca->name, port);
>   		goto device_init_failed;
>   	}
>   
> @@ -2220,8 +2219,8 @@ static struct net_device *ipoib_add_port(const char *format,
>   
>   	result = ib_query_pkey(hca, port, 0, &priv->pkey);
>   	if (result) {
> -		printk(KERN_WARNING "%s: ib_query_pkey port %d failed (ret = %d)\n",
> -		       hca->name, port, result);
> +		pr_warn("%s: ib_query_pkey port %d failed (ret = %d)\n",
> +			hca->name, port, result);
>   		goto device_init_failed;
>   	}
>   
> @@ -2238,8 +2237,8 @@ static struct net_device *ipoib_add_port(const char *format,
>   
>   	result = ib_query_gid(hca, port, 0, &priv->local_gid, NULL);
>   	if (result) {
> -		printk(KERN_WARNING "%s: ib_query_gid port %d failed (ret = %d)\n",
> -		       hca->name, port, result);
> +		pr_warn("%s: ib_query_gid port %d failed (ret = %d)\n",
> +			hca->name, port, result);
>   		goto device_init_failed;
>   	}
>   
> @@ -2249,8 +2248,8 @@ static struct net_device *ipoib_add_port(const char *format,
>   
>   	result = ipoib_dev_init(priv->dev, hca, port);
>   	if (result) {
> -		printk(KERN_WARNING "%s: failed to initialize port %d (ret = %d)\n",
> -		       hca->name, port, result);
> +		pr_warn("%s: failed to initialize port %d (ret = %d)\n",
> +			hca->name, port, result);
>   		goto device_init_failed;
>   	}
>   
> @@ -2260,8 +2259,8 @@ static struct net_device *ipoib_add_port(const char *format,
>   
>   	result = register_netdev(priv->dev);
>   	if (result) {
> -		printk(KERN_WARNING "%s: couldn't register ipoib port %d; error %d\n",
> -		       hca->name, port, result);
> +		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
> +			hca->name, port, result);
>   		goto register_failed;
>   	}
>   
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> index a1ed25422b72..984a88096f39 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
> @@ -178,7 +178,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
>   	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_rx_completion, NULL,
>   				     priv, &cq_attr);
>   	if (IS_ERR(priv->recv_cq)) {
> -		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
> +		pr_warn("%s: failed to create receive CQ\n", ca->name);
>   		goto out_cm_dev_cleanup;
>   	}
>   
> @@ -187,7 +187,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
>   	priv->send_cq = ib_create_cq(priv->ca, ipoib_ib_tx_completion, NULL,
>   				     priv, &cq_attr);
>   	if (IS_ERR(priv->send_cq)) {
> -		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
> +		pr_warn("%s: failed to create send CQ\n", ca->name);
>   		goto out_free_recv_cq;
>   	}
>   
> @@ -208,7 +208,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
>   
>   	priv->qp = ib_create_qp(priv->pd, &init_attr);
>   	if (IS_ERR(priv->qp)) {
> -		printk(KERN_WARNING "%s: failed to create QP\n", ca->name);
> +		pr_warn("%s: failed to create QP\n", ca->name);
>   		goto out_free_send_cq;
>   	}
>   
Reviewed-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks a lot.
Zhu Yanjun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
