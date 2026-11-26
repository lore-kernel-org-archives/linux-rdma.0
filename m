Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727258;
	b=BtMF+jk3+BIqZnDMw7RWEnrpSZ40lRlykRRPpTjh8Prbgvha80kGAt7Ed4aAW0qqOY4/
	 YaQeL4Q2tsWnclfC+O1bpZ99+ozOA9cq0oWE9V2aZXymjTrfIiW8t2JH8jKWA8uGfw9JO
	 HTM8HSQ2SxUoDazRG0HNyWbkwdqKUDHAlA0LbMLSbnmGQZIzixKT4docZw6ESOk4jSeYC
	 pLY0zaWBTZrk6f561VT6zYFgX+ZVQ44nC9LFm0FclHVSECWx8EU01mhckeDNHrOTAQn62
	 zPAyV3vfjVO9obK/2BzJAxCTNLSN0Z13pS5OPjZ/zuqYLbBvuzMDarLtV/1ZrAW2M9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CvkuabTJHhWek2xd3VEhVOCZ9IQhN5HxZg8nZka5CpA=;
	b=E4k371/O9b9ALNG8D+biEKv+Eyd87OkfXbB4jhuB21Uln6HO1bbjW4wE/ya+mS2fD+rX
	 TC0WUwGQ3YAbYMnjj6hhlhJtSkb733xqQ8ZOwYzsrVUBQ+L5NJ9qxM9vv2lPbm0ok1rr7
	 ozBBScAQqqWKIUnf6NNImjutZ/OhdXVcjzffFoJe38dewH8ch+kF9na+KyQUFs/aaqkSh
	 DoLwaU6MJ0IE/RI8CRjBrcarZ0tpwfQGyJUfnK2Zed6rvluQtUS22AGazynCLr4LpkfFj
	 icW59kBBI5+Gx5tbM7wuO8PHg8lmE5bfRm1aYkU83rE9uThRRhAgmEWuw/VYISX2cVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1zVRnjd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96436606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1zVRnjd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED88C1F00893;
	Thu, 26 Nov 2026 21:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727258;
	bh=CvkuabTJHhWek2xd3VEhVOCZ9IQhN5HxZg8nZka5CpA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h1zVRnjdvN2YYXbdLw0IAXc8iYUaEVMQuE7y8qegnaw77Sik/cytoKP6iXVSw+37F
	 Eu1zi+x8eoHY7JLvdWNQUHrtRx42y8F9BKBd/pIoZNcI/IYZMzm3YDOKMSERoHh114
	 61ya68RAybCEPqODX/Mqwq44T0rU/uybaOCX14YWhgCZQuAymB56MHiptJ2Stt1Bv2
	 qg7bQk2ezEapVG1INYvIbwFM3Y+pXujxbqnp1hijPrmIHLa+PHCmBRKMB56t9YHqKK
	 lKu1aAlmK1b38Rm5pXkluAg+jJnMHdthZUtry4Q7zVSTNmLOo/XLtbuaq2IN5XWWtX
	 7KvPpRlHn58AA==
Message-ID: <sashiko-outbox-236193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: TC, use the owner eswitch for encap
 neigh updates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125210629.239095-1-tariqt@nvidia.com>
References: <20261125210629.239095-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:07:37 +0000
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
- [High] net/mlx5e: wrong owner eswitch in mlx5e_attach_encap() on SD
  secondary
--

commit 96c6db1d17691b26e167336b35cba55741af989b
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: TC, use the owner eswitch for encap neigh updates

This commit stores the owner eswitch uplink priv in struct
mlx5e_encap_entry and uses it for encap neighbour flow updates and entry
release instead of deriving priv from e->out_dev.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 4f9f8beffbc8d..d23cf60613ea7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
[ ... ]
> @@ -871,6 +871,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
>  	init_completion(&e->res_ready);
>  	entry_created =3D true;
>  	INIT_LIST_HEAD(&e->route_list);
> +	e->priv =3D netdev_priv(mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH)=
);
> =20
>  	tun_info =3D mlx5e_dup_tun_info(tun_info);
>  	if (!tun_info) {

[Severity: High]
Does mlx5_eswitch_uplink_get_proto_dev() set e->priv to the primary
eswitch when mlx5e_attach_encap() is called on a Socket Direct secondary
eswitch?

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:mlx5_eswitch_upl=
ink_get_proto_dev() {
	struct mlx5_core_dev *primary =3D mlx5_sd_get_primary(esw->dev);

	if (primary)
		esw =3D primary->priv.eswitch;

	return mlx5_eswitch_get_proto_dev(esw, MLX5_VPORT_UPLINK, rep_type);
}

When a tunnel encap flow is offloaded on an SD secondary representor,
mlx5e_attach_encap() inserts e into the secondary esw->offloads.encap_tbl,
allocates e->pkt_reformat on the secondary mdev, and installs the origin
flow on the secondary eswitch, while e->priv points to the primary uplink
priv.  A subsequent neighbour update or encap release via e->priv will
lock the primary encap_tbl_lock, update slow-path FDB rules on the primary
eswitch (colliding with the peer flow and unbalancing fs_chains), and
allocate or free e->pkt_reformat on the primary mdev.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125210629.2390=
95-1-tariqt@nvidia.com?part=3D1
