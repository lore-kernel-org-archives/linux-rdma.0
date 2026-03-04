Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCA926ED3E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Mar 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772635603; cv=none; b=Q9TvAS4qQOLAY/hdpSySUfbcRxHySkPIY8uYGBxMA+vILgBAh5kcwG1uvhJ3qfh20bc6CiJmtWms24AWHrRxO3lon78YgOGji7eiTlsXpWHpdYl3itoMRktDgpzcIUrmNAQS7L7aYCL/Lh2K2UbG/2FP7r12v5cjwj++nC1XA9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772635603; c=relaxed/simple;
	bh=2+kl/26e0Dino/V4LhaL8qkWfVtwox03dFF0L8CNxKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJHgA+p8Qup7iumGrIgrXhh7MUFJEEO9AvyC5n0Dnk3hwtXsqXtBwBC65qzTpmEZhcDWxsjWp7QoZKxEIWrPeONOCHIhfrnbkR2uylg9Pgr0MSrymEIkgPUJ8axp0P34pBHhJkwPj/xoGKkuvxp5GglDQ5CzRQcJSuoYB9l6hQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=seI7T2kZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="seI7T2kZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A61C4CEF7;
	Wed,  4 Mar 2026 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772635602;
	bh=2+kl/26e0Dino/V4LhaL8qkWfVtwox03dFF0L8CNxKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=seI7T2kZzzoNrQyDrMxrTYMwpYBcuXMRlXzi9HywSFbWCrlljy97FVfsOmpWcjb66
	 7w3H+0c7QUE6g+1+p5pRr00QZ19i2GzUg6o9eyEGj4lBRqgyfEhkO2fHqe418W0byz
	 72lm6MUyMQb+3JcrtYFV8lQg4jLGlQubT9KxW/qTv4TKjpIj3dg+KwqZ2GQiqCCde6
	 4B8R7TADvk99hDozh22AIWkjzGVXIm23O4T2BfFztyEfVaYAfrVmFKx7w4iQjMHklK
	 TXdkOTBDB23rlQLyimOntBM/KLDO5IqrAEXRi6RJOPc5VlDfHsmHnfgyxL22dQ5IY/
	 gobrbtijcpesQ==
Date: Wed, 4 Mar 2026 16:46:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, krzysztof.czurylo@intel.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v2 3/5] RDMA/umem: Add pinned revocable dmabuf
 import interface
Message-ID: <20260304144638.GC12611@unreal>
References: <20260302001539.2275303-1-jmoroni@google.com>
 <20260302001539.2275303-4-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302001539.2275303-4-jmoroni@google.com>

On Mon, Mar 02, 2026 at 12:15:37AM +0000, Jacob Moroni wrote:
> Added an interface for importing a pinned but revocable dmabuf.
> This interface can be used by drivers that are capable of revocation
> so that they can import dmabufs from exporters that may require it,
> such as VFIO.
> 
> This interface implements a two step process, where drivers will first
> call ib_umem_dmabuf_get_pinned_revocable_and_lock() which will pin and
> map the dmabuf (and provide a functional move_notify/invalidate_mappings
> callback), but will return with the lock still held so that the
> driver can then populate the callback via
> ib_umem_dmabuf_set_revoke_locked() without races from concurrent
> revocations. This scheme also allows for easier integration with drivers
> that may not have actually allocated their internal MR objects at the time
> of the get_pinned_revocable* call.
> 
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  drivers/infiniband/core/umem_dmabuf.c | 61 +++++++++++++++++++++++++++
>  include/rdma/ib_umem.h                | 20 +++++++++
>  2 files changed, 81 insertions(+)

<...>

> +void ib_umem_dmabuf_set_revoke_locked(struct ib_umem_dmabuf *umem_dmabuf,
> +				      void (*revoke)(void *priv), void *priv)
> +{
> +	dma_resv_assert_held(umem_dmabuf->attach->dmabuf->resv);
> +
> +	umem_dmabuf->pinned_revoke = revoke;
> +	umem_dmabuf->pinned_revoke_priv = priv;

I don't think that you need special priv, you can use umem_dmabuf->private instead.
See reg_user_mr_dmabuf():
 1680         umem_dmabuf->private = mr;

Everything else looks reasonable to me.

Thanks
