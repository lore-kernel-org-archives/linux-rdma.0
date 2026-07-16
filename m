Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1563F44FF;
	Thu, 16 Jul 2026 08:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191744; cv=none; b=Ph0rVIpgnKRneuPGu/Ror7DcdvRNr1rOboRiULgLUTOXXf/SpMvWnkZlrObAehrhjKcs2DUrOE3cdJPWROX8W1T87gy59Xmk8LMU3zHkBVJ4XnE4/XKd9n8a5gtKJ6xWlgNkhK7/jlRR5m1Br+F87T66PGK2tgknhBi/M8k9tjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191744; c=relaxed/simple;
	bh=hLp+PybCHCtVaCleIYF2wKftHYP0X7h/yf9Y4sLQRF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fool2YdspWUzXlH+gy6rUAIgscJkqWmpPVmCSj0ZsRHTwr365Kemze1lD4D2dBZQNLfTyOYDNG6jb4QsNcddCOWTfVjMPdAlFH1IE4NLoehef9aqaywmXTsFm21w78B37QKJz8KhF7VLTKWC9Wl1sDRafG+k2bAvE68aJGljwbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ta4qhwCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ta4qhwCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4606A1F00A3A;
	Thu, 16 Jul 2026 08:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191735;
	bh=ZqqlpTdbq81wO6ZyctFhU08s1DQ3cUKDS1ZmqwjQrd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ta4qhwCG88gN6hmJhCVwhu5LQhZUH+5KiOSpkyx9U1TxqUEUH0nv3Ob23zz3awOCj
	 9nDFGVv8IS6pBlmcyWF+B+R8Z+1DaAdI2IVvzCIhY50UpWsjaDJJFxM7mXeGNoMn4J
	 ViCWqZCAh92XE/caQr0JE8/a8DluWMWi5xsRLPvGq1GN5XRHVCeXy++gMz23BXtEOF
	 7rL8nd+qcI+Xz1bUBVHzvDoQ7260TkGW2pI6t12fyVejU7h2C8qYUH+3siUbr+HHh1
	 C1nisk9NsRzwVcsXSDB3IDK+DGi11OOpj+y+dw1TP1Dkgmg8E6oKzZQvIOkJ3qqDNJ
	 EBaTIGKMS8esA==
Date: Thu, 16 Jul 2026 11:48:48 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, longli@microsoft.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3] RDMA/mana_ib: Adopt robust udata
Message-ID: <20260716084848.GD70906@unreal>
References: <20260714123113.3792099-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714123113.3792099-1-kotaranov@linux.microsoft.com>

On Tue, Jul 14, 2026 at 05:31:13AM -0700, Konstantin Taranov wrote:
> From: Konstantin Taranov <kotaranov@microsoft.com>
> 
> Enable the uverbs robust udata interface in mana_ib by setting
> uverbs_robust_udata and converting the driver to the new udata
> handling model.

Why didn't you set ".uverbs_robust_udata = true" in this patch?

Thanks

