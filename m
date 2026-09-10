Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA643D47B5;
	Thu, 10 Sep 2026 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077274; cv=none; b=eqRjiEa72fvhHrospoHUIrvbYlSnZzftOcJxNYc8/KumeHjV4pwm1515SD1f2VfWD54mRupJjicKuGG2MrwCqsw/vLPn1g7JVxe0Cl9sljIeRY6jG3NSSODXSJiUpfUR1UXzVXoKEiMANIQZXUB9s3/IxmtS5ULmdJPehLG8NuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077274; c=relaxed/simple;
	bh=dIJ9mFKQBqj6qc8YThgW2DzXL1o1yDg37WhwKe92U4E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IPae7paKBC4FBhFrVBLReG3mKn0etuRZ55xxeHou7tpP7HG4C6mbndGgX4rNV1aFv+kzvHtX2HzZIaRqI/5f7ldgZg3hipz1AOCd4mJHTiTU7Cz8BQQyjDr5LmECJKXcIO72cLw1k/WRrCGc4Eml7SyKdcYPiaxm8RCjck5YA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NejN65VQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NejN65VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C4F1F000FF;
	Thu, 10 Sep 2026 21:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077272;
	bh=Th6PXr1+UqCvdS+UYnBpt03sTO4QkgvY5unlGLF9pOc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NejN65VQsKsO8Sgy5QPx+TTVnkp7JyBtqnN8zGRdyFMAF41BWBxmD06iw4RNj+GrL
	 NXr4f+2tm64qNrClZNP2Aj8vQPO374YAmUtuCOj5YT6zyFSJ/qoNHiH45c4c/2m23j
	 n59F53wFkOw1xnrQRO6HfO14D3ibqrtG8+J7J8p1I/ZPolWk+yVSLW35lVwyZnM7A5
	 hfSPdsv2Oehl/nCwAnl7nNGBjLukxj5ST+lytLtF2q62qHVOWEDOH7T6Rc4hQSx7Wt
	 WS/0Mu2q2UVgV70UOp6mMvPTkJI/ZoLPvL564Y+wQDFV3Pvp/AA/fyjQ39DTj4htlK
	 T9XnKh7r3AdmQ==
Subject:
 Re: [PATCH net-next V4 09/14] net/mlx5e: psp: Add an rx_decap steering table
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com, doruk@0sec.ai,
 dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 saeedm@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, willemb@google.com, willemdebruijn.kernel@gmail.com
Date: Thu, 10 Sep 2026 21:54:30 +0000
Message-ID: <178907727052.219967.10408608190614000420@kernel.org>
In-Reply-To: <20260908065244.3799142-10-tariqt@nvidia.com>
References: <20260908065244.3799142-10-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] accel_psp_fs_rx_decap_ft_create()
  (drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c) creates the…
- [Medium] accel_psp_fs_rx_decrypt_ft_create() now unconditionally
  allocates a modify-header context that copies…

--

net/mlx5e: psp: Add an rx_decap steering table

This adds a new PSP RX decapsulation steering table with one rule per
supported PSP version (transport-mode decap, SPI copy into reg_b, flow tag
marker) plus a drop rule for unsupported versions. The mode is tracked in
fs.decap_enabled and switched through accel_psp_fs_rx_reconfigure(), which
is called with decap_wanted == false in this commit.

A couple of questions below.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> index 20d7f14fb4acd..84133cbf86895 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c

[ ... ]

