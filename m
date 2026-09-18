Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5634E80B8
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730195; cv=none; b=jRGbV4Lyt0H8mYM/xRxi7j1wGginiCsKM3T9Bq3CAAQlA6E5yHwrHjiuo9KfKYYZ1e/ZE9T+e1L6+5XmTCnjlOZXoZ9uVKqEP+FVZBwA6umC577cc2A0r5KneVMp1zGakaIzmJPOUei8vgBz8bN8YjEfJ9Ltf+WvMsTRF7GRUPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730195; c=relaxed/simple;
	bh=7nABvqveeSQsByCw1qj6ORFgMyg57HKzH/yiWeC5vZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mZdnyGZ/cecCZzZ1Yj3EbwcNlITDJnwMX0A9qGFF3owaRZAl7X7QIrpMLf7IULcmqCEdH3EeOKZwz+wDBwgFS2qgCc9JVE0cneZE5bLDDLDAct+fauz0n71ueUvZXKZ7ARa/a+3B5f2YbmGDgvK/+gYQFofuo4bSmk21vuq7fII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AWA2Dljn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AWA2Dljn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4415C1F000FF;
	Fri, 18 Sep 2026 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730192;
	bh=TfudhVKqkjmFrx+KmI1ROG9/UPhQ80UV+tRRUX/3YQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AWA2DljnIONf6Zgqwl41m23m+47LtG/1CkGLe85YM89JtsWJx0CYBu1S7yRRerdXQ
	 Ho0QfyvNu62iu2d0fIWjal5kQbkXtumAoQSz9LfMzSn34aM8Gtga71SJUq2IQoMKnM
	 +R3PAJGgXwB03OFfdqrcNVdLI31Oayx8Q/XUSyzk9TCQv38mFA5Qud7Lp6xjzRqjcF
	 r1UZXTz4R1Sway7ZthUm+N6D1ca7zhLyg2m+U58sPbHHHZ/nK11CVbnImcidMHhPL9
	 855mHiwJpHzAsw3aX1RUmkRP4T1KDEgg+u5WkVOGplEBhMWWwEB9/Dyy2oimcv2U8Y
	 zLEtxIWnSu43A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 07/10] RDMA/mlx5: Extract IB specific lock out
 of data direct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-8-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:31 +0000
Message-Id: <20260918111632.4415C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] core: missing smp_store_release() in lockless pointer publication
--

commit 70f41e46e61426ca24948348bb11ea96b2dc863f
Author: Dragos Tatulea <dtatulea@nvidia.com>

RDMA/mlx5: Extract IB specific lock out of data direct

The data_direct_lock from struct mlx5_ib_dev is an IB specific lock.
It protects from unbind while mlx5_data_direct_dev is being accessed.
So move data_direct_lock out of the generic bind/unbind functions
and into the IB specific notifier callback.

> diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniban=
d/hw/mlx5/data_direct.c
> index f871e3ce9f73d..16afacdd36018 100644
> --- a/drivers/infiniband/hw/mlx5/data_direct.c
> +++ b/drivers/infiniband/hw/mlx5/data_direct.c
> @@ -197,9 +197,7 @@ mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
>  static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
>  				  struct mlx5_data_direct_dev *dev)
>  {
> -	mutex_lock(&ibdev->data_direct_lock);
> -	ibdev->data_direct_dev =3D dev;
> -	mutex_unlock(&ibdev->data_direct_lock);
> +	WRITE_ONCE(ibdev->data_direct_dev, dev);

[Severity: High]
Is a release barrier needed here?

By removing the shared lock, this becomes a lockless publication.
mutex_lock() only provides ACQUIRE semantics, so the writer lacks a RELEASE
barrier like smp_store_release().

Could weakly-ordered CPUs reorder the initialization of dev to become
visible after the pointer publication?  This might allow a concurrent
lockless reader to observe the newly assigned pointer but read uninitialized
structure fields (e.g., dev->pdev being NULL), leading to a kernel panic
when dereferenced.

[ ... ]
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index e6b74955d95dc..1fc61a680f8af 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -997,7 +997,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u=
64 offset,
>  		return ERR_PTR(-EOPNOTSUPP);
> =20
>  	mutex_lock(&dev->data_direct_lock);
> -	data_direct_dev =3D dev->data_direct_dev;
> +	data_direct_dev =3D READ_ONCE(dev->data_direct_dev);

[Severity: High]
Is an acquire barrier like smp_load_acquire() needed here instead of
READ_ONCE()?

Since the reader in reg_user_mr_dmabuf_by_data_direct() takes a different
lock (dev->data_direct_lock) than the writer (which takes
mlx5_data_direct_mutex), it loads the pointer locklessly with respect to the
writer.

Could an unprivileged userspace issuing an RDMA memory registration
concurrently with a data direct device hotplug or bind observe uninitialized
memory fields because of this missing barrier?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D7
