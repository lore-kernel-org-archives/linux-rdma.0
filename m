Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E13845DC
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620713; cv=none; b=M8V7Bnk3r+IeRBHC4lfkXWjcGO5EcHdnoYGiTMEp2OXvKhbymPwswfXpty9fhYegqEybJI22FpWvi+75uZJA5VygiRgdzCV+RKoyhSm22UHr/yuH6gnah/v05PnmitbVh2QQBLHibbNX+sKyoKbvH7jfISkKgvOYIdQVbc8QxnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620713; c=relaxed/simple;
	bh=ltTYEL+AETAVvTXj5Zh1MfMXCYibrj8HPADX3beTh1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rv5NeWGPyVfYSvaACII0hO5HAofrJX92o+9BSPGUpbVE5DIjWbk2fkwUyMDIdsTo/HkbxzmkZqWCmf3Cju9ooGLnr54qWYW667ZE91rUXzeLjWwRGTvyW04PbPv175dXFyYvp2L67/qmNpBlPannsV3MFodcXbDIwrRY2PiRJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQSUxKO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQSUxKO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46BE1F000FF;
	Mon, 28 Sep 2026 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620709;
	bh=8nazsUQqgJBJGsBRmdTRMAlYzie7gJxW4KvRvFIf2IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OQSUxKO5i7w+kkax8J8FddFw6bUvBEDYXKsJJ4H/6hGPIgMLzof7LGpRdQVmZ2brM
	 WPWbUoO6I0Jrm2/pc5hkDpxO2wL750p9N9/uzu+rlehWE7w5/ozdwBrjUxY4sf3QWW
	 Eaz6xrBiehzLN5k+wmRskRwCfVS7KzmHa/Z72YWeEIZ1f/a9tbpBp80pjEsbMcNi/T
	 Bao/83kthPbOTIl4qi8mh1rFAtfiNg6v4jlNucsTILapqUD6USCR6rikUhY4A/LNtX
	 ulIqbVkJBZUP6xXv3pZqYz4u1N8m/U5cn7hx8HmxGys9lS6ToiSb8BdscPZVq+14Be
	 /In1hSL9ZX5fQ==
Date: Mon, 28 Sep 2026 21:38:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Check SIG_ERR CQE mkey lookup before
 dereferencing
Message-ID: <20260928183825.GZ563127@unreal>
References: <20260919100806.2320-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919100806.2320-1-lirongqing@baidu.com>

On Sat, Sep 19, 2026 at 06:08:06PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> In mlx5_poll_one, a MLX5_CQE_SIG_ERR completion looks up the signature
> context in dev->sig_mrs via xa_load() but dereferences the result without
> a NULL check. If the corresponding MR has been concurrently deregistered

Is this real scenario? Integrity MRs are in-kernel MRs, they shouldn't
be concurrently deregistered.

Thanks

> (which removes the xarray entry without holding the CQ lock), xa_load()
> returns NULL and the subsequent get_sig_err_item(sig_err_cqe, &sig->err_item)
> crashes in atomic context under xa_lock.
> 
> Add a NULL check that drops the lock, logs a warning, and repolls.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 49b4bf1..b0b1177 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -563,6 +563,13 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  		xa_lock(&dev->sig_mrs);
>  		sig = xa_load(&dev->sig_mrs,
>  				mlx5_base_mkey(be32_to_cpu(sig_err_cqe->mkey)));
> +		if (!sig) {
> +			xa_unlock(&dev->sig_mrs);
> +			mlx5_ib_warn(dev, "CQN: 0x%x Got SIGERR on unknown mkey: 0x%x\n",
> +				     cq->mcq.cqn,
> +				     be32_to_cpu(sig_err_cqe->mkey));
> +			goto repoll;
> +		}
>  		get_sig_err_item(sig_err_cqe, &sig->err_item);
>  		sig->sig_err_exists = true;
>  		sig->sigerr_count++;
> -- 
> 2.9.4
> 
