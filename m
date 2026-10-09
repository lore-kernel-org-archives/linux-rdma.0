Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E573DA5B0
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552666; cv=none; b=c4O/lmSLG5b9p2HVU90pwr177B6P0QU39fp8JKlkYM5p0Fgu1RyEvCZhkmdTDgN0OsOR0mY04darr+de55lwJYmJcf3sYrj4NCPk1rxig22KUirnyoEWwdbpHihLcG9TqF2za1NYR6Fc3P7thDHNeV0MVKKUPrgEobTmaziEyfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552666; c=relaxed/simple;
	bh=0wBT3F6MRzJHZaJK8naauhrzKT/qiLwL5H1qhMDEHA0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=U/3BowO6FAqAo/BPy00WarQND86Ntsowpj7HExDHCL5lY6HwDAd9HmyRCmHFzKDsIhx5RTlM4EcVTJOgoBaVoYI2bViZgRHmhcq5NZ1gEaiAkU8SXq5chsfcoishISj30AdPb7eMJHtZqyh1GVnmC6oBn1E74KsmkgUHW0gjuI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be/S532i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be/S532i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F031F00898;
	Fri,  9 Oct 2026 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552665;
	bh=gtDizRhShZ+4qcTUOLJ5VogkpVIG77cmyuQAqE3Narc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=be/S532iYMjipkG8ZyrV1M8nQJkQFQS7RGxk2qyCwQWNpzq1cNGwM2Ehy8vFv19Z6
	 +3a+KCAi+NBDxYVQr3RK/inlaCWKhHxv72sEwaRkQosr4IJ8cGO+nJ4+1rUCNaK7ND
	 2cgEo0PC/oq9lLL2qNloMqxm/hMusEJRHHEDoGLtbGro3DtZoa32+evYhLtbfJNSZf
	 xYYxTApqrMDcwsuhrKa9yi9GGr8SQfY/Iw4yj+mKT9TwDXH3TWnord1CGF2i8mMv4X
	 rAClxpxZAyIWGoUfSip6VR06pbAkjjX51/8jaEPVCMi09ScmNUPkrTUjckV48wSs/V
	 PHEn18dmkhHIQ==
Message-ID: <sashiko-outbox-165640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/10] net/mlx5e: Add data direct TX
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-7-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5e: GPU unbind causes DMA corruption for active devmem TX
--

commit 2beff8c1365001300351d8ed26d31fd617a37400
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Add data direct TX infrastructure

This commit introduces the necessary infrastructure for peer-to-peer DMA
between the NIC and another device (e.g., GPU) on the TX path. It creates
a crossing mkey linked to the SQ and adds a new SQ state flag to indicate
when Data Direct is enabled.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c
> index 14479da98f427..62ffb41a64dfe 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -182,6 +182,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struc=
t sk_buff *skb,
>  			unsigned char *skb_data, u16 headlen,
>  			struct mlx5_wqe_data_seg *dseg)
>  {
> +	bool dd =3D test_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
>  	dma_addr_t dma_addr =3D 0;
>  	u8 num_dma          =3D 0;
>  	int i;

[ ... ]

> @@ -211,7 +212,8 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struc=
t sk_buff *skb,
>  			goto dma_unmap_wqe_err;
> =20
>  		dseg->addr       =3D cpu_to_be64(dma_addr);
> -		dseg->lkey       =3D sq->mkey_be;
> +		dseg->lkey       =3D dd && skb_frag_is_net_iov(frag) ?
> +				   sq->crossing_mkey_be : sq->mkey_be;

[Severity: High]
If a peer GPU device unbinds while a Data Direct devmem DMABUF is mapped
for TX, the MLX5E_SQ_STATE_DATA_DIRECT flag is forcefully cleared.

Since the asynchronous unbind bypasses the devmem socket binding safety
checks, the application can continue transmitting net_iov fragments that
still contain GPU IOVAs.

When those fragments arrive here, dd is now false, so the code falls
back to using the NIC's local sq->mkey_be for those GPU IOVAs.

Could this cause the NIC to read incorrect local memory or trigger host
IOMMU protection faults? How should active net_iov transmissions be explici=
tly
fenced or dropped when the queue state reverts?

>  		dseg->byte_count =3D cpu_to_be32(fsz);
> =20
>  		mlx5e_dma_push_netmem(sq, skb_frag_netmem(frag), dma_addr, fsz);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D6
