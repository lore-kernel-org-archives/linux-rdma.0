Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A754655;
	Mon,  5 Oct 2026 07:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791186151; cv=none; b=jjeLtjiiPpLA8RbOTEY+6BzcWboNiNgs18IEdlD4IH8+liZgVKms0BvxkP2LNDy7kT/nfqa5TkgbokeV76KCkFaFKwDV2Pp7mEJ7OURJqGSR+BmWlwdn8e5a8uNYym3PoFxHqw3oAfYWaemRYpCsO2QvYdyGl9dEXqC+dJ6ahbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791186151; c=relaxed/simple;
	bh=PlnSP6duwTC6qtREeGDzh7rpURM3ZLG5oAJ0vuf8D/c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rIdNptZdURg4chbLVyMBORbIMvzicN5STISEWI3K6f2boUsKSbunqU1M/MDvDtrAMA32y8LTsvEU6O+TP3e7Q2y8vye2bvmWAkKRCE2OC0U7xdfs0o6Bq1p8g+z2YljUBeITaFvNNB12ESbVACuMic2C/QS/ZJwgZZKe/Of4Pvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkbKhayI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkbKhayI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92BE1F000FF;
	Mon,  5 Oct 2026 07:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791186149;
	bh=IaTlnxZz7nBD56ElFhANPa4xnjc25EbECMZzAeuEaQs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UkbKhayIl4rPmBD4E889Y7WUE3qrZOrtYXvGp5RPnqQuVrwlDRfxaG2h8egy/F66P
	 eHdKEC72E21qi50lJxx1gvL9OqQs2AXzDOiKO8qKmYvJcwr1+iXoPaXdJWBieI59FR
	 gu3Ct7PS1NTh7eyk+4XLjOKMJSqj4JY+wkwCoFoVsuOFBKm82DGrEyyfEo4MGCzAgP
	 l0t3VITDnRuIXTmO1IPcI+YUQGLqlLqB+TZoyegI3QO5Zhcd9Za9FZaA/zVYd2Lfw5
	 7uM3mBGMkDIg3prHfiIvWMGMwTIV9Um61I+yEaFZWHGl93CxHMPD4+J077zwmkwmMq
	 EkPNCenlDRWAw==
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Mon, 05 Oct 2026 07:42:28 +0000
Message-ID: <179118614831.434549.13938965801473464638@kernel.org>
In-Reply-To: <20261004070246.215239-1-tariqt@nvidia.com>
References: <20261004070246.215239-1-tariqt@nvidia.com>
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

- [Medium] This patch breaks the query-failure fallback added by commit
  ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport…
- [Medium] The commit message does not match the code change.

--

net/mlx5: Lag, only cache max_tx_speed that FW has not accepted

This patch changes mlx5_lag_modify_device_vports_speed() so that
vport->agg_max_tx_speed is written only when the vport is disabled or the
FW push fails. When the push succeeds, the cache is cleared to 0. The
enable-time replay in mlx5_esw_vport_set_max_tx_speed() also clears the
cache on success.

Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/

> mlx5_lag_modify_device_vports_speed() also wrote it for enabled vports,
> unconditionally, before even attempting the FW push. If that push
> failed, the cache still claimed speed had been applied, even though FW
> might still hold the old value. That unconfirmed value could then leak
> out: mlx5_esw_vport_enable() replays it if the vport is later disabled
> and re-enabled with no LAG update in between.

[Severity: Medium]
Does the change actually address the scenario described here?

