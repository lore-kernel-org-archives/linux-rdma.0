Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083085;
	b=E4xSkk0gUTH/Qs6DIpaVepqPunC3BnrUXSzCDQAaspNwO4xRVt4OaPQz75Vvt0J270Aq
	 RNP+ptBsajPxrlUPj2ucaV1DTWLEVeKOjrWbp7IgZkzI0oW3WR9VJVy622CPRmZRVTOK8
	 aNin7OQdlKpZ1olv/tQcU7+gdJDdZRne/04u6WTPpCFOA/nYRftpJb3+CI0IWD2VvM6Y8
	 Gk0INWhfNEXkkDJ0QIpRXXEQDKjsgE3YeieCkqydUTLR2n5tvQnILVNKr+MffOhEZqPuH
	 pVF/4jysEONShTqA2vjPXYD0Ot3vuAHDV+aRq5QMBbmLU2R9NmXe5tQwHGmJtYXtsdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083085;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=X5DNySawfwMEuzSPHQkhCP7bQW0nQjo6KbBj+XYDKpM=;
	b=AvC4zrH/JXb4Svu0dDY3X6Mj3mit98Phvvl7l0GNkZwIomc2S0z7tOr+HfRiPEhh9MCN
	 LipcrCo1GRN4Xv2EhMMd+SC1gPAjk7NLKE9F956yywHKJBFMhkT6T4oADGaTUHXPbHhsp
	 pmUlMO3SF48oQ7iND4dKGoIRcScfPVHy9kHOswWLsBTGWQ4UV86xWPUhfmU2BwOuM28A7
	 n3LfWZn9Wz2+KqwUfcbNsKJWy8c//6PuYG88x/1Qwj6IKKk9m2/8MXiJ4vkXQ4MUTPq8N
	 XaeaTIEYj+LfqdiRNCY5t2GjjfujI/7huJq1BBSnVvxdhgcoKshN/BN92mTpD2kb9zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L6VQs9KW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDBD606A33B;
	Sat,  7 Nov 2026 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L6VQs9KW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB11F008A2;
	Sat,  7 Nov 2026 20:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083084;
	bh=X5DNySawfwMEuzSPHQkhCP7bQW0nQjo6KbBj+XYDKpM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L6VQs9KWd93rkzNjHhyrTVC+YSYnXIJzYY66UFpcC/dAOiCP29MlXn8vywIqejzAo
	 Lk0SWhfpZo2N6ztkw7Wrc2+LUhSg+1MyI7W3tzDrKzdHkTXJar0Tmupl7r8VXmXFOV
	 7SGgSaPf/iVy1vubASBj0tc0RMbdiEG0N222hYxlTNyLvCGrcbvAK7fmDdQC7c9MxF
	 VLjde2ku68Hfg4mez3hkURmWm9gkCRwDxzCOrRens+slMTAfpr9iLnP+/3+neCirHv
	 knfCJgjqBd6cOsyKrt8Iyc70H7gRIMn/OQU72h50F0xZ3sVHbuSoBx+G59pJSEO+kP
	 Oa25S45jEnPoQ==
Subject: Re: [PATCH rdma-next 03/23] net/mlx5: Add capability filtering in
 adversarial mode
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:43 +0000
Message-ID: <179408308320.994134.5973332884050170035@kernel.org>
In-Reply-To: <20261103163949.1554-4-yishaih@nvidia.com>
References: <20261103163949.1554-4-yishaih@nvidia.com>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 3 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The adversarial-mode filter copies cmd_hca_cap.max_tc from
  firmware with MLX5_HCA_CAP_ALLOW and never clamps or checks it…
- [High] net/mlx5: unchecked minimum EQ caps cause divide-by-zero in
  alloc_cpu_rmap()
