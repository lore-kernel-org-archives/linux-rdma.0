Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7C52B1DD;
	Wed,  9 Sep 2026 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956149; cv=none; b=YwU759WmfL55jtJ/jdjX6Aby37ymTdoCeKAyOhHqfPXSRaVdLyazXqd9mWrxGVRt2zUW2Wndj9/9pjqu1MVCnRJqOnDD/Xc3hqdtsg/VD3n2pMbe6xQLvR+FaE+jJFxfQXMVE0w8+FfQytRl+5QuvIp5N+QtEYFxEM9gggjM1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956149; c=relaxed/simple;
	bh=8kUX4aNITYpQ023PHJrAC2emHd6Do3cGygd3XJUZyhA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qmiiX17DGoXs1aATIcnaBkBMAOwQOF035dSwkYoFuhZlsQ2IVblq5iNbVjAe9UmwMIFBhP+9+RCgXu5LHv36Z6Ds7FpLMGG3FQ4a0Cep7SKOo+/jm4PVfp5JBjpCZkOu5BIWQXpbSW5QMlmaI7DPMfShFx9R3ZeohxONhzvxx0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5FLItc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5FLItc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536E01F00A3D;
	Wed,  9 Sep 2026 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788956147;
	bh=hM5JFTeqOLPKwwIt7nA5wlvHtN96CuzJXxzeiWd2YdI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=n5FLItc8NSS5GJGZlwSnNHjTOLmo9BnHxPOheWU6CmdSvEn0spZ+5D3LcyLEldgw1
	 C9eGFnkWQNY64ACnb7OAL1Y7LXZtK07dPimoEeJnuvpNn1adkQ07LXUSOeyhTTHg65
	 jADlPg7sv16xZ3IR9OdyFndtWxaV9+erxhhMvVwjmWtEZKdDJ5GCEsJn5r8IpYrykx
	 RHDP8mKq05G+1Nwxpx3+L9Bpc6PA3doPqfWxV8/fQEoJmGpRtQTg7wAdlblwTz4Y8G
	 KuIFTu78kg28eBoMF67ttQN/yruUeHYC/CRY9FceBLBX6RIfPlmRG38JXT0kfpDE0P
	 ++6UjHZhXHKsA==
Subject: Re: [PATCH net V2 3/4] net/mlx5: SD, unload reps on shared FDB create
 error path
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, edwards@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 msanalla@nvidia.com, mbloch@nvidia.com, ohartoov@nvidia.com, parav@nvidia.com,
 phaddad@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org
Date: Wed, 09 Sep 2026 12:15:45 +0000
Message-ID: <178895614589.219967.9154250282246662158@kernel.org>
In-Reply-To: <20260906071332.3759199-4-tariqt@nvidia.com>
References: <20260906071332.3759199-4-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Commit message of "net/mlx5: SD, unload reps on shared FDB create
  error path" describes the change only as symmetry ("The teardown path…

--

net/mlx5: SD, unload reps on shared FDB create error path

The SD branch of mlx5_lag_shared_fdb_create() now unloads the
representors on the error path after destroying the single FDB, matching
what mlx5_lag_shared_fdb_destroy() does.  The patch carries a Fixes: tag
for 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG
state").

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> index 6b4ad3c53f2f3..424040918fa37 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
> @@ -270,6 +270,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
>  			pf->sd_fdb_active = false;
>  		}
>  		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
> +		mlx5_lag_unload_reps_from_locked(ldev, filter);

[Severity: Low]
This isn't a bug in the code, but could the changelog say what state was
actually left behind before this call was added?

The commit message only describes symmetry:

    The teardown path unloads the representors; align the create error
    path to do the same.

In the SD branch, mlx5_lag_shared_fdb_create() sets sd_fdb_active for
every group member before the rescan and the reps reload:

	mlx5_lag_for_each(i, 0, ldev, filter) {
		pf = mlx5_lag_pf(ldev, i);
		pf->sd_fdb_active = true;
	}
	...
	mlx5_lag_rescan_dev_locked(ldev, dev0, true);
	err = mlx5_lag_reload_ib_reps_from_locked(ldev, 0, filter, false);
	if (err) {
		mlx5_core_err(dev0, "Failed to enable lag\n");
		goto err_rescan_drivers;
	}

Non-uplink reps are only skipped while SD LAG is inactive, per
mlx5_esw_offloads_rep_load() in eswitch_offloads.c:

	if (vport_num != MLX5_VPORT_UPLINK &&
	    mlx5_get_sd(esw->dev) && !mlx5_lag_is_active(esw->dev))
		return 0;

so reps do get loaded in that window.  If
mlx5_lag_reload_ib_reps_from_locked() then fails, err_rescan_drivers
clears pf->sd_fdb_active and calls
mlx5_lag_destroy_single_fdb_filter(), which left the VF/SF reps loaded
while SD LAG is no longer active, i.e. exactly the state that
68c2dd59a6c7 was written to avoid.

Since this is Fixes-tagged and therefore stable material, would it help
to spell that resulting state out in the changelog?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906071332.3759199-1-tariqt%40nvidia.com
