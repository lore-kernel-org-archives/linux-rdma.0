Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ED33F12C6
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 09:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789896117; cv=none; b=Bs+gk12igOGOKUkOuoIPkrD2KldrGPdBbf1ckpdHDxT+MoylGv8RKBGmuE7THUKUHPFS4ofhGk/3BHRAkUYrUtkuOp/Gy8YfG+XqMXYrgg4zJBjevBLljK9vynbp62i/SCtLxKnpB/EibZZCDm+2wmweJd6uG2HQvbeUzAv69dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789896117; c=relaxed/simple;
	bh=w8dFdEkHd0B9ZZhQCAZ3A9pGtmtlzTSaUBnRpBUr1+0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p+0hQ47UX2JPGdI+G5WK4vB5DmZphrTwTwW9K4iFn/RftPCDBqmUr6nBuLJuX76fVdX8m4aB1nV589CRBZ/xphnFSF/2CXaxBgDpFSrEt04DSdMZU+LaU2JoebV67Q5TZiZcPwzahS/T2K6r7jlGvn6GZFWD76jEfc/Hn0WClQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MscDkd8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MscDkd8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946EF1F000FF;
	Sun, 20 Sep 2026 09:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789896115;
	bh=guGo7QDxxiw43H5liM9tUIUuuZy7UGBFZK8evsTszkE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MscDkd8d9aCIrcoYZ6Qkf7BxOTTEzi8K7pgtT6z1BHlxn7Nk+AlnxuSRq/WhdxoDZ
	 Bl7EMQ4ZG1gRyMLGAqItVZawJUlmA5MOvaMpkZqdKl7dajc7ksL57+4Z/eBn0vETvu
	 fAK2mUjHBD/DMEW0YyY/HITsMdgnO/iK1SJFr5N9FoRUI087tGnJ4I+lL9ch6f8R9Y
	 Pk0tamX9ClDwAk6FIvO8PoR8jU3m6hqvJVau7KD3PG9gHKK8chelcPh/hPwxVIAj73
	 COJ5Pjx6OdkvDOBpyZ0WpwdqsiVg8WASVCIRi7KTA0OrsScbvBqRRCe2kqcREJXS5t
	 /F3Si9AU41iRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Wait for in-flight page faults on implicit
 MR null_mkey dereg
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260920090613.2186-1-lirongqing@baidu.com>
References: <20260920090613.2186-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 09:21:55 +0000
Message-Id: <20260920092155.946EF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] rdma: kernel panic due to uninitialized waitqueue in mlx5_ib_f=
ree_odp_mr
--

commit 86e92de47c6446ff41d57038760ffc2bf8a38827
Author: Li RongQing <lirongqing@baidu.com>

RDMA/mlx5: Wait for in-flight page faults on implicit MR null_mkey dereg

An implicit ODP MR (imr) publishes two mkeys into dev->odp_mkeys: the
main imr->mmkey and imr->null_mmkey (MLX5_MKEY_NULL). This commit ensures
the handling of null_mmkey mirrors the main-mmkey handling by waiting
for any in-flight fault to finish before destroying the mkey.

> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx=
5/odp.c
> index 8dcbb0e5ccd7c..286d61b582e4d 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -683,6 +683,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>  		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
>  			 mlx5_base_mkey(mr->null_mmkey.key));
> =20
> +		mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);

[Severity: Critical]
Will this crash with a NULL pointer dereference when wait queue operations =
are
performed on an uninitialized waitqueue head?

When a userspace application creates an implicit ODP MR, it is allocated via
mlx5_mr_cache_alloc() in drivers/infiniband/hw/mlx5/mr.c. This function zer=
oes
the structure and initializes the main mmkey waitqueue, but leaves the
null_mmkey waitqueue zero-initialized:

	init_waitqueue_head(&mr->mmkey.wait);
	/* mr->null_mmkey.wait is left zero-initialized */

When alloc_implicit_mr_null_mkey() sets up the null_mmkey in
drivers/infiniband/hw/mlx5/odp.c, it also skips initializing the waitqueue:

	imr->null_mmkey.type =3D MLX5_MKEY_NULL;
	/* init_waitqueue_head(&imr->null_mmkey.wait) is missing */

During destruction, __mlx5_ib_dereg_mr() calls mlx5_ib_free_odp_mr() which
executes this new call to mlx5r_deref_wait_odp_mkey(). This performs wait q=
ueue
operations on the zero-initialized wait_queue_head. Since the list head is =
not
initialized, its next pointer is NULL, causing an immediate NULL pointer
dereference.

Unprivileged local users with RDMA access can trigger this reliably, causing
a local denial of service crash.

> +
>  		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
>  				       mr->null_mmkey.key);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920090613.2186=
-1-lirongqing@baidu.com?part=3D1
