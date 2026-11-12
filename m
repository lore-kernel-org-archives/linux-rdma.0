Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476407;
	b=K4g3QehkUXt1AJRRE04dvBTZnhOeUO+xxLeXvHBVIqis0hmVbXFUDJB1g1Ma2Qzwd6Hu
	 eLt1xz4KAmSpCkUA86Lo2W/F4lCzV8IqTrbqZx5UoGeBw4YtiwqPSpOiZY/xyydHLAiy/
	 YURAO+mSB2NrwqOtk2ecIRci+VwOpJEnqT+nvJ0lDgUbiyFavcaSuj7JaiVOhm2I47m9f
	 66BSvM/NNCP4pkSe07blq6pCbWCuG0BYQ8nZeRxDR6/xIqooqPZ5SCuCTw572hkmJ4y7a
	 GxNitQlIwmVLAYLZ4yE//VRY23418BjfTu2975xYKQoqEh6IyAPtuLviJKAgoWbMTWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476407;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=VPC3kdHAgS+Z/zNG6D36rX2466uvBjXZFBqeDR1tCnw=;
	b=gv8r3ns117ZdGvaWEKO+fjFRjargspzk5uZcSkZiy5l/PM3COHt/sc6K2np96V94tZNy
	 p+Tv7G4bP+e192w4zC3UqKtthVt6bLykBS6s+9WMEkxuIQZuRPhvCHhrjSkNSwv5LkSW/
	 hXmRq6QBmultbHRWzhIz6sSv6EBS1NfQVLcO6W8Dm/q39iQF4QQEMTog6ivsnqGRuWEJa
	 J1VirgYSL8tvPjHS0u7ZncwjqM9k3cBxoe40f5N9y5yRcAH7BCR2O/Hasd4peZ11nINHy
	 6He3ixxezMRvw6kkV3eC7ztlKmsAesNowy5l5uObjafokr9VfUnYf0xmHn2fZXOyDqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WGYku0hU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D755D606A8BD;
	Thu, 12 Nov 2026 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WGYku0hU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C531F00A0D;
	Thu, 12 Nov 2026 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476407;
	bh=VPC3kdHAgS+Z/zNG6D36rX2466uvBjXZFBqeDR1tCnw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WGYku0hUj1J17pKbvHS8seEQinvXAHUQr+/rl+JezdESrLu4lOVwNLe+Cp0Xy5TOo
	 i7fL4PxjbeIfjVTcbqJTx0u5S7oFJP79YRJgLbLcwM7odLib6n7bdL+5IlIgWiIrKy
	 vT1eQiTUVkGXnXVLAqZ0NL5k6hzDrh1+hiYC4FWmzUAakhxu/JYZwHwITqukPZBQy9
	 Qke773tg6kB15P2mIELHYtTBn16D4y70M6DlEMzaRz25Idc7s6/Gv0/FPafugy1Pb7
	 AD3T+i4hznopyv9biCOImgGPsHoOTXKBKiAlEtvq0BvjxgFzXNxU+SRtTH+LxX5i5f
	 Yq29LELHCFduw==
Subject:
 Re: [PATCH net-next V2 06/13] net/mlx5e: Add data direct RX infrastructure
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, dtatulea@nvidia.com, erfansh@meta.com,
 gal@nvidia.com, Jacob.e.keller@intel.com, kaifengw@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, mfleming@cloudflare.com, almasrymina@google.com,
 razor@blackwall.org, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com
Date: Thu, 12 Nov 2026 09:40:05 +0000
Message-ID: <179447640550.2199510.9976355768850888899@kernel.org>
In-Reply-To: <20261110183826.2927274-7-tariqt@nvidia.com>
References: <20261110183826.2927274-7-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] A data-direct RQ's KSM UMR mkey has child entries from two
  different PDs and DMA domains.
- [Medium] mlx5e_alloc_rq() calls mlx5e_rq_alloc_data_direct_mkey() right
  after mlx5e_create_rq_umr_mkey().
- [Medium] net/mlx5e: SHAMPO header buffer double-sized in
  mlx5e_shampo_hd_per_wqe()
- [Low] Data-direct RQs are forced into MLX5E_MPWRQ_UMR_MODE_UNALIGNED
  (KSM) by mlx5e_mpwrq_umr_mode().
