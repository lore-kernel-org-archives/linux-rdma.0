Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E53B3AEF21;
	Wed, 29 Jul 2026 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785366237; cv=none; b=gkOnPyLyNQQprifrtuWVtl2kT1mJ+BxCJvMRZSpbqcTS091tBipYtVTmHekPN5XD+xFJlsGyGyGNO4zmeUsnrQ608ksnezDTvbnE/B0L2xlGRqNi4PcSEH8lYRu2AhjHbcKVQYkiTBQa6ZBg6dBoS5RkBrVoC1DiITy8t/1JdMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785366237; c=relaxed/simple;
	bh=dC4PDjTkYpwLjvO4xjYT3GWuL7n4Ko6CEiuXyh0xHkE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEe8cOMO2PcMFHdQdGSXoaMOg4kO919GQmpNDommP0IgKKhB4whSeRVnc+mh1m9C5wmMLnQAualYUkFSnwScGCiMiAX2niJw2jjaU3jzhex15MNCUKgnV+9n/KgPe9EiuBozZIEdIM1wUxnodcTYIJTjlcXsBVaAsdTANs/dHVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=WQJApQfZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Pfv752JM; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="WQJApQfZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Pfv752JM"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8E2E2140046E;
	Wed, 29 Jul 2026 19:03:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 29 Jul 2026 19:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785366233;
	 x=1785452633; bh=iq4k8oOS+qrYbyKm1+2ypBEBu4O17jCivYh7LxTMU/E=; b=
	WQJApQfZ42xBeMucY3VH9cugXonDZsHm/b2uSs1FfaznBeogCfuLCMDtha9UR4tP
	cHDW8ABNJEzTzP+U7tOBscG5WGMdrEtYWnHXzE0DV/glaPnbuKAxx4y9zRT80N2L
	bvGglT9xQK7K+qggGeqoJhoNa9TIr/AzHBm2/gYB3uhB95xZQH09acningn0OqwV
	pEyw7FYnGaaGFUPHS+EKgAVAy4cEw4ccDHzIY85agcI8pV+TXBOh2UosTON/rA0p
	SDmX65OphYK1IAnjKBybP5HaV6oIYLnw7aMlNdS/AQm2+DNadFGa8QVJPJffnBjB
	PBowA4nZsGE5dy8zpAmb7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785366233; x=
	1785452633; bh=iq4k8oOS+qrYbyKm1+2ypBEBu4O17jCivYh7LxTMU/E=; b=P
	fv752JM+yY6z/HWKh+30sDkwtVtfw1M2x1ULURj6N4VLaDuWtc7sFa98XxKJQtrQ
	cgpRQoCwSAH9VpIqzfr3UahRIDkqLw7nO2VgYMaCl4KrmXpWYaJPhQ00L0SdDXQS
	I0GKkghxXoQctoPIERm1NPHbMqUDhYO+V84jLEeC/PZUCsqNbp4gkp7dCysCEOMV
	D9S1SqvjDZcJsJn2bqz98t5gZiEx6ewYUvMKFVPtQZo6VIbJOrMVx9rbZRKvEi6O
	FwuONzOWg7j9hQqvt+7Wkma7JadLUIqq+wuEt/8P3WjzbdgJGSgqwZnYPq5vSF1m
	M1wHguWIknM2yYsqJ4gGQ==
X-ME-Sender: <xms:2YZqahgixHmPpBS9zmezjcvt1H2WVBrfk_Thu9or4uZMMfkAUdT2xQ>
    <xme:2YZqasaSrp-tATw4eO7otdqQrwkNw5bJaSqTbDMIe5swH3SM01ocwaxLA3pKWwDsi
    25MhKN1KHvWIeMbjzLOus8idhxja7_DtGBWFnJiqJSOmZvx1zCTEk8>
