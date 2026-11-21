Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795248151;
	b=SBZvOSqBp+pt/QeyV1R61157d3EgzCPAuxrRgqSrUtYAbu9marNJLWrRiBpcrDfDMHwp
	 KcCbX3Lbkb/zCyJmtmK0O/NUzHAVS+kDcxsPX82vD6k+V398AZ4ZLtGRUmEtgENe1Q/l5
	 ragBNHcHSq7vl6AUYR7NG2cE0B6Nr0dl1rtd+5Lqpov0Dn9oUHL6nQB8KjylJrl/Iypi1
	 dKVEqwBu6qXpzTt/5826sbBfk3yo51THQikIqIvUsiLZq/rkHWxgmEG4MNEi8jxwu+IY6
	 pjCXwxcxVu/I24ADxnVt/GF63eFEDGP31U0dPUosWIuR6PH1RikfKD/GVBtGRs9vsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795248151;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xdsdrA49tZ9mIKWdjiPrrUD/OrVq94mxynYi7UAzxCA=;
	b=zG6K6QIcWZc3RrGLh5xN8Q2pDyavG9ggsar35XMfl1/JVm90yudbf8m2i8JP730tZpOg
	 4Rm4iHIl9JTmvQpHQBecmZoXcohK9CXBaiHjRxL3DqQerPGcIA9Jz8zgdKRanyNyYyYlq
	 wACC5Gq61mS4e+uGrsOokzlCg0L9qI6eiU65Bz3Ogxhp1dvD093AzxUMf0RQFgvMSih/9
	 X/5tZVmiJBVCg8ZRemIizxlSMKBEstMNvA9HSk/tS0lSJtEs3aLsl4PNWZdOezuyjna7+
	 7bU4isIqNrsZHP3UtNohPykJI0GTy137triyS0tyX3SHSnB1lPEpXt2i9GYzzRnJZyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INXw0QI0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24826606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 08:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INXw0QI0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922E81F000C6;
	Sat, 21 Nov 2026 08:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795248150;
	bh=xdsdrA49tZ9mIKWdjiPrrUD/OrVq94mxynYi7UAzxCA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=INXw0QI0f8jNZuTlr9jyLMOyTJJEK8uJfJPVqcPv/FRSFWJXRuK1YkVFwzka/pzW+
	 79l16zjgZo+/4QzxEXIvTx0EPGUpobMh0MzzmzAQZqr5wGJIdSW1Y+t1A/BEzw5XLm
	 c7oFxzrgbdYmUFmR0I1uJ3nn2+uzcV+P3Tr3S3Et1ORTBWi85bG/DPE5el8BVet2ZK
	 CSJ06WuwPJoxg9szPJlEgYnr2wR+fX+UOdOFOf3xlZCIDi8h22XxMx14nTjxXa+Txh
	 25A+5eYUpAuJ328UhE6nPFSMvKra/WszokdYqtCBph5wTLR4AU/pnZ826eqEeKkAVR
	 kQF9aM0KP5j7Q==
Message-ID: <sashiko-outbox-226812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 1/5] net/mlx5: E-switch, add match-metadata
 allocator for nested VF/SF eswitches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120075959.2533702-2-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
 <20261120075959.2533702-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:02:30 +0000
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
- [High] net/mlx5: inverted virt-LAG check in
  mlx5_esw_match_metadata_alloc()
--

commit a97c2078b8815e78906668a4a9a37e37bc914d39
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches

This commit adds a match-metadata allocator for nested (virt LAG) VF/SF
eswitches that splits the source-port metadata into an 8-bit LAG slot
index and an 8-bit vport ID.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 1323114ce7f93..3c1355f910906 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3650,6 +3650,48 @@ static u32 mlx5_esw_match_metadata_reserved(struct=
 mlx5_eswitch *esw)
