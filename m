Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55B739AD3B;
	Mon, 10 Aug 2026 22:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402295; cv=none; b=OoesuRdLUnC70KW+Uy8kjfz8byAJz8dbXEqQsoASSq09RPIhML+r59Bec8zT+v/JndVgpyjrakTvm7nD3NfB58em5605NQ+njqdHstx3nyyf/J0AaudDUEPqxFD6DlxdjxQCaPv9fseK4+LyAfr+w04Eebe/+5ae3GpNctXLHok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402295; c=relaxed/simple;
	bh=Xbor0olV3ZeQBE+Pc+GHpNflu7yAvdbDsyzECtYKIOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXY2FI1e3yB5aSCZRw7k9FBuwf2sGI3w1WkbfnLElUiBDqmyQ7fsCTHrOxQD7IxRzcBEqgl41afzseNJF7r9DtN/tNMJY4iUXV/dNHQtIOJ+Z1z5zTgip1jMrokmMey3I6spk5z2xEJZDRJna5J0BQDuXEXD/KaBye1FSOBeRqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5rwvgDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5rwvgDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09981F000E9;
	Mon, 10 Aug 2026 22:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786402293;
	bh=1sTXx+30oR2gYl133k+FZnm1EIMDomwGL/YwT/7LbdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5rwvgDMyBuf7Y6dw37n/jSFVl8XIqbTRFas3Bm+UebfQ1Ut5UqKtg+wOmt1DsEbF
	 Vja0NU+W3Kdo0qblKUb6Y6sCyDanNtM3n0Ydl0sfzZygS5ZJhDsWqrW5+BbYsMoFtT
	 2jgx2M2btOB9NPJc9oATue1dYyMaYKbMKnLdBhuHlmBVVfp6tSRJirY3EBUPnX6OMG
	 CmkdnBqWKR/slZGqp7uzkOLXE7UkgaTYQLjJTV4qit7eVhOE7KQQz5TJ3skQ9fN6Hx
	 KwD//KKe54bKf2WvSNjBS0BnOVnz8OwI64flJthBbyJLObzl2PzMWklu4ulThwyaFa
	 z95yiWEQ9sImw==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	aleksandr.loktionov@intel.com,
	aleksander.lobakin@intel.com,
	akiyano@amazon.com,
	daniel.zahka@gmail.com,
	dsahern@kernel.org,
	gal@nvidia.com,
	jiri@nvidia.com,
	jiri@resnulli.us,
	corbet@lwn.net,
	leon@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	nikolay@nvidia.com,
	razor@blackwall.org,
	petrm@nvidia.com,
	przemyslaw.kitszel@intel.com,
	rkannoth@marvell.com,
	saeedm@nvidia.com,
	skhan@linuxfoundation.org,
	horms@kernel.org,
	vdumitrescu@nvidia.com
Subject: Re: [PATCH net-next V5 2/2] net/mlx5: implement max_sfs parameter
Date: Mon, 10 Aug 2026 15:51:31 -0700
Message-ID: <20260810225131.933746-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806073037.3001886-3-tariqt@nvidia.com>
References: <20260806073037.3001886-3-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "second one looks legit at least (about the max value)?"
---
net/mlx5: implement max_sfs parameter

This adds the generic devlink permanent parameter max_sfs to mlx5, so the
number of light-weight subfunctions a PF may create can be set through
devlink instead of vendor tooling.  The setter enables the global
per_pf_num_sf bit and then programs the per-PF SF fields in the MNVDA
non-volatile configuration.

A few questions on the new code below.

> diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
> index cf1dffa676696..9421c89951a05 100644
> --- a/Documentation/networking/devlink/mlx5.rst
> +++ b/Documentation/networking/devlink/mlx5.rst
> @@ -45,8 +45,13 @@ Parameters
>       - The range is between 1 and a device-specific max.
>       - Applies to each physical function (PF) independently, if the device
>         supports it. Otherwise, it applies symmetrically to all PFs.
> +   * - ``max_sfs``
> +     - permanent
> +     - The range is between 0 and a device-specific max.
> +     - Applies to each physical function (PF) independently.
>  
> -Note: permanent parameters such as ``enable_sriov`` and ``total_vfs`` require FW reset to take effect
> +Note: permanent parameters such as ``enable_sriov``, ``total_vfs`` and ``max_sfs``
> +      require FW reset to take effect
>  
>  .. code-block:: bash
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
> index 4a7275e8b62e3..72cc8da5f1193 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
> @@ -68,7 +68,9 @@ struct mlx5_ifc_mnvda_reg_bits {
>  
>  struct mlx5_ifc_nv_global_pci_conf_bits {
>  	u8         sriov_valid[0x1];
> -	u8         reserved_at_1[0x10];
> +	u8         reserved_at_1[0xa];
> +	u8         per_pf_num_sf[0x1];
> +	u8         reserved_at_c[0x5];
>  	u8         per_pf_total_vf[0x1];
>  	u8         reserved_at_12[0xe];
>  
> @@ -93,9 +95,11 @@ struct mlx5_ifc_nv_global_pci_cap_bits {
>  };
>  
>  struct mlx5_ifc_nv_pf_pci_conf_bits {
> -	u8         reserved_at_0[0x9];
> +	u8         log_sf_bar_size[0x8];
> +	u8         pf_total_sf_en[0x1];
>  	u8         pf_total_vf_en[0x1];
> -	u8         reserved_at_a[0x16];
> +	u8         reserved_at_a[0x6];
> +	u8         total_sf[0x10];
>  
>  	u8         reserved_at_20[0x20];
>  
> @@ -158,6 +162,8 @@ struct mlx5_ifc_nv_sw_accelerate_conf_bits {
>  #define MLX5_GET_CFG_HDR_LEN(_mnvda_ptr) \
>  	MLX5_GET(mnvda_reg, _mnvda_ptr, configuration_item_header.length)
>  
> +#define MLX5_DEFAULT_LOG_SF_BAR_SIZE 12
> +
>  static int mlx5_nv_param_read(struct mlx5_core_dev *dev, void *mnvda,
>  			      size_t len)
>  {
> @@ -755,6 +761,115 @@ static int mlx5_devlink_total_vfs_validate(struct devlink *devlink, u32 id,
>  	return 0;
>  }
>  
> +static int mlx5_devlink_max_sfs_get(struct devlink *devlink, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
> +	u32 mnvda[MLX5_ST_SZ_DW(mnvda_reg)] = {};
> +	void *data;
> +	int err;
> +
> +	err = mlx5_nv_param_read_global_pci_conf(dev, mnvda, sizeof(mnvda));
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to read global PCI configuration");
> +		return err;
> +	}

[Severity: Low]

Can this extack message show up as a warning on a perfectly successful
param dump?  mlx5_nv_param_read() maps every mlx5_core_access_reg()
failure to -EOPNOTSUPP:

	mlx5_core_warn(dev, "Failed to read mnvda reg: ...");
	return -EOPNOTSUPP;

and the dump path in net/devlink/param.c swallows that code without
clearing cb->extack:

devlink_nl_param_get_dump_one()
	if (err == -EOPNOTSUPP) {
		err = 0;
	} else if (err) {
		state->idx = param_id;
		break;
	}

netlink_dump_done() then attaches extack->_msg to the NLMSG_DONE even
when the reported error is 0, so on firmware that does not implement the
global PCI configuration item every "devlink dev param show" would print
"mlx5_core: Failed to read global PCI configuration".

The same applies to the "Failed to read PF configuration" message below.
The pre-existing mlx5_devlink_enable_sriov_get() and
mlx5_devlink_total_vfs_get() return the error without touching extack.

> +
> +	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
> +	if (!MLX5_GET(nv_global_pci_conf, data, per_pf_num_sf)) {
> +		ctx->val.vu32 = 0;
> +		return 0;
> +	}
> +
> +	memset(mnvda, 0, sizeof(mnvda));
> +	err = mlx5_nv_param_read_per_host_pf_conf(dev, mnvda, sizeof(mnvda));
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to read PF configuration");
> +		return err;
> +	}
> +
> +	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
> +	if (MLX5_GET(nv_pf_pci_conf, data, pf_total_sf_en))
> +		ctx->val.vu32 = MLX5_GET(nv_pf_pci_conf, data, total_sf);
> +	else
> +		ctx->val.vu32 = 0;
> +
> +	return 0;
> +}
> +
> +static int mlx5_devlink_max_sfs_validate(struct devlink *devlink, u32 id,
> +					 union devlink_param_value *val,
> +					 struct netlink_ext_ack *extack)
> +{
> +	if (val->vu32 > U16_MAX) {
> +		NL_SET_ERR_MSG_FMT_MOD(extack,
> +				       "Max SFs allowed value is %u", U16_MAX);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

[Severity: Low]

The documentation hunk in this patch states:

     - The range is between 0 and a device-specific max.

but mlx5_devlink_max_sfs_validate() only rejects values above U16_MAX,
which is the width of nv_pf_pci_conf.total_sf[0x10] rather than any
device property, and neither the getter nor the setter reads
nv_global_pci_cap for an SF limit.  Compare
mlx5_devlink_total_vfs_validate(), which reports the real bound:

	max = MLX5_GET(nv_global_pci_cap, data, max_vfs_per_pf);
	if (val->vu16 > max) {
		NL_SET_ERR_MSG_FMT_MOD(extack,
				       "Max allowed by device is %u", max);

Relatedly, mlx5_devlink_max_sfs_set() below sets the global
per_pf_num_sf bit with no capability check, while
mlx5_devlink_total_vfs_set() and mlx5_devlink_enable_sriov_set() gate the
equivalent per-PF mode switch on
nv_global_pci_cap.per_pf_total_vf_supported and return -EOPNOTSUPP
otherwise.  No per_pf_num_sf_supported bit is added to
mlx5_ifc_nv_global_pci_cap_bits here.

Should a value beyond the device's actual SF maximum, or a device without
per-PF SF support, fail with something more specific than the generic
"Failed to change PF PCI configuration" that comes from the firmware
write?

> +
> +static int mlx5_devlink_max_sfs_set(struct devlink *devlink, u32 id,
> +				    struct devlink_param_gset_ctx *ctx,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
> +	u32 mnvda[MLX5_ST_SZ_DW(mnvda_reg)] = {};
> +	void *data;
> +	int err;
> +
> +	/* we don't explicitly disable per_pf_num_sf when max_sfs is 0 because
> +	 * another PF may be using SFs
> +	 */
> +	if (ctx->val.vu32) {
> +		err = mlx5_nv_param_read_global_pci_conf(dev, mnvda,
> +							 sizeof(mnvda));
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Failed to read global PCI configuration");
> +			return err;
> +		}

[Severity: Medium]

With value 0 this whole block is skipped, so on a device that is still in
global SF mode (per_pf_num_sf == 0) only the per-PF fields
pf_total_sf_en, total_sf and log_sf_bar_size are written.

mlx5_devlink_max_sfs_get() treats exactly those per-PF fields as
meaningless while per_pf_num_sf is clear:

	if (!MLX5_GET(nv_global_pci_conf, data, per_pf_num_sf)) {
		ctx->val.vu32 = 0;
		return 0;
	}

If the per-PF fields are inert in that mode, can

	devlink dev param set pci/<bdf> name max_sfs value 0 cmode permanent

actually stop SF creation, given that the SF budget keeps coming from the
global configuration?

The call still returns 0 with the "requires a FW reset" extack, and a
later param show reports 0 through the same early return, so user space
sees the disable as successful.  The commit message says:

    A value of 0 will effectively disable creation of new subfunction
    devices.

For comparison, mlx5_devlink_total_vfs_get() reports the global
total_vfs value in the equivalent situation instead of 0.

> +
> +		data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
> +		/* always enable per_pf_num_sf because another PF may use SFs */
> +		MLX5_SET(nv_global_pci_conf, data, per_pf_num_sf, 1);

[Severity: Medium]

per_pf_num_sf lives in the device-global item, not in the per-host-PF
one:

mlx5_nv_param_read_global_pci_conf()
	MLX5_SET_CFG_ITEM_TYPE(global, mnvda, type_class, 0);
	MLX5_SET_CFG_ITEM_TYPE(global, mnvda, parameter_index,
			       MLX5_CLASS_0_CTRL_ID_NV_GLOBAL_PCI_CONF);

so flipping it selects, for the whole device, whether the SF quota comes
from the global configuration or from each PF's own total_sf, while only
this PF's pf_total_sf_en/total_sf are programmed below.

What happens on a sibling PF whose per-PF total_sf was never programmed -
after the FW reset, does its SF capacity get derived from an unprogrammed
(zero) field and SF creation start failing there?

The comment above acknowledges the cross-PF coupling for the disable
direction; the extack at the end only warns about the FW reset and PCI
rescan, not about SF provisioning changing for other functions.

> +
> +		err = mlx5_nv_param_write(dev, mnvda, sizeof(mnvda));
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Failed to change per_pf_num_sf global PCI configuration");
> +			return err;
> +		}
> +		memset(mnvda, 0, sizeof(mnvda));
> +	}

[Severity: Medium]

This read-modify-write touches the device-global nv_global_pci_conf item,
but mlx5_nv_param_register_dl_params() registers these params on each
PF's own devlink instance:

	if (!mlx5_core_is_pf(devlink_priv(devlink)))
		return 0;

	return devl_params_register(devlink, mlx5_nv_param_devlink_params,
				    ARRAY_SIZE(mlx5_nv_param_devlink_params));

so the devlink instance lock is per-PF and cannot serialize accesses to a
shared item.  Can two PFs of the same device lose each other's update?

PF0: mlx5_devlink_max_sfs_set()
       mlx5_nv_param_read_global_pci_conf()   /* reads the shared item */

PF1: mlx5_devlink_total_vfs_set()
       mlx5_nv_param_read_global_pci_conf()
       MLX5_SET(nv_global_pci_conf, data, sriov_valid, 1);
       MLX5_SET(nv_global_pci_conf, data, per_pf_total_vf, 1);
       mlx5_nv_param_write()                  /* commits */

PF0:   MLX5_SET(nv_global_pci_conf, data, per_pf_num_sf, 1);
       mlx5_nv_param_write()                  /* stale copy, clears the
                                                 bits PF1 just wrote */

Both commands report success plus the FW-reset warning, so neither
administrator learns the persistent configuration is not what was asked
for.  The same pattern already exists for enable_sriov and total_vfs, but
this adds a new writer of the shared item.

> +
> +	err = mlx5_nv_param_read_per_host_pf_conf(dev, mnvda, sizeof(mnvda));
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to read PF configuration");
> +		return err;
> +	}

[Severity: Medium]

The two non-volatile writes are not atomic and the first one is never
rolled back.  If this read fails (mlx5_nv_param_read() returns
-EOPNOTSUPP for any mlx5_core_access_reg() failure), or the
mlx5_nv_param_write() below fails on a busy or restricted firmware, the
function returns an error to user space while per_pf_num_sf stays
committed in the NV configuration and this PF's
pf_total_sf_en/total_sf were never programmed.

Since that state survives reboot, is the device left in per-PF SF mode
with an effective budget of 0 after the FW reset even though the devlink
operation reported failure?

Would programming the per-host-PF item first, or restoring the
per_pf_num_sf value that was just read on the failure paths, keep the two
steps balanced?

> +
> +	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
> +	MLX5_SET(nv_pf_pci_conf, data, log_sf_bar_size,
> +		 ctx->val.vu32 ? MLX5_DEFAULT_LOG_SF_BAR_SIZE : 0);

[Severity: Medium]

log_sf_bar_size is a separate persistent knob - the size of each SF's
BAR/doorbell window, the same quantity the device reports as
mlx5_ifc_sf_partition_bits.log_sf_bar_size - and max_sfs does not claim
to control it.

The read above preserves whatever the device is currently programmed
with, and this overwrites it with the hardcoded
MLX5_DEFAULT_LOG_SF_BAR_SIZE (12), or with 0 on the disable path.

Should setting max_sfs also reset the SF BAR window size?  Neither the
commit message nor the documentation hunk mentions it, and 12 is not
validated against any device capability or against the BAR space implied
by total_sf, which may be up to 65535.

> +	MLX5_SET(nv_pf_pci_conf, data, pf_total_sf_en, !!ctx->val.vu32);
> +	MLX5_SET(nv_pf_pci_conf, data, total_sf, ctx->val.vu32);
> +
> +	err = mlx5_nv_param_write(dev, mnvda, sizeof(mnvda));
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to change PF PCI configuration");
> +		return err;
> +	}
> +	NL_SET_ERR_MSG_MOD(extack,
> +			   "Modifying max_sfs requires a FW reset and PCI bus rescan");
> +
> +	return 0;
> +}
> +

[ ... ]
