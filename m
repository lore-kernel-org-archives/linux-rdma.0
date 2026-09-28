Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550CD3CC314;
	Mon, 28 Sep 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621951; cv=none; b=he/ZA1yNnuXLtidLBc0L90yaXzdXHwxdnytCsSSi0i/IrUFNqkaEt5j9792L59j/4zKPSzXF6pnSNUd16krlRKDSsKIWz5MrnjcNPL9EohHqfBEpLd3HqedZemlI6KRI2Ii7q1j47CHOgOW56hQQbnmvmqUekrETaIDOY/AM/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621951; c=relaxed/simple;
	bh=LvB933l55IQfftnhd+z9m9eNi/Cnlx4yAFNX3fMNQ5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYhYAen2FpTjDLffSc6dtBRQc+YNgQJecINi+UAHbV5QhKvjP9rLIrE7tzFlgpXzTId9O/84y1Mtg4fQ2OeCwUKEmqqWmagfqiSvK5J21bVqc8Zf7r0yqaI15xJe4W810vK2px2nwa+B6VAtpfXOFXv1uTHWIIhLefdUbJjChuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0uQY/Eq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0uQY/Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F6D1F000FF;
	Mon, 28 Sep 2026 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790621948;
	bh=p62+ZVd3pTPxwhD2ZetVB8FE7G2cP+N6LpnoaT6IVMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f0uQY/Eq5Q+nvn1LjusiKtFxi0QAA0lH6r1owfHuj50pgN0u2tGf6obB5GF25YKc6
	 w2zaDMGw+Qg5OzFmokdBXhb5oo/cDR1ApUCdzzswTRMrJwVV46yYtk3ABATDOCZJHv
	 o9WoPOnc3b7Xt7oFjZVyVReppaiJ4wsNNkCe4uQGSJxGpQbFZFw+5H/TLaVdqcciaq
	 28S1P443A95sIPZVm6DstRdNtNdCH3AfKZoTazJi0171Vmk2CmNFSiAmCIbupPUqSB
	 8bbH7HYKATjzipscJHU2uqfe1g2QR4OTXujYu1Wa7HRgQ3BnTkbWkIntgC2SpagWJZ
	 YkrLPBbPRpi8Q==
Date: Mon, 28 Sep 2026 21:59:03 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Michael Guralnik <michaelgur@nvidia.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Wait for in-flight page faults on implicit MR
 null_mkey dereg
Message-ID: <20260928185903.GA563127@unreal>
References: <20260920090613.2186-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920090613.2186-1-lirongqing@baidu.com>

On Sun, Sep 20, 2026 at 05:06:13PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> An implicit ODP MR (imr) publishes two mkeys into dev->odp_mkeys: the
> main imr->mmkey and imr->null_mmkey (MLX5_MKEY_NULL). Both are stored via
> mlx5r_store_odp_mkey(), which initialises their usecount to 1, and
> find_odp_mkey() takes a reference on whichever mkey it finds for the
> duration of a page fault.
> 
> __mlx5_ib_dereg_mr() erases and waits on the *main* mmkey usecount only.
> For the null_mmkey, mlx5_ib_free_odp_mr() merely xa_erase()s it from
> odp_mkeys and calls mlx5_core_destroy_mkey() -- it never waits for an
> in-flight memory-scheme page fault (MLX5_MKEY_NULL) that holds a
> reference on null_mmkey. After xa_erase(), find_odp_mkey() stops
> returning the null_mmkey, but a fault already past the lookup still
> holds a reference and dereferences the imr (via container_of and
> pagefault_mr) after __mlx5_ib_dereg_mr() proceeds to kfree(mr).

I'm not sure that your scenario is real. Null mkey is special case to
allow split of large address space faults to smaller chunks.

Thanks

> 
> Mirror the main-mmkey handling: after xa_erase() of null_mmkey, call
> mlx5r_deref_wait_odp_mkey() to drop the reference taken at store time
> and wait for any in-flight fault to finish before destroying the mkey
> and freeing the imr.
> 
> Fixes: 6f2487bfafce ("RDMA/mlx5: Add implicit MR handling to ODP memory scheme")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/hw/mlx5/odp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> index b861861..f27ca77 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -683,6 +683,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>  		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
>  			 mlx5_base_mkey(mr->null_mmkey.key));
>  
> +		mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);
> +
>  		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
>  				       mr->null_mmkey.key);
>  	}
> -- 
> 2.9.4
> 
