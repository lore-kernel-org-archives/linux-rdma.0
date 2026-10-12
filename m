Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3EF41A4E4;
	Mon, 12 Oct 2026 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807023; cv=none; b=KSCqyYJVK5rxHaHr588zr4b0VQY+VuUouJgtMn31qS/c/71a09g14ZXy5ARjEsy3iIFzg8lNGAisbX1e32nlJB6RP/wVu6cgt9sXX3MS6xoCJrG1M8zoejrsB03ie/ga0x1GZeIUdobnnWI6JvmRdi2sabM0yWG1fn5rA2nVmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807023; c=relaxed/simple;
	bh=l6raZMAXhf9dMLYNhLhwY95pksikfmORW40GrE2iy34=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nInVNdaoB5+ou5BrSIWJ/rC513dAXiyKAnLv43p4ymKXfP2xg/0hqDIAIPjqeA24nuMhZJQn5f4ALK9uawcb4NwVXxX9i4iB0BxJEe3LOT75SmYBAtEM6c6xbrrUEOfJ1HC7p1K+9b77Zt5DbPJgWb1ktKUXAzQ1enxsM7WKtis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZSClGga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZSClGga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F901F0089B;
	Mon, 12 Oct 2026 12:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791807018;
	bh=anrg1c6253FnLZIpERC0khiiG86vNVw6etBg+OrCLc8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mZSClGgaM9kY1Is7etP7rlPP+pnJ++gzStyBSiAKSb3o2d7g6hYUPN8qzhmwWur0m
	 NsAXQprs6JKO3MITKNcLWubZvuZ0M40zk9oJ4ML4II0ICaUAfw25ab5G4k8S/3Hjz1
	 B0+6ogGRFDaKz/kGUrWFy/VU7jAMitI+kOwYNrVtwFPqMsLMwnJenRneOHrHm4I19f
	 bLbAhsHIvhQVVGgeKq1/ySL5o+/wQnIE975nRdyC+SLHUikKHi5pjpasCEZ8FctnR3
	 hcL7skuJ4q7q8Uh3GR2a7RQom7GiNdtJ/xupw6uqpYhODwy/QcatODAc3NA7Eyarqk
	 9Hw+yiePDzBIg==
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Select DCBX HOST/AUTO from
 capability flags in setdcbx
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, alazar@nvidia.com,
 cjubran@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com
Date: Mon, 12 Oct 2026 12:10:17 +0000
Message-ID: <179180701752.434549.16734295951082648234@kernel.org>
In-Reply-To: <20261011112900.802150-2-tariqt@nvidia.com>
References: <20261011112900.802150-2-tariqt@nvidia.com>
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5e_dcbnl_setdcbx()
  (drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c) now returns…
- [Medium] The patch reports firmware AUTO mode as CEE|IEEE|LLD_MANAGED
  (0x0e), but only on the setdcbx HOST->AUTO transition path.

--

net/mlx5e: Select DCBX HOST/AUTO from capability flags in setdcbx

This commit changes mlx5e_dcbnl_setdcbx() so that the DCB_CAP_DCBX_HOST
bit selects firmware HOST or AUTO DCBX mode. That merges the two old code
paths into one. When it switches to firmware-controlled mode, it reports
CEE, IEEE and LLD_MANAGED together because of a firmware limitation.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> index 741f75b5bfec..4eef929f5ae9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c

[ ... ]

