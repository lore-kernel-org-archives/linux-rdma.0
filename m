Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF0299929
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438433; cv=none; b=kB8eErHlrXNY8/RaDfxaa0yN0ggxu6fxOztR/OBLnSbmH7GnTxsxtx58WwHus2XOgCN2yyH0LDE3KvREFquyouhKfrlY83YZGr9oyJVk2fo5D+R5iQQ7EfNZ5doA/VRRJI3KPJnsdRhAl1av1yyavO2LjDTRFZEYw04jeRyGQb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438433; c=relaxed/simple;
	bh=Oxi9M9WIAPNUTBUO7azXc2qlMNdidYUbADdfUbmOkDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s09c5+Fi4YFui6IM2uANjQ/RsIIxxjfKOe20GD5vGmUv73Byxxhb7Vtgk4SgkiFxWlIlwuotM3QoRtC18tGnKSHQhFTguYamsL8BNjFhwqrKFTzHUhEeFMmAsnglwjuq2Ng8ciuM1bIq8Ue2psGWrR7kOM+O+N2ZtDqbuYeLAJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wgRhgWdB; arc=none smtp.client-ip=91.218.175.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wgRhgWdB"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Oxi9M9WIAPNUTBUO7azXc2qlMNdidYUbADdfUbmOkDU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791438429; v=1; x=1792043229;
 b=wgRhgWdB/f+satF80/R21WU8Ji31U9YZDFl3rdY91bcAowK5CgF7P2etgBFXaY71F7tUrt9D
 8E1u2nNPYW+hyUaD5I6GmnhlGk1wfTKdYNYqx5WZsCZOuVHP4gvJrJ3F8fnsdtGyq1+n1XMQiN7
 tovEytfgHME2zbZHovm2EZuM=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 46a23afb19c5ec56;
	Thu, 08 Oct 2026 05:47:08 +0000
X-Mizu-Trace-ID: 46a23afb19c5ec56
X-Migadu-Flow: FLOW_OUT
Date: Thu, 8 Oct 2026 13:47:33 +0800
From: Chenguang Zhao <chenguang.zhao@linux.dev>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@mellanox.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel deferred page-fault EQ work
 before teardown
Message-ID: <20261008054733.GA256585@pc>
References: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>

On Thu, Oct 08, 2026 at 12:42:11AM +0100, Prathamesh Deshpande wrote:
> Page-fault EQ work can remain queued after the notifier is disabled.
> Destroying the EQ before cancelling that work can let the worker access
> freed EQ memory.
> 
> Cancel the deferred work before destroying the EQ.
> 
> Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA")
> Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/odp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> index b8618610737a..1f28c30095dc 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -1885,8 +1885,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
>  	if (!eq->core)
>  		return 0;
>  	mlx5_eq_disable(dev->mdev, eq->core, &eq->irq_nb);
> -	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
>  	cancel_work_sync(&eq->work);
> +	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
>  	destroy_workqueue(eq->wq);
>  	mempool_destroy(eq->pool);
>  
> -- 
> 2.43.0
> 

Looks correct. 

Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
