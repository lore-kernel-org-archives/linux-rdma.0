Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AA72931EE;
	Mon, 12 Oct 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816133; cv=none; b=uFrh4XMjHHDk4sV7OtoYYqKioL6QGZ3Bl3pbSwPN7419Z3TDTf7ZVYGvbHlUPAbzTveOv/ZsQHvg8LCFFOXFr3zG62/CaVUNCQjrPtputTeo/i9eRxI23+jwMzDIRUQoFgAMf0f6P5Bp8E2FOXK+sKRkoKXZrhszqmb/poqo54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816133; c=relaxed/simple;
	bh=W8F09HwZaN2VcoEOoluLXavulXG4gK/deXy/e0DTwnY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qbp3cp1oWlxwiQNTfgebWHwTzMj63baN66mDwt+ELhOSdnEzSW43KRQbmSGXYLwsHo3VE1YVaAP9kYmY4vU8EjL1HtyHwGaZ5uG1P/1miakp/xNKR/DYRhXvbZrXGq4xaUAHqqCiRunAR28G75W90agridHfeb2WNV6wNRlBvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFiU0ThJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFiU0ThJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18E31F0089B;
	Mon, 12 Oct 2026 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816131;
	bh=x1Q6QCjec7r5U+8CnAWJzD2ftt/gIfzFTW7HZxHaOuE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FFiU0ThJXS7oaMjVL4GKkXtb/vAg9t0eiAQ1cfx5MFrA52EpQpHeexNJjXej4jHWQ
	 sdZBUaimhi/PzbSE/XSXN3jru8AyHUiHgjCGnip2/uKIGfjXArIJ99ieljFDXQy5Kq
	 MT5tLp93T2ZRjdv4FNk6yNiQkojqp7UMPb7xS8dEMTQoKMmyy0khpiEmW3GIY/skZB
	 8FV06ybm2uhbs1HCSUVlvisErt82TwFBXj1oNvAZ4BvrtyvR4dlLRmfueKBprFB73U
	 5SaGoGpcdV5UOP7ABWNrh1++0eBCLD+ohvPaww1piBchLVBgBhN/AXDO7RuRKrt/HP
	 26juPhFZB8MQg==
Subject:
 Re: [PATCH net-next 05/10] net/mlx5e: Add data direct RX infrastructure
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, byungchul@sk.com, cjubran@nvidia.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, shivajikant@google.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com, yuehaibing@huawei.com,
 bobbyeshleman@gmail.com
Date: Mon, 12 Oct 2026 14:42:09 +0000
Message-ID: <179181612947.434549.5778912893397825826@kernel.org>
In-Reply-To: <20261008132815.654147-6-tariqt@nvidia.com>
References: <20261008132815.654147-6-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In data-direct mode the ICOSQ is too small for the UMR WQEs
  posted to it, so the ring overruns.
- [Medium] In data-direct mode, mlx5e_create_rq_umr_mkey() now creates
  the KSM UMR mkey in mdev->data_direct->pdn.
- [Medium] The data-direct RX path dereferences the per-channel
  mdev->data_direct without a NULL check: ->pdn in…
- [Low] The commit message describes the mkey chain incorrectly.
- [Low] Data-direct RQs now always use the UNALIGNED (KSM) UMR mode, but
  nothing checks that mode's requirements before the channel is opened.

--

net/mlx5e: Add data direct RX infrastructure

This commit adds the RX-side infrastructure for data direct mode. It adds
an RQ state flag and creates a crossing mkey that the RQ WQEs use as their
lkey. It also switches data direct RQs to a KSM UMR mkey in the data
direct PD, whose entries point to the data direct mkey.

> For data direct to work on the RX path, the RQ will use a KSM mkey whose
> entries will point to the crossed mkey. This is necessary to enable DMA
> from the NIC to the other device.

[ ... ]

> - Create KSM mkey and in data direct PD and make it point to the
>   crossed mkey.

[Severity: Low]
This isn't a bug, but does this description match the code?

