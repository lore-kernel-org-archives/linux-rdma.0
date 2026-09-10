Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2531361DBA;
	Thu, 10 Sep 2026 08:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030485; cv=none; b=Mba3Bg1QqhGB2xzKjSEYEFWJsKbIzvYvsflCwPPbeCa9PmMkA0zk4soqR86QSNbHndzISbvDDKOd7uxvjpms4lHIM2PJnbc5+MPc1dMBRnEsheyU/ogbyLL3mQEuMikLhVhg96FDIxoNvhjl1NVXvEV0YLjQQSOKgbausmBwZN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030485; c=relaxed/simple;
	bh=b12foAz2Md/SWoUcUr8Oj8AIHneB+V5XjhVUhZhQZDQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Va9QEkSZw5tG5eo9oc1hZv5F3NG+yaqTt1cCKpMUI47uPxQf3gVQVlaTVMFPVmwLt5LwZdFrMgKUwRPsRLMqcASfEaPGcqQN4NZ52y7bxi8/pacnZ6jjinLNGp1+vdHbcwNMvgvIMB4kLsyaIWoyFXFYPIVLu1FyW0iwW6njmak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=PRVBQtpx; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="PRVBQtpx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1789030483; x=1820566483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R7gxlGRz7QTguceqXQ6HdbD0+7RqNsA7V8WP7LJpllE=;
  b=PRVBQtpxZBl5FHd/W/U/SqwOcBPctFEAIww+tmelmbelMmVi7e1wAbhz
   y1pfUg4MDwhc2Z1sP2vV7lQsZTdZK96Y77ip/JVv2DBTK/zzpif5P4rbR
   CVMpc32Gj+2HvKeKEdQpfCb3J57OPfyKiaSTtF02Fgo/SRhBSYq/Dq8ti
   3s4HN43T0N1aftGg0lxZUWnukzkOIEovYnRTHMvHw8/xyc2jXVnqVqKQF
   PHzqyodLfeh4J+CeOU5pi/VoeQhtklArYoMsYcQVxaBTRdR7nbs+EL9Vi
   xw9UpIdwUMH1lXGJgJ/p5S2Hfpgrhj/NlfCh2Mu3II3ifNnzgYe208094
   A==;
X-CSE-ConnectionGUID: p6gC1CZITiyiCdpnk8tWag==
X-CSE-MsgGUID: YgEI+Wu3RDmhn0xSqACbeA==
X-IronPort-AV: E=Sophos;i="6.27,95,1787011200"; 
   d="scan'208";a="28340410"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:54:40 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:19201]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.57.27:2525] with esmtp (Farcaster)
 id eb725002-d52a-4f52-a39d-3e93eba6da18; Thu, 10 Sep 2026 08:54:40 +0000 (UTC)
X-Farcaster-Flow-ID: eb725002-d52a-4f52-a39d-3e93eba6da18
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 10 Sep 2026 08:54:39 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 10 Sep 2026
 08:54:38 +0000
Date: Thu, 10 Sep 2026 08:54:35 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Gal Pressman <gal.pressman@linux.dev>, Yossi Leybovich
	<sleybo@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem
	<shiraz.saleem@intel.com>, Steve Wise <larrystevenwise@gmail.com>, "Firas
 JahJah" <firasj@amazon.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next 2/2] RDMA/efa: Keep EQ resources alive while
 IRQ is registered
Message-ID: <20260910085435.GB33673@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
 <20260907-use-after-free-of-admin-queue-struct-v1-2-dd9d9267fbf4@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260907-use-after-free-of-admin-queue-struct-v1-2-dd9d9267fbf4@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Sep 07, 2026 at 09:44:47PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The completion IRQ handler accesses the EQ state and DMA buffer. Its IRQ was
> registered before that state was initialized, while teardown released the
> buffer before free_irq() synchronized the handler.
> 
> Initialize the EQ without arming it, register the IRQ, and then arm it.
> Reverse the resource order during teardown by freeing the IRQ before
> destroying the EQ.
> 
> Fixes: 2a152512a155 ("RDMA/efa: CQ notifications")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/efa/efa_com.c  |  3 +--
>  drivers/infiniband/hw/efa/efa_com.h  |  1 +
>  drivers/infiniband/hw/efa/efa_main.c | 18 ++++++++++--------
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
> index cb2d448db2d7..04c6d63c449e 100644
> --- a/drivers/infiniband/hw/efa/efa_com.c
> +++ b/drivers/infiniband/hw/efa/efa_com.c
> @@ -1252,7 +1252,7 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
>  				      err);
>  }
>  
> -static void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
> +void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
>  {
>  	u32 val = 0;
>  
> @@ -1341,7 +1341,6 @@ int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
>  	eeq->phase = 1;
>  	eeq->depth = params.depth;
>  	eeq->cb = cb;
> -	efa_com_arm_eq(edev, eeq);
>  
>  	return 0;
>  
> diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
> index 0341704d0921..98fb6a42a6cb 100644
> --- a/drivers/infiniband/hw/efa/efa_com.h
> +++ b/drivers/infiniband/hw/efa/efa_com.h
> @@ -169,6 +169,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
>  void efa_com_admin_destroy(struct efa_com_dev *edev);
>  int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
>  		    efa_eqe_handler cb, u16 depth, u8 msix_vec);
> +void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq);
>  void efa_com_eq_destroy(struct efa_com_dev *edev, struct efa_com_eq *eeq);
>  int efa_com_dev_reset(struct efa_com_dev *edev,
>  		      enum efa_regs_reset_reason_types reset_reason);
> diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
> index b1df9bb8fac2..753ed8430b69 100644
> --- a/drivers/infiniband/hw/efa/efa_main.c
> +++ b/drivers/infiniband/hw/efa/efa_main.c
> @@ -302,28 +302,30 @@ static void efa_set_host_info(struct efa_dev *dev)
>  
>  static void efa_destroy_eq(struct efa_dev *dev, struct efa_eq *eq)
>  {
> -	efa_com_eq_destroy(&dev->edev, &eq->eeq);
>  	efa_free_irq(dev, &eq->irq);
> +	efa_com_eq_destroy(&dev->edev, &eq->eeq);
>  }
>  
>  static int efa_create_eq(struct efa_dev *dev, struct efa_eq *eq, u32 msix_vec)
>  {
>  	int err;
>  
> -	efa_setup_comp_irq(dev, eq, msix_vec);
> -	err = efa_request_irq(dev, &eq->irq);
> +	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
> +			      dev->dev_attr.max_eq_depth, msix_vec);
>  	if (err)
>  		return err;
>  
> -	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
> -			      dev->dev_attr.max_eq_depth, msix_vec);
> +	efa_setup_comp_irq(dev, eq, msix_vec);
> +	err = efa_request_irq(dev, &eq->irq);
>  	if (err)
> -		goto err_free_comp_irq;
> +		goto err_destroy_eq;
> +
> +	efa_com_arm_eq(&dev->edev, &eq->eeq);
>  
>  	return 0;
>  
> -err_free_comp_irq:
> -	efa_free_irq(dev, &eq->irq);
> +err_destroy_eq:
> +	efa_com_eq_destroy(&dev->edev, &eq->eeq);
>  	return err;
>  }
>  
> 
> -- 
> 2.55.0
>

Looks good to me, thanks!

Reviewed-by: Michael Margolin <mrgolin@amazon.com>

