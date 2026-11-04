Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812430;
	b=JvQDU/ozMKrIsKVh0krvnsYjRKdWC7nxr4TpX9InIVootRVq26I3Rv2w1ghXCOLvaz6N
	 4jUeaHBm4h3H61m6Dvc315aG/Da8TVN/aFdk9rJeXkKAkD/1bed+N0Qd2tFp9J9p8uBS8
	 NsQ694ICtPPCwCWA4gjV3txl+VnOtQDvtd8tGCPfYgjkuI5OQX1fHJCnnjZAQPGHIBB2u
	 HWuUEhZXz0ltU4HOCrQQjmZQM4RcO3Qu6YcEFXox8OIg83UT5676iZHLaEY05UQm09JCW
	 bQidzCmxPQQGkxmqkLQT1U2XsI0sRWO+j++8gl/UczAr7rwRKyJSi5RYbIs+Q+zEmSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812430;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7wOK6ZERcMKWxXkYOtvXSPUhe0+LFOfXaYuJAQVarhI=;
	b=JTpAnMsKLchAAvrT7JtYABBKz2XldT1D5DIf/AZWApYTVTlfsaUruRK5L2BBSMJ6Ycqk
	 WqBV+xLvylNlvYpMJsjLqtlsxR/Z2aNkQzZMcVmXF3ZByD7njGiNRt7VoDW0F8mZ999aS
	 xv6TbycUsskAwcsVOE/1ZI6GXb7Z1zep9dYKQQifr8NTqpsVu2Eimi0XYaFtupMWlWWiL
	 xYozJPxb4YhlX2sG5I46psFsLUELcQDVJm5uMwIOIBykXHx5MydImFe9lJYXIgkiB31Ts
	 aEwplBDjqn8QsQtv4Byw6bD5ur6Wodaq5xXYXGMXfPRPnYhJC8ETz2HZYJqySZwUlcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNf2XZB9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECAE606A336
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNf2XZB9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B69E1F00A1A;
	Wed,  4 Nov 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812430;
	bh=7wOK6ZERcMKWxXkYOtvXSPUhe0+LFOfXaYuJAQVarhI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YNf2XZB9YuvSxvp3KvxpyYIcw/dCBkg331SxoTbYJHh4XXRG33tIh6gLQJyYh+9Bg
	 IuLJQS1IADKIzfvdpw18NrkGOpUtejQNOXK3u9/FT1n/kl1YM1fUt2XRX2v10c0oBW
	 dUHYGkhNbQc5dis+Bm2xR3KTJp/mQuJQCXMh97ee5JMtG7YdkY8JnqSpPsBkwIo2Ny
	 L3rim8rSC/WxWLam2SSVktKiUuyz6xN/636ZkikWkP5QJTTe59dd4i7ONHdfjB/GDx
	 9ZdqGFxwIg1f+TmnE5g+aayBoK/6qrYcQXn8yOlQ6Qn/CvhfEI0npA2+x2IPsa0TaG
	 sSiPorxkt+Fcg==
Message-ID: <sashiko-outbox-197738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 11/15] net/mlx5: E-switch, add match-metadata
 allocator for nested VF/SF eswitches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-12-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-12-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: broken virt-LAG check in mlx5_esw_match_metadata_alloc()
--

commit 9baf575a43e87029cfdb18972493f93999d3c0c8
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches

This commit introduces a match-metadata allocator for nested VF and SF
eswitches that encodes the function's LAG member index and an 8-bit vport
ID into the 16-bit source-port metadata field.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 70e6dd9561a66..ef1043517e9e2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3651,6 +3651,48 @@ static u32 mlx5_esw_match_metadata_reserved(struct=
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
> @@ -3659,6 +3701,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswit=
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
> @@ -3679,6 +3724,9 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswit=
ch *esw, u32 metadata)
>  {
>  	u32 vport_bit_mask =3D (1 << ESW_VPORT_BITS) - 1;
> =20
> +	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
> +		return mlx5_nested_esw_match_metadata_free(esw, metadata);

[Severity: High]
Does negating mlx5_virt_lag_nonmember(esw->dev) in
mlx5_esw_match_metadata_alloc() and mlx5_esw_match_metadata_free() break
switchdev mode on VF and SF eswitches that do not support virt LAG?

In drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h,
mlx5_virt_lag_nonmember() is defined as:

static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
{
	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
}

When mlx5_virt_lag_is_supported(esw->dev) is false, mlx5_lag_dev(esw->dev)
is NULL and mlx5_virt_lag_nonmember(esw->dev) returns false.

As a result, !mlx5_virt_lag_nonmember(esw->dev) evaluates to true, sending
non-virt-LAG VF and SF eswitches into mlx5_nested_esw_match_metadata_alloc(=
):

esw_offloads_enable()
  esw_offloads_metadata_init()
    esw_offloads_vport_metadata_setup()
      mlx5_esw_match_metadata_alloc()
        mlx5_nested_esw_match_metadata_alloc()
          mlx5_lag_get_member_idx() -> -ENOENT

Because mlx5_lag_get_member_idx(esw->dev) returns -ENOENT when
mlx5_lag_dev(esw->dev) is NULL, mlx5_nested_esw_match_metadata_alloc()
returns 0 and esw_offloads_vport_metadata_setup() fails with -ENOSPC.

Should mlx5_esw_match_metadata_alloc() and mlx5_esw_match_metadata_free()
check whether the device is actually a virt LAG member (for example,
checking mlx5_virt_lag_is_supported(esw->dev) && mlx5_lag_dev(esw->dev),
or simply mlx5_lag_dev(esw->dev)) instead of !mlx5_virt_lag_nonmember(esw->=
dev)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D11
