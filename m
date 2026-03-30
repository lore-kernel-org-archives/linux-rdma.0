Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86ED3D092A
	for <linux-rdma@vger.kernel.org>; Mon, 30 Mar 2026 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876428; cv=none; b=B17rlYlWQVHEzK5RpFSqbOGfSES3lXJ/46diSlNtxfYDnbvKKD0iWYTS88zpABEA3jrLQ81U2AP9QdWnEjIEbZ+xsh6cQJmjniYHyKEPig8w52HIlDgH42kOKP57rxueNMIRwD6imGJ5i+RLQrpQQlOZzp+jhAceNxdDCU2UJUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876428; c=relaxed/simple;
	bh=Bd+gR3qVSUm9Pfm3vOESb0Dfzvka0uISqJgcz7jmlUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmPx5tXOgbBRpMUsnUaygj4hEEizo7L8S5j0qODRMI00tUp+JFjEzCoo8BIWJwX4P5FgGCURhbLpV1Uzs+etb03oh1CqAHbQvW+6887AKoTmI2fxAvFPWJ8nMYTM5BNpyh/ARzjQpuXVrNPyokD89lTtHn0TBkHz7V24YK6lX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzEVGtbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzEVGtbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30EFC4CEF7;
	Mon, 30 Mar 2026 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774876428;
	bh=Bd+gR3qVSUm9Pfm3vOESb0Dfzvka0uISqJgcz7jmlUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzEVGtbeKIim8Z8eGa7dZm2M3zxHX9AcqbUOyekO0ZR7p+4n8J76ywTDzmP4Eb4Hb
	 07a7xItSuXz3jDZP/+GLdB8XWK6ZA2UWQ8L3FnBfzfuX2ZRVh/Qc/gNiPi5FgC1urL
	 7wM2n0Yydcx3BlFVOF7ex5JZD0SGzF3NXFKGgP/1xqMPlul3O+5gB13DntPum1TNpb
	 yrbw42AeBpzjAUcU8hzmPG7a570DtxFtZkYNkfztMiybR71qcdJ7TjIvVfcz4B+yQP
	 9pjij00hP87jwXGL6d38xCHnM9jvNHtWcZzS2+jx6ZJqz28S4sIt2N0WOWol4GfZA+
	 HyDqvSSzKcoWw==
Date: Mon, 30 Mar 2026 16:13:43 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
	mie@igel.co.jp
Subject: Re: [PATCH 1/2] RDMA/umem: Change for rdma devices has not dma device
Message-ID: <20260330131343.GV814676@unreal>
References: <20260326052739.3778-1-yanjun.zhu@linux.dev>
 <20260326052739.3778-2-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260326052739.3778-2-yanjun.zhu@linux.dev>

On Wed, Mar 25, 2026 at 10:27:38PM -0700, Zhu Yanjun wrote:
> Current implementation requires a dma device for RDMA driver to use
> dma-buf memory space as RDMA buffer.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  drivers/infiniband/core/umem_dmabuf.c | 35 ++++++++++++++++++++++++++-
>  include/rdma/ib_umem.h                |  1 +
>  2 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
> index d30f24b90bca..65c5f09f380f 100644
> --- a/drivers/infiniband/core/umem_dmabuf.c
> +++ b/drivers/infiniband/core/umem_dmabuf.c
> @@ -142,6 +142,8 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
>  		goto out_release_dmabuf;
>  	}
>  
> +	umem_dmabuf->dmabuf = dmabuf;
> +
>  	umem = &umem_dmabuf->umem;
>  	umem->ibdev = device;
>  	umem->length = size;
> @@ -152,6 +154,24 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
>  	if (!ib_umem_num_pages(umem))
>  		goto out_free_umem;
>  
> +	/* Software RDMA drivers has not dma device. Just get dmabuf from fd */
> +	if (!device->dma_device) {

I understand your intent, but RXE cannot support dmabuf, as dmabuf
requires a real DMA‑capable device to be attached. In addition, it is
unclear how you expect PCI peer‑to‑peer operations to work when one
side (RXE) is not a PCI device at all.

Thanks
