Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=12.32.117.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795773484;
	b=egZz+4WvfrwDy4xQSfuzTDaUaXiUxa974O0bKUR6SMfoMNCsm9nj8JZ0JVQspmoJWWBl
	 2a+gMZfcp+yBpQ1Og5FPq/0wBdGTrxeZYl+X/kspmPNf5u5zCCT5hI1czS6BZyI982hVc
	 BdoBx0Xyr1KWA0kDvpuAWOPEb7uFf0AzpIiKdLlmHnlXuZsoXgvGQkmCTa67au2FOwPL9
	 t1Ple04rALYD+WUSncmjLSwFU/mJc6GpvMsMC3YTk+ZAEXT7X+BXmCJNlIndIJNgiN6dQ
	 uyLy/89ZjzEf2eVPvwGA8y4h9ohtR08xHsw9zr9Csjq8HpImTM74vY9UQob/a85u7QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773484;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JFphfoy6S9D+/a+A+JrnpdbDLlR+JncLJixu3CUmI0k=;
	b=ku6xDKzZgJYiyu80Je82JB6mCreX8bwU/z4xOrJgZC8IMowfBx2cfXy4AJuB7wNDiWZm
	 09ay3+wLCikfxlUOvju6/G7ZwEhhVc/nuH3IOXy+OWCujZbjik/tSRQUbloXryrdzJRpH
	 UQCSjzirT/yvtH+Gfs0/gkETa+TR93s36B7KCtY2abxdmgitngNvASbsaMVTu/ZWQ/UZW
	 70FCvg/VyZXyE0ZJpTDdOSkeDyhXb8hUankqnKMCCTIAtgYlw6gLPfKDRmSIIioYhdHlU
	 b8TsY7iJAAMOKilwf0vpy7JH5Oumjid94DjlH2doq8VM2OnZ9zwv581Oh4M1h0wgyaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chelsio.com;
	spf=pass smtp.mailfrom=chelsio.com;
	arc=none smtp.remote-ip=12.32.117.8
