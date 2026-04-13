Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE773CD8AB;
	Mon, 13 Apr 2026 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090619; cv=none; b=DgMxmkfXfNAaKR+XvaQ46OzDGBwyHWJAEgstDXlJWhPvkMXYVheN3DdiXfebRn9/vKo7RLpl8NYy8VL6Qg/ejHFK620HOsOoP5t2LFxDPIS0QM7nqWnGWUVw5Ylvj4Q2hKWbkqnDpiA9QDNWYskci99ZhKezDcyNRGQNrS++EtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090619; c=relaxed/simple;
	bh=wVyc4p5BmfcPo6mXW+i0uQbURUVCalHakg2O4vAcgjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iz0/81fo9ffExGZ5tY3PilhQ7Vpe5lABKIHmJNFy+gs04o8VUAY9ktv7f6nSFYXitFqJt37UgytQ6coiULC33YeGjwscrGJPCjqBibGgwQThlADyoZjmS5AV0dAZrB+837/Vw/dbkiGS8XhyLssxYMmWPhZVfgQDWyx3LrPB+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moIe5J/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moIe5J/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44AC2BCAF;
	Mon, 13 Apr 2026 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776090618;
	bh=wVyc4p5BmfcPo6mXW+i0uQbURUVCalHakg2O4vAcgjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=moIe5J/N1VyvpOz+TA9v44wlA8d1AOZdkX9MLS7ya4G65+U+wcqsu7oIUB0ctsEL2
	 GDre3iE8Z5+UtcN9nJg+Uf8KUDQBdkmwa6gsxhcXPEiueqlwCDirsDxsYS4s8cbq3G
	 yPan54p+dNiIkXmmESESOQcv5K3Vo0AzhlkTGO/cr4AlHQSSLycA+kuBHqBvSC4DPF
	 p0UiXIcMs1mRJL0u9Gilaw0jgEgpvr7bzoEuYF0gsAxASnEspdcHrOjnQEwopf8bDh
	 LgXcDRhs68neCVimJSgbBXWAbVPHcZG3TWY3q5hbzRYW39qOt6jSCY3vhBAWYqnN5o
	 piQqNrCOFH+NQ==
Date: Mon, 13 Apr 2026 17:30:12 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jack Morgenstein <jackm@dev.mellanox.co.il>,
	Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Fix refcount leak in add_port() error path
Message-ID: <20260413143012.GH21470@unreal>
References: <20260411091626.2141130-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260411091626.2141130-1-lgs201920130244@gmail.com>

On Sat, Apr 11, 2026 at 05:16:26PM +0800, Guangshuo Li wrote:
> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
> 
> In add_port(), if kobject_init_and_add() fails, the error path frees p
> directly instead of releasing the kobject reference with kobject_put().
> This may leave the reference count of the embedded struct kobject
> unbalanced, resulting in a refcount leak and potentially leading to a
> use-after-free.
> 
> Fix this by using kobject_put(&p->kobj) in the kobject_init_and_add()
> failure path.

The analysis is correct, the implementation is wrong.

> 
> Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/infiniband/hw/mlx4/sysfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
> index 88f534cf690e..15b36b9e4bd6 100644
> --- a/drivers/infiniband/hw/mlx4/sysfs.c
> +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> @@ -642,7 +642,7 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
>  				   kobject_get(dev->dev_ports_parent[slave]),
>  				   "%d", port_num);
>  	if (ret)
> -		goto err_alloc;
> +		goto err_kobj;
>  
>  	p->pkey_group.name  = "pkey_idx";
>  	p->pkey_group.attrs =
> @@ -689,6 +689,11 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
>  	kobject_put(dev->dev_ports_parent[slave]);
>  	kfree(p);

This needs to be changed to: “kobject_put(&p->kobj);”.

>  	return ret;
> +
> +err_kobj:
> +	kobject_put(&p->kobj);

I’m also wondering why we don’t call kobject_put() in the port deletion
path as well.

Thanks

> +	return ret;
> +
>  }
>  
>  static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
> -- 
> 2.43.0
> 
