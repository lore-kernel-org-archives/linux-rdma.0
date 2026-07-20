Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CE424661;
	Mon, 20 Jul 2026 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784552532; cv=none; b=OmpXZ5ohGpRtF6WajiYTehmSmQjiGaHz7FDYfULTB+URARGEUnUH/U9jqhFYVJNM/IuNzW2i82ybQrA9Ixs9aIPNM515epl4OEM5+wmp0wpSgh0exn4euWpnZ/iduXDRnn3saX/nrPUu5vddoV9nXDoIhfXaO+bnIS5YifK0FHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784552532; c=relaxed/simple;
	bh=yTFfzMxTYmlMARn+mVjJmwJKhkszOsE5KYzfbPaQt9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjhZNkSzd8cVduxQIpSMUm3maq8YT+kxtIRWJHZWG5pzol9S1GZ0PNY5PeusCmWKIFmgUJzGBJNW1wt3LsWZmzNh1XLIEt/Wy/weuAJVmg16Wqx/1kh/OHUVTxTLFrDCzmMNwfMhr+igvC0eadGaLyv3JZhOC351bQeSsjl82Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgyQAPe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgyQAPe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402DD1F00A3A;
	Mon, 20 Jul 2026 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784552524;
	bh=bXeSjo7031KQonRaAjWYtxb6FfEUGZRus8Cl97dsp3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UgyQAPe1+oHCj4U93jAQO/4pppblUIZmjj9IbLWZEJQGkX/Hf98oBdwz44HtOYswM
	 COzamfP9FBSVhFbtlukf+VTOM1FqJMk5aX4/Te9zQhdUnm1yiTlBzbdHwFFc6zLjgc
	 V0ml4rXeNRU1kCT1kps4e2Ct1i5EpcLM9zGsKUUG71AqdGTw49hupqotwjZ167C+hv
	 o4JgmNn8E+L5hiskO8f8NSKTjz2+3OMD73+AVCtcu7r2IrkejvUKW82NtmF+Cf0G3T
	 DAFalvLUwEAWyv3raWdbrP6he5lxnEs0M9HdaBEHLM5SjEIRWPLj8NaxuqGvWet7LC
	 ug1igEFhT+cXw==
Date: Mon, 20 Jul 2026 16:01:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/umem: Fix the ib_umem_dmabuf_get() prototype
Message-ID: <20260720130158.GF110966@unreal>
References: <f450b272eff7c0f0d3c1a5f08d27ebc042704f76.1784495762.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f450b272eff7c0f0d3c1a5f08d27ebc042704f76.1784495762.git.christophe.jaillet@wanadoo.fr>

On Sun, Jul 19, 2026 at 11:16:17PM +0200, Christophe JAILLET wrote:
> If CONFIG_INFINIBAND_USER_MEM is not defined, then the last parameter of
> ib_umem_dmabuf_get() is missing a const qualifier in order to match its
> prototype.
> 
> This is an issue since commit dcae56cfecc6 ("RDMA/mlx5: Constify struct
> ib_frmr_pool_ops and dma_buf_attach_ops") because now a "const struct
> dma_buf_attach_ops *o" can really be passed to the function.
> 
> Fixes: dcae56cfecc6 ("RDMA/mlx5: Constify struct ib_frmr_pool_ops and dma_buf_attach_ops")

I squashed that fix to the problematic commit.

Thanks

> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  include/rdma/ib_umem.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index 31b3a86fe73a..1fe87fd1d769 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -250,7 +250,7 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
>  					  unsigned long offset,
>  					  size_t size, int fd,
>  					  int access,
> -					  struct dma_buf_attach_ops *ops)
> +					  const struct dma_buf_attach_ops *ops)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> -- 
> 2.55.0
> 
