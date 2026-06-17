Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5B7341ADD;
	Wed, 17 Jun 2026 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689278; cv=none; b=LSdR78ClQXqAJvIGlub0pRLSssuf71a8rd/J5d3Lgqpqqd2x0GnCE4q1F+ycouR2MEFTtmyrP4qo0S28ak+3f/DW+67rfA3uTs+v9qg5pYRrDEnrIhQ6w6tFWmPPkI7O801tgRmWitpWhQlWmdNfWzkuRQVPkOt8Y+kbxcdgzvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689278; c=relaxed/simple;
	bh=mdpARkk5ZHpUYutdupMFuTRX/LVTrPMR7KpYge5m8nQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXuwujs/zYovi3TN8HPx/mRoEA8F1tOIESK669+IHhr5CxL29KIGx6kcJ1riqmKLlH9TTHwEn99zOtkrwI68poOpm+KoqJ6EkmMevms40JAjHttppgYzAODIQBTIfDb4JDO1bfj4GgKYDdZvOBxY7p8Ezy7aMOJ/PgNkeSU47z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlEN7Amy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlEN7Amy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825261F000E9;
	Wed, 17 Jun 2026 09:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781689277;
	bh=cyKgowJd1zhtu0qWQyFQH6H6T62iAG8kuM8i9z4Jxjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UlEN7AmyCCwaO+J4i9oamPtHdmVZ6G0/gAGSRwLuRjaagQs3lDyxjk40lSgbur3hB
	 ylJRSbuW1A1cPyPN9tYZJPoSQzq9LcbTWtTFGkbKSKME6t3BZYZZJlR9/lch7zX+YF
	 4qfkae6Io7Ss1TUNmFMfh8nEB/bc5CFmE1WdLKGm1e9SpT/ofui5QQl5xl48ReHTZn
	 oci5C/Nm9/58vLwrHWdwLln5QtUn5tSZ5sNYyoXLf2RGAIPj4eMefrg4HsQzVlw66F
	 TDGCdcXWGqTNVrifsQBICrLvQQeV694Aew79tmUlE4mtNRRKtA9oIh3VYrDCVIba6b
	 vAfUZLXMq+mmQ==
Date: Wed, 17 Jun 2026 12:41:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v8 2/4] dma-buf: add optional get_pci_tph() callback
Message-ID: <20260617094113.GU327369@unreal>
References: <20260615065912.2177918-1-zhipingz@meta.com>
 <20260615065912.2177918-3-zhipingz@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615065912.2177918-3-zhipingz@meta.com>

On Sun, Jun 14, 2026 at 11:58:59PM -0700, Zhiping Zhang wrote:
> Add an optional dma_buf_ops.get_pci_tph callback and a
> DMA-buf importer wrapper, dma_buf_get_pci_tph().
> 
> TPH is PCIe TLP Processing Hint. 8-bit ST and 16-bit Extended ST are
> distinct PCIe TPH namespaces, so the importer requests the namespace it
> can emit and the exporter returns the matching ST/PH tuple or
> -EOPNOTSUPP.
> 
> dma_buf_get_pci_tph() is the importer entry point. It requires
> &dmabuf->resv to be held while the callback runs and returns
> -EOPNOTSUPP when the exporter does not provide PCI TPH metadata.
> 
> The first user is VFIO_DEVICE_FEATURE_DMA_BUF_TPH in vfio-pci, with
> mlx5 as the first importer.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> ---
>  drivers/dma-buf/dma-buf.c | 25 +++++++++++++++++++++++++
>  include/linux/dma-buf.h   | 16 ++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d504c636dc29..7a4c9b0d5dab 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1144,6 +1144,31 @@ void dma_buf_unpin(struct dma_buf_attachment *attach)
>  }
>  EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
>  
> +/**
> + * dma_buf_get_pci_tph - Retrieve PCIe TLP Processing Hint (TPH) metadata
> + * @dmabuf: DMA buffer to query
> + * @extended: false for 8-bit ST, true for 16-bit Extended ST
> + * @steering_tag: returns the raw steering tag for the requested namespace
> + * @ph: returns the TPH processing hint
> + *
> + * Wrapper for the optional &dma_buf_ops.get_pci_tph callback.
> + *
> + * Must be called with &dma_buf.resv held. Returns -EOPNOTSUPP if the
> + * exporter does not implement the callback or has no metadata for the
> + * requested namespace.
> + */
> +int dma_buf_get_pci_tph(struct dma_buf *dmabuf, bool extended,
> +			u16 *steering_tag, u8 *ph)
> +{
> +	dma_resv_assert_held(dmabuf->resv);
> +
> +	if (!dmabuf->ops->get_pci_tph)
> +		return -EOPNOTSUPP;
> +
> +	return dmabuf->ops->get_pci_tph(dmabuf, extended, steering_tag, ph);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_get_pci_tph, "DMA_BUF");
> +
>  /**
>   * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
>   * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d1203da56fc5..5e7b69a40f3d 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -113,6 +113,20 @@ struct dma_buf_ops {
>  	 */
>  	void (*unpin)(struct dma_buf_attachment *attach);
>  
> +	/**
> +	 * @get_pci_tph:

There should be a blank line after the line above, along with a clear and
concise description of what this callback does.

Thanks

> +	 * @dmabuf: DMA buffer for which to retrieve TPH metadata
> +	 * @extended: false for 8-bit ST, true for 16-bit Extended ST
> +	 * @steering_tag: Returns the raw TPH steering tag for the requested
> +	 *                namespace
> +	 * @ph: Returns the TPH processing hint (2-bit value)
> +	 *
> +	 * Optional callback for dma_buf_get_pci_tph(). Called with
> +	 * &dma_buf.resv held.
> +	 */
> +	int (*get_pci_tph)(struct dma_buf *dmabuf, bool extended,
> +			   u16 *steering_tag, u8 *ph);
> +
>  	/**
>  	 * @map_dma_buf:
>  	 *
> @@ -563,6 +577,8 @@ void dma_buf_detach(struct dma_buf *dmabuf,
>  		    struct dma_buf_attachment *attach);
>  int dma_buf_pin(struct dma_buf_attachment *attach);
>  void dma_buf_unpin(struct dma_buf_attachment *attach);
> +int dma_buf_get_pci_tph(struct dma_buf *dmabuf, bool extended,
> +			u16 *steering_tag, u8 *ph);
>  
>  struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info);
>  
> -- 
> 2.53.0-Meta
> 