X-ME-Received: <xmr:2YZqatWDqlSqwLTquFIORCX524M5nXUGC1Z3_nAJzZJbS3wmtaNe_GYZx5fdwg>
X-ME-Proxy-Cause: dmFkZTG3fomMBc9e28gLQyoOP1Wro/I6KKy3CmvIzRD1Vm8oKh9xeKOJI1D5w0Oho/HLoY
    RFMEVbnvdCEuFsrQ+b8FwOqjXNpWe/WxHMZ0KfTKETdYuiBBh7LUgHavgAtzFoUpjQzsH2
    4pq6/EwC30eHJFniL5abDEDZ4InNojpUL296AFYazsG77GIDGB5HOUCebCze2XEoJHSPVc
    bDCoqJ0IbkPOIq3JXA/8vlWnlYTad7q1lyLy4YWiEO6ztNOexreOIh3zvD/5qPsBGKi7qh
    UtwzkEQLvMvamBBsqCQmz2WP1gPNOtuOqhSzSiuv52MiF8p/X+BmhZj4PJ/CcqApx0raow
    uzayBzvGejrPYJi05nCoTYU3Wf6uOfnIAyIjg+vk1ihCrItqGu5brNJmKVxbVze4wj25bH
    z0cC3U3YI+8zJBNAtvPSA52ot+Rf4uGuhv5oPrNbGhddx7K6KL9yxNqHwwdmN4e3z5zVZX
    7kTr9hToSZfJa0nE60nfVasodgMVouZ9j9A2xAYAWuNXnP9ZIg6zMipR3aAqw31HRXCb2r
    BvGlJzNG1OuYmwmenLy8bT05Vj2XbDm8wq0t83Qun91/MdanIC1ownZaz1YTcuOAv/iP9O
    fseBlnwCPxKK+PY+v9KOsPg5sda/zLggaHv+XwSskPho9e4jxgjRTu1nNi6w
X-ME-Proxy: <xmx:2YZqakEf1eLqJjaHL2ZNv0SfkxHv6LRJYKqsidgy0K-sjv3ZYweEXg>
    <xmx:2YZqana_qNVheifbwTNFusKGTRjt9_OpchUqAKaAZ7HRj2Phewzr_Q>
    <xmx:2YZqajHVT3ewj7mX4o5dxaGxbbrZ93UnlOtuLEfkIKTX3AdhJtQN5A>
    <xmx:2YZqat2uoQfsRkzZVHtA3maBoZs2FQCKk95IMfMZJZgDNjr8Yw0SSA>
    <xmx:2YZqasNTKCivYxP1dO_ZpSnaC-yWRwLttwex63B2C6_sSlpLusPu28_b>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jul 2026 19:03:52 -0400 (EDT)
Date: Wed, 29 Jul 2026 17:03:50 -0600
From: Alex Williamson <alex@shazbot.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Michael Guralnik <michaelgur@nvidia.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
 Bjorn Helgaas <bhelgaas@google.com>, <kvm@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, alex@shazbot.org
Subject: Re: [PATCH v12 0/4] vfio/dma-buf: add TPH support for peer-to-peer
 access
Message-ID: <20260729170350.1a1c2229@shazbot.org>
In-Reply-To: <20260715204008.3911275-1-zhipingz@meta.com>
References: <20260715204008.3911275-1-zhipingz@meta.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Jul 2026 13:39:55 -0700
Zhiping Zhang <zhipingz@meta.com> wrote:
>
> Depends on (submitted separately):
>   net/mlx5: free mlx5_st_idx_data on final dealloc
>     https://lore.kernel.org/linux-rdma/20260612170406.3339093-1-zhipingz@meta.com
>   PCI/TPH: fold reserved completer encoding in get_rp_completer_type()
>     https://lore.kernel.org/linux-pci/20260715202409.3767494-1-zhipingz@meta.com

Sashiko failed to apply[1], it can't handle such dependencies.  The
first dependency already exists in linux-next, I applied the latter
manually, therefore the patch indexes in the below local sashiko run
results are off by one.  This used Claude Opus 4.8 rather than the
standard Gemini 3.1 Pro Preview used in the on-list reviews, other LLMs
may find more or less.

