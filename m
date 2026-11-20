Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165360;
	b=EsFeV0grl6HPX94J6/JIsXCpAkim8NaAZlDJwIRJJN7MG/TUFfzrWtT2nq7NGmbzZdFV
	 KFM8J30pAusbGZKe9wgXRvy1VFtNtsCjwRfA5K2aSn5srq//COE6InxEqngstizX3Zg6V
	 PqJ+h8Lw4LC94qC1efIH+g0aUSy4j3/6Ml8KW5ZQAwKVjgmPPjWqa9ce8Ny6TsuoFZhPG
	 Wi8JEMqT4PSmxCi7/FjZhj5FZAhG7ZQVoHeGvfVdo9Ps9+37inpVcQ1mYpR9cUZ5lE+pQ
	 N4/iiFJFxXwdjVyST4z9SUekS3Ku0GMmS3Sao91Y6YUptSkW9k2ekFHow0hGtRXYhbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165360;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=B27NBmW6xEW99C4mPgAJ/Hv6uDSHsBlZ/pHbt7OCb5c=;
	b=TqrM066Rm6vlvnXrstUzhSqNCEysvCtBlCeLbGNBNzOcSkE/LBANLbqH14jVSh3ox3jU
	 +bPrK3kt17JPZ8r6ZINBzzYh1Avpg+OhoLYPM4kMqY7d1VW5JW3q8NPWzFfFKu/DqDeRO
	 vDWmdfDS6C8F56vE3TQyKN+8C+R9oSqvbMdnEBz25g+vcu0GXKGA5wTpxdfsJAoxz7VDZ
	 nM5Jy1BKeo3HR2aYouPctt+pNCVHa2kCWPrah9bGL7m0AfSWYax2iWurl0GCo2u+OE3/S
	 YqYRlilGP6i6JLBFDAdBBzF4yQTycHJMw7+RV+GiW4E11b+ygvX7YzLAqIB8SPylVVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CbL1ygrH;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB628606A325;
	Fri, 20 Nov 2026 09:02:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB628606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CbL1ygrH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795165359; x=1826701359;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=gARWLH6ZEUJrL59sAcqoW3jvuymgTvg3AgpOXJipfyc=;
  b=CbL1ygrHZWBkpMsFO9UllxrDIMpb1z5cMPNV6c4OqwOLjC+tVhHpdAvH
   EVnKn/J8dRlNlgXzRi7T8x89OZJbJ2HDx5wEf9ywCMVVBRz6bPOc+Zgdb
   hSrSG/QQKoUCZ5Ptiu2bxZfArvRferEJpDFVWNoorlyB+RZ3kTam9bMN5
   zxMooJOF54M+D4cFI2VK0U7PkN/GTw1HXbTkYDmB+K/kVq9R27r0JKrfd
   gczzVQjHCGMnXPHz3z/qZPPB9M6tToSfcslRG52hp1TR8YJj0aZnlA4/z
   aMAebxtDYa6KoU9euJPu1tTZzHw5wckwflQICTIpFr4RK2JF6w9JJBV20
   A==;
X-CSE-ConnectionGUID: DsEtWkpXT46iE3YQ3rsPMA==
X-CSE-MsgGUID: 9cVg5mjQTsmOOoaCgUy5Sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3927345"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="3927345"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 01:02:38 -0800
X-CSE-ConnectionGUID: fBG0jayzTsmxWVASfsMV9Q==
X-CSE-MsgGUID: Nmec7opNSWCMak6X0xk8jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10648511"
Received: from soc-pf6038af.clients.intel.com (HELO [10.217.180.38]) ([10.217.180.38])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 01:02:29 -0800
Message-ID: <47f2ff46-1837-43f5-a413-0dbf29716d7a@linux.intel.com>
Date: Fri, 20 Nov 2026 10:02:27 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/24] dma-buf: Convert exporters allocating a table
 per map to the SGT mapping type
