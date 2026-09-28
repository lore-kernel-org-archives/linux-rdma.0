Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0184AB1B7;
	Mon, 28 Sep 2026 11:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595585; cv=none; b=tRaiONMX20VQk9jcJj6K2Cj+/uNjcZU4BXPdt5vHuYHF5g063UhP3Y3/zC3xZWz7Eu/YLR+h0SXrCm8kbSjnfBxADaSOV7h6W6L0N+9ktdKpZ4ylnIWVWYV4opFDBkK9fqh8T8L2Ba/KjcraCdnwZkknnVKYTVWa/FCjeKAhCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595585; c=relaxed/simple;
	bh=7ZF0BRjIJqX/KOidmX/OHiatMSen2enP8yQ9UUTUHbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXjZYsk/AHofm4ADeGC6+UWuyPCvF03X2xXf6Iqn3XtbIIfZNZDwJFStpBwmoVa48T5AvKad4fQmlIiwwQk6eMM5YWObcEPep5pvKWp6g8umb6K+k3yeH7jraB6PhaaZZ4mRjFpBtNpiZj7nMr9wJaIPxoGYcNcvQ7P5aaUbubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hv2bvoAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hv2bvoAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106881F00898;
	Mon, 28 Sep 2026 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790595583;
	bh=tuxpGOBlXPQdQzzdNYHCp3UbEPW4mCQ2s4Nd1YplerY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hv2bvoAwpPdBq7HSkr12h515+KozETs72ljAzreAcwskWTuj0/7BcON1cpAr6r5R2
	 l94tBWYuvrUeOn2ga6t4SgJodnFpL9UTFHsYrv1xNCnzt/g3UcK72YvAkbmZZGgaKW
	 BAYMAvyauaPO8JGMnKP+oXEnobmTD/OCvwKvrPKKBZ9KdDgEggmv8Ek9Rg7HVXK4ZO
	 OmdhmNy07k1pFdB8N3/S5cZnjQCutaHmawHqkMbt2hRcG2NJa/u3jvD6mRlmikVEui
	 mJJV5J/YhFUdHXAmoAE/lS46ek59jbIZ1/mUOxCt7GMwkBDEK78jIbov3E8kOFCAv/
	 pNN+meeiILBOQ==
Date: Mon, 28 Sep 2026 14:39:40 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Tariq Toukan <tariqt@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH mlx5-next 07/10] RDMA/mlx5: Extract IB specific lock out
 of data direct
Message-ID: <20260928113940.GV563127@unreal>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-8-tariqt@nvidia.com>
 <20260918111632.4415C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918111632.4415C1F000FF@smtp.kernel.org>

On Fri, Sep 18, 2026 at 11:16:31AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] core: missing smp_store_release() in lockless pointer publication
> --
> 
> commit 70f41e46e61426ca24948348bb11ea96b2dc863f
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> RDMA/mlx5: Extract IB specific lock out of data direct
> 
> The data_direct_lock from struct mlx5_ib_dev is an IB specific lock.
> It protects from unbind while mlx5_data_direct_dev is being accessed.
> So move data_direct_lock out of the generic bind/unbind functions
> and into the IB specific notifier callback.
> 
> > diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
> > index f871e3ce9f73d..16afacdd36018 100644
> > --- a/drivers/infiniband/hw/mlx5/data_direct.c
> > +++ b/drivers/infiniband/hw/mlx5/data_direct.c
> > @@ -197,9 +197,7 @@ mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
> >  static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
> >  				  struct mlx5_data_direct_dev *dev)
> >  {
> > -	mutex_lock(&ibdev->data_direct_lock);
> > -	ibdev->data_direct_dev = dev;
> > -	mutex_unlock(&ibdev->data_direct_lock);
> > +	WRITE_ONCE(ibdev->data_direct_dev, dev);
> 
> [Severity: High]
> Is a release barrier needed here?
> 
> By removing the shared lock, this becomes a lockless publication.
> mutex_lock() only provides ACQUIRE semantics, so the writer lacks a RELEASE
> barrier like smp_store_release().
> 
> Could weakly-ordered CPUs reorder the initialization of dev to become
> visible after the pointer publication?  This might allow a concurrent
> lockless reader to observe the newly assigned pointer but read uninitialized
> structure fields (e.g., dev->pdev being NULL), leading to a kernel panic
> when dereferenced.
> 
> [ ... ]
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> > index e6b74955d95dc..1fc61a680f8af 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -997,7 +997,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
> >  		return ERR_PTR(-EOPNOTSUPP);
> >  
> >  	mutex_lock(&dev->data_direct_lock);
> > -	data_direct_dev = dev->data_direct_dev;
> > +	data_direct_dev = READ_ONCE(dev->data_direct_dev);
> 
> [Severity: High]
> Is an acquire barrier like smp_load_acquire() needed here instead of
> READ_ONCE()?
> 
> Since the reader in reg_user_mr_dmabuf_by_data_direct() takes a different
> lock (dev->data_direct_lock) than the writer (which takes
> mlx5_data_direct_mutex), it loads the pointer locklessly with respect to the
> writer.
> 
> Could an unprivileged userspace issuing an RDMA memory registration
> concurrently with a data direct device hotplug or bind observe uninitialized
> memory fields because of this missing barrier?

At least for bind, no. The ibdev device shouldn't be operable at that
stage yet.

Thanks

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260917111422.4054862-1-tariqt@nvidia.com?part=7
> 