We should probably reevaluate the best merge path for these, it doesn't
make a lot of sense to me to have one patch routed through Bjorn's tree
for a self-contained fix where no known hardware makes use of the
reserved encoding, then depend on that change in the first patch of
this series.  We need Bjorn's ack here anyway, the Fixes: tag is
academic in current code.  Suggest adding that patch into this series
on the re-spin and prodding required subsystem maintainers for review.

I'd upgrade the severity of the first issue below since it affects the
uAPI.  Thanks,

Alex

[1]https://sashiko.dev/#/patchset/20260715204008.3911275-1-zhipingz@meta.com

Inline Review:
--- Patch [4]: vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature ---
commit 3a3a7e88fb6acb9853e8f8bea216613aeea43b4f
Author: Zhiping Zhang <zhipingz@meta.com>

vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature

This patch implements the dma-buf get_pci_tph callback for vfio-pci
exported dma-bufs and adds VFIO_DEVICE_FEATURE_DMA_BUF_TPH so userspace
can publish TPH metadata for a VFIO-owned device. It gates the feature on
the device reporting TPH Completer support in Device Capabilities 2.

Link: https://lore.kernel.org/r/20260715204008.3911275-4-zhipingz@meta.com

> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> index c16f460c01d6..7db84d27dfec 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c

[ ... ]

> +int vfio_pci_core_feature_dma_buf_tph(struct vfio_pci_core_device *vdev,
> +				      u32 flags,
> +				      struct vfio_device_feature_dma_buf_tph __user *arg,
> +				      size_t argsz)
> +{
> +	struct vfio_device_feature_dma_buf_tph set_tph;
> +	struct vfio_pci_dma_buf *priv;
> +	struct dma_buf *dmabuf;
> +	u8 comp;
> +	int ret;
> +
> +	comp = pcie_tph_completer_type(vdev->pdev);
> +	if (comp == PCI_EXP_DEVCAP2_TPH_COMP_NONE)
> +		return -EOPNOTSUPP;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> +				 sizeof(set_tph));
> +	if (ret != 1)
> +		return ret;

[Severity: Low]
Should the PROBE path here also require that the device can actually
export a vfio dma-buf?

The only gate before vfio_check_feature() is the completer-type check:

	comp = pcie_tph_completer_type(vdev->pdev);
	if (comp == PCI_EXP_DEVCAP2_TPH_COMP_NONE)
		return -EOPNOTSUPP;

vfio_check_feature() returns 0 for a PROBE request, so on a device that
reports TPH Completer support in Device Capabilities 2 but whose pci_ops
has no get_dmabuf_phys, a VFIO_DEVICE_FEATURE_PROBE for
VFIO_DEVICE_FEATURE_DMA_BUF_TPH reports success even though no vfio
dma-buf can ever be created to carry the TPH metadata. Every real SET
would then fail later, either at dma_buf_get() or at the
dmabuf->ops != &vfio_pci_dmabuf_ops ownership check.

The sibling base feature vfio_pci_core_feature_dma_buf() opens with:

	if (!vdev->pci_ops || !vdev->pci_ops->get_dmabuf_phys)
		return -EOPNOTSUPP;

so its PROBE reports unsupported when no dma-buf can be created.

The commit message says PROBE was made to "follow the same hardware gate
so the feature only probes as supported when the device can really
consume it." Would adding the same get_dmabuf_phys check make PROBE
consistent with vfio_pci_core_feature_dma_buf() and match that stated
intent?

--- Patch [5]: RDMA/mlx5: get tph for p2p access when registering dma-buf mr ---
commit e612584ae6697d1ebf77baf0fb1487a41e4c6511
Author: Zhiping Zhang <zhipingz@meta.com>

RDMA/mlx5: get tph for p2p access when registering dma-buf mr

This patch wires up mlx5_ib to query dma_buf_get_pci_tph() metadata at MR
registration time for p2p access and program requester-side TPH on the
outbound mkey.  As part of it, mlx5_st_alloc_index() is split so that a new
mlx5_st_alloc_index_by_tag() helper does the table lookup while the old
entry point still handles the ACPI steering-tag query.

