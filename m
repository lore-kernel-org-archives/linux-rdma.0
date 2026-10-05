Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AC241C8C;
	Mon,  5 Oct 2026 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189522; cv=none; b=DNQd77Oxl09yqN0UiZhAs2EIE/Y6ZXj5rTAPY2OJ7v4HELTBXNzxed3OUR0pzhQAPpoAsZG1qfMNlmgGxe9ZWyx2kEfd/6GYdmcn5QZ9lXtJ8wETlvhjxsTLGrXA2tODWM5+nxod8cUGUHjezmLC5/eQu3GxO6Nh0OVnU5V4Wbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189522; c=relaxed/simple;
	bh=MC1KmqeTtDk1eyOH8gIRGM2S3YtpB2hWGEh9wtV+Ypw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iqfaa8LyzFVNYtdTKKy5KqN6rNRJnIyCLpEjGztLYgT/VVav/bdEnrGU1BWHgrIb8aYYRC100sING/0eAJIAJuBhpwEEwabHWveRd6Tr9HvK0+V6KAwUxJ3doRObWbJmeumQ/PQlRrxeclBOOaVX0ZxhXdi9HsOeBZf30tRtRCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnBpTi3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnBpTi3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A7D1F000FF;
	Mon,  5 Oct 2026 08:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791189520;
	bh=Cl0maxNxupkaqap8L0nASdcsNOyfNaewhXeRFnK8a5E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KnBpTi3tjAWly/xnxfB5gYgMvI5SUgY51rD0jAAyvmS0z+X9yxCV4IkgyZCow9E2y
	 w0S00Z4AMdl59JclIK+sMfbmphAFCSPByzQZ8rrn9Bknyp47IOSVh/+1685vt/VVFt
	 hkkDxUNMiWsd48A6ynw0cpbW88S7p1Ml3z5+j1uK1GxwLVOD9MvKidRZhHlw1ZH33z
	 CKheF+tETMkEyU2MV2hX4tQfijk/4KmPBXZdGTyU3FTKYg5jsFCQBtuUmlnxGOqZqA
	 pmlNil6C2SNWjiMaPdWm1RSrBK1wS/FKaqtdkf5bfqBATBRwhbMgQJdTBUCU1pOdhb
	 MxUi9+02yARjA==
Subject: Re: [PATCH net] Revert "net/mlx5: E-Switch, preserve max tx speed on
 vport state modification"
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, horms@kernel.org
Date: Mon, 05 Oct 2026 08:38:39 +0000
Message-ID: <179118951927.434549.1850225496015622556@kernel.org>
In-Reply-To: <20261004083531.216988-1-tariqt@nvidia.com>
References: <20261004083531.216988-1-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The revert's correctness rests on a firmware claim that cannot
  be checked from the kernel tree, and that claim contradicts the commit…

--

Revert "net/mlx5: E-Switch, preserve max tx speed on vport state modification"

This reverts the query-and-write-back of max_tx_speed in
mlx5_modify_vport_admin_state() and mlx5_esw_adj_vport_modify(). The
commit message says FW treats a zero max_tx_speed in MODIFY_VPORT_STATE
as "not provided", so no query is needed to keep the current value.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> index 5774ec1174287..78f3d15b599d0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> @@ -93,30 +93,6 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
>  	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
>  #endif
>  
> -	if (MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed) &&
> -	    opmod == MLX5_VPORT_STATE_OP_MOD_ESW_VPORT &&
> -	    vport != MLX5_VPORT_UPLINK) {
> -		u32 speed = 0;
> -		int err;
> -
> -		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
> -						    other_vport, &speed, NULL);

[ ... ]

> -		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
> -	}
> -
>  	MLX5_SET(modify_vport_state_in, in, opcode,
>  		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
>  	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);

[Severity: Medium]

The commit being reverted, ad0ae7aefa7a, describes the opposite firmware
behavior:

  "When modifying vport state, the firmware interprets a zero in the max tx
  speed field as an intentional reset, which can overwrite previously set
  values."

This revert says:

  "FW skips writing it whenever it's 0, treating that as "not provided"
  rather than "reset to zero"."

Which of these is correct, and does it hold for every FW version?

Could the commit message explain why the earlier description was wrong?
For example, it could cite the PRM or a FW version where this behavior
was confirmed.

The command layout has valid bits for the connect fields but none for
max_tx_speed:

include/linux/mlx5/mlx5_ifc.h:mlx5_ifc_modify_vport_state_in_bits {
    ...
	u8         max_tx_speed[0x10];
	u8         ingress_connect[0x1];
	u8         egress_connect[0x1];
	u8         ingress_connect_valid[0x1];
	u8         egress_connect_valid[0x1];
    ...
}

So after this patch, mlx5_modify_vport_admin_state() and
mlx5_esw_adj_vport_modify() always send max_tx_speed=0. Whether that
keeps the current speed is decided entirely by FW.

Suppose some FW that advertises esw_vport_state_max_tx_speed does reset
on zero. Would routine admin state changes then clear the LAG-aggregated
speed programmed by mlx5_lag_modify_device_vports_speed()? For example:

ip link set <rep> down
  mlx5e_rep_close()
    mlx5_modify_vport_admin_state(priv->mdev,
                                  MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
                                  rep->vport, 1,
                                  MLX5_VPORT_ADMIN_STATE_DOWN);

The same applies to mlx5e_rep_open(), mlx5e_rep_change_carrier() and
mlx5_eswitch_set_vport_state(). It also applies to adjacent vport connect
and disconnect, which mlx5_esw_fdb_active() and mlx5_esw_fdb_inactive()
do through mlx5_esw_adj_vport_modify().

In that case vport->agg_max_tx_speed would still hold the aggregated
value. Nothing would reapply it until the next LAG event or
mlx5_esw_vport_enable(). That is the hardware/software mismatch that
ad0ae7aefa7a set out to fix.

Also, this patch carries a Fixes: tag, but the commit message only calls
the reverted code "unnecessary" and names no defect. The reverted code
added one query and wrote back the value FW had just reported.

Is there a user-visible problem being fixed here? If not, would this fit
better as a cleanup without the Fixes: tag?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261004083531.216988-1-tariqt%40nvidia.com
