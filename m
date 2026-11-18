Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022022;
	b=egnxG6HJ9NpYQQABuRkxi7MAjvqljZ+NkWP+dFvgI2wTYf1nMH9jGphn7UY3eJ8kgE6v
	 zlK6OMbwd9RT+yqYqh+l5nID7M6IJjvTXn3oU22TJtdUKyPXI3y8Dql8U3Qu4p6nvDcKD
	 Q+6pf0RhBuO3d8GicB8K9ircZgjDsf7WdsvRmzbP+ofp765F9Yq89MLAblU3iUV3FvPur
	 gC7drHEpVzoVil6qKHv03XX9zH+RVU89+Xg3RL98uG6H/hNu+NL2/DlEFbG4qGUIooL7F
	 q3nYooXKbpLo+1GeLf9VSB06RjrWD3NarlIbZsB7pgUX0jyYUnv9GMNqaBLTVanTbVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022022;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g5cuJXlwoo1uBN/bvuj0L1Yc/omui/VebJ8EEB7MNeU=;
	b=sy+9pgPwDFjurew5kV3TWlaKYkpGQXs6VkEUVto7hdWrxmcMIo9dhCGWzZLfgRc3oOfp
	 hZyqwruDMPyUg6dlPrUHR+5IqtNA548UtgPWGAdOGuV8T7Qic/zcFUv1hR1YQ9kK1oyal
	 9mCDRcoOSaF3cjp2i94coBxSkuCINF71YLMhioCzyExlg+XijwiCI+oPSyyM4ucOmeljN
	 DTo5UBzRbdelxXmePYvGnxMMc56ZurNwTUayYTvWIKh41J0dtzeEj/H7VTDkjcF4C5ZLz
	 gbXmgL+49hRGX/jv2qaMoxSOe2Gtdw7HPrdVpBLO7O1ALdTUZRkqb1uPKdnaX7YVlyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f7AJk2ds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998DA606A33F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f7AJk2ds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F881F000C6;
	Wed, 18 Nov 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022022;
	bh=g5cuJXlwoo1uBN/bvuj0L1Yc/omui/VebJ8EEB7MNeU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f7AJk2dsNNEKaKcnDTkYsonke0RWT8Reca2UKNRB0HU65dttHosaRuc1jCGQJ+UJ7
	 4Pya+Mual23FYayfwg9IKosmv9r7Qt3Ry+4p3pvQE1FYECenUjNtPcoQK9xrR/JxOR
	 WPEVU2xcuUiNPrZ3Y/ZmaMXE2v9fHT9csamyklU3BIrC4io+Sf0QBrFwbMnsV8iRfd
	 uurG78XdntLHwwETttM4i4TEtVTQTYa4cq1N/tl/ia2E+Il1ZlL6FwqQ+wPP+FW/Ku
	 8HYDgqW7YZd+na1Ew29zSG6iQvLU8707s+5PN5wdUQpHWC2kZz3WheqeUpzs7q8pbu
	 fX242YpL9Q9IQ==
Message-ID: <sashiko-outbox-221605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 04/21] net/mlx5: Catch too low max number
 of EQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-5-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-5-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/mlx5: divide-by-zero in alloc_rmap() when get_num_eqs()
  returns 0
--

commit 3ffd9856318c7a723d1d765cb083af29c7442990
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5: Catch too low max number of EQs

This commit checks for a negative return value from get_num_eqs() in
mlx5_eq_table_create() and returns -EINVAL when firmware reports fewer EQs
than MLX5_MAX_ASYNC_EQS.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/e=
thernet/mellanox/mlx5/core/eq.c
> index d11ec263d53c9..b34670eb037cf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -1195,9 +1195,13 @@ static int get_num_eqs(struct mlx5_core_dev *dev)
>  int mlx5_eq_table_create(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_eq_table *eq_table =3D dev->priv.eq_table;
> -	int err;
> +	int err, num_eqs;
> +
> +	num_eqs =3D get_num_eqs(dev);
> +	if (num_eqs < 0)
> +		return -EINVAL;
> =20
> -	eq_table->max_comp_eqs =3D get_num_eqs(dev);
> +	eq_table->max_comp_eqs =3D num_eqs;

[Severity: High]
Can allowing num_eqs =3D=3D 0 cause a divide-by-zero in alloc_rmap() on non=
-SF
devices?

When firmware on a PF or VF reports max_dev_eqs =3D=3D MLX5_MAX_ASYNC_EQS,
get_num_eqs() returns 0.  mlx5_eq_table_create() stores 0 in
eq_table->max_comp_eqs and then calls alloc_rmap():

drivers/net/ethernet/mellanox/mlx5/core/eq.c:alloc_rmap() {
	if (mlx5_core_is_sf(mdev))
		return 0;

	eq_table->rmap =3D alloc_irq_cpu_rmap(eq_table->max_comp_eqs);
	...
}

alloc_irq_cpu_rmap(0) passes size =3D=3D 0 to alloc_cpu_rmap(), which execu=
tes
cpu % size and crashes the kernel with a divide error.

Even on SFs where alloc_rmap() returns early, eq_table->max_comp_eqs =3D=3D=
 0
causes mlx5_comp_vectors_max() to return 0, which triggers divide-by-zero
faults in mlx5_ib (via ib_cq_pool_get() dividing by num_comp_vectors) and
in mlx5vf_create_tracker().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D4
