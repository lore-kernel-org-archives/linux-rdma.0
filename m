Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791489;
	b=Q/GXRoHF34dmg4D+iAlBSvXK3bg2/hparBUOmLQQ64LktfYlIQp80PJwfxQo4vL3OoZu
	 Zs4SC8Y7cnbKapd8pDqz60HWtqMfq+pNFf4iOOPlm8LDgGKyAOPYZc4runq+noYa6jdAS
	 Yv4DCuhEPFvQ2xyEzChD5JBoh+Mn8aAuy3mYSHTHWHmBx4RDp6txNsE10p9svvDYtlPan
	 sLcZrSmoGrQYdMgGOXg2zIw5L2F2J71YboggnD5nS7JTT5UnGXVaNe8FQculp+wQDr0wN
	 3XNjGEjMl3wm9TjyyzJdCaFjeTxhnnVXEYEq2X2krvoH37REghsz0obZvAH9UfVjbRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791489;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KKP3/ndlpQfL2/jwV93hSis3S+0djklYUual5zIH3SE=;
	b=K1/keTMw4F26FE+tPKZr2w3v4d8hWqEkyMN422M982aKzCjwOoq6Ig8ryNEpDV+aLGcv
	 L8P0N/xtFWEjALNsExtR3DuxnY/+2eHkv9aTG0yGK0S9qenGT+7gtSSLK9djBuWQcMqi0
	 k2GqKwITzeg//5E+DbW1+DFgSTrMg06aWjLAtH/F/6haX3Xbsp+vGo/4Mjvxxkpl7xDjV
	 OIdKura3CvSi/LMTbGT4I7EgPxaEFwAbZGvJATki9hFA6vjeQWV2HcQkRMmVFnuTY9gxX
	 f3she49Vf7Zay5+k9Rj9hESE2wzY785o5nOlqadcusz265bIxSfqMfzje0rD/b1dYgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UW1GSKvs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4EE606A324
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UW1GSKvs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27651F000C1;
	Fri, 27 Nov 2026 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791489;
	bh=KKP3/ndlpQfL2/jwV93hSis3S+0djklYUual5zIH3SE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UW1GSKvsxRDIxAXG/DJb8B8Tg9a7aBQz1avRcX0yCRbQR2u+OKZ2fgf8YOi2fePQZ
	 vUvWdJmYOr+95Ytfz8nqoUu9e/a8pCqwquo4WNmksVQetLy8chbnPvcu0FQwRYH9q+
	 kx9J4DqlxuEHjyCfLOIDXo8CReAwMS1Ian9slTDdwJTwGwjzXqsS6Zd1qvXgdsl7uY
	 RtDLQuprB1quLUrWRKDszNHWz6ULFPAhhW9D/GljrfQ2LyDqos/u3q7Cxcgwcsa+HB
	 fYBa5ujygqo1AN+FS4ji+U1szeHIWqC4dHCI6h8k/0BSIyX8ITdl8ivsfEj2qI843L
	 Iu0c7000zgmUA==
Message-ID: <sashiko-outbox-237638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/11] net/xsc: add event queues and MSI-X
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145724.70868-6-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
 <20261126145724.70868-6-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/xsc: invalid vmap() of dma_alloc_coherent() pages in
  xsc_buf_alloc()
--

commit 73274bfd54f18b8487a549dce31abd6f4b58e46d
Author: Xin Tian <tianx@yunsilicon.com>

net/xsc: add event queues and MSI-X

This commit adds asynchronous and completion event queues, allocates MSI-X
vectors, and dispatches link events from a workqueue.

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/ne=
t/ethernet/yunsilicon/xsc/pci/alloc.c
> new file mode 100644
> index 0000000000000..46eb0b031511d
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
> @@ -0,0 +1,123 @@

[ ... ]

> +int xsc_buf_alloc(struct xsc_core_device *xdev,
> +		  unsigned long size,
> +		  unsigned long max_direct,
> +		  struct xsc_buf *buf)
> +{
> +	dma_addr_t t;
> +
> +	buf->size =3D size;
> +	if (size <=3D max_direct) {

[ ... ]

> +	} else {
> +		struct page **pages;
> +		unsigned int i;
> +
> +		buf->direct.buf =3D NULL;
> +		buf->nbufs      =3D DIV_ROUND_UP(size, PAGE_SIZE);
> +		buf->npages     =3D buf->nbufs;
> +		buf->page_shift =3D PAGE_SHIFT;
> +		buf->page_list  =3D kcalloc(buf->nbufs, sizeof(*buf->page_list),
> +					  GFP_KERNEL);
> +		if (!buf->page_list)
> +			return -ENOMEM;
> +
> +		for (i =3D 0; i < buf->nbufs; i++) {
> +			buf->page_list[i].buf =3D
> +				dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
> +						   &t, GFP_KERNEL);
> +			if (!buf->page_list[i].buf)
> +				goto err_free;
> +
> +			buf->page_list[i].map =3D t;
> +		}
> +
> +		pages =3D kmalloc_array(buf->nbufs, sizeof(*pages), GFP_KERNEL);
> +		if (!pages)
> +			goto err_free;
> +
> +		for (i =3D 0; i < buf->nbufs; i++) {
> +			void *addr =3D buf->page_list[i].buf;
> +
> +			if (is_vmalloc_addr(addr))
> +				pages[i] =3D vmalloc_to_page(addr);
> +			else
> +				pages[i] =3D virt_to_page(addr);
> +		}
> +		buf->direct.buf =3D vmap(pages, buf->nbufs, VM_MAP, PAGE_KERNEL);
> +		kfree(pages);
> +		if (!buf->direct.buf)
> +			goto err_free;
> +	}

[Severity: High]
Is it valid to call virt_to_page() or vmalloc_to_page() and vmap(...,
PAGE_KERNEL) on memory returned by dma_alloc_coherent()?

Coherent DMA allocations are not guaranteed to be backed by normal linear
or vmalloc struct pages, and on non-coherent architectures or confidential
VMs remapping coherent DMA pages with PAGE_KERNEL creates a conflicting
cacheable or encrypted alias.  This branch is hit for every completion EQ
on 4K-page kernels (alloc_comp_eqs() -> xsc_create_map_eq() ->
xsc_buf_alloc() with size =3D 16384 and max_direct =3D PAGE_SIZE).

Also, when buf->nbufs > 1, xsc_buf_offset() and xsc_fill_page_array() use
buf->page_list directly and never touch buf->direct.buf, so the vmap()
here and the paired vunmap() in xsc_buf_free() can be dropped altogether.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com?part=3D5
