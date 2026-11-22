Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795349788;
	b=0YamyAy1wfox5V/zr5t0xkv+9zujGqeSWVMfUBOw+aMVyOlDeubPKcj8lsHgchG9xae5
	 52SkZ/5rAO/RCQIZdtuRtk2oJs8z37++3ewC/dSwRh0UErLRjXw8sgccPGMGE5L8MnKFQ
	 k4FxU6q4XfWKQ5+oTKElYEbZWz5n89NJGxqrR4Cx5UIoEQW8zC6fD+ys/GS8ilCVAVkOz
	 1QGspccEgTg0iAJo3wmMIzxsdOIS6AUSvtKJQklflbA4l9HvfXQojSc0U4pCt1zB8dOWz
	 el/HuVKNwBdR2FgM4NssMBHqRAdyVXZcNUvVv4p5vJIVKWLjF36WznUgrxPDLeyy21Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795349788;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3BOwbU+lSzvKHVM3g0ZPvEwDeJxpQFlPSm4+1sqZp8A=;
	b=ZBemrCavnsAtJqm1xS/Cm1XZsFFqmSGchO7ihXznkG8yDPwScz/nxUNGSVKhsVRQKUuJ
	 n9MvHIMVjljgjQVHuNbkgifmlRbR/Ohk7ov7ZH1YRNLpW2L3v+FCX+5j2cYWF9W53yMr/
	 gewuRQFZrJldStErEmzH/XM0B78aU043unm+6IviS3Ei1b6f1d0sqe2qeQgtOZhkSLld7
	 W9vQBkKK1yx98NRrR9YYW6mvUt7X3EgCGBd/xRPrPcebwQ0svhZBFGujZqFl+w5AviKNR
	 /HUwtL7x3uVD0W7b/4+682WPUJFlIiVzk+j+DO1R7ia+kSBfwM7JEYDbvnf9Z9TdYJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAHIFOdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77E9606A32C;
	Sun, 22 Nov 2026 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAHIFOdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7E31F000CF;
	Sun, 22 Nov 2026 12:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795349788;
	bh=3BOwbU+lSzvKHVM3g0ZPvEwDeJxpQFlPSm4+1sqZp8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XAHIFOdxEFGpZ07DXRlMmJseIHGaGLg2JtoI+jAKxJyKEdKQSo2swQIKE0wjJ1uVB
	 cnmXAnLoEG/T64q3QuaIKTEHfBMS8YfXr9K1OWsyvGgk7kDVVrVtdaJgTStN3IIHrh
	 zZzfoKVKW8FeF5Tt897LEcoBXeiQPkj4xzBmM4HXTxhtCh5IJUgOrZfDDyHwcTPp9n
	 l82VRLdwMei73/dANRRsMM6anYBfseUCUJ1aacLg61Kwwlv/bLvkQ2VWEOtgCZ51gD
	 1t98rI3aKHyCiuaXqGJq/ij4Q+3wPhGPUIzpuAdZKNNR7NkKxqTaDemMaDl2epyt4T
	 p+6MyozmpEznA==
Date: Sun, 22 Nov 2026 14:16:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, longli@microsoft.com,
	jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/mana_ib: Enable RDMA devices on the
 CDX bus
Message-ID: <20261122121623.GC14811@unreal>
References: <20261117182043.149267-1-kotaranov@linux.microsoft.com>
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
In-Reply-To: <20261117182043.149267-1-kotaranov@linux.microsoft.com>

On Tue, Nov 17, 2026 at 10:20:43AM -0800, Konstantin Taranov wrote:
> From: Zhiyue Qiu <zhiyueqiu@microsoft.com>
> 
> Enable MANA RDMA on CDX by depending on the shared GDMA core and matching
> the CDX auxiliary devices.
> 
> Map non-PCI userspace doorbells with pgprot_device() to match the CDX
> transport, and report the Microsoft vendor ID directly.
> 
> Allocate missing DMA parameters before GDMA setup using managed memory.
> Register a cleanup action to clear the device pointer before the memory
> is freed.

The commit message merely lists the code changes in the patch. It should
explain why you are using pgprot_device() and why you report Microsoft
vendor ID directly.

> 
> Signed-off-by: Zhiyue Qiu <zhiyueqiu@microsoft.com>
> Co-developed-by: Konstantin Taranov <kotaranov@microsoft.com>
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> ---
> Changes in v2:
> - Allocate missing CDX DMA parameters before GDMA setup.
> 
>  drivers/infiniband/hw/mana/Kconfig            | 10 +++----
>  drivers/infiniband/hw/mana/device.c           |  2 ++
>  drivers/infiniband/hw/mana/main.c             |  9 ++++--
>  .../net/ethernet/microsoft/mana/gdma_cdx.c    | 30 +++++++++++++++----
>  4 files changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mana/Kconfig b/drivers/infiniband/hw/mana/Kconfig
> index 546640657bac..6eae7fa91d95 100644
> --- a/drivers/infiniband/hw/mana/Kconfig
> +++ b/drivers/infiniband/hw/mana/Kconfig
> @@ -1,10 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config MANA_INFINIBAND
>  	tristate "Microsoft Azure Network Adapter support"
> -	depends on NETDEVICES && ETHERNET && PCI && MICROSOFT_MANA
> +	depends on NETDEVICES && ETHERNET && MICROSOFT_GDMA_CORE
>  	help
>  	  This driver provides low-level RDMA support for Microsoft Azure
> -	  Network Adapter (MANA). MANA supports RDMA features that can be used
> -	  for workloads (e.g. DPDK, MPI etc) that uses RDMA verbs to directly
> -	  access hardware from user-mode processes in Microsoft Azure cloud
> -	  environment.
> +	  Network Adapter (MANA) on the PCI or CDX bus. MANA supports RDMA
> +	  features that workloads such as DPDK and MPI can use to directly
> +	  access hardware from user-mode processes in the Microsoft Azure
> +	  cloud environment.