To: Alistair Popple <apopple@nvidia.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com, chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-7-c0183a409bdf@nvidia.com>
Content-Language: en-US
From: Karol Wachowski <karol.wachowski@linux.intel.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-7-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20-Nov-26 6:55, Alistair Popple wrote:
> These exporters allocate a struct sg_table in map_dma_buf() and free
> it again in unmap_dma_buf().
> 
> The conversion is mechanical and no behaviour change is expected.
> Instead of map_dma_buf() allocating a sg_table it instead allocates and
> returns a dma_buf_sgt_mapping, which the unmap callbacks also take.
> 
> As a side effect this fixes a leak in fsl_asrc_m2m. Its unmap_dma_buf()
> only DMA unmapped the per-map table and never freed it. It now frees the
> mapping including the table.
> 
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   drivers/accel/amdxdna/amdxdna_cbuf.c             | 30 ++++++++------
>   drivers/accel/amdxdna/amdxdna_ubuf.c             | 34 +++++++++-------
>   drivers/accel/habanalabs/common/memory.c         | 52 +++++++++++++-----------
>   drivers/gpu/drm/armada/armada_gem.c              | 36 +++++++++-------
>   drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c | 30 ++++++++------
>   drivers/gpu/drm/tegra/gem.c                      | 30 ++++++++------
>   samples/vfio-mdev/mbochs.c                       | 31 ++++++++------
>   sound/soc/fsl/fsl_asrc_m2m.c                     | 32 +++++++++------
>   8 files changed, 161 insertions(+), 114 deletions(-)
> 
> diff --git a/drivers/accel/amdxdna/amdxdna_cbuf.c b/drivers/accel/amdxdna/amdxdna_cbuf.c
> index a504560aae98..945436516cc6 100644
> --- a/drivers/accel/amdxdna/amdxdna_cbuf.c
> +++ b/drivers/accel/amdxdna/amdxdna_cbuf.c
> @@ -5,6 +5,7 @@
>   
>   #include <drm/drm_mm.h>
>   #include <drm/drm_prime.h>
> +#include <linux/dma-buf-mapping.h>
>   
>   #include "amdxdna_cbuf.h"
>   #include "amdxdna_pci_drv.h"
> @@ -81,11 +82,13 @@ struct amdxdna_cbuf_priv {
>   	struct drm_mm_node node;
>   };
>   
> -static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
> -					 enum dma_data_direction direction)
> +static struct dma_buf_sgt_mapping *
> +amdxdna_cbuf_map(struct dma_buf_attachment *attach,
> +		 enum dma_data_direction direction)
>   {
>   	struct amdxdna_cbuf_priv *cbuf = attach->dmabuf->priv;
> -	struct device *dev = attach->dev;
> +	struct device *dev = dma_buf_sgt_dma_device(attach);
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct scatterlist *sgl, *sg;
>   	int ret, n_entries, i;
>   	struct sg_table *sgt;
> @@ -93,9 +96,10 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
>   	size_t dma_size;
>   	size_t max_seg;
>   
> -	sgt = kzalloc_obj(*sgt);
> -	if (!sgt)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return ERR_PTR(-ENOMEM);
> +	sgt = &mapping->sgt;
>   
>   	max_seg = min_t(size_t, UINT_MAX, dma_max_mapping_size(dev));
>   	n_entries = (cbuf->node.size + max_seg - 1) / max_seg;
> @@ -127,24 +131,27 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
>   		dma_size -= len;
>   	}
>   
> -	return sgt;
> +	return mapping;
>   
>   free_sgl:
>   	kfree(sgl);
>   free_sgt:
> -	kfree(sgt);
> +	kfree(mapping);
>   	return ERR_PTR(ret);
>   }
>   
>   static void amdxdna_cbuf_unmap(struct dma_buf_attachment *attach,
> -			       struct sg_table *sgt,
> +			       struct dma_buf_sgt_mapping *mapping,
>   			       enum dma_data_direction direction)
>   {
> -	dma_unmap_resource(attach->dev, sg_dma_address(sgt->sgl),
> +	struct sg_table *sgt = &mapping->sgt;
> +
> +	dma_unmap_resource(dma_buf_sgt_mapping_dma_device(mapping),
> +			   sg_dma_address(sgt->sgl),
>   			   drm_prime_get_contiguous_size(sgt), direction,
>   			   DMA_ATTR_SKIP_CPU_SYNC);
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   }
>   
>   static void amdxdna_cbuf_release(struct dma_buf *dbuf)
> @@ -210,12 +217,11 @@ static void amdxdna_cbuf_vunmap(struct dma_buf *dbuf, struct iosys_map *map)
>   }
>   
>   static const struct dma_buf_ops amdxdna_cbuf_dmabuf_ops = {
> -	.map_dma_buf = amdxdna_cbuf_map,
> -	.unmap_dma_buf = amdxdna_cbuf_unmap,
>   	.release = amdxdna_cbuf_release,
>   	.mmap = amdxdna_cbuf_mmap,
>   	.vmap = amdxdna_cbuf_vmap,
>   	.vunmap = amdxdna_cbuf_vunmap,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_cbuf_map, amdxdna_cbuf_unmap),
>   };
>   
>   static int amdxdna_cbuf_clear(struct dma_buf *dbuf)
> diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
> index 0e0cd69cd1fb..ed8b0ab9e554 100644
> --- a/drivers/accel/amdxdna/amdxdna_ubuf.c
> +++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
> @@ -7,6 +7,7 @@
>   #include <drm/drm_device.h>
>   #include <drm/drm_print.h>
>   #include <linux/dma-buf.h>
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/overflow.h>
>   #include <linux/pagemap.h>
>   #include <linux/vmalloc.h>
> @@ -20,42 +21,48 @@ struct amdxdna_ubuf_priv {
>   	struct mm_struct *mm;
>   };
>   
> -static struct sg_table *amdxdna_ubuf_map(struct dma_buf_attachment *attach,
> -					 enum dma_data_direction direction)
> +static struct dma_buf_sgt_mapping *
> +amdxdna_ubuf_map(struct dma_buf_attachment *attach,
> +		 enum dma_data_direction direction)
>   {
>   	struct amdxdna_ubuf_priv *ubuf = attach->dmabuf->priv;
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct sg_table *sg;
>   	int ret;
>   
> -	sg = kzalloc_obj(*sg);
> -	if (!sg)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return ERR_PTR(-ENOMEM);
> +	sg = &mapping->sgt;
>   
>   	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->nr_pages, 0,
>   					ubuf->nr_pages << PAGE_SHIFT, GFP_KERNEL);
>   	if (ret)
> -		goto err_free_sg;
> +		goto err_free_mapping;
>   
> -	ret = dma_map_sgtable(attach->dev, sg, direction, 0);
> +	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
>   	if (ret)
>   		goto err_free_table;
>   
> -	return sg;
> +	return mapping;
>   
>   err_free_table:
>   	sg_free_table(sg);
> -err_free_sg:
> -	kfree(sg);
> +err_free_mapping:
> +	kfree(mapping);
>   	return ERR_PTR(ret);
>   }
>   
>   static void amdxdna_ubuf_unmap(struct dma_buf_attachment *attach,
> -			       struct sg_table *sg,
> +			       struct dma_buf_sgt_mapping *mapping,
>   			       enum dma_data_direction direction)
>   {
> -	dma_unmap_sgtable(attach->dev, sg, direction, 0);
> +	struct sg_table *sg = &mapping->sgt;
> +
> +	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sg,
> +			  direction, 0);
>   	sg_free_table(sg);
> -	kfree(sg);
> +	kfree(mapping);
>   }
>   
>   static void amdxdna_ubuf_release(struct dma_buf *dbuf)
> @@ -70,9 +77,8 @@ static void amdxdna_ubuf_release(struct dma_buf *dbuf)
>   }
>   
>   static const struct dma_buf_ops amdxdna_ubuf_dmabuf_ops = {
> -	.map_dma_buf = amdxdna_ubuf_map,
> -	.unmap_dma_buf = amdxdna_ubuf_unmap,
>   	.release = amdxdna_ubuf_release,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_ubuf_map, amdxdna_ubuf_unmap),
>   };
>   
>   struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
> diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
> index 361cff577381..fc39ccd6f8db 100644
> --- a/drivers/accel/habanalabs/common/memory.c
> +++ b/drivers/accel/habanalabs/common/memory.c
> @@ -9,6 +9,7 @@
>   #include "habanalabs.h"
>   #include "../include/hw_ip/mmu/mmu_general.h"
>   
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/uaccess.h>
>   #include <linux/slab.h>
>   #include <linux/vmalloc.h>
> @@ -1531,13 +1532,15 @@ static int set_dma_sg(struct scatterlist *sg, u64 bar_address, u64 chunk_size,
>   	return 0;
>   }
>   
> -static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64 *pages, u64 npages,
> -						u64 page_size, u64 exported_size, u64 offset,
> -						struct device *dev, enum dma_data_direction dir)
> +static struct dma_buf_sgt_mapping *
> +alloc_sgt_from_device_pages(struct hl_device *hdev, u64 *pages, u64 npages, u64 page_size,
> +			    u64 exported_size, u64 offset, struct device *dev,
> +			    enum dma_data_direction dir)
>   {
>   	u64 dma_max_seg_size, curr_page, size, chunk_size, left_size_to_export, left_size_in_page,
>   		left_size_in_dma_seg, device_address, bar_address, start_page;
>   	struct asic_fixed_properties *prop = &hdev->asic_prop;
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct scatterlist *sg;
>   	unsigned int nents, i;
>   	struct sg_table *sgt;
> @@ -1553,9 +1556,10 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
>   		return ERR_PTR(-EINVAL);
>   	}
>   
> -	sgt = kzalloc_obj(*sgt);
> -	if (!sgt)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return ERR_PTR(-ENOMEM);
> +	sgt = &mapping->sgt;
>   
>   	/* Use the offset to move to the actual first page that is exported */
>   	for (start_page = 0 ; start_page < npages ; ++start_page) {
> @@ -1686,7 +1690,7 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
>   			"SG entry %d: address %#llx, length %#x\n",
>   			i, sg_dma_address(sg), sg_dma_len(sg));
>   
> -	return sgt;
> +	return mapping;
>   
>   err_unmap:
>   	for_each_sgtable_dma_sg(sgt, sg, i) {
> @@ -1700,7 +1704,7 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
>   	sg_free_table(sgt);
>   
>   err_free_sgt:
> -	kfree(sgt);
> +	kfree(mapping);
>   	return ERR_PTR(rc);
>   }
>   
> @@ -1714,22 +1718,22 @@ static int hl_dmabuf_attach(struct dma_buf *dmabuf,
>   	hl_dmabuf = dmabuf->priv;
>   	hdev = hl_dmabuf->ctx->hdev;
>   
> -	rc = pci_p2pdma_distance(hdev->pdev, attachment->dev, true);
> +	rc = pci_p2pdma_distance(hdev->pdev, dma_buf_sgt_dma_device(attachment), true);
>   
>   	if (rc < 0)
>   		attachment->peer2peer = false;
>   	return 0;
>   }
>   
> -static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
> -					enum dma_data_direction dir)
> +static struct dma_buf_sgt_mapping *
> +hl_map_dmabuf(struct dma_buf_attachment *attachment, enum dma_data_direction dir)
>   {
>   	u64 *pages, npages, page_size, exported_size, offset;
>   	struct dma_buf *dma_buf = attachment->dmabuf;
>   	struct hl_vm_phys_pg_pack *phys_pg_pack;
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct hl_dmabuf_priv *hl_dmabuf;
>   	struct hl_device *hdev;
> -	struct sg_table *sgt;
>   
>   	hl_dmabuf = dma_buf->priv;
>   	hdev = hl_dmabuf->ctx->hdev;
> @@ -1753,18 +1757,21 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
>   		page_size = hl_dmabuf->dmabuf->size;
>   	}
>   
> -	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size, exported_size, offset,
> -						attachment->dev, dir);
> -	if (IS_ERR(sgt))
> -		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(sgt));
> +	mapping = alloc_sgt_from_device_pages(hdev, pages, npages, page_size,
> +					      exported_size, offset,
> +					      dma_buf_sgt_dma_device(attachment),
> +					      dir);
> +	if (IS_ERR(mapping))
> +		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(mapping));
>   
> -	return sgt;
> +	return mapping;
>   }
>   
>   static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
> -				  struct sg_table *sgt,
> +				  struct dma_buf_sgt_mapping *mapping,
>   				  enum dma_data_direction dir)
>   {
> +	struct sg_table *sgt = &mapping->sgt;
>   	struct scatterlist *sg;
>   	int i;
>   
> @@ -1776,14 +1783,14 @@ static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
>   	 * a sync of the memory to the CPU's cache, as it never resided inside that cache.
>   	 */
>   	for_each_sgtable_dma_sg(sgt, sg, i)
> -		dma_unmap_resource(attachment->dev, sg_dma_address(sg),
> -					sg_dma_len(sg), dir,
> -					DMA_ATTR_SKIP_CPU_SYNC);
> +		dma_unmap_resource(dma_buf_sgt_mapping_dma_device(mapping),
> +				   sg_dma_address(sg), sg_dma_len(sg), dir,
> +				   DMA_ATTR_SKIP_CPU_SYNC);
>   
>   	/* Need to restore orig_nents because sg_free_table use that field */
>   	sgt->orig_nents = sgt->nents;
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   }
>   
>   static struct hl_vm_hash_node *memhash_node_export_get(struct hl_ctx *ctx, u64 addr)
> @@ -1850,9 +1857,8 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
>   
>   static const struct dma_buf_ops habanalabs_dmabuf_ops = {
>   	.attach = hl_dmabuf_attach,
> -	.map_dma_buf = hl_map_dmabuf,
> -	.unmap_dma_buf = hl_unmap_dmabuf,
>   	.release = hl_release_dmabuf,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(hl_map_dmabuf, hl_unmap_dmabuf),
>   };
>   
>   static int export_dmabuf(struct hl_ctx *ctx,
> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> index 044acdef6351..1eff00567386 100644
> --- a/drivers/gpu/drm/armada/armada_gem.c
> +++ b/drivers/gpu/drm/armada/armada_gem.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include <linux/dma-buf.h>
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/mman.h>
>   #include <linux/shmem_fs.h>
> @@ -383,41 +384,44 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
>   }
>   
>   /* Prime support */
> -static struct sg_table *
> +static struct dma_buf_sgt_mapping *
>   armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
>   	enum dma_data_direction dir)
>   {
> +	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
>   	struct drm_gem_object *obj = attach->dmabuf->priv;
>   	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct scatterlist *sg;
>   	struct sg_table *sgt;
>   	int i;
>   
> -	sgt = kmalloc_obj(*sgt);
> -	if (!sgt)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return NULL;
> +	sgt = &mapping->sgt;
>   
>   	if (dobj->obj.filp) {
> -		struct address_space *mapping;
> +		struct address_space *file_mapping;
>   		int count;
>   
>   		count = dobj->obj.size / PAGE_SIZE;
>   		if (sg_alloc_table(sgt, count, GFP_KERNEL))
>   			goto free_sgt;
>   
> -		mapping = dobj->obj.filp->f_mapping;
> +		file_mapping = dobj->obj.filp->f_mapping;
>   
>   		for_each_sgtable_sg(sgt, sg, i) {
>   			struct page *page;
>   
> -			page = shmem_read_mapping_page(mapping, i);
> +			page = shmem_read_mapping_page(file_mapping, i);
>   			if (IS_ERR(page))
>   				goto release;
>   
>   			sg_set_page(sg, page, PAGE_SIZE, 0);
>   		}
>   
> -		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
> +		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
>   			goto release;
>   	} else if (dobj->page) {
>   		/* Single contiguous page */
> @@ -426,7 +430,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
>   
>   		sg_set_page(sgt->sgl, dobj->page, dobj->obj.size, 0);
>   
> -		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
> +		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
>   			goto free_table;
>   	} else if (dobj->linear) {
>   		/* Single contiguous physical region - no struct page */
> @@ -437,7 +441,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
>   	} else {
>   		goto free_sgt;
>   	}
> -	return sgt;
> +	return mapping;
>   
>    release:
>   	for_each_sgtable_sg(sgt, sg, i)
> @@ -446,19 +450,21 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
>    free_table:
>   	sg_free_table(sgt);
>    free_sgt:
> -	kfree(sgt);
> +	kfree(mapping);
>   	return NULL;
>   }
>   
>   static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
> -	struct sg_table *sgt, enum dma_data_direction dir)
> +	struct dma_buf_sgt_mapping *mapping, enum dma_data_direction dir)
>   {
>   	struct drm_gem_object *obj = attach->dmabuf->priv;
>   	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
> +	struct sg_table *sgt = &mapping->sgt;
>   	int i;
>   
>   	if (!dobj->linear)
> -		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
> +		dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sgt,
> +				  dir, 0);
>   
>   	if (dobj->obj.filp) {
>   		struct scatterlist *sg;
> @@ -468,7 +474,7 @@ static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
>   	}
>   
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   }
>   
>   static int
> @@ -478,10 +484,10 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
>   }
>   
>   static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
> -	.map_dma_buf	= armada_gem_prime_map_dma_buf,
> -	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
>   	.release	= drm_gem_dmabuf_release,
>   	.mmap		= armada_gem_dmabuf_mmap,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(armada_gem_prime_map_dma_buf,
> +				     armada_gem_prime_unmap_dma_buf),
>   };
>   
>   struct dma_buf *
> diff --git a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
> index f2863da7f5c1..bba066f3cb50 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
> @@ -4,20 +4,24 @@
>    * Copyright © 2016 Intel Corporation
>    */
>   
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/vmalloc.h>
>   #include "mock_dmabuf.h"
>   
> -static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
> -					 enum dma_data_direction dir)
> +static struct dma_buf_sgt_mapping *
> +mock_map_dma_buf(struct dma_buf_attachment *attachment,
> +		 enum dma_data_direction dir)
>   {
>   	struct mock_dmabuf *mock = to_mock(attachment->dmabuf);
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct sg_table *st;
>   	struct scatterlist *sg;
>   	int i, err;
>   
> -	st = kmalloc_obj(*st);
> -	if (!st)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return ERR_PTR(-ENOMEM);
> +	st = &mapping->sgt;
>   
>   	err = sg_alloc_table(st, mock->npages, GFP_KERNEL);
>   	if (err)
> @@ -29,26 +33,27 @@ static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
>   		sg = sg_next(sg);
>   	}
>   
> -	err = dma_map_sgtable(attachment->dev, st, dir, 0);
> +	err = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
>   	if (err)
>   		goto err_st;
>   
> -	return st;
> +	return mapping;
>   
>   err_st:
>   	sg_free_table(st);
>   err_free:
> -	kfree(st);
> +	kfree(mapping);
>   	return ERR_PTR(err);
>   }
>   
>   static void mock_unmap_dma_buf(struct dma_buf_attachment *attachment,
> -			       struct sg_table *st,
> +			       struct dma_buf_sgt_mapping *mapping,
>   			       enum dma_data_direction dir)
>   {
> -	dma_unmap_sgtable(attachment->dev, st, dir, 0);
> -	sg_free_table(st);
> -	kfree(st);
> +	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
> +			  &mapping->sgt, dir, 0);
> +	sg_free_table(&mapping->sgt);
> +	kfree(mapping);
>   }
>   
>   static void mock_dmabuf_release(struct dma_buf *dma_buf)
> @@ -88,12 +93,11 @@ static int mock_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
>   }
>   
>   static const struct dma_buf_ops mock_dmabuf_ops =  {
> -	.map_dma_buf = mock_map_dma_buf,
> -	.unmap_dma_buf = mock_unmap_dma_buf,
>   	.release = mock_dmabuf_release,
>   	.mmap = mock_dmabuf_mmap,
>   	.vmap = mock_dmabuf_vmap,
>   	.vunmap = mock_dmabuf_vunmap,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
>   };
>   
>   static struct dma_buf *mock_dmabuf(int npages)
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index e6aa6dae4ec8..8e288a34f10f 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -11,6 +11,7 @@
>    */
>   
>   #include <linux/dma-buf.h>
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/iommu.h>
>   #include <linux/module.h>
>   #include <linux/pagemap.h>
> @@ -626,51 +627,56 @@ int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
>   	return __tegra_gem_mmap(gem, vma);
>   }
>   
> -static struct sg_table *
> +static struct dma_buf_sgt_mapping *
>   tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
>   			    enum dma_data_direction dir)
>   {
> +	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
>   	struct drm_gem_object *gem = attach->dmabuf->priv;
>   	struct tegra_bo *bo = to_tegra_bo(gem);
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct sg_table *sgt;
>   
> -	sgt = kmalloc_obj(*sgt);
> -	if (!sgt)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return NULL;
> +	sgt = &mapping->sgt;
>   
>   	if (bo->pages) {
>   		if (sg_alloc_table_from_pages(sgt, bo->pages, bo->num_pages,
>   					      0, gem->size, GFP_KERNEL) < 0)
>   			goto free;
>   	} else {
> -		if (dma_get_sgtable(attach->dev, sgt, bo->vaddr, bo->iova,
> +		if (dma_get_sgtable(dma_dev, sgt, bo->vaddr, bo->iova,
>   				    gem->size) < 0)
>   			goto free;
>   	}
>   
> -	if (dma_map_sgtable(attach->dev, sgt, dir, 0))
> +	if (dma_map_sgtable(dma_dev, sgt, dir, 0))
>   		goto free;
>   
> -	return sgt;
> +	return mapping;
>   
>   free:
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   	return NULL;
>   }
>   
>   static void tegra_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
> -					  struct sg_table *sgt,
> +					  struct dma_buf_sgt_mapping *mapping,
>   					  enum dma_data_direction dir)
>   {
>   	struct drm_gem_object *gem = attach->dmabuf->priv;
>   	struct tegra_bo *bo = to_tegra_bo(gem);
> +	struct sg_table *sgt = &mapping->sgt;
>   
>   	if (bo->pages)
> -		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
> +		dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sgt,
> +				  dir, 0);
>   
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   }
>   
>   static void tegra_gem_prime_release(struct dma_buf *buf)
> @@ -740,14 +746,14 @@ static void tegra_gem_prime_vunmap(struct dma_buf *buf, struct iosys_map *map)
>   }
>   
>   static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {
> -	.map_dma_buf = tegra_gem_prime_map_dma_buf,
> -	.unmap_dma_buf = tegra_gem_prime_unmap_dma_buf,
>   	.release = tegra_gem_prime_release,
>   	.begin_cpu_access = tegra_gem_prime_begin_cpu_access,
>   	.end_cpu_access = tegra_gem_prime_end_cpu_access,
>   	.mmap = tegra_gem_prime_mmap,
>   	.vmap = tegra_gem_prime_vmap,
>   	.vunmap = tegra_gem_prime_vunmap,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(tegra_gem_prime_map_dma_buf,
> +				     tegra_gem_prime_unmap_dma_buf),
>   };
>   
>   struct dma_buf *tegra_gem_prime_export(struct drm_gem_object *gem,
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 64ea19253ee3..3502d0b37bd1 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -32,6 +32,7 @@
>   #include <linux/pci.h>
>   #include <linux/dma-buf.h>
>   #include <linux/highmem.h>
> +#include <linux/dma-buf-mapping.h>
>   #include <drm/drm_fourcc.h>
>   #include <drm/drm_rect.h>
>   #include <drm/drm_modeset_lock.h>
> @@ -857,46 +858,51 @@ static void mbochs_print_dmabuf(struct mbochs_dmabuf *dmabuf,
>   		dmabuf->mode.offset, dmabuf->mode.size, dmabuf->pagecount);
>   }
>   
> -static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
> -					  enum dma_data_direction direction)
> +static struct dma_buf_sgt_mapping *
> +mbochs_map_dmabuf(struct dma_buf_attachment *at,
> +		  enum dma_data_direction direction)
>   {
>   	struct mbochs_dmabuf *dmabuf = at->dmabuf->priv;
>   	struct device *dev = mdev_dev(dmabuf->mdev_state->mdev);
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct sg_table *sg;
>   
>   	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
>   
> -	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
> -	if (!sg)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		goto err1;
> +	sg = &mapping->sgt;
>   	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
>   				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
>   		goto err2;
> -	if (dma_map_sgtable(at->dev, sg, direction, 0))
> +	if (dma_map_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0))
>   		goto err3;
>   
> -	return sg;
> +	return mapping;
>   
>   err3:
>   	sg_free_table(sg);
>   err2:
> -	kfree(sg);
> +	kfree(mapping);
>   err1:
>   	return ERR_PTR(-ENOMEM);
>   }
>   
>   static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
> -				struct sg_table *sg,
> +				struct dma_buf_sgt_mapping *mapping,
>   				enum dma_data_direction direction)
>   {
>   	struct mbochs_dmabuf *dmabuf = at->dmabuf->priv;
>   	struct device *dev = mdev_dev(dmabuf->mdev_state->mdev);
> +	struct sg_table *sg = &mapping->sgt;
>   
>   	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
>   
> -	dma_unmap_sgtable(at->dev, sg, direction, 0);
> +	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping), sg,
> +			  direction, 0);
>   	sg_free_table(sg);
> -	kfree(sg);
> +	kfree(mapping);
>   }
>   
>   static void mbochs_release_dmabuf(struct dma_buf *buf)
> @@ -918,11 +924,10 @@ static void mbochs_release_dmabuf(struct dma_buf *buf)
>   	mutex_unlock(&mdev_state->ops_lock);
>   }
>   
> -static struct dma_buf_ops mbochs_dmabuf_ops = {
> -	.map_dma_buf	  = mbochs_map_dmabuf,
> -	.unmap_dma_buf	  = mbochs_unmap_dmabuf,
> +static const struct dma_buf_ops mbochs_dmabuf_ops = {
>   	.release	  = mbochs_release_dmabuf,
>   	.mmap		  = mbochs_mmap_dmabuf,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mbochs_map_dmabuf, mbochs_unmap_dmabuf),
>   };
>   
>   static struct mbochs_dmabuf *mbochs_dmabuf_alloc(struct mdev_state *mdev_state,
> diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
> index 58101ce07c9f..79fde68f9394 100644
> --- a/sound/soc/fsl/fsl_asrc_m2m.c
> +++ b/sound/soc/fsl/fsl_asrc_m2m.c
> @@ -7,6 +7,7 @@
>   
>   #include <linux/dma/imx-dma.h>
>   #include <linux/dma-buf.h>
> +#include <linux/dma-buf-mapping.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/pm_runtime.h>
>   #include <sound/asound.h>
> @@ -414,35 +415,42 @@ static int fsl_asrc_m2m_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
>   	return snd_dma_buffer_mmap(dmab, vma);
>   }
>   
> -static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
> -						 enum dma_data_direction direction)
> +static struct dma_buf_sgt_mapping *
> +fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
> +			 enum dma_data_direction direction)
>   {
> +	struct device *dma_dev = dma_buf_sgt_dma_device(attachment);
>   	struct snd_dma_buffer *dmab = attachment->dmabuf->priv;
> +	struct dma_buf_sgt_mapping *mapping;
>   	struct sg_table *sgt;
>   
> -	sgt = kmalloc_obj(*sgt);
> -	if (!sgt)
> +	mapping = kzalloc_obj(*mapping);
> +	if (!mapping)
>   		return NULL;
> +	sgt = &mapping->sgt;
>   
> -	if (dma_get_sgtable(attachment->dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
> +	if (dma_get_sgtable(dma_dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
>   		goto free;
>   
> -	if (dma_map_sgtable(attachment->dev, sgt, direction, 0))
> +	if (dma_map_sgtable(dma_dev, sgt, direction, 0))
>   		goto free;
>   
> -	return sgt;
> +	return mapping;
>   
>   free:
>   	sg_free_table(sgt);
> -	kfree(sgt);
> +	kfree(mapping);
>   	return NULL;
>   }
>   
>   static void fsl_asrc_m2m_unmap_dma_buf(struct dma_buf_attachment *attachment,
> -				       struct sg_table *table,
> +				       struct dma_buf_sgt_mapping *mapping,
>   				       enum dma_data_direction direction)
>   {
> -	dma_unmap_sgtable(attachment->dev, table, direction, 0);
> +	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
> +			  &mapping->sgt, direction, 0);
> +	sg_free_table(&mapping->sgt);
> +	kfree(mapping);
>   }
>   
>   static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
> @@ -452,9 +460,9 @@ static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
>   
>   static const struct dma_buf_ops fsl_asrc_m2m_dma_buf_ops = {
>   	.mmap = fsl_asrc_m2m_mmap,
> -	.map_dma_buf = fsl_asrc_m2m_map_dma_buf,
> -	.unmap_dma_buf = fsl_asrc_m2m_unmap_dma_buf,
>   	.release = fsl_asrc_m2m_release,
> +	DMA_BUF_SIMPLE_SGT_EXP_MATCH(fsl_asrc_m2m_map_dma_buf,
> +				     fsl_asrc_m2m_unmap_dma_buf),
>   };
>   
>   static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
> 

Acked-by: Karol Wachowski <karol.wachowski@linux.intel.com>
