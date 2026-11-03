Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745306;
	b=FlNu5/IFAz+qalU7hl+97Z1wN36EL3fMy0vgFGwfq29mY11uMMHTUZdMYBSgF2i0v7nG
	 ODm0XEpWP3WYu5bs7nDMtbMxHHhIdisPXeNhQDjLf9CdlDlaB5nxPOQ9kA/RZZOwIOg5b
	 cSTcMc3qf9tPORFsaBqZqvSrPBheMNNWRJwT7JZ3DdwWRJzKbwMCTb/4nIZyOecrifbh0
	 jGSs5eYLeJMjfOn63QokXaxZx2EBehv3fofOaZ62cJeB79F45UWUx66QIzG0LyXHU66QE
	 oeYTs1PlOU34+DB15iY4y5yhaCsU+Z9jj7YUXgtzLbLilNJYVE814SBJVG/pHdgXH7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745306;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v9xaoGANZ7VsBizv4+TsMMWIZqQEPZ/RbWAZVidg00M=;
	b=sDABChnTvQ6VjDOlHH9mO1a9nHrWd1Li5gh9pZyzIS73LHBFI+FVan40D37WwgvD7ebB
	 w8P26bobqfgBb6LgymxN5FJ+9+8wIHmJEQb3T1qlCMnWZH1ZcO8YBFD3XaSdkcCmIF9vA
	 3i24l6cxo/70CUeoaQatgej+aKH0gNUQdNsE0Cx02rJfjOCnk70fFbs1WlukNe3gNxrR/
	 WtRxT6fG/0zoXs8k8FxvP7T1l+vjdeDQscf6Zeh1sWR4Ewd4IcA6R+RFtZ115zB3wW+w/
	 eLYm9AKQXwDUEYTmau3ivUVj91/yOsPxGW/UQlRdZExAVPK2tPPo8Vq4Ic/epmBW5sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEy1C6Aw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A864C606A329
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEy1C6Aw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2CC1F000C1;
	Tue,  3 Nov 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745305;
	bh=v9xaoGANZ7VsBizv4+TsMMWIZqQEPZ/RbWAZVidg00M=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ZEy1C6AwvNtCutgffTAx5yxVZp4sQlIwE4MO4K0JPHdttD3Ojhn5AleCGobT1kLVB
	 88jkgaGj3bbv7CWvU9vLGJpQRnVr0u9+6yIWeoHmnQGbrnIL/G4iZUhRiIhgk5dI9c
	 AOyA1/TPDyXeXIgTd3iP7pc5kOYUkpInaEbb2qA+ALOfxaqNu1reqb9K29gM8QwuPc
	 YdxSNV845HgCaZZ0cLYk3YAkH0EFk5Xn+OrjBIb3w5IPj2NPVmqzedKBKW9Q89a0zU
	 bCGHua2XBrSgpVOIULd1fynInKJ+cy8JRgTLZBrXQFY2ZvGN9vtpn7cY5Y0p7pYKrX
	 tuV0FIf2PXD4A==
Message-ID: <sashiko-outbox-196139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 14/15] RDMA/mlx5: Support new Unordered
 access flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-15-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-15-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:04 +0000
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
- [Medium] RDMA/mlx5: missing IB_ACCESS_UNORDERED in _mlx5r_umr_update_mr_p=
as() for DD
--

commit d54e400e3350128fbcd9fb5d5bce4f37dfe241bd
Author: Michael Gur <michaelgur@nvidia.com>

RDMA/mlx5: Support new Unordered access flag

This commit adds mlx5_ib support for the IB_ACCESS_UNORDERED flag by mapping
it to MLX5_MKEY_ORDER_UNORDERED, enabling ATS on DMABUF MRs with unordered
access, and marking the flag as unchangeable via UMR.

> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw=
/mlx5/mlx5_ib.h
> index dd1fe8fd42206..75ea3f91e9314 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -1672,11 +1672,13 @@ static inline bool mlx5_umem_needs_ats(struct mlx=
5_ib_dev *dev,
>  {
>  	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
>  		return false;
> -	return access_flags & IB_ACCESS_RELAXED_ORDERING;
> +	return access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED=
);
>  }
> =20
>  static inline enum mlx5_mkey_order mlx5r_access_to_mkey_order(int access=
_flags)
>  {
> +	if (access_flags & IB_ACCESS_UNORDERED)
> +		return MLX5_MKEY_ORDER_UNORDERED;
>  	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
>  		return MLX5_MKEY_ORDER_RELAXED;
>  	return MLX5_MKEY_ORDER_STRICT;

[Severity: Medium]
As reported by Sashiko on v1 [1], when a Data-Direct DMABUF MR is registered
with IB_ACCESS_UNORDERED via mlx5_ib_reg_user_mr_dmabuf() ->
reg_user_mr_dmabuf_by_data_direct(), both crossed_mr and crossing_mr are
configured with MLX5_MKEY_ORDER_UNORDERED and ATS via
mlx5r_access_to_mkey_order() and mlx5_umem_needs_ats().

However, when populating the KSM entries in
drivers/infiniband/hw/mlx5/umr.c:_mlx5r_umr_update_mr_pas(), only
IB_ACCESS_RELAXED_ORDERING is checked when selecting between mdd->mkey_ro a=
nd
mdd->mkey:

		if (dd) {
			struct mlx5_data_direct *mdd =3D dev->mdev->data_direct;

			cur_ksm->va =3D cpu_to_be64(rdma_block_iter_dma_address(&biter));
			if (mr->access_flags & IB_ACCESS_RELAXED_ORDERING &&
			    mdd->mkey_ro_valid)
				cur_ksm->key =3D cpu_to_be32(mdd->mkey_ro);
			else
				cur_ksm->key =3D cpu_to_be32(mdd->mkey);

Similarly, in
drivers/infiniband/hw/mlx5/mr.c:reg_user_mr_dmabuf_by_data_direct(), when
mkey_ro_valid is false, only IB_ACCESS_RELAXED_ORDERING is masked out of
access_flags:

	if (!dev->mdev->data_direct->mkey_ro_valid)
		access_flags &=3D ~IB_ACCESS_RELAXED_ORDERING;

Should _mlx5r_umr_update_mr_pas() and reg_user_mr_dmabuf_by_data_direct()
also handle IB_ACCESS_UNORDERED so that Data-Direct KSM entries and
crossed_mr/crossing_mr ordering match the underlying Data-Direct mkey?

[1] https://lore.kernel.org/r/20260726092943.2880176-15-michaelgur@nvidia.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D14