- [Low] mlx5e_create_umr_mkey() rejects MLX5E_MPWRQ_UMR_MODE_UNALIGNED
  when MLX5_CAP_GEN(mdev, fixed_buffer_size) is missing and logs…

--

net/mlx5e: Add data direct RX infrastructure

This commit adds the RX side infrastructure for data direct in mlx5e. It
adds a new RQ state flag and a crossing mkey over the RQ's UMR mkey. It
also creates the KSM UMR mkey in the data direct PD and sizes the ICOSQ for
the KSM UMR mode. Data direct itself is enabled in a later commit.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index 5caf7820a136b..61a77ee77244a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
>  	bool unaligned = xsk ? xsk->unaligned : false;
>  	bool oversized = false;
>  
> +	if (rqo && rqo->data_direct)
> +		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
> +

[Severity: Medium]
mlx5e_open_channel() only enables data direct together with SHAMPO,
so every data-direct RQ also allocates a SHAMPO header buffer.
Switching those RQs to UNALIGNED here changes the WQE geometry, but
the header buffer sizing doesn't seem to follow.

mlx5_rq_shampo_alloc() sizes the buffer through
mlx5e_shampo_hd_per_wq(), which calls mlx5e_shampo_hd_per_wqe(). That
helper still computes the stride geometry without rqo:

	u16 num_strides = BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, NULL));
	u8 log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL);

With rqo == NULL this uses the ALIGNED (MTT) WQE size. With 4K pages
and 16-byte KSM entries, mlx5e_mpwrq_log_wqe_sz() is one smaller for
the data-direct RQ. Each WQE therefore holds half as many strides and
half as many header reservations.

The log_wq_sz in rq_param->rqc, however, was computed with rqo through
mlx5e_mpwqe_get_log_rq_size(), so the ring has twice as many WQEs.
mlx5e_shampo_hd_per_wq() then multiplies the unhalved hd_per_wqe by
the doubled wq_size, and hd_per_wq comes out twice as large as needed.

Apart from allocating twice the header pages and DMA mappings, this
looks like it can overflow the hardware field. Take an 8192 entry RX
ring with sw_mtu <= 1024. hd_per_wq would go from 32768 to 65536, and
mlx5e_create_rq() would write order_base_2(hd_per_wq) = 16 into the
4-bit log_headers_buffer_entry_num field, which truncates to 0. The
device would then be told the header buffer has one entry while the
driver posts headers across 65536 of them.

Should mlx5e_shampo_hd_per_wqe() take the RQ's rqo
(cparam->rq_opt), so it sees the same UMR mode as the RQ?
mlx5e_shampo_get_log_cq_size() already passes rqo to the same helpers.

[Severity: Low]

This puts data-direct RQs under the KSM limits. Is there anything that
checks the ring size against those limits, the way mlx5e_mpwrq_validate_xsk()
does for XSK?

mlx5e_ethtool_get_ringparam() still computes rx_max_pending from the
MLX5E_MPWRQ_UMR_MODE_ALIGNED geometry. Its comment says only XSK RQs may
clamp the queue length. mlx5e_mpwqe_get_log_rq_size() makes the same
assumption:

	if (WARN_ON_ONCE(params->log_rq_mtu_frames > log_pkts_per_wqe + max_log_rq_size))
		return max_log_rq_size;

KSM entries are twice the size of MTT entries, and max_num_entries is
bounded by 1 << log_max_klm_list_size. Take a device with
log_max_klm_list_size <= 15, an MTU around 9000 and an RX ring of 8192.
log_pkts_per_wqe would be 3 and max_log_rq_size would be 9, so 3 + 9 < 13.

