Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810623;
	b=f1Fyw/laJMs/EUEgFZtgaDLRi4G4D9UmsAINJDMrRQIjT3bXRAqnwoPaqcyZk9itpKk+
	 PqVMag2fyq7zeH6/CSghnqIxOo/Hb7S6mjEkkhK3m7lzoTGRnTOIz3+BGI6uaV02kKsPr
	 19y76C7j3suix4girv2QXCZiV8ANvjAVzDiCCXh7Yj0D9gtYPaSMwWGvcpWBcd89i7PWJ
	 WAOx3IrwqF1f5lnJ9NAEzYvWKNDCFMxNwismILRBbn0ZtgHXSmqxsKdu1m73tt4B6CXYZ
	 /vvYtajmnqmO44geo0DUFuBzRZPxDmNY70dkc53OxBfPHTbxkf0kawtKEL/6hi1bChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810623;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j99mLmJlt161qYFKOyHyQiOyN3cwIEmMY2+jNmDUIc0=;
	b=OvzlNPgg3ThMzzp9iVaYzV+LkY3Oz5HDDOpaoavI3GSo4mIQj3yn6nIiFlW1Yh+IEWbf
	 LodUYpOHwVxLbnYgCcNNrdh4oD/L2dQGB0o9eeYsct0d1Zt4QoEjFySnZugehx3idfW9R
	 nGHsvLW+l1pB5j4A3LfMGDdlCNgq+C+SqQVls3qcgcUDtSm3zbuRqIEvAHCMEIyoIb0d2
	 MLcfQi/cOrNxiLcAHQs0jhMAHDwblpbAul4eI993fxnwVf81ADV8zXj3aTagg8KaJQx+/
	 IS/LL9Qku90PkZXKhAuziasZ30YyeRKnx6fQ0WLemR7SML+BUo8ffYHpWnqSqhwp+mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Z70MWgi/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF4606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z70MWgi/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A2F1F00919;
	Wed,  4 Nov 2026 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810622;
	bh=j99mLmJlt161qYFKOyHyQiOyN3cwIEmMY2+jNmDUIc0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z70MWgi/xIJjpY1iCFpDMGWWR0Q3ZKBiSl+JixzV4iRqSOjcPHkU/z03IweB+sCfu
	 AK0e9MSiDRaUVaRfJJTXexDDsRA4FYYDxjAxC0m0c+nstmYgExFRjjB18YBfw2kc48
	 ZkEBvFcTczpYAKppzAx3rCo7hBuQRxcBdD8pY5WamnZdzlGDfqwFodZyH00nMAH5l1
	 yyML+urtsSRheP0ZGcD+SyAf9v1qbAeg6/Dz5eE0NfL2C99pab7WwRSbnATeUIIMZu
	 jN8dB0zwtcMrNVKBIeQsTG+SXdXpDKVPBmjGQGiRIOrZQd96i71RjZcgv1UZeU75ZQ
	 QwqxlecZtiUlA==
Message-ID: <sashiko-outbox-197656@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 03/23] net/mlx5: Add capability filtering in
 adversarial mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-4-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-4-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap read
- [High] net/mlx5: unchecked minimum EQ caps cause divide-by-zero in alloc_=
cpu_rmap()
- [Medium] net/mlx5: incomplete log_min_mkey_entity_size check in caps_filt=
er.c
- [Medium] net/mlx5: unclamped log_max_*_list caps overflow signed shift in=
 en_fs.c
--

commit 8f36be5a60064c165f291709b6cbba37c28f527e
Author: Dragos Tatulea <dtatulea@nvidia.com>

net/mlx5: Add capability filtering in adversarial mode

This commit introduces capability filtering in adversarial mode by clearing
firmware capabilities by default and selectively allowing, clamping, or
validating fields in current and max HCA capabilities.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> new file mode 100644
> index 0000000000000..67b2603397450
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> @@ -0,0 +1,381 @@

[ ... ]

> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, vo=
id *dst,
> +					   void *src)
> +{
> +	int err;
> +
> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));

