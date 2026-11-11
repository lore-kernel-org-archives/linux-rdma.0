Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404806;
	b=F9XEL1SBbkm591YF+YxW2UDglVUdRi/Jwus2Tto1RP95imc9i4qAf5g47B+D7KVLjt+m
	 C2oGBbhtPGkqWSbWhnAJP6x107VcwctZkpEpkEQrTvakkgRhhw2RFSGU9+YCwCzdzbqkD
	 qcJrAgMY/DDnsiIQG3684QBV4NxHF7xQclGyVG/P5kO65+oOhTC960KqKuN5ACa1+vfpG
	 Nn2b+eSrnp+yjEdqeLYNxbEYbC/MDRnX7sKvVMXRo9HZzGBh7THC8ssI5Hi7QbfepLsKV
	 83jzABgjBicilog/adOTijoEN74nCJ/psQpy/sq+h0n7DolmbgzyfCb29urC9P6QVbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404806;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2/EPFI1Izp8BpQhwlR0gN+CuLUJt9LOt+K9IPgEdZGc=;
	b=3LP3M7LgFnFypTlTsrp184zpbk6XAMTeIOAkptKhfNyIZ2AvOpVIx3bjlaHwpOxkt1Ug
	 Noz9qH7ez94YMT4AXOMxrBnqNEvuTslE9GNQisuwy5wNXsRiGt2Plpu1kttmsQhDCuYHu
	 cdKHXaX0NbeycYacyVv4LFVwGAN/LHnBCWKjaLcrq8QPnk0jt6QGI/jkHlke7FxyeXEaj
	 +BHp7gq0SnK9xJVuQCVgFx7f3cUxWXP/6trm6gtljKQ1t/CiOyNqECg8GS8IYZYVgQQsZ
	 xmAirYAyXF/7pt5Z/aPUv3f30LT8y2zh2bXcYulpuPRDS8YmTY3RJxJOeqAMSiNseDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JahGOa6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6CB606A332
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JahGOa6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048CC1F00A06;
	Wed, 11 Nov 2026 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404806;
	bh=2/EPFI1Izp8BpQhwlR0gN+CuLUJt9LOt+K9IPgEdZGc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JahGOa6gwmcKUCbrIM+A8XBveARBs7Lj0Jr5IcrbalrBFZWOoCExWEyMZLW4Ds6mJ
	 GAwjwNplZmq6zHTnunbGUq1A6271kM2HuuERFnO0Vz7y4js1lv168QBJJOEexpu68U
	 EyuGpaWXFUsZNEdp1C80nJ+4y0PMycuCHD8+qfeZfvsNWHG6qMG1AMdlJyZV6USBZn
	 ThyLTkCQQUA3ioKk7FRwbLwa+AfWAD3//SsiQ3RMqMYeULv9A0k9sRWL0kIRN4nBVm
	 x6PvJkS0ZSGoPGWyXhBmvwiGGCEhM8jImCMCb2BjdLwPkHJSbfjnDVvBqUPEQ4LKGu
	 SWuKw4aW9+ayA==
Message-ID: <sashiko-outbox-209088@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 03/24] net/mlx5: Add capability filtering
 in adversarial mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-4-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap
  read
- [High] net/mlx5: unclamped max_tc in mlx5_adversarial_filter_general()
  overflows stack
- [Medium] net/mlx5: unclamped log_max_*_list caps in
  mlx5_adversarial_filter_general()
--

commit 3a4fed029c43a049522bf33112212c850561f40e
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5: Add capability filtering in adversarial mode

This commit introduces capability filtering and range validation for HCA
capabilities queried from firmware when running in adversarial mode.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> new file mode 100644
> index 0000000000000..023f996bc95ea
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> @@ -0,0 +1,381 @@
[ ... ]
> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, vo=
id *dst,
> +					   void *src)
> +{
[ ... ]
> +	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dcbx);

[Severity: High]
Should max_tc be clamped to IEEE_8021QAZ_MAX_TCS (8)?

max_tc is a 4-bit field, so untrusted firmware can report up to 15 and make
mlx5_max_tc() return up to 14.  When qos and ets are also enabled,
mlx5e_ets_init() and mlx5e_dcbnl_ieee_setets_core() run during mlx5e probe
and loop up to mlx5_max_tc() + 1, overflowing the 8-entry arrays in struct
ieee_ets, tc_group[], tc_tx_bw[], and qetc_reg on the stack:

drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c:mlx5e_ets_init() {
	ets.ets_cap =3D mlx5_max_tc(priv->mdev) + 1;
	for (i =3D 0; i < ets.ets_cap; i++) {
		ets.tc_tx_bw[i] =3D MLX5E_MAX_BW_ALLOC;
		ets.tc_tsa[i] =3D IEEE_8021QAZ_TSA_VENDOR;
		ets.prio_tc[i] =3D i;
	}
...
}

[ ... ]

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eq_overrun_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, invalid_command_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, quota_exceeded_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_flow_counter_bulk);

[Severity: High]
Can an unclamped log_max_flow_counter_bulk cause an out-of-bounds heap read
past fc_stats->bulk_query_out?

log_max_flow_counter_bulk is an 8-bit field.  During mlx5_init_fc_stats(),
get_init_bulk_query_len() shifts 1 by log_max_flow_counter_bulk as a signed
int:

drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c:get_init_bulk_query_l=
en() {
	return min_t(int, MLX5_INIT_COUNTERS_BULK,
		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
}

A value >=3D 32 shifts out of bounds, and 31 overflows to INT_MIN
(-2147483648).  mlx5_cmd_fc_get_bulk_query_out_len() then multiplies
bulk_len by MLX5_ST_SZ_BYTES(traffic_counter) (16UL) and truncates the
result to int, returning 16 bytes for fc_stats->bulk_query_out while
fc_stats->bulk_query_len is set to -2147483648.  When flow counters are
queried in mlx5_fc_stats_query_all_counters(), update_counter_cache()
indexes flow_statistics[] past the 16-byte buffer.

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_sq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_tir);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, basic_cyclic_rcv_wqe);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_rqt);
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, log_max_rqt_size, 0, 13);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_bar_uar_access);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_odp_page_fault);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce_rw_supported);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_wq_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_state);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_vlan_list);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_mc_list);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_current_uc_list);

[Severity: Medium]
Can log_max_vlan_list, log_max_current_mc_list, or log_max_current_uc_list
overflow the signed shift in mlx5e_vport_context_update_vlans() and
mlx5e_vport_context_update_addr_list()?

All three are 5-bit fields.  When any of them is 31, the 1 << 31 computation
in mlx5e_vport_context_update_vlans() or
mlx5e_vport_context_update_addr_list() overflows max_list_size or max_size
to INT_MIN:

drivers/net/ethernet/mellanox/mlx5/core/en_fs.c:mlx5e_vport_context_update_=
vlans() {
...
	max_list_size =3D 1 << MLX5_CAP_GEN(fs->mdev, log_max_vlan_list);

	if (list_size > max_list_size) {
		fs_warn(fs, "netdev vlans list size (%d) > (%d) max vport list size, some=
 vlans will be dropped\n",
			list_size, max_list_size);
		list_size =3D max_list_size;
	}

	vlans =3D kvcalloc(list_size, sizeof(*vlans), GFP_KERNEL);
...
}

list_size (or size) is then clamped to INT_MIN and passed as a huge size_t
to kvcalloc() or kcalloc() without __GFP_NOWARN, triggering an allocator
WARN_ON_ONCE and failing VLAN and MAC filter updates.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D3
