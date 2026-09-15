Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0764E3CBE9C;
	Tue, 15 Sep 2026 01:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437085; cv=none; b=EQT9+cEZPoZuCBjcoW0qxCzS6p32Fle6bnq0Lf8bWiL7qw5eh2vU5o9VbBT1VE2ZvP8iiPEDOIEro4Gn/Dae9rAopSnBNFCci57HQEY4dnGFQfJgYnZ19JncHHryALTyZgQaVarhHGDLo5tYj63iluMCnI6ARuMpDprWNm5n4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437085; c=relaxed/simple;
	bh=E1ucaflFItR9siFhcRRr6KFkMWdYqUsIIMazmS/kmCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJrhH1L21G//zpgHmm6AiTnMtNK8erjgqp3bXm33YYJuBgJ5COEshfSfA6BeD7BeCjzGn8GzPAZW2p2cNo76zt538qbdeH4Cl1fz+ZTnw7K7M4L1Wg8n8QgRVBYKw0aHAOpdp1/d5DP7tnT/oFhVY3Vl1Pq+RVqOroSDdTDuLRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uoc435NI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uoc435NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A43E1F00893;
	Tue, 15 Sep 2026 01:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437083;
	bh=uEohjPuGdO6g06Ts2rEgwJCG9gECWcT0mC8kzhYWVCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uoc435NIUWrBi1VQbVIMaGHmq8nsgAHNpqzmrANzIWdimn65Y3ICHIeyt0iGDD+Do
	 RhhhzbRHl8rpavetEjqP0fU7jUWGf1SrnAlKN3daap6Hog2sW+MGiu85sJ9cNL19MA
	 hhsCtD1AbDCBwNtzy70TX/lP+zbiaLv2W7u9z6GjU7kKdcKhkvFvjMWiqyQ8fv8HXS
	 4f8tZB5PCTU9qCpSOuj/BGX2KjeRoRr/jA8PAfEYDZN7bWtXhKuU7cKE16VlbbB4MG
	 +XqAG7iFCoZmneS8YNKHoMvHd05/qxxtBpitmTVe9WLtZZ+/V8WIvIkv+YmspUKmdj
	 hgL9ovLOlGy8w==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edwards@nvidia.com,
	gal@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	msanalla@nvidia.com,
	mbloch@nvidia.com,
	ohartoov@nvidia.com,
	saeedm@nvidia.com,
	shayd@nvidia.com
Subject: Re: [PATCH net 2/5] net/mlx5: Lag, reset vport speed on teardown
Date: Mon, 14 Sep 2026 18:51:22 -0700
Message-ID: <20260915015122.875353-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910102432.3845360-3-tariqt@nvidia.com>
References: <20260910102432.3845360-3-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/mlx5: Lag, reset vport speed on teardown

The cached agg_max_tx_speed was only reset on the regular LAG teardown
path in mlx5_do_bond(), so MPESW teardown left stale values behind. The
reset call is moved into mlx5_deactivate_lag() so all teardown paths run
it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 5aa9d5c98fe16..c2f21eb4ea7cf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1075,6 +1075,8 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
>  	if (master_idx < 0)
>  		return -EINVAL;
>  
> +	mlx5_lag_reset_vports_speed(ldev);
> +

[Severity: Medium]
This isn't a bug introduced by this patch, but now that mlx5_deactivate_lag()
is the single place claimed to reset the vport speeds on "every teardown
path", is the helper it calls complete enough for that claim?

mlx5_lag_reset_vports_speed() skips a PF entirely when the oper speed query
fails:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_reset_vports_speed() {
	ret = mlx5_port_oper_linkspeed(mdev, &speed);
	if (ret) {
		mlx5_core_dbg(mdev,
			      "Failed to reset vports speed for device %s. Oper speed is not available (err=%d)\n",
			      dev_name(mdev->device), ret);
		continue;
	}
}

For that PF, vport->agg_max_tx_speed keeps the LAG aggregate value written
earlier by mlx5_lag_modify_device_vports_speed(), and enabled vports keep
the aggregated max_tx_speed in FW even though the FW LAG object is
destroyed.

The stale value then gets replayed later, in eswitch.c:

mlx5_esw_vport_enable() {
	if (vport->agg_max_tx_speed)
		mlx5_esw_vport_set_max_tx_speed(esw, vport);
}

and is also used as the fallback in vport.c:

mlx5_modify_vport_admin_state() {
	speed = IS_ERR(esw_vport) ? 0 : esw_vport->agg_max_tx_speed;
}

so an inflated reported TX speed can survive with no LAG present. This is
the same best-effort handling that came in with 50f1d188c580, and moving the
call site strictly increases the number of paths that attempt the reset, so
nothing is made worse here.

Both mlx5_lag_reset_vports_speed() and
mlx5_lag_modify_device_vports_speed() return void, so mlx5_deactivate_lag()
cannot observe the skip and still returns 0. Would it make sense to have the
reset path clear the cached agg_max_tx_speed (or fall back to zero) when
mlx5_port_oper_linkspeed() fails, rather than leaving the LAG aggregate
cached?

Also worth noting on the caching order in
mlx5_lag_modify_device_vports_speed():

	vport->agg_max_tx_speed = speed;

	if (!vport->enabled)
		continue;

	ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod, vport->vport, true, speed);
	if (ret)
		mlx5_core_dbg(...);

the cache is updated before the FW command and a FW failure is only logged,
so cache and FW can diverge during teardown too.

> @@ -1676,7 +1678,6 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
>  		mlx5_modify_lag(ldev, &tracker);
>  		mlx5_lag_set_vports_agg_speed(ldev);
>  	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
> -		mlx5_lag_reset_vports_speed(ldev);
>  		mlx5_disable_lag(ldev);
>  	}
>  }
