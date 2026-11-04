Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786873;
	b=KYXJYJL3i+I80SK7jcreb6ZLfc40Il7GWYYeORlGkSpqHG5zJb4JLwLGMD9AWAseQU0k
	 4t6S1bQrOZae083FWNk+Ed27S5WuDRW0ti5haFc4scjvp/CaSfYr7OYe9il6TKRHtcweN
	 72rvOWlzCyJR0X+VP6+LvM3oMp57JqWL7xW61xRwP3Uo9zIr7dWg5W4Z1+YRicO9jTyVt
	 49kpnJWicpzyWfpT9zKwIl4EL73b1jaoZhzqNSAhEAxRUQNSnU5VikCGZzNXkbAVfUXh7
	 vCLrVi7MDoaaEAU0bODA+0o1+a8v06J7njivD36RJ7OYJmvVNhOyBfCF/8k24bk0tpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786873;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9hueydKPHbwqRHr29tjXZcE3MJ9mKdeb8gNayc7RByM=;
	b=d6pQwLyibv4+dO6n+LtCm2oN2TSy2jyT4pR3gEWBcjeimLg2Yy2Hj+34yjmB/PzO+m3Q
	 gyV+IslA5mBWzhoSzMxSEs024B3xqBnMbYm9KzX68cUjIsJy3XDsfOXbbNUCbLIAfEJoL
	 vEPv8TiALOAtg4t6TIRaq2Bjxf6miNuMi23w5erWEXsqc+XjcSvVYDDZ1giX/QWsUIzN+
	 uRIAYt3HSI1w9pqr6qtwTKbg5JZFBu2fIa2IO3CfjBxizxQoftQiTcf7Mmgda1Puhq3+a
	 dwdXC6go6wBfwxAv/iuDtmBNThwNYosnzziEsvcEzSvYRoM+pPUtO/8ROzhIMe+l58A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3nlOY1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EABB606A326;
	Wed,  4 Nov 2026 10:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3nlOY1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6E11F00919;
	Wed,  4 Nov 2026 10:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786871;
	bh=9hueydKPHbwqRHr29tjXZcE3MJ9mKdeb8gNayc7RByM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o3nlOY1Qhr6Bk6bjbuvjzB1VBZMnZo43ALULab1PPD2ywwLWmblgaREyNW770dp86
	 oVEFIfskshqiU6I2sDYsCkn5Kh0pZ+uA43xqXaCnIetBcahxXCfzu1hEu64HIe4oKW
	 7IaJxxvHd0VkSHdIeabQYZAfmuTh2yxVTQezyuwxPyupwkFX/t+I/6Z1NKoBnnn7Nq
	 em4KWN3srnOWFwPKpO1cUh+pP1AncQwN9bzS52P+wOREFruti5UpYVSRLTCMIsf0Yt
	 yGc1QrHAjwpMEGKK43m5g+Q+Fw49ciBm7bt6S5WkyF4mbPQfR/Z/jhQVYbdSDcfFWg
	 6HUqJIGQc1JfA==
Date: Wed, 4 Nov 2026 12:07:47 +0200
From: Leon Romanovsky <leon@kernel.org>
To: 0z5a <dezhen.lu@student.uni-tuebingen.de>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Message-ID: <20261104100747.GD478286@unreal>
References: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>
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
In-Reply-To: <20261103142804.67210-1-dezhen.lu@student.uni-tuebingen.de>

On Tue, Nov 03, 2026 at 03:28:04PM +0100, 0z5a wrote:
> From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
> 
> devx_umem_find_best_pgsize() computes the page size in an unsigned long
> but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
> in an unsigned int. When the DMA mapping of the umem is contiguous and
> aligned to 4 GiB or more, and the umem length is a multiple of that
> size, ib_umem_find_best_pgoff() selects a page size >= 2^32. Since the
> value is a power of two, the truncation turns it into 0 and the
> registration fails with -EINVAL.
> 
> The umem log_page_size field is 5 bits wide on top of
> MLX5_ADAPTER_PAGE_SHIFT, so the command can encode these page sizes.
> 
> Seen on two GH200 nodes (ConnectX-7, firmware 32.38.3056 and
> 32.43.1014) with a dma-buf exported from cudaMalloc memory: registering
> 4 GiB or 8 GiB umems at 4 GiB-aligned offsets of the dma-buf fails with
> EINVAL every time, while 2 GiB umems at the same offsets and
> ibv_reg_dmabuf_mr() of the same ranges succeed. Restricting the user
> pgsz_bitmap to <= 2 GiB makes all of them succeed.
> 
> Other large physically contiguous buffers, such as a 16 GiB hugetlb
> page on an arm64 kernel with 64K base pages, should hit the same path.
> 
> Use unsigned long for the page size, as commit f0c2427412b4
> ("RDMA/mlx5: Fix page_size variable overflow") already did for the MR
> paths.
> 
> The bug was found by an AI coding assistant (Claude Opus 5.5, Anthropic)
> during an audit of 32-bit truncations of page sizes and offsets in
> drivers/infiniband/core and drivers/infiniband/hw/mlx5. The assistant
> also wrote the reproducer and this patch. The reproducer was run on the
> GH200 nodes described above.
> 
> Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
> ---
> 
> Notes:
>     Testing notes:
>     - The failures above were reproduced with the DOCA-OFED 26.01 mlx5_ib,
>       whose devx_umem_find_best_pgsize() is identical to upstream; I do not
>       have root on these hosts, so I could not load a patched module.
>     - So I have not verified that CREATE_UMEM accepts log_page_size values
>       for pages >= 4 GiB. If it does not, capping pgsz_bitmap at 2^31 in
>       devx_umem_find_best_pgsize() is the alternative fix.
>     - Compile-tested on v7.4-rc1 (arm64 defconfig + MLX5_INFINIBAND, W=1).
>     - A standalone reproducer (dma-buf from cuMemGetHandleForAddressRange()
>       plus mlx5dv_devx_umem_reg_ex(), sweeping offsets) is available on
>       request.


Isn't this fix enough?
https://patch.msgid.link/r/1-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
15fe76e23615 ("RDMA/umem: Fix truncation for block sizes >= 4G")

Thanks

> 
>  drivers/infiniband/hw/mlx5/devx.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index fc6f793dc..2277160d9 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -2294,8 +2294,8 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
>  	return 0;
>  }
>  
> -static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
> -					       unsigned long pgsz_bitmap)
> +static unsigned long devx_umem_find_best_pgsize(struct ib_umem *umem,
> +						unsigned long pgsz_bitmap)
>  {
>  	unsigned long page_size;
>  
> @@ -2333,7 +2333,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
>  				   int access)
>  {
>  	unsigned long pgsz_bitmap;
> -	unsigned int page_size;
> +	unsigned long page_size;
>  	__be64 *mtt;
>  	void *umem;
>  	int ret;
> -- 
> 2.43.0
> 