>  	return MLX5_ESW_METADATA_RSVD_UPLINK;
>  }
> =20
> +/* Nested (virt LAG) source-port metadata layout: the upper ESW_NESTED_I=
DX_BITS
> + * hold the VF/SF's slot in the LAG and the lower ESW_NESTED_VPORT_BITS =
hold a
> + * vport id unique within its eswitch. The two fields still sum to
> + * ESW_SOURCE_PORT_METADATA_BITS. The LAG slot (0-254, per the xa_alloc(=
) limit
> + * in mlx5_ldev_add_mdev()) fits in ESW_NESTED_IDX_BITS; slots 0xf0 and =
up would
> + * drive the PFNUM bits to the 0xf reserved by internal port offload, so=
 only
> + * 0-239 are used.
> + */
> +#define ESW_NESTED_VPORT_BITS 8
> +#define ESW_NESTED_IDX_BITS (ESW_SOURCE_PORT_METADATA_BITS - ESW_NESTED_=
VPORT_BITS)
> +
> +static u32 mlx5_nested_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
> +{
> +	u32 vport_end_ida =3D (1 << ESW_NESTED_VPORT_BITS) - 1;
> +	u32 max_idx =3D (1 << ESW_NESTED_IDX_BITS) -
> +		      (1 << (ESW_NESTED_IDX_BITS - ESW_PFNUM_BITS)) - 1;
> +	int idx;
> +	int id;
> +
> +	idx =3D mlx5_lag_get_member_idx(esw->dev);
> +	if (idx < 0 || idx > max_idx)
> +		return 0;
> +
> +	/* Use only non-zero id's (2-255). */
> +	id =3D ida_alloc_range(&esw->offloads.vport_metadata_ida,
> +			     MLX5_ESW_METADATA_RSVD_UPLINK + 1,
> +			     vport_end_ida, GFP_KERNEL);
> +	if (id < 0)
> +		return 0;
> +	id =3D (idx << ESW_NESTED_VPORT_BITS) | id;
> +	return id;
> +}
> +
> +static void mlx5_nested_esw_match_metadata_free(struct mlx5_eswitch *esw,
> +						u32 metadata)
> +{
> +	u32 vport_bit_mask =3D (1 << ESW_NESTED_VPORT_BITS) - 1;
> +
> +	/* Metadata holds only ESW_NESTED_VPORT_BITS of actual ida id. */
> +	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
> +}
> +
>  u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>  {
>  	u32 vport_end_ida =3D (1 << ESW_VPORT_BITS) - 1;
> @@ -3658,6 +3700,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswit=
ch *esw)
>  	int pf_num;
>  	int id;
> =20
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_alloc(esw);
> +
>  	/* Only 4 bits of pf_num */
>  	pf_num =3D mlx5_sd_pf_num_get(esw->dev);
>  	if (pf_num < 0 || pf_num > max_pf_num)
> @@ -3678,6 +3723,9 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswit=
ch *esw, u32 metadata)
>  {
>  	u32 vport_bit_mask =3D (1 << ESW_VPORT_BITS) - 1;
> =20
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_free(esw, metadata);
> +
>  	/* Metadata contains only 12 bits of actual ida id */
>  	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
>  }

[Severity: High]
As reported by Shay Drory on v1 [1], does negating
mlx5_virt_lag_nonmember(esw->dev) route non-PF eswitches that do not
support virt LAG into mlx5_nested_esw_match_metadata_alloc()?

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h:mlx5_virt_lag_nonmember()=
 {
	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
}

When mlx5_virt_lag_is_supported(esw->dev) is false on a standalone VF or
SF eswitch manager, mlx5_lag_dev(esw->dev) is NULL and
mlx5_virt_lag_nonmember(esw->dev) returns false.  That dispatches
mlx5_esw_match_metadata_alloc() to mlx5_nested_esw_match_metadata_alloc(),
where mlx5_lag_get_member_idx(esw->dev) returns -ENOENT and metadata
allocation returns 0, causing esw_offloads_vport_metadata_setup() to fail
with -ENOSPC when enabling switchdev mode.

Should mlx5_esw_match_metadata_alloc() and mlx5_esw_match_metadata_free()
check mlx5_lag_dev(esw->dev) instead of !mlx5_virt_lag_nonmember(esw->dev)?

[1] https://lore.kernel.org/r/20261110093136.377962-1-shayd@nvidia.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120075959.2533=
702-1-tariqt@nvidia.com?part=3D1