In mlx5e_rq_alloc_data_direct_mkey(), the KSM UMR mkey itself is passed
as the crossed mkey:

	umr_mkey = be32_to_cpu(rq->mpwqe.umr_mkey_be);
	...
	return mlx5e_create_crossing_vhca_mkey(mdev, umr_mkey,

The KSM entries written in mlx5e_alloc_rx_mpwqe() point to
mdev->data_direct->mkey or ->mkey_ro (ksm_child_mkey_be), not to the
crossed mkey.

So the chain in the code looks like:

  RQ lkey -> crossing mkey (hw_objs.pdn)
          -> crossed KSM UMR mkey (data_direct->pdn)
          -> data direct mkey

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index 5caf7820a136b..88b4cd5497d88 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
>  	bool unaligned = xsk ? xsk->unaligned : false;
>  	bool oversized = false;
>  
> +	if (rqo && rqo->data_direct)
> +		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
> +

[Severity: Low]
Data direct RQs now always use the UNALIGNED (KSM) mode. Is this mode
validated anywhere before the channel is opened?

mlx5e_mpwrq_validate_regular() still checks only the ALIGNED mode:

	enum mlx5e_mpwrq_umr_mode umr_mode = mlx5e_mpwrq_umr_mode(mdev, NULL);

set_pflag_data_direct(), added later in the series, doesn't check
fixed_buffer_size either. The first check happens during
mlx5e_alloc_rq(), in mlx5e_create_umr_mkey():

	mlx5_core_warn(mdev, "Unaligned AF_XDP requires fixed_buffer_size capability\n");
	return -EINVAL;

On a device without fixed_buffer_size, a data direct RQ with no AF_XDP in
use would fail channel open with this AF_XDP-specific message.

The KSM limit derived from log_max_klm_list_size isn't checked up front
either. mlx5e_create_rq_umr_mkey() only warns when num_entries is larger
than max_num_entries, and then continues.

[ ... ]

> @@ -1296,12 +1299,14 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
>  int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
>  			      struct mlx5e_params *params,
>  			      struct netdev_queue_config *qcfg,
> +			      bool data_direct,
>  			      struct mlx5e_channel_param *cparam)
>  {
>  	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
>  	int err;
>  
>  	cparam->rq_opt.qcfg = qcfg;
> +	cparam->rq_opt.data_direct = data_direct;
>  
>  	err = mlx5e_build_rq_param(mdev, params, &cparam->rq_opt, &cparam->rq);
>  	if (err)

[Severity: High]
The RQ parameters are now built with rq_opt.data_direct set, so the RQ
geometry is computed for KSM. Is the ICOSQ still sized for the MTT layout?

The next call, mlx5e_build_icosq_log_wq_sz(), does:

	/* UMR WQEs for the regular RQ. */
	wqebbs = mlx5e_mpwrq_total_umr_wqebbs(mdev, params, NULL);

With rqo == NULL, mlx5e_mpwrq_umr_mode() returns the ALIGNED mode, so the
budget assumes 8-byte MTT entries. KSM entries are 16 bytes. That halves
the maximum pages per WQE in mlx5e_mpwrq_log_wqe_sz(), which doubles the
RQ WQE count from mlx5e_mpwqe_get_log_rq_size(). Where the log WQE size
is capped at 17 (ECPF), the per-UMR WQEBB count grows instead.

With defaults (MTU 1500, log_rq_mtu_frames=10, 64-byte cachelines), the
MTT budget is 8 WQEs * 10 WQEBBs = 80. That rounds up to a 128-WQEBB
ICOSQ. The KSM RQ has 16 WQEs, so the first fill does:

mlx5e_post_rx_mpwqes()
  mlx5e_alloc_rx_mpwqe()   /* 15 times, 10 WQEBBs each */

That posts about 150 WQEBBs plus NOP padding in one batch before the
doorbell. MTU 9000 has the same problem: about 1270 WQEBBs are needed
for a 1024-WQEBB ICOSQ.

Neither mlx5e_post_rx_mpwqes() nor mlx5e_icosq_get_next_pi() checks for
free space. Can the producer then wrap onto UMR WQEs and sq->db.wqe_info[]
entries that the hardware hasn't completed yet?

This still seems to be the case at the end of the series. There,
mlx5e_build_icosq_log_wq_sz() still passes NULL, and the commit
"net/mlx5e: Enable the data direct netdev feature" makes this path
reachable.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index b86c7b52774a0..e0d46e067c720 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

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
The KSM UMR mkey is now created in mdev->data_direct->pdn. However,
mlx5e_create_umr_mkey() still fills every UNALIGNED entry with a child
key from the regular PD:

	case MLX5E_MPWRQ_UMR_MODE_UNALIGNED:
		ksm = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
		for (i = 0; i < npages; i++)
			ksm[i] = (struct mlx5_ksm) {
				.key = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey),
				.va = cpu_to_be64(filler_addr),
			};

mlx5e_alloc_rx_mpwqe() rewrites only the first pages_per_wqe entries of
each WQE with ksm_child_mkey_be.

mlx5e_mpwrq_mtts_per_wqe() reserves extra entries per WQE
(ALIGN(pages_per_wqe + 1, 4)) to absorb hardware write overflow. These
are never rewritten, so they keep hw_objs.mkey.

That seems to be the reason for moving the UMR mkey into the data direct
PD in the first place. If the hardware requires KSM child mkeys to be in
the same PD as the parent, would an oversized frame that reaches these
overflow entries cause a protection error? That would mean an RQ error
CQE instead of a harmless write to the filler page.

[ ... ]

> @@ -2873,7 +2958,11 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
>  		goto err_free;
>  	}
>  
> -	err = mlx5e_build_channel_param(mdev, params, qcfg, cparam);
> +	data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
> +		      netif_rxq_has_unreadable_mp(netdev, ix);
> +
> +	err = mlx5e_build_channel_param(mdev, params, qcfg, data_direct,
> +					cparam);

[Severity: Medium]
data_direct is decided here from the netdev-wide pflag and
netif_rxq_has_unreadable_mp(). However, mdev comes from
mlx5_sd_ch_ix_get_dev(priv->mdev, ix), which can be a Socket-Direct
secondary PF. Can mdev->data_direct be NULL for this channel?

The RQ allocation path dereferences it without a check:

mlx5e_alloc_rq()
  mlx5e_create_rq_umr_mkey()
    pdn = dd ? mdev->data_direct->pdn : ...
  mlx5e_rq_alloc_data_direct_mkey()
    mdev->data_direct->mkey_ro_valid ? ...

mlx5_data_direct_init() leaves mdev->data_direct NULL when
mlx5_data_direct_supported() is false. set_pflag_data_direct(), added
later in the series, only checks priv->mdev.

mlx5e_queue_get_dma_dev() already handles a NULL ch->mdev->data_direct
through mlx5_data_direct_get_dev(), so that case seems to be expected.

Suppose the primary PF supports data direct and a secondary PF does not.
Would binding devmem to a queue owned by the secondary oops in
mlx5e_create_rq_umr_mkey()?

This can't be reached in this commit. It becomes reachable with the
commit "net/mlx5e: Enable the data direct netdev feature".

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008132815.654147-1-tariqt%40nvidia.com