> 
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> ---
> v3: use ib_no_udata_io
> v2: Removed the udata request for alloc ucontext
>  drivers/infiniband/hw/mana/cq.c     |  8 +++++-
>  drivers/infiniband/hw/mana/device.c |  1 +
>  drivers/infiniband/hw/mana/main.c   | 29 ++++++++++++++++------
>  drivers/infiniband/hw/mana/mr.c     | 13 ++++++++++
>  drivers/infiniband/hw/mana/qp.c     | 38 +++++++++++++++++++++++------
>  drivers/infiniband/hw/mana/wq.c     | 12 +++++++++
>  include/uapi/rdma/mana-abi.h        |  2 +-
>  7 files changed, 86 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
> index f2547989f..d4e5e3f91 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -27,7 +27,8 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	is_rnic_cq = mana_ib_is_rnic(mdev);
>  
>  	if (udata) {
> -		err = ib_copy_validate_udata_in(udata, ucmd, buf_addr);
> +		err = ib_copy_validate_udata_in_cm(udata, ucmd, buf_addr,
> +						   MANA_IB_CREATE_RNIC_CQ);
>  		if (err)
>  			return err;
>  
> @@ -105,6 +106,11 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
>  	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
>  	struct ib_device *ibdev = ibcq->device;
>  	struct mana_ib_dev *mdev;
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  
> diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
> index 9811570ab..a8d19586a 100644
> --- a/drivers/infiniband/hw/mana/device.c
> +++ b/drivers/infiniband/hw/mana/device.c
> @@ -15,6 +15,7 @@ static const struct ib_device_ops mana_ib_dev_ops = {
>  	.owner = THIS_MODULE,
>  	.driver_id = RDMA_DRIVER_MANA,
>  	.uverbs_abi_ver = MANA_IB_UVERBS_ABI_VERSION,
> +	.uverbs_robust_udata = true,
>  
>  	.add_gid = mana_ib_gd_add_gid,
>  	.alloc_mw = mana_ib_alloc_mw,
> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index efe2935bd..e645b7637 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -101,6 +101,10 @@ int mana_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  	struct gdma_context *gc;
>  	int err;
>  
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
> +
>  	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  	gc = mdev_to_gc(dev);
>  
> @@ -133,6 +137,11 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  	struct gdma_destroy_pd_req req = {};
>  	struct mana_ib_dev *dev;
>  	struct gdma_context *gc;
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  	gc = mdev_to_gc(dev);
> @@ -142,7 +151,11 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
>  
>  	req.pd_handle = pd->pd_handle;
>  
> -	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err)
> +		return err;
> +
> +	return 0;
>  }
>  
>  static int mana_gd_destroy_doorbell_page(struct gdma_context *gc,
> @@ -198,17 +211,17 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
>  	int doorbell_page;
>  	int ret;
>  
> +	ret = ib_no_udata_io(udata);
> +	if (ret)
> +		return ret;
> +
>  	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  	gc = mdev_to_gc(mdev);
>  
>  	/* Allocate a doorbell page index */
>  	ret = mana_gd_allocate_doorbell_page(gc, &doorbell_page);
> -	if (ret) {
> -		ibdev_dbg(ibdev, "Failed to allocate doorbell page %d\n", ret);
> +	if (ret)
>  		return ret;
> -	}
> -
> -	ibdev_dbg(ibdev, "Doorbell page allocated %d\n", doorbell_page);
>  
>  	ucontext->doorbell = doorbell_page;
>  
> @@ -575,7 +588,7 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
>  	struct pci_dev *pdev = to_pci_dev(mdev_to_gc(dev)->dev);
>  	int err;
>  
> -	err = ib_is_udata_in_empty(uhw);
> +	err = ib_no_udata_io(uhw);
>  	if (err)
>  		return err;
>  
> @@ -605,7 +618,7 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
>  	if (!mana_ib_is_rnic(dev))
>  		props->raw_packet_caps = IB_RAW_PACKET_CAP_IP_CSUM;
>  
> -	return ib_respond_empty_udata(uhw);
> +	return 0;
>  }
>  
>  int mana_ib_query_port(struct ib_device *ibdev, u32 port,
> diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
> index 030bfdcff..1233685b4 100644
> --- a/drivers/infiniband/hw/mana/mr.c
> +++ b/drivers/infiniband/hw/mana/mr.c
> @@ -113,6 +113,10 @@ struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
>  	if (dmah)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return ERR_PTR(err);
> +
>  	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  
>  	ibdev_dbg(ibdev,
> @@ -327,6 +331,11 @@ int mana_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
>  {
>  	struct mana_ib_dev *mdev = container_of(ibmw->device, struct mana_ib_dev, ib_dev);
>  	struct mana_ib_pd *pd = container_of(ibmw->pd, struct mana_ib_pd, ibpd);
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	return mana_ib_gd_create_mw(mdev, pd, ibmw);
>  }
> @@ -346,6 +355,10 @@ int mana_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
>  	struct mana_ib_dev *dev;
>  	int err;
>  
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
> +
>  	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
>  
>  	err = mana_ib_gd_destroy_mr(dev, mr->mr_handle);
> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
> index 60926f39a..b5ff07e34 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -651,10 +651,8 @@ static int mana_ib_create_ud_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
>  	u32 doorbell, queue_size;
>  	int i, err;
>  
> -	if (udata) {
> -		ibdev_dbg(&mdev->ib_dev, "User-level UD QPs are not supported\n");
> +	if (udata)
>  		return -EOPNOTSUPP;
> -	}
>  
>  	for (i = 0; i < MANA_UD_QUEUE_TYPE_MAX; ++i) {
>  		queue_size = mana_ib_queue_size(attr, i);
> @@ -745,6 +743,11 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  	struct gdma_context *gc = mdev_to_gc(mdev);
>  	struct mana_port_context *mpc;
>  	struct net_device *ndev;
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	mana_gd_init_req_hdr(&req.hdr, MANA_IB_SET_QP_STATE, sizeof(req), sizeof(resp));
>  
> @@ -797,7 +800,11 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  		req.ah_attr.flow_label = attr->ah_attr.grh.flow_label;
>  	}
>  
> -	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
> +	if (err)
> +		return err;
> +
> +	return 0;
>  }
>  
>  int mana_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
> @@ -826,7 +833,11 @@ static int mana_ib_destroy_qp_rss(struct mana_ib_qp *qp,
>  	struct mana_ib_pd *pd;
>  	struct mana_ib_wq *wq;
>  	struct ib_wq *ibwq;
> -	int i;
> +	int i, err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	ndev = mana_ib_get_netdev(qp->ibqp.device, qp->port);
>  	mpc = netdev_priv(ndev);
> @@ -872,6 +883,11 @@ static int mana_ib_destroy_qp_raw(struct mana_ib_qp *qp, struct ib_udata *udata)
>  	struct mana_port_context *mpc;
>  	struct net_device *ndev;
>  	struct mana_ib_pd *pd;
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	ndev = mana_ib_get_netdev(qp->ibqp.device, qp->port);
>  	mpc = netdev_priv(ndev);
> @@ -890,7 +906,11 @@ static int mana_ib_destroy_rc_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
>  {
>  	struct mana_ib_dev *mdev =
>  		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
> -	int i;
> +	int i, err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	mana_table_remove_qp(mdev, qp);
>  
> @@ -908,7 +928,11 @@ static int mana_ib_destroy_ud_qp(struct mana_ib_qp *qp, struct ib_udata *udata)
>  {
>  	struct mana_ib_dev *mdev =
>  		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
> -	int i;
> +	int i, err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	mana_remove_qp_from_cqs(qp);
>  	mana_table_remove_qp(mdev, qp);
> diff --git a/drivers/infiniband/hw/mana/wq.c b/drivers/infiniband/hw/mana/wq.c
> index 5c2134a0b..6b066d605 100644
> --- a/drivers/infiniband/hw/mana/wq.c
> +++ b/drivers/infiniband/hw/mana/wq.c
> @@ -55,6 +55,11 @@ int mana_ib_destroy_wq(struct ib_wq *ibwq, struct ib_udata *udata)
>  	struct mana_ib_wq *wq = container_of(ibwq, struct mana_ib_wq, ibwq);
>  	struct ib_device *ib_dev = ibwq->device;
>  	struct mana_ib_dev *mdev;
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
>  
>  	mdev = container_of(ib_dev, struct mana_ib_dev, ib_dev);
>  
> @@ -69,10 +74,17 @@ int mana_ib_create_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_table,
>  				 struct ib_rwq_ind_table_init_attr *init_attr,
>  				 struct ib_udata *udata)
>  {
> +	int err;
> +
> +	err = ib_no_udata_io(udata);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * There is no additional data in ind_table to be maintained by this
>  	 * driver, do nothing
>  	 */
> +
>  	return 0;
>  }
>  
> diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
> index a75bf32b8..8336bf51b 100644
> --- a/include/uapi/rdma/mana-abi.h
> +++ b/include/uapi/rdma/mana-abi.h
> @@ -25,7 +25,7 @@ enum mana_ib_create_cq_flags {
>  
>  struct mana_ib_create_cq {
>  	__aligned_u64 buf_addr;
> -	__u16	flags;
> +	__u16	comp_mask;
>  	__u16	reserved0;
>  	__u32	reserved1;
>  };
> -- 
> 2.43.0
> 
