Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7283B993A
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 10:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886093; cv=none; b=nEPGxXhAQPeNvpCMe8PtNQMq7KrPxwK+RFYTcCpkbdd0kGEz8ur+QCPQ+aiEP/XTiRl9A4X8itH4oEIBQAfHz7viVvHfKeR67wwo+kTYbbT8i6r6LoOiVsB4yaglf2L20nCrIh6WKSdgveACE3uVBYi3VXwxwdoD2ZihBe1Pd0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886093; c=relaxed/simple;
	bh=NMxs/NsshMPYc8Ze5noCenRRv6TcStMV0aWrv7YBmDY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=paTSUGr/jJiTC/do8FW81HvUxpom382PG3DpIwX08E7XpYEgsve2DPcPjw/SoExLF8PfTZQgTXnjZEgOHt41djQ6q183L6cobmc5/b3WNdR9SsTayuaS2D0tiCoRseilgfi7KAvhBKuicrVHacOr+UQuXpINUhr+RSLaPUSXE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hT/F9pwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hT/F9pwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4413F1F00893;
	Tue, 13 Oct 2026 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791886092;
	bh=bQyKZh61+v7vj1WSn6e5jOPsOQvcekkpcshfa0XpSqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hT/F9pwqfjgyB1q84baceaNcn5FMHuyBChqhy8wQbFXSu0L4XNaxA+UAnIlcY6HbE
	 xDw3MvedpjyUHJOP5G1ohajyRppTx7aeEWpR8hUWBz6oAKUIwRnixC3NhZkUHNnfh+
	 cwvOtP4iac7iQ+rG+37wQMDerqNgjOrDDF3McJGTe/9TdqQ6pvGaOgOkocYB+p9lWy
	 fV4OCNElmflxuyqv/BhP1VwwBwNk127BcYrvRfGV8TXIFxy9ZTqtA0C7aPJPfi6/s9
	 J1tXE8Nzax8G+tx7+WCf51KaIeDHRL5Xy5p2kDE30G7xxZ78Ksw8KBEqwav0+kIq7O
	 2tEubzNBXCSRQ==
Message-ID: <sashiko-outbox-169457@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool
 creation race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012100555.1317878-3-acassen@corp.free.fr>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <20261012100555.1317878-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 10:08:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mlx5: hws: 32-bit truncation in modify header action match
--

commit 33535690e64312a76a1dd5c1afe587641631b515
Author: Alexandre Cassen <acassen@corp.free.fr>

net/mlx5: HWS, fix modify header pool creation race

This commit addresses a race condition during modify header pool creation
where concurrent callers might allocate pools at the same index. It fixes
this by keeping created pools until cleanup, allowing lockless lookups for
existing pools while using a mutex for creation.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.=
c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 66edb42268cbd..11cced847186e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
[ ... ]
> @@ -1457,6 +1459,23 @@ mlx5_fs_destroy_mh_pool(struct mlx5_fs_pool *pool,=
 struct xarray *mh_pools,
>  	kfree(pool);
>  }
> =20
> +static struct mlx5_fs_pool *
> +mlx5_fs_find_mh_pool(struct xarray *mh_pools,
> +		     struct mlx5hws_action_mh_pattern *pattern,
> +		     unsigned long *cnt)
> +{
> +	struct mlx5_fs_pool *pool;
> +	unsigned long i;
> +
> +	*cnt =3D 0;
> +	xa_for_each(mh_pools, i, pool) {
> +		if (mlx5_fs_hws_mh_pool_match(pool, pattern))

[Severity: High]
Does this code rely on a matching function that truncates 64-bit payload
data?

Looking at mlx5_fs_hws_mh_pool_match() in
drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c, it
casts the 64-bit modify action words down to 32 bits:

		if ((__force __be32)pattern->data[i] !=3D
		    (__force __be32)pool_pattern->data[i])
			return false;

Since data is an array of 64-bit elements (__be64 *data), this discards 32
bits which include fields like action_type, field, offset, and length.
Consequently, two distinct modify actions sharing the same lower 32 bits wi=
ll
incorrectly match, and the driver might apply the wrong header modification=
s.

Can this be triggered by user-space or network admin configurations setting
up similar TC or RDMA flow rules, resulting in wrong hardware pool reuse and
corrupted traffic headers?

> +			return pool;
> +		(*cnt)++;
> +	}
> +	return NULL;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012100555.1317=
878-1-acassen@corp.free.fr?part=3D2