- [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap
  read
- [Medium] The commit message says the patch will "trust only a subset of
  capabilities" and will "Start off by clearing all firmware…
- [Medium] In adversarial mode, dev->caps.hca[MLX5_CAP_GENERAL]->cur no
  longer reflects firmware's current configuration: -…
- [Medium] mlx5_adversarial_filter_general_2() checks
  log_min_mkey_entity_size only against (max_mkey_log_entity_size_mtt ?:…
- [Low] The num_ports clamp uses the literal 8 as its upper bound, and
  the comment says the bound comes from MLX5_MAX_PORTS (`/* 0 is…

--

net/mlx5: Add capability filtering in adversarial mode

This adds mlx5_store_caps(). In adversarial mode it replaces the raw
memcpy of firmware HCA capabilities with per-field allow-list filtering
for the general, general_2 and ethernet offload capability types. A few
numeric capabilities are clamped or range-checked, and a failed check
aborts driver load. The remaining capability types are either passed
through whole or zeroed.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> new file mode 100644
> index 0000000000000..67b2603397450
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
> @@ -0,0 +1,381 @@

[ ... ]

> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
> +					   void *src)
> +{

[ ... ]

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, port_type);
> +	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);

[Severity: Low]
This isn't a bug, but the comment says the bound comes from MLX5_MAX_PORTS.
Could the clamp use MLX5_MAX_PORTS directly instead of the literal 8? The
two values agree today.

> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);

[Severity: High]
Should max_tc be clamped or checked here too? It is a 4 bit field, so
firmware can report up to 15. mlx5_max_tc() turns it into a loop bound:

drivers/net/ethernet/mellanox/mlx5/core/port.c:mlx5_max_tc() {
	u8 num_tc = MLX5_CAP_GEN(mdev, max_tc) ? : 8;

	return num_tc - 1;
}

That can return up to 14, but the callers assume at most 7 and use it to
index 8-entry arrays.

This path runs at netdev init with no user action. It is gated only by
the qos and ets caps, and both are allow-listed above:

mlx5e_nic_init()
  mlx5e_dcbnl_initialize()
    mlx5e_ets_init()
      ets.ets_cap = mlx5_max_tc(priv->mdev) + 1;
      mlx5e_dcbnl_ieee_setets_core()
        mlx5e_build_tc_group()
        mlx5e_build_tc_tx_bw()
        mlx5_set_port_tc_group()
        mlx5_set_port_tc_bw_alloc()

mlx5e_dcbnl_ieee_setets_core() declares these on the stack:

	u8 tc_tx_bw[IEEE_8021QAZ_MAX_TCS];
	u8 tc_group[IEEE_8021QAZ_MAX_TCS];

The build helpers fill them with for (i = 0; i <= max_tc; i++). Does a
max_tc of 9 or more overflow tc_group[] and tc_tx_bw[]?

mlx5_set_port_tc_group() then does:

	u32 in[MLX5_ST_SZ_DW(qetc_reg)] = {0};
	...
	for (i = 0; i <= mlx5_max_tc(mdev); i++) {
		MLX5_SET(qetc_reg, in, tc_configuration[i].g, 1);

qetc_reg is 80 bytes, so tc_configuration[14] would land well past the
end of in[].

The same loops appear in mlx5_set_port_tc_bw_alloc(),
mlx5_query_port_ets_rate_limit(), mlx5_modify_port_ets_rate_limit(),
mlx5e_dcbnl_ieee_getets(), mlx5e_dcbnl_ieee_getmaxrate() and
mlx5e_dcbnl_ieee_setmaxrate(). The getets and getmaxrate paths can be
reached through RTM_GETDCB without CAP_NET_ADMIN.

With trusted firmware this behavior predates the patch. num_ports is
clamped here for the same kind of reason, so would it make sense to clamp
max_tc to IEEE_8021QAZ_MAX_TCS as well? No later patch in the series seems
to touch mlx5/core, so the gap would still be there at the end of the
series.

[ ... ]

> +static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, void *dst,
> +					     void *src)
> +{

[ ... ]

> +	val = MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 31;
> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
> +				 val);
> +	if (err)
> +		return err;
> +
> +	/* The fixed buffer min is don't-care when its valid bit is clear. */
> +	if (!MLX5_GET(cmd_hca_cap_2, dst,
> +		      min_mkey_log_entity_size_fixed_buffer_valid))
> +		return 0;

[Severity: Medium]
log_min_mkey_entity_size is only compared against the MTT max here. Is
that enough for the code that consumes it?

In mlx5_ib, get_min_log_entity_size_cap() uses log_min_mkey_entity_size
as the KSM minimum exactly when the fixed buffer valid bit is clear. The
KSM maximum comes from max_mkey_log_entity_size_fixed_buffer. This
combination passes the filter:

  max_mkey_log_entity_size_mtt = 0
  log_min_mkey_entity_size = 20
  max_mkey_log_entity_size_fixed_buffer = 12
  min_mkey_log_entity_size_fixed_buffer_valid = 0

mlx5_umem_mkc_find_best_pgsz() then builds GENMASK_ULL(12, 20). That mask
is empty, so KSM mkey registration fails.

There is a second case. The filter accepts log_min_mkey_entity_size up to
31, and mlx5e_mpwrq_min_page_shift() uses it directly. For a regular RQ,
mlx5e_mpwrq_page_shift() hits this whenever the value is above PAGE_SHIFT:

	if (WARN_ON_ONCE(!xsk && req_page_shift < min_page_shift))

Should the filter also bound log_min_mkey_entity_size by
max_mkey_log_entity_size_fixed_buffer and by PAGE_SHIFT?

[ ... ]

> +	switch (cap_type) {
> +	case MLX5_CAP_GENERAL:
> +		return mlx5_adversarial_filter_general(dev, dst, src);
> +	case MLX5_CAP_GENERAL_2:
> +		return mlx5_adversarial_filter_general_2(dev, dst, src);
> +	case MLX5_CAP_ETHERNET_OFFLOADS:
> +		return mlx5_adversarial_filter_per_protocol(dev, dst, src);
> +
> +	case MLX5_CAP_ATOMIC:
> +	case MLX5_CAP_ROCE:
> +	case MLX5_CAP_FLOW_TABLE:
> +	case MLX5_CAP_DEV_EVENT:
> +		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
> +		break;

[Severity: Medium]
The commit message says:

  When in adversarial mode, trust only a subset of capabilities
  and do some additional validations.

  Start off by clearing all firmware capabilities and enabling
  them one by one.

Is the whole-structure pass-through for MLX5_CAP_ATOMIC, MLX5_CAP_ROCE,
MLX5_CAP_FLOW_TABLE and MLX5_CAP_DEV_EVENT intended? MLX5_CAP_FLOW_TABLE
in particular carries numeric limits that the steering code relies on.

There is a related case. mlx5_adversarial_filter_general() allow-lists
sbcam_reg, qcam_reg, mcam_reg and pcam_reg. In mlx5_query_hca_caps() those
bits gate mlx5_get_pcam_reg(), mlx5_get_mcam_access_reg_group() and
mlx5_get_qcam_reg(). These store firmware data straight into
dev->caps.pcam, dev->caps.mcam and dev->caps.qcam without going through
mlx5_store_caps().

If this is deliberate, could the commit message say which capability
areas are still trusted wholesale?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index f9e10464a71b5..e76a4486b5a31 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -325,12 +325,12 @@ int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_ty
>  
>  	switch (cap_mode) {
>  	case HCA_CAP_OPMOD_GET_MAX:
> -		memcpy(dev->caps.hca[cap_type]->max, hca_caps,
> -		       MLX5_UN_SZ_BYTES(hca_cap_union));
> +		err = mlx5_store_caps(dev, cap_type,
> +				      dev->caps.hca[cap_type]->max, hca_caps);
>  		break;
>  	case HCA_CAP_OPMOD_GET_CUR:
> -		memcpy(dev->caps.hca[cap_type]->cur, hca_caps,
> -		       MLX5_UN_SZ_BYTES(hca_cap_union));
> +		err = mlx5_store_caps(dev, cap_type,
> +				      dev->caps.hca[cap_type]->cur, hca_caps);
>  		break;

[Severity: Medium]
In adversarial mode, dev->caps.hca[MLX5_CAP_GENERAL]->cur now holds the
filtered image:

- it is zeroed, and only allow-listed fields are copied back
- num_of_uars_per_page is forced
- num_ports, num_lag_ports, num_vhca_ports and log_max_rqt_size are
  clamped

handle_hca_cap() still uses ->cur as the template for SET_HCA_CAP:

drivers/net/ethernet/mellanox/mlx5/core/main.c:handle_hca_cap() {
    ...
	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
				   capability);
	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL]->cur,
	       MLX5_ST_SZ_BYTES(cmd_hca_cap));
    ...
}

It then writes the whole structure back with set_caps().

Does this program every firmware-writable field to 0 if it is not on the
allow-list and handle_hca_cap() does not set it explicitly? Are the forced
and clamped values also written back to the device?

If so, adversarial mode changes the device configuration, not only what
the driver trusts, and the commit message doesn't mention it. Is that
intended, or should handle_hca_cap() start from the unfiltered firmware
values?

The GENERAL_2 path in handle_hca_cap_2() seems fine here. Its do_set
triggers, sw_vhca_id_valid and lag_per_mp_group, are not allow-listed, so
set_caps() is never reached for GENERAL_2 in adversarial mode.

[ ... ]

> @@ -0,0 +1,381 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
> +
> +#include "linux/mlx5/device.h"
> +#include <linux/mlx5/driver.h>
> +#include <linux/mlx5/qp.h>
> +#include "mlx5_core.h"
> +
> +#define MLX5_HCA_CAP_ALLOW(cap, fld) \
> +	MLX5_SET(cap, dst, fld, MLX5_GET(cap, src, fld))
> +#define MLX5_HCA_CAP_ALLOW64(cap, fld) \
> +	MLX5_SET64(cap, dst, fld, MLX5_GET64(cap, src, fld))
> +
> +/* Allow a numeric capability range restricted to [lo, hi]. */
> +#define MLX5_HCA_CAP_CLAMP(cap, fld, lo, hi) \
> +	MLX5_SET(cap, dst, fld, mlx5_cap_clamp(dev, #fld, \
> +					       MLX5_GET(cap, src, fld), \
> +					       (lo), (hi)))
> +
> +/* Check cap range and return error otherwise. */
> +#define MLX5_HCA_CAP_CHECK(cap, fld, lo, hi) \
> +	mlx5_cap_check(dev, #fld, MLX5_GET(cap, dst, fld), (lo), (hi), false)
> +/* Same but zero is also a valid value. */
> +#define MLX5_HCA_CAP_CHECK_Z(cap, fld, lo, hi) \
> +	mlx5_cap_check(dev, #fld, MLX5_GET(cap, dst, fld), (lo), (hi), true)
> +
> +static u32 mlx5_cap_clamp(struct mlx5_core_dev *dev, const char *name,
> +			  u32 val, u32 lo, u32 hi)
> +{
> +	u32 clamped = clamp_t(u32, val, lo, hi);
> +
> +	if (clamped != val)
> +		mlx5_core_warn(dev, "cap filter: FW reported %s=%u, outside [%u, %u], using %u\n",
> +			       name, val, lo, hi, clamped);
> +
> +	return clamped;
> +}
> +
> +static int mlx5_cap_check(struct mlx5_core_dev *dev, const char *name,
> +			  u32 val, u32 lo, u32 hi, bool zero)
> +{
> +	if (val >= lo && val <= hi)
> +		return 0;
> +
> +	if (zero && !val)
> +		return 0;
> +
> +	mlx5_core_err(dev, "cap filter: FW reported %s=%u, outside [%u, %u] %s\n",
> +		      name, val, lo, hi,
> +		      zero ? "or 0" : "");
> +
> +	return -EINVAL;
> +}
> +
> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
> +					   void *src)
> +{
> +	int err;
> +
> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> +
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, page_request_disable);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_resource_manager);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, hca_cap_2);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_teardown_request);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_in_use);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_active);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_allocated);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_on_vhca_state_invalid);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vhca_id);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_srq_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_qp_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, event_cap);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_qp);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_srq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_sgl_for_optimized_performance);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_cq_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_write_umr);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read_umr);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_cq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_write);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read_pci_enabled);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_mkey);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, terminate_scatter_list_mkey);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fast_teardown);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_eq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_indirection);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fixed_buffer_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, force_teardown);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_extended_translation_offset);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_klm_list_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qpc_extension);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_req_dc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cq_overrun);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_res_dc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, release_all_pages);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce_accl);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_req_qp);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_ra_res_qp);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, end_pad);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cc_query_allowed);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cc_modify_allowed);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cache_line_128byte);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rts2rts_qp_counters_set_id);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_int_rq_oob);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sbcam_reg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qcam_reg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, gid_table_size);
> +
> +	/* Values outside of [0, 4] range are unexpected. */
> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, gid_table_size, 0, 4);
> +	if (err)
> +		return err;
> +
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, out_of_seq_cnt);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, retransmission_q_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, debug);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, modify_rq_counter_set_id);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_delay_drop);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_qp_cnt);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pkey_table_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_group_manager);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_queue_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ets);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, nic_flow_table);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, mcam_reg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pcam_reg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, local_ca_ack_delay);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, enhanced_error_q_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, beacon_led);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, port_type);
> +	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dcbx);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, general_notification_event);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, stat_rate_support);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pci_sync_for_fw_update_event);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cqe_version);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_modify_entity_size_disabled);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_modify_atomic_disabled);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_indirect_mkey_disabled);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_fence);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cmdif_checksum);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sho);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qos);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eth_net_offloads);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, roce);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, atomic);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_moderation);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_period_mode_modify);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cq_period_start_from_cqe);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, apm);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, umr_ptr_rlky);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qp_packet_based);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pkv);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, uar_4k);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, fl_rc_qp_when_roce_disabled);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_pg_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, bf);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, driver_version);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, mkey_by_name);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_bf_reg_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, disciplined_fr_counter);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, qp_error_syndrome);
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_lag_ports, 0, 1);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_wqe_sz_sq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, icm_mng_function_id_mode);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, tis_tir_td_order);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_wqe_sz_rq);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, query_host_net_function_num_max);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_qp_mcg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_mcg);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_transport_domain);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, relaxed_ordering_read);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_pd);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_ud);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_uc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_xrc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_dc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, dp_ordering_ooo_all_rc);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, pcie_reset_using_hotreset_method);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap,
> +			   pci_sync_for_fw_update_with_driver_unload);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vnic_env_cnt_steering_fail);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, vport_counter_local_loopback);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, q_counter_aggregation);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, q_counter_other_vport);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, nic_receive_steering_discard);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, receive_discard_vport_down);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, transmit_discard_vport_down);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, eq_overrun_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, invalid_command_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, quota_exceeded_count);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_flow_counter_bulk);

[Severity: High]
Should log_max_flow_counter_bulk be clamped like log_max_rqt_size?
It is an 8 bit field, so firmware can report up to 255.
get_init_bulk_query_len() uses it directly as a shift count. It
returns min_t(int, MLX5_INIT_COUNTERS_BULK, 1 << the field).

A value of 31 makes the shift yield INT_MIN, so min_t() returns a
negative bulk length. Any value of 32 or more is an undefined shift.

That value is used at init time:

mlx5_init_once()
  mlx5_fs_core_alloc()
    mlx5_init_fc_stats()
      mlx5_fc_stats_bulk_query_buf_realloc()
        mlx5_cmd_fc_get_bulk_query_out_len()

mlx5_cmd_fc_get_bulk_query_out_len() multiplies the size_t
MLX5_ST_SZ_BYTES(traffic_counter) by bulk_len and returns the result
as an int. For INT_MIN the low 32 bits of the product are zero. That
leaves out_len as just the 16 byte query_flow_counter_out header. The
16 byte kvzalloc() succeeds, and fc_stats->bulk_query_len is set to
INT_MIN.

Then, once any flow counter exists:

- mlx5_fc_stats_query_all_counters() reads bulk_query_len into a u32
  bulk_len of 0x80000000
- mlx5_cmd_fc_bulk_query() is issued with the same 16 byte outlen
- update_counter_cache() indexes flow_statistics[] in bulk_query_out
  by counter->id - bulk_base_id

Doesn't that read past the end of the 16 byte allocation for every
counter?

With trusted firmware this predates the patch, but this filter is
where it should be caught. Would clamping to the log of
MLX5_SW_MAX_COUNTERS_BULK be enough here? get_max_bulk_query_len()
does the same shift. If the fix goes into fs_counters.c instead, it
would need to cover both helpers.

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
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sq_ts_format);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, rq_ts_format);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, steering_format_version);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, create_qp_start_hint);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, ats);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, cross_vhca_rqt);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_uctx);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_eqs);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_uar_page_sz);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_geneve_tlv_options);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_geneve_tlv_option_data_len);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_dci_stream_channels);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_dci_errored_streams);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, crossing_vhca_mkey);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, native_port_num);
> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_vhca_ports, 0, 1);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, sw_owner_id);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_num_of_monitor_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_ppcnt_monitor_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_q_monitor_counters);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, apu);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, uctx_cap);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, num_total_dynamic_vf_msix);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, min_dynamic_vf_msix_table_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, data_direct);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_dynamic_vf_msix_table_size);
> +	MLX5_HCA_CAP_ALLOW64(cmd_hca_cap, vhca_tunnel_commands);
> +
> +	MLX5_SET(cmd_hca_cap, dst, num_of_uars_per_page, MLX5_UARS_IN_PAGE);
> +
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, flow_counter_bulk_alloc);
> +
> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, log_pg_sz,
> +				 MLX5_ADAPTER_PAGE_SHIFT,
> +				 MLX5_ADAPTER_PAGE_SHIFT);
> +	if (err)
> +		return err;
> +
> +#define LOG_BF_REG_SIZE_MIN ilog2(2 * MLX5_SEND_WQE_BB)
> +#define LOG_BF_REG_SIZE_MAX \
> +	ilog2((MLX5_ADAPTER_PAGE_SIZE - MLX5_BF_OFFSET) / MLX5_BFREGS_PER_UAR)
> +
> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap, log_bf_reg_size,
> +				 LOG_BF_REG_SIZE_MIN,
> +				 LOG_BF_REG_SIZE_MAX);
> +	if (err)
> +		return err;
> +
> +#undef LOG_BF_REG_SIZE_MAX
> +#undef LOG_BF_REG_SIZE_MIN
> +
> +	return MLX5_HCA_CAP_CHECK(cmd_hca_cap, min_dynamic_vf_msix_table_size, 0,
> +				  MLX5_GET(cmd_hca_cap, dst,
> +					   max_dynamic_vf_msix_table_size));
> +}
> +
> +static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, void *dst,
> +					     void *src)
> +{
> +	int err;
> +	u32 val;
> +
> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> +
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, dp_ordering_force);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, query_vuid);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, umr_log_entity_size_5);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_insert_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_insert_offset);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_remove_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_reformat_remove_offset);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, sf_eq_usage);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_rqt_vhca_id);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
> +			   min_mkey_log_entity_size_fixed_buffer_valid);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, log_min_mkey_entity_size);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
> +			   min_mkey_log_entity_size_fixed_buffer);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2,
> +			   max_mkey_log_entity_size_fixed_buffer);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_mkey_log_entity_size_mtt);
> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap_2, max_num_eqs_24b);
> +
> +	err = MLX5_HCA_CAP_CHECK_Z(cmd_hca_cap_2, max_mkey_log_entity_size_mtt,
> +				   MLX5_ADAPTER_PAGE_SHIFT, 63);
> +	if (err)
> +		return err;
> +
> +	err = MLX5_HCA_CAP_CHECK_Z(cmd_hca_cap_2,
> +				   max_mkey_log_entity_size_fixed_buffer,
> +				   MLX5_ADAPTER_PAGE_SHIFT, 63);
> +	if (err)
> +		return err;
> +
> +	val = MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 31;
> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
> +				 val);
> +	if (err)
> +		return err;
> +
> +	/* The fixed buffer min is don't-care when its valid bit is clear. */
> +	if (!MLX5_GET(cmd_hca_cap_2, dst,
> +		      min_mkey_log_entity_size_fixed_buffer_valid))
> +		return 0;
> +
> +	val = MLX5_GET(cmd_hca_cap_2, dst,
> +		       max_mkey_log_entity_size_fixed_buffer) ?: 31;
> +	return MLX5_HCA_CAP_CHECK(cmd_hca_cap_2,
> +				  min_mkey_log_entity_size_fixed_buffer, 0, val);
> +}
> +
> +static int mlx5_adversarial_filter_per_protocol(struct mlx5_core_dev *dev,
> +						 void *dst, void *src)
> +{
> +	memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> +
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, csum_cap);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, vlan_cap);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
> +			   self_lb_en_modifiable);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps, max_lso_cap);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
> +			   wqe_inline_mode);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
> +			   rss_ind_tbl_cap);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
> +			   cqe_checksum_full);
> +	MLX5_HCA_CAP_ALLOW(per_protocol_networking_offload_caps,
> +			   max_vxlan_udp_ports);
> +
> +	return 0;
> +}
> +
> +#undef MLX5_HCA_CAP_ALLOW
> +#undef MLX5_HCA_CAP_ALLOW64
> +#undef MLX5_HCA_CAP_CLAMP
> +#undef MLX5_HCA_CAP_CHECK
> +#undef MLX5_HCA_CAP_CHECK_Z
> +
> +int mlx5_store_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type,
> +		    void *dst, void *src)
> +{
> +	if (!mlx5_is_adversarial()) {
> +		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
> +		return 0;
> +	}
> +
> +	switch (cap_type) {
> +	case MLX5_CAP_GENERAL:
> +		return mlx5_adversarial_filter_general(dev, dst, src);
> +	case MLX5_CAP_GENERAL_2:
> +		return mlx5_adversarial_filter_general_2(dev, dst, src);
> +	case MLX5_CAP_ETHERNET_OFFLOADS:
> +		return mlx5_adversarial_filter_per_protocol(dev, dst, src);
> +
> +	case MLX5_CAP_ATOMIC:
> +	case MLX5_CAP_ROCE:
> +	case MLX5_CAP_FLOW_TABLE:
> +	case MLX5_CAP_DEV_EVENT:
> +		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
> +		break;
> +
> +	default:
> +		memset(dst, 0, MLX5_UN_SZ_BYTES(hca_cap_union));
> +		break;
> +	}
> +
> +	return 0;
> +}

[Severity: High]
Should the EQ count be range checked as well? log_max_eq and
max_num_eqs are allow-listed here, and max_num_eqs_24b is allow-listed
in mlx5_adversarial_filter_general_2(). Nothing makes sure the device
reports more EQs than the driver reserves for async EQs.

mlx5_max_eq_cap_get() returns max_num_eqs_24b if it is set, otherwise
max_num_eqs, otherwise 1 << log_max_eq. get_num_eqs() then takes the
minimum of two values:

- the IRQ table's completion vector count
- max_dev_eqs - MLX5_MAX_ASYNC_EQS

MLX5_MAX_ASYNC_EQS is 3 or 4, depending on
CONFIG_INFINIBAND_ON_DEMAND_PAGING.

Suppose firmware reports exactly MLX5_MAX_ASYNC_EQS, for example
max_num_eqs = 4 with ODP enabled. Then eq_table->max_comp_eqs becomes
0, and probe continues into:

mlx5_load()
  mlx5_eq_table_create()
    alloc_rmap()
      alloc_irq_cpu_rmap(eq_table->max_comp_eqs)
        alloc_cpu_rmap(0, GFP_KERNEL)

alloc_cpu_rmap() fills the near[] table with:

	rmap->near[cpu].index = cpu % size;

Doesn't that divide by zero during driver load? This path is taken
with CONFIG_RFS_ACCEL on non-SF devices and needs no user action.

If firmware reports fewer EQs than MLX5_MAX_ASYNC_EQS, max_comp_eqs
goes negative instead. alloc_cpu_rmap() rejects that value as too
large. But when the rmap is not allocated, what do
mlx5_comp_vectors_max() and the completion EQ code make of a negative
count?

With trusted firmware this predates the patch. The three fields come
from two different cap types, so one MLX5_HCA_CAP_CHECK() in a single
filter function can't cover them all. Would it be simpler to reject
max_dev_eqs <= MLX5_MAX_ASYNC_EQS in get_num_eqs() or
mlx5_eq_table_create()? Or is there a good place in the filter for
this check?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
