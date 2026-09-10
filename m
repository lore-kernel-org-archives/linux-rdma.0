Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684F43AFD08;
	Thu, 10 Sep 2026 08:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030439; cv=none; b=Nm4ut8/nKEHc+TKpycB02Fo+4zlV3AYsbyxKLWSp/FYUYvHD2G1WrRQzMF4pEFh2RfUK67s5rC9bhAS/zKtB+/UWWq7CUdYytZOPBY3voq4pFFGe1g2YMJr5oaILLh1olbxAZsr2w78mXVnJ0PR9V8FRYsG9FZYHGx4fMg5lFpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030439; c=relaxed/simple;
	bh=FwB7BN2iUtvLKoc8uPbrwjjH4iGnZpokxg7lTmcbBU4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9RSQw6am9w7GDnwziQf5/Py91PTBT/fiE46k9N+q97mvwwup5ybpO8J5XQuq8BisORMb/NnDz0SF+B5LeL48ZHUqzwj9dW47OEvje0J8PTMrU+4Q6f0kOPPURA4zQbbSurUqjtdQScztXnrA9s+HdBNBMQnQbV9H6ejimwpBho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ro4a5FBm; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ro4a5FBm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1789030438; x=1820566438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fPXAF7JO6wlyL6EK3ze805Bg3fCBCWQqUFlJoyTbric=;
  b=ro4a5FBm9OdeeKvlQR3likhqPJYCQCrW9yq9pFYye4FFrrZzf4QD7fst
   kuuBiI2r5L9Qy41p1hKm4/3uQTgU9RGTxRu0M+nto33/Ly/h/+4qqixAd
   Z5MIC4PfH4BJSPLg9RXsPJFltyxUPBsdHiTcSg91ootgi+61CR6c1oBPk
   Ocd4Iydl2LmHljWDwcjLNVgWzIFrO62GC18acaerIanBALjizLx7+X62n
   SAbOpuhNyUw++MPSINgnXmck1ZQXcSjlFWHebILvATQ74l/TfXGN0V4Kx
   Ff+3bVkny87mgWojP57Qgb8T79MbSk9wIHh0U+VnydeCi2yb3NuE5cAKs
   w==;
X-CSE-ConnectionGUID: ygD4VYnTQNi6OOjiMeBBxw==
X-CSE-MsgGUID: Jz+7q+N2Qh+u1d9YhQqK4g==
X-IronPort-AV: E=Sophos;i="6.27,95,1787011200"; 
   d="scan'208";a="28215681"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:53:56 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:8931]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.54:2525] with esmtp (Farcaster)
 id 3fef8b1f-ce17-488b-836e-37ce6f49275e; Thu, 10 Sep 2026 08:53:55 +0000 (UTC)
X-Farcaster-Flow-ID: 3fef8b1f-ce17-488b-836e-37ce6f49275e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 10 Sep 2026 08:53:55 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 10 Sep 2026
 08:53:53 +0000
Date: Thu, 10 Sep 2026 08:53:46 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Gal Pressman <gal.pressman@linux.dev>, Yossi Leybovich
	<sleybo@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem
	<shiraz.saleem@intel.com>, Steve Wise <larrystevenwise@gmail.com>, "Firas
 JahJah" <firasj@amazon.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next 1/2] RDMA/efa: Keep admin queues alive while
 IRQ is registered
Message-ID: <20260910085346.GA33673@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
 <20260907-use-after-free-of-admin-queue-struct-v1-1-dd9d9267fbf4@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260907-use-after-free-of-admin-queue-struct-v1-1-dd9d9267fbf4@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Sep 07, 2026 at 09:44:46PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The management IRQ handler accesses both the admin completion queue and the
> async event queue. The driver registered the IRQ before constructing these
> queues and destroyed them before freeing the IRQ, so the handler's lifetime
> was not contained by the resources it accesses.
> 
> Initialize the queues with interrupts masked, request the IRQ, and then
> switch to interrupt mode. On removal, reset the device and free the IRQ
> before destroying the queues. Also reset the device before destroying the
> queues if IRQ registration fails, because the device already has their DMA
> addresses.
> 
> Fixes: b7f5e880f377 ("RDMA/efa: Add the efa module")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/efa/efa_com.c  |  4 +---
>  drivers/infiniband/hw/efa/efa_main.c | 15 +++++++++------
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
> index 583b1cf0d721..cb2d448db2d7 100644
> --- a/drivers/infiniband/hw/efa/efa_com.c
> +++ b/drivers/infiniband/hw/efa/efa_com.c
> @@ -850,7 +850,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
>  
>  	aq->dmadev = edev->dmadev;
>  	aq->efa_dev = edev->efa_dev;
> -	set_bit(EFA_AQ_STATE_POLLING_BIT, &aq->state);
> +	efa_com_set_admin_polling_mode(edev, true);
>  
>  	sema_init(&aq->avail_cmds, aq->depth);
>  
> @@ -868,8 +868,6 @@ int efa_com_admin_init(struct efa_com_dev *edev,
>  	if (err)
>  		goto err_destroy_sq;
>  
> -	efa_com_set_admin_polling_mode(edev, false);
> -
>  	err = efa_com_admin_init_aenq(edev, aenq_handlers);
>  	if (err)
>  		goto err_destroy_cq;
> diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
> index 4cd80727dcd2..b1df9bb8fac2 100644
> --- a/drivers/infiniband/hw/efa/efa_main.c
> +++ b/drivers/infiniband/hw/efa/efa_main.c
> @@ -619,18 +619,21 @@ static struct efa_dev *efa_probe_device(struct pci_dev *pdev)
>  	edev->aq.msix_vector_idx = dev->admin_msix_vector_idx;
>  	edev->aenq.msix_vector_idx = dev->admin_msix_vector_idx;
>  
> -	err = efa_set_mgmnt_irq(dev);
> +	err = efa_com_admin_init(edev, &aenq_handlers);
>  	if (err)
>  		goto err_disable_msix;
>  
> -	err = efa_com_admin_init(edev, &aenq_handlers);
> +	err = efa_set_mgmnt_irq(dev);
>  	if (err)
> -		goto err_free_mgmnt_irq;
> +		goto err_destroy_admin;
> +
> +	efa_com_set_admin_polling_mode(edev, false);
>  
>  	return dev;
>  
> -err_free_mgmnt_irq:
> -	efa_free_irq(dev, &dev->admin_irq);
> +err_destroy_admin:
> +	efa_com_dev_reset(edev, EFA_REGS_RESET_INIT_ERR);
> +	efa_com_admin_destroy(edev);
>  err_disable_msix:
>  	efa_disable_msix(dev);
>  err_reg_read_destroy:
> @@ -654,8 +657,8 @@ static void efa_remove_device(struct pci_dev *pdev,
>  
>  	edev = &dev->edev;
>  	efa_com_dev_reset(edev, reset_reason);
> -	efa_com_admin_destroy(edev);
>  	efa_free_irq(dev, &dev->admin_irq);
> +	efa_com_admin_destroy(edev);
>  	efa_disable_msix(dev);
>  	efa_com_mmio_reg_read_destroy(edev);
>  	devm_iounmap(&pdev->dev, edev->reg_bar);
> 
> -- 
> 2.55.0
>

Looks good to me, thanks!

Reviewed-by: Michael Margolin <mrgolin@amazon.com>

