Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B129B44AB73
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426641; cv=none; b=gqopmDlX3ko+J54bjQZCEDML5xcSdzVJJNVyBCr55JbXf8KqtAOoVocY4aV8p0/pRfWknrOves7hMotEiBspXbrjgoU6lLwt9norczRtDx3xQsPSoC/ZH2wpppuicleAztwZ7PBo86YTCywtEhc66XEbrt3/SEaaiYnPGVB2xio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426641; c=relaxed/simple;
	bh=PsLGQ/DsdNG99ic2sD2Y54PwoGhzx0wnEwiZexpmvrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZw5c0Lj5FGbXvMDpBzIKdSLO6i2D5zCjf094zKa7h2vLYDryu827MooiKalj7DMvE93uSlGrjlVijXNWKM/uZRfQOI6IqGllnr4Lc8qmAN5oOSrJva6giiCRDnYcxAdU2WjkBUYus5EyHOYsAvK4dE3fso/eJ2741d+7Sl4UZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPFIZSQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPFIZSQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781AE1F000E9;
	Thu,  3 Sep 2026 09:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788426639;
	bh=922EDFJcaNR+amT1p04mtTnvn5s8hU9crx/KMLkiTQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kPFIZSQQlKxQBS0JJPLmEHP4l0LGJL/Wp6s6AQcCl6rMdhmzTQtc7YvtekCV/yMXw
	 PiAu1rxYwszcMXB65Kv7cwgCT+WnPBfbffmwo939p8tJ1KqPlaRDi5IEaBIqgShEck
	 eLbFb/1+7K1siebWaxIgftW7laJj6dVEjcAUF9WyeCtofySjqxJCYjDaO/98buJ+qq
	 iSy4qCPypIilNsgzErqUScha6QvZj8mtR9rZ4LKcuP+PHp3yPCjGehgVrZE2rKVN+g
	 FkYjCJ7nGrx4o5ALuTN2ci1elDmfXYKJrOvHQ8JjT/uZL7PPCx6/RCE1FWEy0tc6Ar
	 Z9Yhvxlvf19TA==
Date: Thu, 3 Sep 2026 12:10:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
Subject: Re: [PATCH for-next v2 1/4] RDMA/erdma: Support non-contiguous
 kernel QP buffers
Message-ID: <20260903091033.GY24140@unreal>
References: <20260827082523.36294-1-chengyou@linux.alibaba.com>
 <20260827082523.36294-2-chengyou@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827082523.36294-2-chengyou@linux.alibaba.com>

On Thu, Aug 27, 2026 at 04:25:20PM +0800, Cheng Xu wrote:
> A single coherent allocation for kernel QP queues can fail for large
> queues when memory is fragmented.
> 
> Allocate page-sized coherent buffers and describe them with the existing
> MTT. Keep the userspace QP path unchanged.
> 
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> ---
>  drivers/infiniband/hw/erdma/erdma_cq.c    |   4 +-
>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +++--
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 195 +++++++++++++---------
>  drivers/infiniband/hw/erdma/erdma_verbs.h |  44 ++++-
>  4 files changed, 179 insertions(+), 102 deletions(-)

<...>

> +static void erdma_free_kmem(struct erdma_dev *dev, struct erdma_mem *mem)
> +{
> +	struct erdma_buf_list *buf_list;
> +	u32 i;
> +
> +	if (!mem->kmem)
> +		return;

Can it be null?

> +
> +	buf_list = mem->kmem->buf_list;
> +	if (buf_list) {

Write the unwinding section of erdma_alloc_kmem() to don't call to
erdma_free_kmem().

> +		for (i = 0; i < mem->page_cnt; i++)
> +			if (buf_list[i].buf)
> +				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
> +						  buf_list[i].buf,
> +						  buf_list[i].dma_addr);
> +		kfree(buf_list);
> +	}
> +
> +	kfree(mem->kmem);
> +	mem->kmem = NULL;
> +}
> +
> +static int erdma_alloc_kmem(struct erdma_dev *dev, struct erdma_mem *mem,
> +			    size_t size)
> +{
> +	struct erdma_buf_list *buf_list;
> +	u32 i;
> +
> +	mem->type = ERDMA_KMEM;
> +	mem->page_size = PAGE_SIZE;
> +	mem->page_offset = 0;
> +	mem->page_cnt = DIV_ROUND_UP(size, PAGE_SIZE);
> +	mem->mtt_nents = mem->page_cnt;
> +	mem->len = size;
> +
> +	mem->kmem = kzalloc_obj(*mem->kmem);
> +	if (!mem->kmem)
> +		goto err_free_mem;

There is no point to call to erdma_free_kmem() here and you can return
immediately.

> +
> +	buf_list = kcalloc(mem->page_cnt, sizeof(*buf_list), GFP_KERNEL);
> +	if (!buf_list)
> +		goto err_free_mem;

Please write error unwinding explicitly.

> +	mem->kmem->buf_list = buf_list;
> +
> +	for (i = 0; i < mem->page_cnt; i++) {
> +		buf_list[i].buf = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
> +						     &buf_list[i].dma_addr,
> +						     GFP_KERNEL);
> +		if (!buf_list[i].buf)
> +			goto err_free_mem;
> +	}
> +
> +	mem->mtt = erdma_create_mtt(dev, MTT_SIZE(mem->page_cnt), true);
> +	if (IS_ERR(mem->mtt)) {
> +		mem->mtt = NULL;

Why? You will release mem anyway.

> +		goto err_free_mem;
> +	}
> +	for (i = 0; i < mem->page_cnt; i++)
> +		mem->mtt->buf[i] = buf_list[i].dma_addr;
> +
> +	return 0;
> +
> +err_free_mem:
> +	erdma_free_kmem(dev, mem);
> +	return -ENOMEM;
> +}
> +

<...>

> +struct erdma_buf_list {
> +	void *buf;
> +	dma_addr_t dma_addr;
> +};

This struct is very similar to scatter-gather list, why don't you use it
directly?

Thanks
