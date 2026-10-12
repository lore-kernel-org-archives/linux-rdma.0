Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56052AD36;
	Mon, 12 Oct 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798049; cv=none; b=AhIoQpDPjMAiXxRLQ6ez+kut24y2Il/QXWC6Z3EsFdFr2vZrtjQrbi5hRaw6ETV3tR4GZdeA1Lkdknh2YH1rqintpSfaffucvyRNy8uz4Vh2S5AZsmatYz5KXSJ5Om/ly3vvDK9IQ37i32thI6OfTrwv9TvRJcZDtK17Fq3h/jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798049; c=relaxed/simple;
	bh=a6FvpKy2Z1vtgnntPtKf+UWcUhRmkqdd5O8tdJ5HVP8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lz9nPz53l6TTu4ZHPxndkl1hEbSWukYoUSmGvU88FuflWQj92IqQdN+ZRO+1Xx2dlSWeHprzIBFX1uHVWBIbYZ5Hc5VL0wiKfVRNMcC/S8FfoFUJbRnHaO9dnqfy97Z7U+vz+l7CJgjmYIccP6tK7+1bgeWwJUNAOFJ3hjXdH0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8rGZPJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8rGZPJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193621F0089D;
	Mon, 12 Oct 2026 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791798047;
	bh=ZzTdgKXEL3BVoaE1Vc+qFEalY2IjFij49xzMtVOaX44=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e8rGZPJmlk9vGjVE0GMJXTi2yzoes3DQkJN+9veJ4/H2CH8S0wVK3juo+U3mReCok
	 PMYI611mdsSD8QHFqUACqHfsp2ueJAycQdtvWXxhTSDzpU0zAc+Cn5EVIAApzZWVfM
	 iezEHOJGExTU4pM/GYeUrusXlODXp9UUxf1E/zE5zgj9qP1evZSu85mS3GUBqPDWd/
	 fySIBvvi3rhHWcmDYaJN5Ij1ro1QXJE839m5LdjwnNPqvhPPj88d6Z6C8klEBKwDAG
	 6e//OQda/9ZKKiHNnMNjD4QZnhKTP+o6hwLIbMtMEU6Hfn5BefVsaDf+xjuwaCEmPR
	 Zs/2U7ABgq/Tw==
Subject:
 Re: [PATCH net-next] net/mlx5: Remove max_external_SFs device resource
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, cratiu@nvidia.com, gal@nvidia.com,
 jiri@resnulli.us, corbet@lwn.net, kees@kernel.org, leon@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, rdunlap@infradead.org, saeedm@nvidia.com,
 shayd@nvidia.com, skhan@linuxfoundation.org, horms@kernel.org
Date: Mon, 12 Oct 2026 09:40:45 +0000
Message-ID: <179179804565.434549.2194696630956114111@kernel.org>
In-Reply-To: <20261011093828.784454-1-tariqt@nvidia.com>
References: <20261011093828.784454-1-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch removes the device-scope devlink resource
  `max_external_SFs` (resource id 2, MLX5_DL_RES_MAX_EXTERNAL_SFS) from…
- [Low] The commit message says "Users can look up SF limits per-port
  directly via 'devlink port show'".

--

net/mlx5: Remove max_external_SFs device resource

This commit removes the device-level max_external_SFs devlink resource
from mlx5. The reason given is that the per-port max_SFs resources on
each PF port representor make it redundant. The devlink-resource.rst
examples are updated to match.

> Users can look up SF limits per-port directly via 'devlink port show'
> to correlate with controller number and pfnum.

[Severity: Low]
Is 'devlink port show' the right command here? Port-scoped resources are
returned by DEVLINK_CMD_RESOURCE_DUMP in net/devlink/resource.c. The port
get reply does not include them:

net/devlink/resource.c:devlink_nl_resource_dump_doit() {
    ...
	resource_list = devlink_port ?
		&devlink_port->resource_list : &devlink->resource_list;
    ...
}