> @@ -403,11 +434,164 @@ int accel_psp_fs_rx_check_ft_create(struct mlx5e_psp_fs *fs,
>  	return err;
>  }
>  
> +static
> +int accel_psp_fs_rx_decap_ft_create(struct mlx5e_psp_fs *fs,
> +				    struct mlx5e_psp_rx_decap_table *decap)
> +{

[ ... ]

> +	/* Create FT */
> +	ft_attr.max_fte = 1 + MLX5E_PSP_NUM_SUPPORTED_VERSIONS;
> +	ft_attr.level = MLX5E_ACCEL_FS_PSP_DECAP_FT_LEVEL;
> +	ft_attr.prio = MLX5E_NIC_PRIO;
> +	ft_attr.autogroup.num_reserved_entries = 1;
> +	err = accel_psp_fs_create_ft(fs, &ft_attr, &decap->ft);

[Severity: High]
Should ft_attr.flags here include MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT?

Every rule installed into this table below carries
MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT with a
MLX5_REFORMAT_TYPE_REMOVE_PSP_TRANSPORT context, but the table flag is the
only source of flow_table_context.reformat_en:

fs_cmd.c:mlx5_cmd_create_flow_table() {
	int en_encap = !!(ft->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
	...
	MLX5_SET(create_flow_table_in, in, flow_table_context.reformat_en,
		 en_encap);
}

The SWS and HWS backends derive reformat_en from the same flag, so with
flags == 0 the table is created with reformat disabled while its FTEs
request a reformat action.

The directly analogous header-removal case in the same driver does set the
flag, for the MACsec RX check table that hosts
MLX5_REFORMAT_TYPE_DEL_MACSEC:

lib/macsec_fs.c:macsec_fs_rx_create() {
	flow_table = macsec_fs_auto_group_table_create(ns,
						       MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT,
						       RX_CHECK_TABLE_LEVEL,
						       RX_CHECK_TABLE_NUM_FTE);
}

IPsec does the same on rx->ft.sa / tx->ft.sa in en_accel/ipsec_fs.c, and so
do esw/bridge.c, lib/fs_chains.c, esw/vporttbl.c and eswitch_offloads.c for
their reformat-bearing tables.

If firmware rejects the reformat FTE, mlx5_add_flow_rules() fails in the
version loop, accel_psp_fs_rx_decap_ft_create() unwinds, and
accel_psp_fs_rx_reconfigure() only prints "HW GRO for PSP unavailable", so
the feature stays inert even on HW/FW advertising
reformat_del_psp_transport. If a backend instead accepts the FTE without
performing the reformat, packets that still carry UDP+PSP headers get the
PSP-decap flow tag and are interpreted as decapsulated by the RX handler
added later in the series.

Note there is no software-side check in fs_core.c for this mismatch, so it
only shows up as a firmware syndrome at rule installation time. Also, as
IPsec shows (mlx5_eswitch_block_encap() before setting the flag), adding the
flag alone may not be the whole fix.

At the end of the series (selftests: drv-net: Add PSP HW GRO conformance
tests) psp.c still has no ft_attr.flags assignment and no
MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT anywhere.

> +	if (err) {
> +		mlx5_core_err(mdev, "fail to create psp decap rx ft err=%d\n",
> +			      err);
> +		goto out_spec;
> +	}

[ ... ]

> +	/* pkt_reformat: decap PSP transport */
> +	reformat_params.type = MLX5_REFORMAT_TYPE_REMOVE_PSP_TRANSPORT;
> +	reformat = mlx5_packet_reformat_alloc(mdev, &reformat_params,
> +					      MLX5_FLOW_NAMESPACE_KERNEL);
> +	if (IS_ERR(reformat)) {
> +		err = PTR_ERR(reformat);
> +		goto out_err;
> +	}
> +	decap->reformat = reformat;
> +
> +	for (i = 0; i < MLX5E_PSP_NUM_SUPPORTED_VERSIONS; i++) {

[ ... ]

> +		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
> +			MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
> +			MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		flow_act.pkt_reformat = reformat;
> +		flow_act.modify_hdr = modify_hdr;
> +		dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> +		dest.ft = fs->rx.ft;
> +
> +		rule = mlx5_add_flow_rules(decap->ft, spec, &flow_act, &dest, 1);
> +		if (IS_ERR(rule)) {
> +			err = PTR_ERR(rule);
> +			goto out_err;
> +		}
> +		decap->rule[i] = rule;
> +	}
> +	goto out_spec;
> +
> +out_err:
> +	accel_psp_fs_rx_decap_ft_destroy(fs, decap);
> +out_spec:
> +	kvfree(spec);
> +	return err;
> +}
> +

[ ... ]

> @@ -474,6 +660,24 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
>  	}
>  	decrypt->miss_rule = rule;
>  
> +	/* Create modify_hdr to copy SPI to REG_C_0 */
> +	MLX5_SET(copy_action_in, action, action_type, MLX5_ACTION_TYPE_COPY);
> +	MLX5_SET(copy_action_in, action, src_field,
> +		 MLX5_ACTION_IN_FIELD_PSP_HEADER_1);
> +	MLX5_SET(copy_action_in, action, src_offset, 0);
> +	MLX5_SET(copy_action_in, action, length, 0);  /* 0 = 32 bits */
> +	MLX5_SET(copy_action_in, action, dst_field,
> +		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
> +	MLX5_SET(copy_action_in, action, dst_offset, 0);
> +
> +	modhdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL, 1,
> +					  action);
> +	if (IS_ERR(modhdr)) {
> +		err = PTR_ERR(modhdr);
> +		goto out_err;
> +	}
> +	decrypt->modify_hdr = modhdr;
> +