> @@ -453,32 +434,31 @@ static u8 mlx5e_dcbnl_getdcbx(struct net_device *dev)
>  
>  static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev, u8 mode)
>  {
> +	bool new_is_host = mode & DCB_CAP_DCBX_HOST;
>  	struct mlx5e_priv *priv = netdev_priv(dev);
>  	struct mlx5e_dcbx *dcbx = &priv->dcbx;
> +	enum mlx5_dcbx_oper_mode target_mode;
>  
>  	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
>  		return 1;
>  
> -	if ((!mode) && MLX5_CAP_GEN(priv->mdev, dcbx)) {
> -		if (dcbx->mode == MLX5E_DCBX_PARAM_VER_OPER_AUTO)
> -			return 0;
> -
> -		/* set dcbx to fw controlled */
> -		if (!mlx5e_dcbnl_set_dcbx_mode(priv, MLX5E_DCBX_PARAM_VER_OPER_AUTO)) {
> -			dcbx->mode = MLX5E_DCBX_PARAM_VER_OPER_AUTO;
> -			dcbx->cap &= ~DCB_CAP_DCBX_HOST;
> -			return 0;
> -		}
> +	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
> +		return !new_is_host;
>  
> -		return 1;
> -	}
> +	target_mode = new_is_host ? MLX5E_DCBX_PARAM_VER_OPER_HOST :
> +				    MLX5E_DCBX_PARAM_VER_OPER_AUTO;
> +	if (dcbx->mode == target_mode)
> +		return 0;

[Severity: Medium]
Do these two early returns lose the requested DCBX flags?

If the device lacks the dcbx HCA capability, the first check returns 0
for any HOST request.

If firmware is already in the target mode, the second check returns 0.
One example is a host LLDP agent sending HOST|VER_IEEE (0x09) while the
port is already in HOST mode.

Neither path reaches the "dcbx->cap = mode;" at the end of the function.

Before this patch, both cases went through
mlx5e_dcbnl_switch_to_host_mode(). That helper returned 0 when the cap was
missing or the mode was already HOST, and the caller then did:

	dcbx->cap = mode;
	return 0;

Now dcbnl_setdcbx() reports success to userspace, but
mlx5e_dcbnl_getdcbx() keeps returning the initial CEE|IEEE|HOST (0x0d).
The same stale value goes into DCB_ATTR_DCBX in the IEEE/CEE get and
notify paths, and into event.dcbx for dcb_app notifier events.

fcoe_dcb_app_notification() in drivers/scsi/fcoe/fcoe.c consumes that
value:

	if (entry->dcbx & DCB_CAP_DCBX_VER_CEE)
		prio = ffs(entry->app.priority) - 1;

If VER_CEE is still set after userspace selected IEEE only, could FCoE
read an IEEE priority as a CEE bitmap?

The commit message only talks about folding the two code paths into one.
Was this change in behaviour intended? It is still present at the end of
the series.

>  
> -	if (!(mode & DCB_CAP_DCBX_HOST))
> +	if (mlx5e_dcbnl_set_dcbx_mode(priv, target_mode))
>  		return 1;
>  
> -	if (mlx5e_dcbnl_switch_to_host_mode(netdev_priv(dev)))
> -		return 1;
> +	if (!new_is_host)
> +		mode = DCB_CAP_DCBX_VER_CEE |
> +		       DCB_CAP_DCBX_VER_IEEE |
> +		       DCB_CAP_DCBX_LLD_MANAGED;

[Severity: Medium]
Does the reported AUTO state now depend on history rather than on the
firmware state?

This sets cap to CEE|IEEE|LLD_MANAGED (0x0e), but only after an actual
HOST to AUTO transition. mlx5e_dcbnl_initialize() was not updated. When
firmware is in a non-host mode at probe time, it still does:

	priv->dcbx.cap = DCB_CAP_DCBX_VER_CEE |
			 DCB_CAP_DCBX_VER_IEEE;
	if (priv->dcbx.mode == MLX5E_DCBX_PARAM_VER_OPER_HOST)
		priv->dcbx.cap |= DCB_CAP_DCBX_HOST;

That gives 0x0c, without LLD_MANAGED. A later non-host setdcbx request
then hits the "if (dcbx->mode == target_mode) return 0;" check above, so
LLD_MANAGED is never added.

So the same firmware state is reported as 0x0c after booting in AUTO, but
as 0x0e after a runtime switch to AUTO. The difference shows up in:

  - getdcbx
  - DCB_CAP_ATTR_DCBX, since mlx5e_dcbnl_getcap() ORs in dcbx->cap
  - DCB_ATTR_DCBX in the IEEE/CEE get and notify paths
  - event.dcbx

Before this patch, both paths reported 0x0c.

Should mlx5e_dcbnl_initialize() also set LLD_MANAGED in the AUTO case?
That would match "report CEE, IEEE and LLD_MANAGED together" from the
commit message.

There is a related problem in the same function. setdcbx still rejects
LLD_MANAGED at the top even though it now reports it, which breaks a get
then set round trip.

The later patch in this series, "net/mlx5e: Add DCB_CAP_DCBX_LLD_MANAGED
support in setdcbx", fixes that part by removing the check. The
history-dependent reporting is still present at the end of the series.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011112900.802150-1-tariqt%40nvidia.com
