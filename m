Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F464A92F9;
	Mon, 28 Sep 2026 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595251; cv=none; b=hxQw2dv5WWv0MBpPGGPrzUx8MAiL8TJiPOucW06Px/GpaMChn53SVvVdOL3hj/T4ezBNIKz3ANA1C8h4jAy+EIFsGZ7WLAebbNibsykxs/RMvFkd9KJoox4mD+M9MDqHePqtt138xU7lHtXV0wTF69juEL8a5KgscQ7C6A0zE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595251; c=relaxed/simple;
	bh=+IegY64XpdMZVSyA9YQBbIWrrtRTZN+9FgicvoQErjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V22SLFWgexmG71/SHN2Gmmt4hez3NMgfG/ymREpnzhCOhalAbmbH1w9HqfMevYX6owtmb15KFtjQGWdwDYrNaS3tmJL/6Xlvyrt7siIaX3Qh9TiYdfg1wugE8HLY5o7ULSmufucdYlypvH/c7frtXEeP7Bbd9iGgctFbUBG6NN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAyjXBCe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAyjXBCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0325E1F00893;
	Mon, 28 Sep 2026 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790595249;
	bh=j2jCvKGAx9jgZksh/pxpKtOfPI/fTDRJxGFahiqz9TY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mAyjXBCefs3xlsZJHVdf1RyouVfAMcB38iAZoWARckoyykA6XfYDpgI5FTVYT1HBj
	 oXsZ8UAypbyaQCRx+GnKwvIn8a71NuPudzeBROJsEGYXjskx7CG3xNEDkqDj/ehGK0
	 sZWXdYsXYh6wEDhxliotFSzEvyUMAUj1vrpEDsj8CoLV5eNKpyPOc93F6Je56nW0e7
	 KjCdfagUEarKaqOZwbseoIiVUxUp/NPJU+PzSKzn/o9pADVzs+sBQzerMiMY7hr/tK
	 j5X/rvudDhDZdPnfaypDRh0ORBH6GzjCw6PikdkRbhBQeE4pP3Fx2VVZ0Y1HBA8mqP
	 XfQ9CupGjYNjA==
Date: Mon, 28 Sep 2026 14:34:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Tariq Toukan <tariqt@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH mlx5-next 10/10] mlx5: Move data direct implementation to
 mlx5_core
Message-ID: <20260928113405.GU563127@unreal>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-11-tariqt@nvidia.com>
 <20260918111634.4B8BD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918111634.4B8BD1F00893@smtp.kernel.org>

On Fri, Sep 18, 2026 at 11:16:33AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mlx5: fatal device probe failure on optional data direct init error
> --
> 
> commit 99d3c5a833c6ca3bd3a1b016b15bbb8a8b597a79
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> mlx5: Move data direct implementation to mlx5_core
> 
> This commit moves the data direct implementation from mlx5_ib to mlx5_core
> so it can be used by netdev devices. The data direct initialization is moved
> to mlx5_load() and resource creation is managed by the core driver.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> > rename from drivers/infiniband/hw/mlx5/data_direct.c
> > rename to drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> > index 3878c4aebb2c6..67717110feab0 100644
> > --- a/drivers/infiniband/hw/mlx5/data_direct.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
> 
> [ ... ]
> 
> > -	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
> > +	err = mlx5_data_direct_query_vuid(mdev, reg->vuid);
> >  	if (err) {
> > -		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=%d\n",
> > -			     err);
> > +		mlx5_core_warn(mdev,
> > +			       "Failed to query VUID, disabling data direct, err=%d\n",
> > +			       err);
> >  		kfree(reg);
> > -		return err;
> > +		return -EINVAL;
> >  	}
> 
> [Severity: High]
> In mlx5_data_direct_init(), does this code inadvertently cause a fatal probe
> failure? The warning claims the optional feature is being disabled, but
> returning -EINVAL bubbles up and aborts the entire core driver probe. If the
> intent is to gracefully disable the feature when the VUID query fails,
> shouldn't it return 0 instead?

There is a need to update the comment, the failure to enable data direct
is fatal, as we are enabling based on FW capability for very specific
devices which support data-direct mode.

> 
> [ ... ]
> 
> > -int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
> > +int mlx5_data_direct_register(struct mlx5_core_dev *mdev,
> >  			      struct notifier_block *nb)
> >  {
> >  	struct mlx5_data_direct_registration *reg;
> >  
> > -	if (!mlx5_data_direct_supported(ibdev->mdev))
> > +	if (!mlx5_data_direct_supported(mdev))
> >  		return 0;
> >  
> > -	reg = container_of(ibdev->data_direct,
> > -			    struct mlx5_data_direct_registration, dd);
> > +	reg = container_of(mdev->data_direct,
> > +			   struct mlx5_data_direct_registration, dd);
> 
> [Severity: High]
> If mlx5_data_direct_init() is modified to return 0 on failure to allow
> graceful degradation, will this code in mlx5_data_direct_register() trigger
> a NULL pointer dereference?
> 
> It appears mlx5_data_direct_supported() only checks hardware capabilities,
> blindly assuming mdev->data_direct is allocated. Should
> mlx5_data_direct_supported() also check if mdev->data_direct is valid, or
> should there be an explicit check here?

No, if capabilities exist, we should or enable direct mode or fail
driver probe.

> 
> [ ... ]
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 643b4aac20336..34f0375b68513 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> 
> [ ... ]
> 
> > @@ -1339,8 +1340,14 @@ static int mlx5_load(struct mlx5_core_dev *dev)
> >  	if (err)
> >  		goto err_traps_reg;
> >  
> > +	err = mlx5_data_direct_init(dev);
> > +	if (err)
> > +		goto err_data_direct;
> > +
> >  	return 0;
> 
> [Severity: High]
> Does propagating the error from mlx5_data_direct_init() here in mlx5_load()
> unintentionally disable the entire NIC (both Ethernet and IB) when the
> optional data direct initialization fails?

Same, thanks

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260917111422.4054862-1-tariqt@nvidia.com?part=10
> 