[ ... ]

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eq_overrun_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, invalid_command_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, quota_exceeded_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_flow_counter_bulk);

[Severity: High]
Should log_max_flow_counter_bulk be clamped or range-checked here?

During initialization, mlx5_init_once() -> mlx5_fs_core_alloc() ->
mlx5_init_fc_stats() calls get_init_bulk_query_len():

drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c:get_init_bulk_query_l=
en() {
	return min_t(int, MLX5_INIT_COUNTERS_BULK,
		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
}

Because log_max_flow_counter_bulk is an 8-bit field, if an untrusted device
reports 31, (1 << 31) overflows a signed 32-bit int to INT_MIN (-2147483648=
),
and get_init_bulk_query_len() returns -2147483648.

Then mlx5_fc_stats_bulk_query_buf_realloc() passes that negative bulk_len to
mlx5_cmd_fc_get_bulk_query_out_len():

drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c:mlx5_cmd_fc_get_bulk_query=
_out_len() {
	return MLX5_ST_SZ_BYTES(query_flow_counter_out) +
		MLX5_ST_SZ_BYTES(traffic_counter) * bulk_len;
}

Since MLX5_ST_SZ_BYTES(traffic_counter) is 16UL (size_t), multiplying 16UL =
by
(size_t)(-2147483648) produces 0xfffffff800000000UL, whose lower 32 bits are
0. Truncating the result to int returns out_len =3D 16.

kvzalloc(16, GFP_KERNEL) then succeeds while fc_stats->bulk_query_len is set
to -2147483648. When mlx5_fc_stats_work runs
mlx5_fc_stats_query_all_counters() -> update_counter_cache(), could this re=
ad
flow_statistics[index] out of bounds past the 16-byte fc_stats->bulk_query_=
out
buffer?

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
Can unclamped values in log_max_vlan_list, log_max_current_mc_list, and
log_max_current_uc_list overflow the signed shifts in en_fs.c?

In drivers/net/ethernet/mellanox/mlx5/core/en_fs.c,
mlx5e_vport_context_update_vlans() computes:

	max_list_size =3D 1 << MLX5_CAP_GEN(fs->mdev, log_max_vlan_list);

	if (list_size > max_list_size) {
		fs_warn(fs, "netdev vlans list size (%d) > (%d) max vport list size, some=
 vlans will be dropped\n",
			list_size, max_list_size);
		list_size =3D max_list_size;
	}

	vlans =3D kvcalloc(list_size, sizeof(*vlans), GFP_KERNEL);

and mlx5e_vport_context_update_addr_list() similarly computes:

	max_size =3D is_uc ?
		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_uc_list) :
		1 << MLX5_CAP_GEN(fs->mdev, log_max_current_mc_list);

Since these three capabilities are 5-bit fields (0..31), if an adversarial
device reports 31, (1 << 31) overflows a signed 32-bit int to INT_MIN
(-2147483648). The comparison list_size > max_list_size (or size > max_size)
then evaluates to true, setting the count to -2147483648 and passing
(size_t)(-2147483648) to kvcalloc() and kcalloc() without __GFP_NOWARN.

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sq_ts_format);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_ts_format);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, steering_format_version);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, create_qp_start_hint);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ats);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cross_vhca_rqt);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_uctx);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_eqs);

[Severity: High]
What happens if the EQ capabilities (log_max_eq, max_num_eqs, or
max_num_eqs_24b in mlx5_adversarial_filter_general_2()) result in a maximum=
 EQ
count less than or equal to MLX5_MAX_ASYNC_EQS?

mlx5_max_eq_cap_get() derives the maximum device EQs from max_num_eqs_24b,
max_num_eqs, or (1 << log_max_eq). During mlx5_load() ->
mlx5_eq_table_create(), get_num_eqs() calculates:

drivers/net/ethernet/mellanox/mlx5/core/eq.c:get_num_eqs() {
	...
	num_eqs =3D min_t(int, mlx5_irq_table_get_num_comp(eq_table->irq_table),
			max_dev_eqs - MLX5_MAX_ASYNC_EQS);
	...
}