[Severity: Medium]
Should this SPI copy be gated on the same capability as the decap table?

The only consumer of REG_C_0 here is the optional decap table, which
re-copies REG_C_0 into REG_B and is gated in accel_psp_fs_rx_reconfigure()
on:

	bool decap_supported =
		MLX5_CAP_FLOWTABLE(fs->mdev,
				   flow_table_properties_nic_receive.reformat_del_psp_transport);

with failures there being warn-only. On the decrypt path, however, the
MLX5_ACTION_IN_FIELD_PSP_HEADER_1 copy is unconditional, and a failure is
fatal for the whole feature:

accel_psp_fs_rx_create()
  accel_psp_fs_rx_decrypt_ft_create()   /* -> goto out_err */
    NL_SET_ERR_MSG(extack, "Failed creating RX decrypt steering table");

mlx5_cmd_modify_header_alloc() validates only num_actions against
max_modify_header_actions, so the source field is validated by firmware
alone and there is no capability bit for it. Both
MLX5_ACTION_IN_FIELD_PSP_HEADER_1 and the reformat_del_psp_transport bit
came in with commit bee40a7d0bd1 ("net/mlx5: Add PSP related fields to the
mlx5_ifc"), while PSP crypto offload shipped earlier with commit
04a3134f88a4. On FW that has PSP crypto offload but not the newer PSP header
field, does PSP offload stop being enable-able at all rather than just
losing decap/GRO?

That would not match the commit message:

    The intention is for failures creating the new table to not block
    feature reconfig/PSP toggling.
    ...
    Nothing happens on older HW/FW without the ability to decapsulate PSP
    transport.

The change to the pre-existing decrypt rule is not mentioned in the commit
message at all; could it be described there?

Two smaller points in the same block. This is the only failure branch of
accel_psp_fs_rx_decrypt_ft_create() without an mlx5_core_err(), while the
code it replaces did log ("fail to alloc psp set modify_header_id err=%d").
And since accel_psp_fs_rx_create() calls accel_psp_fs_rx_reconfigure(fs,
false) in this commit, the extra MOD_HDR action runs for every PSP RX packet
with nothing reading REG_C_0 until the follow-up patch enables decap. At the
end of the series the decrypt-side copy is still unconditional and still
unlogged.

>  	/* Add PSP RX decrypt rule */
>  	setup_fte_udp_psp(spec, PSP_DEFAULT_UDP_PORT);
>  
> @@ -484,8 +688,10 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
>  			   MLX5E_ACCEL_FLOW_TAG_PROTO_PSP);
>  
>  	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_PSP;
> -	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
> -			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
> +	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
> +		MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
> +		MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +	flow_act.modify_hdr = modhdr;
>  	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>  	dest.ft = fs->check.ft;
>  	rule = mlx5_add_flow_rules(decrypt->ft, spec, &flow_act, &dest, 1);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
