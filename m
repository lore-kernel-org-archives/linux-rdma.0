Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBE931F985;
	Fri,  3 Jul 2026 04:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783052004; cv=none; b=EpsZxymwHjKyys4Mv/EeDLjsYLqZzGR82D2KQXqtHQmZBn7MhM3G0Jyh/iYZKT4V94O8WHVRz+waJQSAWW55fISTmjMnhC0SyfktKCXkuIIr3mFNEfiz4onfQlp7lrywdAs+ibwj9jwoegssr4RzC+HsnTdCZr43uHnpximEBZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783052004; c=relaxed/simple;
	bh=K4NBvrxg4Ts9M6VttlUDeDJolSfbLlqEPIWhgvRM+0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KogDKDRhCITbA+jw0d06vKSa0Af+mke0zQbjTO201BkIZ9OqHqxcVqo9ZGGWdO9noU0zWf9ZcXd1AmdOgw4kYcrTe2CzQuK4h6YRZQSgBMaq5WDTQibjTj4hiqRybKngCpOGyb7ZnVUGc+l61up+YYBTfbHo0Er9ht18LkSnG/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VuDVjd0b; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VuDVjd0b"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hfeWr5BHyNT6a2qtRYqbBQlFcdwj0Mi1m3+qvWhJyVw=;
	b=VuDVjd0bwczVpJ86vC5m+JuF/iKUAcVHTzEMJVKNogwOSlH+bYnG6ob/LPzGQL/rCI1BKG5W2
	C350Wjx7rkkzv6WqBMK7nlcStWNKRDH96Pr7g/TE1ERIUoJDaA1s0CqR5E3rhaIL/h4wogxPXJG
	LCk+cUNoPQ4zTAACPYftuvc=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gs0Vh5vzDz1cyPx;
	Fri,  3 Jul 2026 12:03:56 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 336F74056D;
	Fri,  3 Jul 2026 12:13:06 +0800 (CST)
Received: from [10.67.121.161] (10.67.121.161) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 3 Jul 2026 12:13:05 +0800
Message-ID: <6ab4c781-2409-4015-aac1-01d5cc1b9f6f@huawei.com>
Date: Fri, 3 Jul 2026 12:13:05 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/4] vfio/pci: implement get_pci_tph and DMA_BUF_TPH
 feature
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Michael Guralnik <michaelgur@nvidia.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: <kvm@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
References: <20260702181025.2694961-1-zhipingz@meta.com>
 <20260702181025.2694961-4-zhipingz@meta.com>
Content-Language: en-US
From: fengchengwen <fengchengwen@huawei.com>
In-Reply-To: <20260702181025.2694961-4-zhipingz@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo500009.china.huawei.com (7.202.194.199)

On 7/3/2026 2:10 AM, Zhiping Zhang wrote:
> Implement dma-buf get_pci_tph for vfio-pci exported dma-bufs and add
> VFIO_DEVICE_FEATURE_DMA_BUF_TPH so userspace can publish TPH metadata
> for a VFIO-owned device.
> 
> 8-bit ST and 16-bit Extended ST are distinct PCIe TPH namespaces; the
> uAPI carries both with explicit validity flags, and get_pci_tph()
> returns the value matching the importer's requested namespace or
> -EOPNOTSUPP.
> 
> Publish and read the TPH descriptor under dmabuf->resv, matching the
> locking used for other importer-visible dma-buf state. The SET ioctl
> takes dma_resv_lock_interruptible(), while the callback runs under
> DMA-buf's asserted resv lock.
> 
> The attach path reads @revoked without holding memory_lock. Annotate it
> with READ_ONCE() to document this intentional lockless access: the read
> is a benign early-out, and a racing revocation is re-checked under
> dmabuf->resv in vfio_pci_dma_buf_map() before any mapping is handed out.

I believe this modification (@revoked) might be related to resetting the
bit field segment and subsequently identifying a concurrency issue. It is
recommended to submit this as an independent commit.

> The annotation only needs to keep the access well-formed against the
> memory_lock-protected writers.
> 
> Reject requests the device cannot consume as a completer:
> pcie_tph_completer_type() must report at least
> PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY, and Extended ST requires
> PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH. Make PROBE follow the same hardware
> gate so the feature only probes as supported when the device can really
> consume it.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>

...

>  
>  #include "vfio_pci_priv.h"
> @@ -19,7 +20,17 @@ struct vfio_pci_dma_buf {
>  	u32 nr_ranges;
>  	struct kref kref;
>  	struct completion comp;
> -	u8 revoked : 1;
> +
> +	/*
> +	 * Updates protected by dmabuf->resv, @revoked additionally
> +	 * protected by memory_lock.
> +	 */
> +	u16 tph_st_ext;
> +	u8 tph_st;

how about: u16 tph_xst;
	   u16 tph_st;

> +	bool revoked;

why not move revoked before or after tph fields if it don't take one bit field?

> +	u8 tph_st_valid:1;
> +	u8 tph_st_ext_valid:1;

how about: u8 tph_xst_valid

> +	u8 tph_ph:2;
>  };

...

> +#define VFIO_DEVICE_FEATURE_DMA_BUF_TPH 13
> +
> +#define VFIO_DMA_BUF_TPH_ST		(1 << 0)
> +#define VFIO_DMA_BUF_TPH_ST_EXT		(1 << 1)
> +
> +struct vfio_device_feature_dma_buf_tph {
> +	__s32	dmabuf_fd;
> +	__u32	flags;
> +	__u16	steering_tag_ext;
> +	__u8	steering_tag;

how about:
	__u16 xst;
	__u8 st;
and it corresponding to VFIO_DMA_BUF_TPH_ST/ST_EXT

Thanks

> +	__u8	ph;
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