If an untrusted device reports max_dev_eqs =3D=3D MLX5_MAX_ASYNC_EQS (for e=
xample,
max_num_eqs =3D 4 or log_max_eq =3D 2 when MLX5_MAX_ASYNC_EQS is 4), get_nu=
m_eqs()
sets eq_table->max_comp_eqs =3D 0.

mlx5_eq_table_create() then calls alloc_rmap() -> alloc_irq_cpu_rmap(0) ->
alloc_cpu_rmap(0, GFP_KERNEL), which divides by size =3D=3D 0 in cpu % size.
Wouldn't this trigger a divide-by-zero fault during driver load unless the
effective EQ count is checked to be strictly greater than MLX5_MAX_ASYNC_EQS
(and log_max_eq is kept below 31)?

[ ... ]

> +static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, =
void *dst,
> +					     void *src)
> +{
> +	int err;
> +	u32 val;
> +
> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));

[ ... ]

> +	val =3D MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 3=
1;
> +	err =3D MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
> +				 val);
> +	if (err)
> +		return err;
> +
> +	/* The fixed buffer min is don't-care when its valid bit is clear. */
> +	if (!MLX5_GET(cmd_hca_cap_2, dst,
> +		      min_mkey_log_entity_size_fixed_buffer_valid))
> +		return 0;

[Severity: Medium]
Are there two cases where the validation of log_min_mkey_entity_size in
mlx5_adversarial_filter_general_2() is too permissive?

First, when min_mkey_log_entity_size_fixed_buffer_valid is 0,
mlx5_adversarial_filter_general_2() returns 0 without checking
log_min_mkey_entity_size against max_mkey_log_entity_size_fixed_buffer.
However, in drivers/infiniband/hw/mlx5/mlx5_ib.h, get_min_log_entity_size_c=
ap()
falls back to log_min_mkey_entity_size when that valid bit is clear:

	if (access_mode =3D=3D MLX5_MKC_ACCESS_MODE_KSM &&
	    MLX5_CAP_GEN_2(dev->mdev,
			   min_mkey_log_entity_size_fixed_buffer_valid))
		min_log_size =3D MLX5_CAP_GEN_2(
			dev->mdev, min_mkey_log_entity_size_fixed_buffer);
	else
		min_log_size =3D
			MLX5_CAP_GEN_2(dev->mdev, log_min_mkey_entity_size);

while get_max_log_entity_size_cap() still uses
max_mkey_log_entity_size_fixed_buffer for MLX5_MKC_ACCESS_MODE_KSM. If
min_mkey_log_entity_size_fixed_buffer_valid is 0 and
max_mkey_log_entity_size_fixed_buffer < log_min_mkey_entity_size <=3D
max_mkey_log_entity_size_mtt, min_log_entity_size_cap will exceed
max_log_entity_size_cap in mlx5_umem_mkc_find_best_pgsz(), producing an
inverted GENMASK_ULL() of 0 and triggering WARN_ON(!page_size) in
alloc_cacheable_mr() and can_use_umr_rereg_pas().

Second, during mlx5e probe, mlx5e_build_rq_params() ->
mlx5e_mpwrq_validate_regular() -> mlx5e_mpwrq_page_shift(mdev, NULL) checks:

drivers/net/ethernet/mellanox/mlx5/core/en/params.c:mlx5e_mpwrq_page_shift(=
) {
	u8 min_page_shift =3D MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev);
	u8 req_page_shift =3D xsk ? xsk->log_hrq_ix_sz : PAGE_SHIFT;

	/* Regular RQ uses order-0 pages, the NIC must be able to map them. */
	if (WARN_ON_ONCE(!xsk && req_page_shift < min_page_shift))
		min_page_shift =3D req_page_shift;
	...
}

where MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev) is log_min_mkey_entity_size ?: 12.
If log_min_mkey_entity_size is allowed to be up to 31 (greater than
PAGE_SHIFT), wouldn't this trigger WARN_ON_ONCE() on probe?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D3