Received: from stargate.chelsio.com (unknown [12.32.117.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5ED606A31C;
	Fri, 27 Nov 2026 09:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA5ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from localhost (Showryamn.asicdesigners.com [10.193.191.35])
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 6AR9vl7Q022767;
	Fri, 27 Nov 2026 01:57:47 -0800
Date: Fri, 27 Nov 2026 15:27:46 +0530
From: Showrya M N <showrya@chelsio.com>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, Potnuri Bharat Teja <bharat@chelsio.com>,
        "larrystevenwise@gmail.com" <larrystevenwise@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rolanddreier@rivian.com" <rolanddreier@rivian.com>
Subject: Re: [PATCH v2] RDMA/cxgb4: Use dealloc_driver op to fix ioremap leak
 on alloc failure
Message-ID: <awlUGjqjkKPAK2nV@chelsio.com>
References: <20261123165128.GL179082@ziepe.ca>
 <20261126170841.11048-1-serhatkumral1@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126170841.11048-1-serhatkumral1@gmail.com>

On Thursday, November 11/26/26, 2026 at 22:38:41 +0530, Serhat Kumral wrote:

tested-by: Showrya M N <showrya@chelsio.com>

Thanks.

> In c4iw_alloc(), if c4iw_rdev_open() fails, the previously ioremapped
> BAR2/on-chip memory (bar2_kva / oc_mw_kva) is leaked because
> ib_dealloc_device() does not unmap it.
> 
> Refactor c4iw_dealloc() to take struct ib_device * and register it as the
> .dealloc_driver callback in c4iw_dev_ops. Move ib_set_device_ops() and
> the xarray/mutex/waitqueue initializations earlier in c4iw_alloc() so
> that all ib_dealloc_device() error paths invoke c4iw_dealloc(). Guard
> c4iw_rdev_close() with dev->rdev.free_workq so it is only called when
> c4iw_rdev_open() succeeded.
> 
> Update c4iw_register_device() and c4iw_remove() to rely on
> ib_dealloc_device() and ib_unregister_device() rather than calling
> c4iw_dealloc() directly, and handle the case where cancel_work_sync()
> cancels reg_work before registration runs.
> 
> Fixes: c6d7b26791a2 ("RDMA/cxgb4: Support on-chip SQs")
> Fixes: fa658a98a2d0 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/device.c   | 66 +++++++++++++-------------
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  3 +-
>  drivers/infiniband/hw/cxgb4/provider.c |  7 +--
>  3 files changed, 40 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 24ac9871ce67..336747080abd 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -931,22 +931,23 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
>  	c4iw_destroy_resource(&rdev->resource);
>  }
>  
> -void c4iw_dealloc(struct uld_ctx *ctx)
> +void c4iw_dealloc(struct ib_device *ibdev)
>  {
> -	debugfs_remove_recursive(ctx->dev->debugfs_root);
> -	c4iw_rdev_close(&ctx->dev->rdev);
> -	WARN_ON(!xa_empty(&ctx->dev->cqs));
> -	WARN_ON(!xa_empty(&ctx->dev->qps));
> -	WARN_ON(!xa_empty(&ctx->dev->mrs));
> -	wait_event(ctx->dev->wait, xa_empty(&ctx->dev->hwtids));
> -	WARN_ON(!xa_empty(&ctx->dev->stids));
> -	WARN_ON(!xa_empty(&ctx->dev->atids));
> -	if (ctx->dev->rdev.bar2_kva)
> -		iounmap(ctx->dev->rdev.bar2_kva);
> -	if (ctx->dev->rdev.oc_mw_kva)
> -		iounmap(ctx->dev->rdev.oc_mw_kva);
> -	ib_dealloc_device(&ctx->dev->ibdev);
> -	ctx->dev = NULL;
> +	struct c4iw_dev *dev = to_c4iw_dev(ibdev);
> +
> +	debugfs_remove_recursive(dev->debugfs_root);
> +	if (dev->rdev.free_workq)
> +		c4iw_rdev_close(&dev->rdev);
> +	WARN_ON(!xa_empty(&dev->cqs));
> +	WARN_ON(!xa_empty(&dev->qps));
> +	WARN_ON(!xa_empty(&dev->mrs));
> +	wait_event(dev->wait, xa_empty(&dev->hwtids));
> +	WARN_ON(!xa_empty(&dev->stids));
> +	WARN_ON(!xa_empty(&dev->atids));
> +	if (dev->rdev.bar2_kva)
> +		iounmap(dev->rdev.bar2_kva);
> +	if (dev->rdev.oc_mw_kva)
> +		iounmap(dev->rdev.oc_mw_kva);
>  }
>  
>  static void c4iw_remove(struct uld_ctx *ctx)
> @@ -954,12 +955,12 @@ static void c4iw_remove(struct uld_ctx *ctx)
>  	pr_debug("c4iw_dev %p\n", ctx->dev);
>  
>  	/* c4iw_register_device() may still be using ctx->dev. */
> -	cancel_work_sync(&ctx->reg_work);
> -	if (!ctx->dev)
> -		return;
> +	if (cancel_work_sync(&ctx->reg_work))
> +		ib_dealloc_device(&ctx->dev->ibdev);
> +	else if (ctx->dev)
> +		c4iw_unregister_device(ctx->dev);
>  
> -	c4iw_unregister_device(ctx->dev);
> -	c4iw_dealloc(ctx);
> +	ctx->dev = NULL;
>  }
>  
>  static int rdma_supported(const struct cxgb4_lld_info *infop)
> @@ -990,6 +991,19 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>  	}
>  	devp->rdev.lldi = *infop;
>  
> +	xa_init_flags(&devp->cqs, XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&devp->qps, XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&devp->mrs, XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&devp->hwtids, XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&devp->atids, XA_FLAGS_LOCK_IRQ);
> +	xa_init_flags(&devp->stids, XA_FLAGS_LOCK_IRQ);
> +	mutex_init(&devp->rdev.stats.lock);
> +	mutex_init(&devp->db_mutex);
> +	INIT_LIST_HEAD(&devp->db_fc_list);
> +	init_waitqueue_head(&devp->wait);
> +	devp->avail_ird = devp->rdev.lldi.max_ird_adapter;
> +	ib_set_device_ops(&devp->ibdev, &c4iw_dev_ops);
> +
>  	/* init various hw-queue params based on lld info */
>  	pr_debug("Ing. padding boundary is %d, egrsstatuspagesize = %d\n",
>  		 devp->rdev.lldi.sge_ingpadboundary,
> @@ -1050,18 +1064,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>  		return ERR_PTR(ret);
>  	}
>  
> -	xa_init_flags(&devp->cqs, XA_FLAGS_LOCK_IRQ);
> -	xa_init_flags(&devp->qps, XA_FLAGS_LOCK_IRQ);
> -	xa_init_flags(&devp->mrs, XA_FLAGS_LOCK_IRQ);
> -	xa_init_flags(&devp->hwtids, XA_FLAGS_LOCK_IRQ);
> -	xa_init_flags(&devp->atids, XA_FLAGS_LOCK_IRQ);
> -	xa_init_flags(&devp->stids, XA_FLAGS_LOCK_IRQ);
> -	mutex_init(&devp->rdev.stats.lock);
> -	mutex_init(&devp->db_mutex);
> -	INIT_LIST_HEAD(&devp->db_fc_list);
> -	init_waitqueue_head(&devp->wait);
> -	devp->avail_ird = devp->rdev.lldi.max_ird_adapter;
> -
>  	if (c4iw_debugfs_root) {
>  		devp->debugfs_root = debugfs_create_dir(
>  					pci_name(devp->rdev.lldi.pdev),
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index e17c1252536b..2ab852e611c6 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -1003,7 +1003,8 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
>  			    u32 max_num_sg);
>  int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
>  		   unsigned int *sg_offset);
> -void c4iw_dealloc(struct uld_ctx *ctx);
> +void c4iw_dealloc(struct ib_device *ibdev);
> +extern const struct ib_device_ops c4iw_dev_ops;
>  struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
>  					   u64 length, u64 virt, int acc,
>  					   struct ib_dmah *dmah,
> diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
> index 904a5323a693..8fa9b88f3b2a 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -460,7 +460,7 @@ static void get_dev_fw_str(struct ib_device *dev, char *str)
>  		 FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
>  }
>  
> -static const struct ib_device_ops c4iw_dev_ops = {
> +const struct ib_device_ops c4iw_dev_ops = {
>  	.owner = THIS_MODULE,
>  	.driver_id = RDMA_DRIVER_CXGB4,
>  	.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION,
> @@ -472,6 +472,7 @@ static const struct ib_device_ops c4iw_dev_ops = {
>  	.create_cq = c4iw_create_cq,
>  	.create_qp = c4iw_create_qp,
>  	.create_srq = c4iw_create_srq,
> +	.dealloc_driver = c4iw_dealloc,
>  	.dealloc_pd = c4iw_deallocate_pd,
>  	.dealloc_ucontext = c4iw_dealloc_ucontext,
>  	.dereg_mr = c4iw_dereg_mr,
> @@ -552,7 +553,6 @@ void c4iw_register_device(struct work_struct *work)
>  	memcpy(dev->ibdev.iw_ifname, dev->rdev.lldi.ports[0]->name,
>  	       sizeof(dev->ibdev.iw_ifname));
>  
> -	ib_set_device_ops(&dev->ibdev, &c4iw_dev_ops);
>  	ret = set_netdevs(&dev->ibdev, &dev->rdev);
>  	if (ret)
>  		goto err_dealloc_ctx;
> @@ -566,7 +566,8 @@ void c4iw_register_device(struct work_struct *work)
>  err_dealloc_ctx:
>  	pr_err("%s - Failed registering iwarp device: %d\n",
>  	       pci_name(ctx->lldi.pdev), ret);
> -	c4iw_dealloc(ctx);
> +	ib_dealloc_device(&dev->ibdev);
> +	ctx->dev = NULL;
>  	return;
>  }
>  
> -- 
> 2.53.0
> 
> 
