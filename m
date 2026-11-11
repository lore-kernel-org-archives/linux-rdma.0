Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422435;
	b=m8o6LvPA9n+4n/aNib4gSq4A63mX8hP6WKwiuAko/IQ8w8ZO++oCfRiJ3Mfy1FZ6Y/Bl
	 GUEG9oiEuW39mTNEn22BXYFqQeScU2+UaWwW8fQaaVqno0WjqpXzH9O/GVnzuWpJnlgnm
	 G4o8j1QuwGNPUTEKRF+qsyEHd5w2HmdlD/yUg2KKUt/Ji4StzeH0Zefkb9TNTTw83m6yj
	 /zj3/U/vJoT3KG1Hm5D4Oxa6m3mrBFOP4MqnHxfdJlOyYQ8Tf4X6YauFwwVKOp14B1cFc
	 dc3JDBKmf8ysFjq4adVt06sFSyqAM5JAJbvrNcyn9kAofTfwHADn9n4+2vrBO1GpvAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Xf8zyiueSVzYrH/SCMqzBUlEOsIVDNdSSAYAHqewYEI=;
	b=ZWzEqr8DcdrOc5JwYUdduaLRyVhXYpg7UjoIWJY7j4JbeK0fL4lebf6rk/fBXxL6bKmY
	 Kb/9hTX9rZO+fU1rDEH/2RtbNGNY2ECRuPXt0TSiBc/qrnKE4L4G0+jliLRF3oe7+Up7q
	 QX/UypPm+u8xLGMIaPDLw14iypZ0Ligv8YNuBmCClnUPvD0dvizykTV2QX+xlK9duiXIa
	 rUMzkFKJXdNF4m3ke9bNY2UH6njK5r++UZruI557wIRiU2628MthgAk8mILOX8f5EFs/2
	 XCRDNhYiafF5tvlsIyzEy2WtJ22XoRmSybgGMrOn/H7Sdrh6OzSFFANs1Hz1tD9QHTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2lTo4xt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304F3606A32E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2lTo4xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21B21F00A05;
	Wed, 11 Nov 2026 18:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422435;
	bh=Xf8zyiueSVzYrH/SCMqzBUlEOsIVDNdSSAYAHqewYEI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y2lTo4xt1qJ0Gitgq8E4BADqES7JEUmrW/L1JCJzDACd+0uGSMcSmvATKI4cIVvow
	 G/QJHaO0o2Oian3aQblMpt/BPiF4UdsXj9b/yx8T/IgnCdioxxj9s9UUyx/EsZvLKM
	 SVq7cu9guT6IRDiN1LRxvq0NV8u6+UDZAtvT+bdDR1TqdCmAH9JioNg260PPzBY7S9
	 kutFteceWquwApncUStuQi3YA82++TFuaimwlKtZtjWifFDNEpWAy1GFHYfg+cXcMx
	 zjUZNJM8GE6XQGEd6CXbxR0m8xVMO9IO0D0emDTbK4FC+0VdMd3XzlHhjHAmnZe75U
	 ZiZdSbcD1pAjg==
Message-ID: <sashiko-outbox-209474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 06/13] net/mlx5e: Add data direct RX
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-7-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:34 +0000
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
- [Medium] net/mlx5e: SHAMPO header buffer double-sized in
  mlx5e_shampo_hd_per_wqe()
--

commit 65149098852b3b139560ca93742af4a582b969d5
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Add data direct RX infrastructure

This commit adds RX infrastructure for data direct mode, including a new
RQ state flag, crossing and KSM mkeys, and ICOSQ sizing for KSM UMR WQEs.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en/params.c
> index 5caf7820a136b..61a77ee77244a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
>  	bool unaligned =3D xsk ? xsk->unaligned : false;
>  	bool oversized =3D false;
> =20
> +	if (rqo && rqo->data_direct)
> +		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
> +
>  	if (xsk) {
>  		oversized =3D xsk->chunk_size < (1 << page_shift);
>  		WARN_ON_ONCE(xsk->chunk_size > (1 << page_shift));

[Severity: Medium]
Does switching data-direct SHAMPO RQs to MLX5E_MPWRQ_UMR_MODE_UNALIGNED
cause mlx5e_shampo_hd_per_wq() to double-size the SHAMPO header buffer and
overflow log_headers_buffer_entry_num at maximum ring size?

With 4KB pages, MLX5E_MPWRQ_UMR_MODE_UNALIGNED uses 16-byte KSM entries
instead of 8-byte MTT entries, which halves the WQE size from 256KB to
128KB and doubles wq_size in rq_param->rqc.  However,
mlx5e_shampo_hd_per_wqe() ignores rq_param and passes NULL for rqo:

drivers/net/ethernet/mellanox/mlx5/core/en/params.c:mlx5e_shampo_hd_per_wqe=
() {
	u16 num_strides =3D BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, NULL=
));
	u8 log_stride_sz =3D mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL);
	int pkt_per_rsrv =3D BIT(mlx5e_shampo_get_log_pkt_per_rsrv(params));
	int wqe_size =3D BIT(log_stride_sz) * num_strides;
    ...
}

Because rqo is NULL, mlx5e_shampo_hd_per_wqe() computes wqe_size for
MLX5E_MPWRQ_UMR_MODE_ALIGNED (256KB) instead of UNALIGNED (128KB), and
mlx5e_shampo_hd_per_wq() multiplies that unhalved hd_per_wqe by the
doubled wq_size from rq_param->rqc.  This allocates twice as many SHAMPO
header pages as needed, and when log_rq_mtu_frames is 13 with sw_mtu <=3D
1024, hd_per_wq doubles from 32768 to 65536, causing
order_base_2(rq->mpwqe.shampo->hd_per_wq) (16) in mlx5e_create_rq() to
overflow the 4-bit log_headers_buffer_entry_num hardware field to 0.

Passing rqo (or reading log_wqe_num_of_strides and log_wqe_stride_size
from rq_param->rqc) in mlx5e_shampo_hd_per_wqe() would compute the actual
WQE size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D6