After this patch, the failure branch in
mlx5_lag_modify_device_vports_speed() still caches the speed:

		if (ret) {
			mlx5_core_dbg(mdev, ...);
			vport->agg_max_tx_speed = speed;

and mlx5_esw_vport_enable() still replays any nonzero value:

	if (vport->agg_max_tx_speed)
		mlx5_esw_vport_set_max_tx_speed(esw, vport);

So a failed push followed by a disable and re-enable, with no LAG update
in between, behaves the same before and after the patch. The third
paragraph of the message keeps this on purpose.

> Clear it once FW has accepted the value, so a superseded speed is not
> replayed over a newer one.

Which path could program a newer speed that a stale cache would then
overwrite? Only two places write agg_max_tx_speed, and they are also the
only callers of mlx5_modify_vport_max_tx_speed(). One is the LAG loop,
which always overwrites the cache with the latest LAG speed. The other is
the enable-time replay.

The only real change in behavior seems to be clearing the cache on
success. The message doesn't mention two side effects of that:

- The query-failure fallback added by ad0ae7aefa7a ("net/mlx5: E-Switch,
  preserve max tx speed on vport state modification") stops working (see
  below).
- Vports that were programmed successfully no longer get a replay on
  re-enable.

Because of the Fixes: c6df9a65cbb0 tag, this change would go to stable
trees even though the bug described above can still happen. Could the
commit message and the Fixes tag be revisited?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index fc197d1dc9dfe..f8c220bf7b5ca 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -951,6 +951,8 @@ static void mlx5_esw_vport_set_max_tx_speed(struct mlx5_eswitch *esw,
>  		mlx5_core_dbg(esw->dev,
>  			      "Failed to set vport %d speed %d, err=%d\n",
>  			      vport->vport, vport->agg_max_tx_speed, ret);
> +	else
> +		vport->agg_max_tx_speed = 0;
>  }
>  
>  int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 3b34bec559e08..7cee78cb47df9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1502,17 +1502,21 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
>  		if (vport->vport == MLX5_VPORT_UPLINK)
>  			continue;
>  
> -		vport->agg_max_tx_speed = speed;
> -
> -		if (!vport->enabled)
> +		if (!vport->enabled) {
> +			vport->agg_max_tx_speed = speed;
>  			continue;
> +		}
>  
>  		ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
>  						     vport->vport, true, speed);
> -		if (ret)
> +		if (ret) {
>  			mlx5_core_dbg(mdev,
>  				      "Failed to set vport %d speed %d, err=%d\n",
>  				      vport->vport, speed, ret);
> +			vport->agg_max_tx_speed = speed;
> +		} else {
> +			vport->agg_max_tx_speed = 0;
> +		}

[Severity: Medium]
Can clearing the cache here break the query-failure fallback in
mlx5_modify_vport_admin_state()?

That function, and mlx5_esw_adj_vport_modify() in esw/adj_vport.c, use
agg_max_tx_speed as the last known speed when QUERY_VPORT_STATE fails:

drivers/net/ethernet/mellanox/mlx5/core/vport.c:mlx5_modify_vport_admin_state() {
    ...
		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
						    other_vport, &speed, NULL);
		if (err) {
			...
			speed = IS_ERR(esw_vport) ? 0 :
				esw_vport->agg_max_tx_speed;
			...
		}
		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
    ...
}

With this patch, agg_max_tx_speed becomes 0 on every vport whose LAG speed
was pushed successfully, either here or in the replay in
mlx5_esw_vport_set_max_tx_speed().

Suppose a later admin state change on that vport hits a query failure.
Wouldn't the fallback then send max_tx_speed = 0, which ad0ae7aefa7a
describes as an intentional reset in FW? That would wipe the LAG aggregate
speed that was just programmed:

mlx5_lag_modify_device_vports_speed()
  mlx5_modify_vport_max_tx_speed()      /* succeeds */
  vport->agg_max_tx_speed = 0
...
mlx5_modify_vport_admin_state()
  mlx5_query_vport_max_tx_speed()       /* fails */
  speed = esw_vport->agg_max_tx_speed   /* 0 */
  MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed)

These are the admin state changes that can reach this path:

- mlx5e_rep_open(), mlx5e_rep_close() and mlx5e_rep_change_carrier()
- mlx5_eswitch_set_vport_state()
- esw_vport_setup() and esw_vport_cleanup()

Adjacent vport connect and disconnect through mlx5_esw_adj_vport_modify()
are affected the same way. After that, nothing pushes the speed again
until the next LAG speed event.

Before this patch, the cache still held the programmed speed after a
successful push, so the fallback rewrote the correct value.

The patch now treats agg_max_tx_speed as a pending value, but both
fallback readers still treat it as the last programmed speed. Can one
field serve both meanings?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261004070246.215239-1-tariqt%40nvidia.com