You should rely less on AI and review its output more carefully. The
only point you needed to add was that MAND works on both PCI and CDX buses.
Instead, you rewrote the entire text. The original text was not limited to
PCI, so all of the changes above are unnecessary.

> diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
> index 62c7803ca6c6..33e47490755f 100644
> --- a/drivers/infiniband/hw/mana/device.c
> +++ b/drivers/infiniband/hw/mana/device.c
> @@ -257,6 +257,8 @@ static void mana_ib_remove(struct auxiliary_device *adev)
>  static const struct auxiliary_device_id mana_id_table[] = {
>  	{ .name = "mana.rdma", },
>  	{ .name = "mana.eth", },
> +	{ .name = "mana_cdx.rdma", },
> +	{ .name = "mana_cdx.eth", },
>  	{},
>  };
>  
> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
> index 858bbc325eb2..afb8fa002f73 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -572,7 +572,11 @@ int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
>  	pfn = (gc->phys_db_page_base +
>  	       gc->db_page_size * mana_ucontext->doorbell) >>
>  	      PAGE_SHIFT;
> -	prot = pgprot_writecombine(vma->vm_page_prot);
> +	/* Match the Device attributes used by the CDX transport. */
> +	if (dev_is_pci(gc->dev))
> +		prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		prot = pgprot_device(vma->vm_page_prot);
>  
>  	ret = rdma_user_mmap_io(ibcontext, vma, pfn, PAGE_SIZE, prot,
>  				NULL);
> @@ -623,14 +627,13 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
>  			 struct ib_udata *uhw)
>  {
>  	struct mana_ib_dev *dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
> -	struct pci_dev *pdev = to_pci_dev(mdev_to_gc(dev)->dev);
>  	int err;
>  
>  	err = ib_no_udata_io(uhw);
>  	if (err)
>  		return err;
>  
> -	props->vendor_id = pdev->vendor;
> +	props->vendor_id = PCI_VENDOR_ID_MICROSOFT;
>  	props->vendor_part_id = dev->gdma_dev->dev_id.type;
>  	props->max_mr_size = MANA_IB_MAX_MR_SIZE;
>  	props->page_size_cap = dev->adapter_caps.page_size_cap;
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> index 0d01e3d2f0d9..6c6ddc14ef7e 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> @@ -3,6 +3,7 @@
>  #include <linux/module.h>
>  #include <linux/bitmap.h>
>  #include <linux/cdx/cdx_bus.h>
> +#include <linux/device.h>
>  #include <linux/msi.h>
>  #include <linux/xarray.h>
>  
> @@ -61,11 +62,8 @@ static int mana_cdx_setup_hwc_irqs(struct gdma_context *gc)
>  		return err;
>  	}
>  
> -	/* The PCI path also calls dma_set_max_seg_size(), but that is
> -	 * deliberately omitted here: the CDX core does not attach a
> -	 * dma_parms to the device, so the helper would only WARN, and MANA
> -	 * never builds scatter-gather lists, so the limit is never read.
> -	 */
> +	dma_set_max_seg_size(gc->dev, UINT_MAX);
> +	dma_set_seg_boundary(gc->dev, DMA_BIT_MASK(32));

PCI code declares almost same code in probe function and not in mana_XXX_setup_hwc_irqs().

>  
>  	err = cdx_enable_msi(cdx_dev);
>  	if (err) {
> @@ -196,6 +194,13 @@ static const struct gdma_bus_ops mana_cdx_bus_ops = {
>  	.dev_reset		= mana_cdx_dev_reset,
>  };
>  
> +static void mana_cdx_clear_dma_parms(void *data)
> +{
> +	struct device *dev = data;
> +
> +	dev->dma_parms = NULL;

Will you reuse dev after the device has been released?

> +}
> +
>  static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
>  {
>  	struct gdma_context *gc;
> @@ -241,6 +246,21 @@ static int mana_cdx_gd_probe(struct cdx_device *cdx_dev)
>  	gc->bar0_va = bar0_va;
>  	gc->dev = &cdx_dev->dev;
>  	gc->bus_ops = &mana_cdx_bus_ops;
> +	if (!gc->dev->dma_parms) {
> +		gc->dev->dma_parms = devm_kzalloc(gc->dev,
> +						  sizeof(*gc->dev->dma_parms),
> +						  GFP_KERNEL);
> +		if (!gc->dev->dma_parms) {
> +			err = -ENOMEM;
> +			goto unmap_bar;
> +		}
> +
> +		/* Clear the pointer before devres frees the allocation. */
> +		err = devm_add_action_or_reset(gc->dev, mana_cdx_clear_dma_parms,
> +					       gc->dev);
> +		if (err)
> +			goto unmap_bar;

Why do you need devm_XXX interfaces if device can't be accessed after it
is released?

Thanks

> +	}
>  
>  	/* gc->is_pf is intentionally left clear: this device uses the VF
>  	 * register layout, and the vPort and MAC filter registration that
> -- 
> 2.43.0
> 
