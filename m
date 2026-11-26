Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694337;
	b=ZBQB4DrSxOtxNGVzh7AcRi2lriFtx7rJcAAm6ffpuMXWmDyglJPL6cFYgUX7XJXgvXtD
	 XOqkae0Y+eGav5ti3zo/Zmjgh3l54xX58hGXNee4JHgeTWmleywAbDNVp3x8O/61HuH70
	 r5ZkpUWsNYYcnEMenbzOOhfLu/G8SlQzdPAfjF6xGSqYhwbj5PaIU/VdFkoewe7NB9mDC
	 bIIgAZ9FY+l+ZZZHOshQT0/Ap+q3rFsivmiccqVhi21FjpeTFHMPWJvQmk2Oyg89pUYzm
	 yjdLM6UOKva3KAY7Wlb1L1QRCQm77R4oMCnIVz0NJZvxLBRAxHEZkPaIttbuvtr8dXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694337;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jUXOb/7NHDhl2KO9+Lfn/n76yOctCL6VjT5ewWWHbTc=;
	b=aytuFnpNaOZRNRRYvI31zIU7rXLTVm9sdCUKwYjyJzseNjhTBpIxYO03RjMgtxi3GX9+
	 ghB+TPhYvw5fGK0iJImpaGlkvFPiDinXFizBHqJK0M+XCdY1OC/RmxyqExW6XYl0AYOH0
	 808Q1baNOpAM8zcxw7cvA5z+EJu+TG90zk3Mh41E4A6elHSuQzE18X9uiOd44MJa+NwVW
	 ug2cLsMm5QYAnFnXrdxbGuaxFyicwgGm0peJHp675UNnPDI66G5LGl65esZwswAANUmPR
	 NvxatYYCuM3Cq15PpBwSNLFb/c+zGvtStFe9TiMqErAUsqJGlQ2pv6ARLF7MZCEW/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9pov8ir;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C536606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9pov8ir
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEBB1F000C0;
	Thu, 26 Nov 2026 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694337;
	bh=jUXOb/7NHDhl2KO9+Lfn/n76yOctCL6VjT5ewWWHbTc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N9pov8iru6PtLwZ6LeQHy8tGP/hGW0HgBtXCxhG5/1tGeVVksvJNkWz6cPuxo8m8z
	 bEQyb/LCFlAYCnwghEmP4K/4cnBph1Sx9+16lvPA7ySbeqsMBCPfbchEsXA+dCZHBr
	 tyZJ++b4eJY4tyOq/DZE5n+BvtcENtl8zkj1YD2miVqppkJdcjNhza7KNvXrfzQ24D
	 EjMZ+U86sJAGtmT7H/gBCI+5hXsj6fXJ9RxkzpcwfMCYgBMyT8i6a3hqIgW5gtgTYy
	 FNZqNhbLNGLM2W+5UFTF+rFr/Wyeeq9IbHYH+PThai2evwDKIjGY+w9A6QGlq25dMU
	 1JDuOj3f7Nxpg==
Message-ID: <sashiko-outbox-235455@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: E-Switch, Fix offloaded nf flowtable
 rules never being hit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125115815.87909-1-tariqt@nvidia.com>
References: <20261125115815.87909-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 11:58:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] net/mlx5: off-by-one FDB sub-namespace priority in
  esw_chains_create() [1]
--

commit 60c8dade186c303e933b7f1b16d70cd37bc59342
Author: Tariq Toukan <tariqt@nvidia.com>

net/mlx5: E-Switch, Fix offloaded nf flowtable rules never being hit

This commit sets the nf flowtable as the chains end table before creating
the root flow table in esw_chains_create(), ensuring the root table's miss
rule points to the nf flowtable chain rather than the slow path.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 4747841310914..f71cd03035924 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -1693,6 +1693,11 @@ esw_chains_create(struct mlx5_eswitch *esw, struct=
 mlx5_flow_table *miss_fdb)
>  		goto nf_ft_err;
>  	}
> =20
> +	/* Set the end table before opening the root, so that the root's
> +	 * miss rule goes to the nf flowtable chain, not to the slow path.
> +	 */
> +	mlx5_chains_set_end_ft(chains, nf_ft);
> +
>  	/* Always open the root for fast path */
>  	ft =3D mlx5_chains_get_table(chains, 0, 1, 0);
>  	if (IS_ERR(ft)) {
> @@ -1707,8 +1712,6 @@ esw_chains_create(struct mlx5_eswitch *esw, struct =
mlx5_flow_table *miss_fdb)
>  			goto level_1_err;
>  	}
> =20
> -	mlx5_chains_set_end_ft(chains, nf_ft);
> -
>  	return 0;
> =20
>  level_1_err:

[Severity: High]
This problem wasn't introduced by this patch, but does setting
attr.fs_base_prio to FDB_BYPASS_PATH (1) earlier in esw_chains_create()
cause an off-by-one priority lookup [1] when mlx5_chains_get_table()
creates managed FDB tables?

When mlx5_chains_create_table() creates a managed table in
MLX5_FLOW_NAMESPACE_FDB (the root table at chain 0, prio 1, level 0, or any
table when ignore_flow_level is not supported), it looks up the per-chain
sub-namespace and adds chains->fs_base_prio:

drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c:mlx5_chains_create_=
table() {
    ...
	if (!mlx5_chains_ignore_flow_level_supported(chains) ||
	    (chain =3D=3D 0 && prio =3D=3D 1 && level =3D=3D 0)) {
		ft_attr.level =3D chains->fs_base_level;
		ft_attr.prio =3D chains->fs_base_prio + prio - 1;
		ns =3D (chains->ns =3D=3D MLX5_FLOW_NAMESPACE_FDB) ?
			mlx5_get_fdb_sub_ns(chains->dev, chain) :
			mlx5_get_flow_namespace(chains->dev, chains->ns);
    ...
}

However, create_fdb_sub_ns_prio_chain() initializes each FDB sub-namespace
with 0-based priorities 0 through FDB_TC_MAX_PRIO - 1 (0..15).  Adding
FDB_BYPASS_PATH (1) places the root table at sub-namespace priority 1
instead of 0, and on devices without ignore_flow_level support, creating a
table at the maximum priority FDB_TC_MAX_PRIO (16) asks for ft_attr.prio =3D
16 and fails in find_prio() with -EINVAL.

[1] https://sashiko.dev/#/bug/linux-9702e5c8-96e6-42e9-a756-b9f79ba339e1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125115815.8790=
9-1-tariqt@nvidia.com?part=3D1