The devlink-resource.rst updated by this patch lists port resources with
'devlink resource show pci/0000:03:00.0/196608' and 'devlink resource
show scope port'.

Could the commit message say that the max_SFs values come from devlink
resource show, and that devlink port show only maps the port index to
controller and pfnum?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> index 1724bf7e0e7af..c36dbd7de8778 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
> @@ -262,24 +262,17 @@ static void mlx5_sf_hw_table_res_unregister(struct mlx5_core_dev *dev)
>  	devl_resources_unregister(priv_to_devlink(dev));
>  }
>  
> -static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev, u16 max_fn,
> -					 u16 max_ext_fn)
> +static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev,
> +					 u16 max_fn)
>  {
>  	struct devlink_resource_size_params size_params;
>  	struct devlink *devlink = priv_to_devlink(dev);
> -	int err;
>  
>  	devlink_resource_size_params_init(&size_params, max_fn, max_fn, 1,
>  					  DEVLINK_RESOURCE_UNIT_ENTRY);
> -	err = devl_resource_register(devlink, "max_local_SFs", max_fn, MLX5_DL_RES_MAX_LOCAL_SFS,
> -				     DEVLINK_RESOURCE_ID_PARENT_TOP, &size_params);
> -	if (err)
> -		return err;
> -
> -	devlink_resource_size_params_init(&size_params, max_ext_fn, max_ext_fn, 1,
> -					  DEVLINK_RESOURCE_UNIT_ENTRY);
> -	return devl_resource_register(devlink, "max_external_SFs", max_ext_fn,
> -				      MLX5_DL_RES_MAX_EXTERNAL_SFS, DEVLINK_RESOURCE_ID_PARENT_TOP,
> +	return devl_resource_register(devlink, "max_local_SFs", max_fn,
> +				      MLX5_DL_RES_MAX_LOCAL_SFS,
> +				      DEVLINK_RESOURCE_ID_PARENT_TOP,
>  				      &size_params);
>  }

[Severity: Medium]
Does the per-port max_SFs fully replace max_external_SFs?

max_external_SFs has been visible on pci/<bdf> since commit 6486c0f44ed8
("net/mlx5: Expose max possible SFs via devlink resource"). It was
registered at probe, gated only by mlx5_vhca_event_supported(). Anything
that looks it up by name, or by resource id 2, will no longer find it in
any eswitch mode.

The replacement is registered only on this path:

mlx5_esw_offloads_load_rep()
  mlx5_esw_offloads_devlink_port_register()
    mlx5_esw_devlink_port_res_register()

Both ends of that path can skip it:

eswitch_offloads.c:mlx5_esw_offloads_load_rep() {
	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
		return 0;
    ...
}

esw/devlink_port.c:mlx5_esw_devlink_port_res_register() {
    ...
	if (vport_num != MLX5_VPORT_HOST_PF &&
	    !mlx5_esw_is_spf_vport(esw, vport_num))
		return 0;
    ...
}

In legacy mode (the default at probe), or when the host PF representor
isn't loaded, does any devlink resource still report the external host
SF capacity?

mlx5_sf_hw_table_init() still computes max_ext_fn through
mlx5_esw_sf_max_hpf_functions() and uses it for MLX5_SF_HWC_EXT_HOST. So
the driver still has the value, but no longer exposes it.

Also, mlx5_esw_offloads_devlink_port_register() only reports a failure
from mlx5_esw_devlink_port_res_register() through mlx5_core_dbg(). If
that registration fails, nothing exposes the value at all.

max_local_SFs stays device-level and is always visible, so the two
limits are now exposed in different ways.

SF port creation already requires switchdev mode, so in legacy mode the
missing value is planning information rather than something needed at
runtime. Even so, neither the commit message nor the devlink-resource.rst
update says that a user-visible resource is being removed. Neither says
that the port-level max_SFs entries exist only in switchdev mode.

Could this be stated, or could the device-level entry be kept for
compatibility?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011093828.784454-1-tariqt%40nvidia.com
