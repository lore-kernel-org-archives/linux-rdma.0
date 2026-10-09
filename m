Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD174DAF8F
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552666; cv=none; b=OucsXDTypF8agJ1CYua0+tfw8dyYXAs+4exEuywVtYZcH5QQhZxtE+isebPJ4Lnv8lvBT19uBQUA9mLXXdqywsmBGGmxAT/IhDnd5ch9tv+UKakQUk2/1c0wjksN3+zV+KSlRC70RaYKO9sih0COAayhD+NuZa1Au4G8eLI63O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552666; c=relaxed/simple;
	bh=IFBuYU79h7eF5kXTMRlvlBM3rhuify99NwJE6DNzmOQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ddqDQ2KDNo2eJ3e8rWFodleNbSiedmYxPWUl707VltS+xYni4ciBP3WAiY5FcT5cb+tQngj3VkkHqKC6RxSOzjDp0VDoy4JGW2KwemDsfGhpX4iuEjBcYI1XobdSa4MUH3vdqwEeb4rgOJp59F7fL9UnQNDsKvAC2l+z9VuF+dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtaMnBPa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtaMnBPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52C1F00893;
	Fri,  9 Oct 2026 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552664;
	bh=1jN8ak9Pfi9ytuhMr+opzU+N7856moNB8Lm2AqHalzk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FtaMnBPax440ROrKug0YpB6jq2WlEtKIWgpJmQjpQJ06LeWRbWs7vfQVhxsKUldkZ
	 hTAP9EUA+UfIt20FGSc9X8bwL9GiJQCYOQVf++TKVuxw7VWxslxl8tB3ojTRKJiQaz
	 QYl2Kj6afu3PueTGLoqEqFnpeFTkaVF5HLqBDec/bCP8CVwg2H2T1fMHI14meRiiKy
	 SG3/vlDixky7ENAwgp6SSQXDEzzRffuc59TbYu3bqW5MO/RVte9Q7krbWwP6ufI5h0
	 YQFRCPuqy+a068yBtSBOoShCCgUPRlabIK/zPEVix6LQaPWLceZLyqVdSAo6xiHmSC
	 ioj6rjmP6Gucw==
Message-ID: <sashiko-outbox-165639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/10] net/mlx5e: Add data direct RX
 infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-6-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5e: data direct with SHAMPO disabled causes peer-to-peer DM=
A to use host memory addresses
- [High] net/mlx5e: MKey PD mismatch for wqe_overflow causes HW protection =
fault
--

commit 6520b18194c553450bad712fcea9bc323c0c23ce
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5e: Add data direct RX infrastructure

This commit adds RX infrastructure for data direct, which enables
peer-to-peer DMA between the NIC and another device like a GPU. It
introduces a new RQ state flag, a crossing mkey, and a KSM mkey
pointing to the crossed mkey.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index b86c7b52774a0..e0d46e067c720 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
[ ... ]
> @@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_cor=
e_dev *mdev, struct mlx5e_rq
>  			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
>  			      max_num_entries);
> =20
> +	pdn =3D dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
>  	err =3D mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
>  				    &umr_mkey, rq->wqe_overflow.addr,
> -				    rq->mpwqe.umr_mode, xsk_chunk_size);
> +				    rq->mpwqe.umr_mode, pdn,
> +				    xsk_chunk_size);
>  	rq->mpwqe.umr_mkey_be =3D cpu_to_be32(umr_mkey);

[Severity: High]
Could this lead to a hardware protection fault due to a protection domain
mismatch?

When data direct is enabled, the indirect umr_mkey is explicitly created in
the data direct pdn. However, the gap (padding) entries for oversized
packets are initialized in mlx5e_create_umr_mkey() using an mkey that belon=
gs
to the hardware objects protection domain:

ksm[i] =3D (struct mlx5_ksm) {
    .key =3D cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey),
    .va =3D cpu_to_be64(filler_addr),
};

Because mlx5e_alloc_rx_mpwqe() issues a UMR WQE that only overwrites the va=
lid
pages_per_wqe entries, these gap entries between WQEs remain untouched. If =
an
oversized packet overflows into the gap, the hardware will access the KSM a=
nd
encounter a mismatch between the indirect umr_mkey and the target
hw_objs.mkey.

Would this cause the hardware to drop the queue into an error state,
resulting in a potential denial of service from remotely sent oversized
packets?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
> index 9e1224930e067..c992da08caaee 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
[ ... ]
> @@ -669,9 +669,15 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq,=
 u16 ix)
>  			goto err_unmap;
> =20
>  		addr =3D page_pool_get_dma_addr_netmem(frag_page->netmem);
> -		umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
> -			.ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
> -		};
> +		if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
> +			umr_wqe->inline_ksms[i] =3D (struct mlx5_ksm) {
> +				.key =3D rq->mpwqe.ksm_child_mkey_be,
> +				.va  =3D cpu_to_be64(addr),
> +			};
> +		else
> +			umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
> +				.ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
> +			};
>  	}

[Severity: High]
Can this write out of bounds and corrupt peer device memory?

If the administrator enables data direct but later disables hardware GRO
(SHAMPO) via ethtool, or if it is otherwise disabled, mlx5e_alloc_rq() does
not set PP_FLAG_ALLOW_UNREADABLE_NETMEM during page pool creation.

Without this flag, page_pool_create() ignores the dmabuf memory provider
and allocates standard host memory pages instead. Here in
mlx5e_alloc_rx_mpwqe(), the function fetches a host page, retrieves its host
DMA address, and configures the hardware using the data direct crossing mkey
along with the host DMA address as the virtual address (va).

Since the crossing mkey points to the peer device memory (such as a GPU),
the hardware will treat the large host DMA address as an offset into the
peer memory. Will this lead to out-of-bounds peer-to-peer DMA writes that
corrupt the GPU memory or trigger an IOMMU fault?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D5
