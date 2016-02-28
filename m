From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/13] IB/core: generic RDMA READ/WRITE API
Date: Sun, 28 Feb 2016 17:05:52 +0200
Message-ID: <56D30CD0.9080108@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456596631-19418-8-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 9a77bb8..1ef3a1a 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -48,6 +48,7 @@
>   #include <rdma/ib_verbs.h>
>   #include <rdma/ib_cache.h>
>   #include <rdma/ib_addr.h>
> +#include <rdma/rw.h>
>
>   #include "core_priv.h"
>
> @@ -751,6 +752,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>   {
>   	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
>   	struct ib_qp *qp;
> +	int ret;
> +
> +	/*
> +	 * If the callers is using the RDMA API calculate the resources
> +	 * needed for the RDMA READ/WRITE operations.
> +	 *
> +	 * Note that these callers need to pass in a port number.
> +	 */
> +	if (qp_init_attr->cap.max_rdma_ctxs)
> +		rdma_rw_init_qp(device, qp_init_attr);
>
>   	qp = device->create_qp(pd, qp_init_attr, NULL);
>   	if (IS_ERR(qp))
> @@ -764,6 +775,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>   	atomic_set(&qp->usecnt, 0);
>   	qp->mrs_used = 0;
>   	spin_lock_init(&qp->mr_lock);
> +	INIT_LIST_HEAD(&qp->rdma_mrs);
>
>   	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
>   		return ib_create_xrc_qp(qp, qp_init_attr);
> @@ -787,6 +799,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>
>   	atomic_inc(&pd->usecnt);
>   	atomic_inc(&qp_init_attr->send_cq->usecnt);
> +
> +	if (qp_init_attr->cap.max_rdma_ctxs) {
> +		ret = rdma_rw_init_mrs(qp, qp_init_attr);
> +		if (ret) {
> +			pr_err("failed to init MR pool ret= %d\n", ret);
> +			ib_destroy_qp(qp);
> +			qp = ERR_PTR(ret);
> +		}

This is new compared to what we did in fabrics.

Note that this is an ideal place to reserve send queue
entries for MR assisted rdmas (e.g. iWARP). This way the
ULP does not even need to be aware of the reservations!

> +	}
> +
>   	return qp;
>   }
>   EXPORT_SYMBOL(ib_create_qp);