Link: https://lore.kernel.org/r/20260715204008.3911275-5-zhipingz@meta.com

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> index 7cedc348790d..877b37b4e639 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> @@ -92,23 +92,18 @@ void mlx5_st_destroy(struct mlx5_core_dev *dev)
>  	kfree(st);
>  }
>  
> -int mlx5_st_alloc_index(struct mlx5_core_dev *dev, enum tph_mem_type mem_type,
> -			unsigned int cpu_uid, u16 *st_index)
> +int mlx5_st_alloc_index_by_tag(struct mlx5_core_dev *dev, u16 tag,
> +			       u16 *st_index)
>  {
>  	struct mlx5_st_idx_data *idx_data;
>  	struct mlx5_st *st = dev->st;
>  	unsigned long index;
>  	u32 xa_id;
> -	u16 tag;
> -	int ret;
> +	int ret = 0;
>  
>  	if (!st)
>  		return -EOPNOTSUPP;
>  
> -	ret = pcie_tph_get_cpu_st(dev->pdev, mem_type, cpu_uid, &tag);
> -	if (ret)
> -		return ret;
> -
>  	if (st->direct_mode) {
>  		*st_index = tag;
>  		return 0;

[ ... ]

> @@ -152,8 +147,46 @@ int mlx5_st_alloc_index(struct mlx5_core_dev *dev, enum tph_mem_type mem_type,
>  	mutex_unlock(&st->lock);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(mlx5_st_alloc_index_by_tag);
> +
> +int mlx5_st_alloc_index(struct mlx5_core_dev *dev, enum tph_mem_type mem_type,
> +			unsigned int cpu_uid, u16 *st_index)
> +{
> +	u16 tag;
> +	int ret;
> +
> +	ret = pcie_tph_get_cpu_st(dev->pdev, mem_type, cpu_uid, &tag);
> +	if (ret)
> +		return ret;
> +
> +	return mlx5_st_alloc_index_by_tag(dev, tag, st_index);
> +}
>  EXPORT_SYMBOL_GPL(mlx5_st_alloc_index);

[Severity: Low]
This refactor moves the if (!st) return -EOPNOTSUPP; short-circuit into
mlx5_st_alloc_index_by_tag(), so the remaining mlx5_st_alloc_index() now
calls pcie_tph_get_cpu_st() before that guard is reached.

Before this patch mlx5_st_alloc_index() checked !st first and returned
-EOPNOTSUPP without ever calling pcie_tph_get_cpu_st().  Now the order is
reversed:

mlx5_st_alloc_index()
    pcie_tph_get_cpu_st(dev->pdev, ...)   /* runs first */
    mlx5_st_alloc_index_by_tag()
        if (!st) return -EOPNOTSUPP;      /* guard now lives here */

For a device where dev->st is NULL (TPH not supported, e.g.
!MLX5_CAP_GEN(mkey_pcie_tph), no pdev->tph_cap, or a failed mlx5_st_create()),
the DMAH-with-CPU-id path mlx5_ib_alloc_dmah() -> mlx5_st_alloc_index() now
reaches pcie_tph_get_cpu_st(), which performs an ACPI _DSM invocation
(acpi_get_cpu_uid() + pcie_find_root_port() + tph_invoke_dsm()) that was
previously skipped entirely.

Is this added firmware query on a device that does not support ST intended?

There is also an errno change: when the _DSM lookup itself fails,
mlx5_st_alloc_index() now returns pcie_tph_get_cpu_st()'s error (e.g.
-ENODEV or -EINVAL) to userspace instead of the prior -EOPNOTSUPP.  When the
lookup succeeds the by_tag re-check still returns -EOPNOTSUPP, so the two
differ only on the sub-path where the _DSM fails.

Would it be worth restoring the !st early-out in mlx5_st_alloc_index() before
the pcie_tph_get_cpu_st() call, or noting this behavioral change in the
commit message, which currently presents the change only as extracting
mlx5_st_alloc_index_by_tag()?