Would that trigger the WARN_ON_ONCE() and quietly shrink the RX ring below
the size ethtool reports? Neither mlx5e_open_channel() nor the later
set_pflag_data_direct() appears to check for this. The comments in both
places would also no longer match the code.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 96b521d8bed35..cee73f3b7a997 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -425,7 +425,7 @@ static u8 mlx5e_mpwrq_access_mode(enum mlx5e_mpwrq_umr_mode umr_mode)
>  static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
>  				 u32 npages, u8 page_shift, u32 *umr_mkey,
>  				 dma_addr_t filler_addr,
> -				 enum mlx5e_mpwrq_umr_mode umr_mode,
> +				 enum mlx5e_mpwrq_umr_mode umr_mode, u32 pdn,
>  				 u32 xsk_chunk_size)
>  {

[Severity: Low]

Data-direct RQs now use UNALIGNED mode, so they hit the existing
fixed_buffer_size check at the top of this function:

	if ((umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED ||
	     umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE) &&
	    !MLX5_CAP_GEN(mdev, fixed_buffer_size)) {
		mlx5_core_warn(mdev, "Unaligned AF_XDP requires fixed_buffer_size capability\n");
		return -EINVAL;
	}

On a device without fixed_buffer_size, opening a data-direct channel would
fail with -EINVAL and a warning about AF_XDP, which the user never set up.

Should the message be updated? Alternatively, could fixed_buffer_size be
checked before data direct is enabled?

[ ... ]

> @@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
>  			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
>  			      max_num_entries);
>  
> +	pdn = dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
>  	err = mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
>  				    &umr_mkey, rq->wqe_overflow.addr,
> -				    rq->mpwqe.umr_mode, xsk_chunk_size);
> +				    rq->mpwqe.umr_mode, pdn,
> +				    xsk_chunk_size);

[Severity: Medium]

With dd set, the parent KSM mkey is now created in
mdev->data_direct->pdn. However, mlx5e_create_umr_mkey() still fills every
UNALIGNED entry with the regular NIC mkey and the filler page:

mlx5e_create_umr_mkey() {
    ...
	case MLX5E_MPWRQ_UMR_MODE_UNALIGNED:
		ksm = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
		for (i = 0; i < npages; i++)
			ksm[i] = (struct mlx5_ksm) {
				.key = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey),
				.va = cpu_to_be64(filler_addr),
			};
    ...
}

hw_objs.mkey belongs to hw_objs.pdn. filler_addr is rq->wqe_overflow.addr,
which is mapped with dma_map_page(rq->pdev, ...) against the NIC function.

At runtime, mlx5e_alloc_rx_mpwqe() only rewrites inline_ksms[0] through
inline_ksms[pages_per_wqe - 1] with ksm_child_mkey_be.
mlx5e_mpwrq_mtts_per_wqe() returns ALIGN(pages_per_wqe + 1, ...), so each
WQE has at least one overflow entry that is never rewritten. That entry
still points at hw_objs.mkey.

Does this leave the data-direct KSM mkey with child mkeys from two
different PDs? If the device checks that an indirect mkey and its child
mkeys share a PD, could a packet larger than MTU that writes into the
overflow slot cause a local protection error and put the RQ into error
recovery? The filler page is supposed to absorb such writes.

For comparison, mlx5_ib creates its data-direct KSM mkey in
data_direct->pdn. _mlx5r_umr_update_mr_pas() fills its entries only with
data_direct->mkey or mkey_ro, or with key=0/va=0 on ZAP.

This code looks unchanged at the end of the series.

[ ... ]

> @@ -975,10 +1050,14 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>  		if (err)
>  			goto err_rq_drop_page;
>  
> -		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
> +		err = mlx5e_rq_alloc_data_direct_mkey(rq);
>  		if (err)
>  			goto err_rq_mkey;

[Severity: Medium]

This creates the crossing mkey right after mlx5e_create_rq_umr_mkey().
At that point the crossed UMR mkey is still in the free state, because
mlx5e_create_umr_mkey() sets:

	MLX5_SET(mkc, mkc, free, 1);

The crossed mkey only becomes valid after the first UMR WQE completes on
the ICOSQ, once the channel is activated.

The other in-tree crossing user is reg_user_mr_dmabuf_by_data_direct() in
drivers/infiniband/hw/mlx5/mr.c, and it uses the opposite order. First,
reg_user_mr_dmabuf() enables the crossed KSM mkey through UMR. Only then is
reg_create_crossing_vhca_mr() called.

Will CREATE_MKEY with MLX5E_MKC_ACCESS_MODE_CROSSING always accept a
crossed mkey that is still free? If firmware checks the crossed mkey's
state at creation time, mlx5e_create_crossing_vhca_mkey() would fail here
for every data-direct RQ.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
