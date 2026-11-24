Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509171;
	b=l1+DpdyuUObBwmOoO+eqjkhMbOzMENWL2AtBgiHo7oC7jvQVHeIMeLE3bZTQFMUkdvrS
	 8BD1j3CdsihrddxkzQMhZI741l9J8AmBuzYDtLm+qwhdOm73rfJl9RX6xCoKBKq/QZEZ8
	 3TTPABzS+hG5lxlaa86A51ox0+WqUOKV3EKzG+XMTZ1wHX+GthV1LSBo6D1nfROilfhWD
	 WruBvSfD41ulMpD0qEm175x+aqfEc09Od+IJWogzdsqO64944lWNXVsSKKkXTdfQ7J1js
	 oyDcvkVc9WuhikADfU3Wvmnju9U5Tp5xF45LQI3oit9cMV+4TrYmVGdiIyDUbWHhXGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509171;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=SSWvAwr/5hEsEptr43m3m8mH5r8bFDdlRYQILkQYTEM=;
	b=4MidSxzNLQ38LK/joPJCMlbvg1tBPv+xQ+qq+YFZqzTXlBPjL+MCjFzQxPJfmJXyg/j6
	 33Wcx0tvBh0gn21Uzbwf7b6u07WUW/jn8qj0YIwcXg9cwRCmr76kyiXwIhEa0UEjj1h+K
	 1eRaapudWhAj/BCHTMgfDDthT2vEjtW+BplvUSGwERV/Em6otblCujvc3UcaoPDAwuAGj
	 nznfCmbUMM4e1VX6+0RbrvmvsbgdnV7Gp3P4hR0euCAm3BdEiPpfJo8KdVUc8T67/EII+
	 SNM/P+vKka65pAyHTp1BOKpX9d3vKkrGq+29sNLmFymU6tokbYoEXJ/ebm52YDV7qNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hXm+mFJ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A133A606A6A4;
	Tue, 24 Nov 2026 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hXm+mFJ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473DD1F000EB;
	Tue, 24 Nov 2026 08:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509171;
	bh=SSWvAwr/5hEsEptr43m3m8mH5r8bFDdlRYQILkQYTEM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hXm+mFJ0ZVFvxtft1siHaeFCEq15eVyX1uNX3Viw8chFsdW5P1zxElSeuZG8anSYo
	 SylVsyGdIx2tHYNfnJrir+0jX868exfOO8lr1TbOeMD/dLvPofdGdfvJY4b64RihGH
	 j0v+Mb3iWuULc5ch2IuzUYmXkATmFgP3Le49YbixtYcXWETt2ELynCtzPZC0tG0g8e
	 F1Fq+p7C/QJ2/FtY3Y5+iZR8iraAhxGJYjGWhzdjx/ryPu63jIGHbhi+6tTTkemNU1
	 U+X8nez2jByFn88divXgrhtdmpGSy1x5IAfC62IQiq97uklyEpHxwxO29A4YDNHr5u
	 WReMwwvxgnR+A==
Subject: Re: [PATCH net-next V2 3/5] net/mlx5: E-switch, drop master egress
 rule under a SW vport LAG
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Tue, 24 Nov 2026 08:32:49 +0000
Message-ID: <179550916987.3135.15857697066223649709@kernel.org>
In-Reply-To: <20261120075959.2533702-4-tariqt@nvidia.com>
References: <20261120075959.2533702-4-tariqt@nvidia.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5_eswitch_offloads_vport_lag_del_one() calls
  esw_set_master_egress_rule() for every slave that passes…
- [Low] The commit message describes the conflict as a general property
  of the software vport LAG: the master egress rule redirects the…

--

net/mlx5: E-switch, drop master egress rule under a SW vport LAG

This commit removes a slave's eswitch master egress rule when the
software vport LAG slave egress rule is installed. It restores the rule
when the vport LAG is removed. It also moves the MPESW metadata cleanup
in mlx5_lag_disable_mpesw() to after the shared FDB is destroyed.

> The software vport LAG emulation cannot. It is a catch-all rule in the
> slave eswitch's egress ACL that forwards to the master's manager vport,
> while the master egress rule redirects the packet after the FDB - past
> the point where the slave egress rule is evaluated - so the bounced
> packet never reaches it.
>
> The two therefore cannot coexist: drop the master egress rule when the
> software vport LAG is installed, and restore it when it is removed.

[Severity: Low]
Is this conflict already present in shipped kernels for MPESW over SD
groups?

Before this patch, MPESW over SD appears to install both rules for the
other SD primary:

mlx5_lag_enable_mpesw()
  mlx5_mpesw_teardown_sd_fdb()          /* clears fn->sd_fdb_active */
  mlx5_lag_shared_fdb_create(FILTER_ALL)
    mlx5_activate_lag()
      mlx5_create_lag()
        mlx5_lag_create_single_fdb()
          mlx5_eswitch_offloads_single_fdb_add_one()
            /* master egress rule for each SD-primary slave */

Then mlx5_ib loads on the master:

mlx5_eth_lag_init()
  mlx5_cmd_create_vport_lag()           /* sw path, group_id != 0 */
    mlx5_lag_create_vport_lag()         /* FILTER_ALL */
      mlx5_eswitch_offloads_vport_lag_add_one()
        esw_set_slave_egress_rule()     /* only this, pre-patch */

Following the commit message's own reasoning, that pair of rules
misdelivers traffic.

The software vport LAG came from 98d56915eef5 ("net/mlx5: LAG, introduce
software vport LAG implementation"). MPESW over SD came from
de464720489c ("net/mlx5: LAG, add MPESW over SD LAG support").

Could the commit message say that the existing MPESW over SD
configuration is affected, and add the matching Fixes: tag?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 57f58e79478e4..2072921c1fffa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3380,12 +3380,32 @@ void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
>  int mlx5_eswitch_offloads_vport_lag_add_one(struct mlx5_eswitch *master_esw,
>  					    struct mlx5_eswitch *slave_esw)
>  {
> -	return esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
> +	int err;
> +
> +	err = esw_set_slave_egress_rule(master_esw->dev, slave_esw->dev);
> +	if (err)
> +		return err;
> +
> +	esw_unset_master_egress_rule(master_esw->dev, slave_esw->dev);
> +
> +	return 0;
>  }
>  
>  void mlx5_eswitch_offloads_vport_lag_del_one(struct mlx5_eswitch *master_esw,
> -					     struct mlx5_eswitch *slave_esw)
> +					     struct mlx5_eswitch *slave_esw,
> +					     int max_slaves)
>  {
> +	int err;
> +
> +	if (mlx5_sd_is_primary(slave_esw->dev)) {
> +		err = esw_set_master_egress_rule(master_esw->dev,
> +						 slave_esw->dev, max_slaves);

[Severity: Medium]
Is this restore correct when no master egress rule existed before
mlx5_eswitch_offloads_vport_lag_add_one() ran?

On the add side, esw_unset_master_egress_rule() returns early when
vport->egress.acl is NULL and does not record whether it removed
anything. Here the rule is recreated for any SD-primary slave. The two
sides only match when a shared FDB installed the rule beforehand.

mlx5_eth_lag_init() creates the vport LAG whenever mlx5_lag_is_active()
and mlx5_lag_is_sw_managed() are true. Neither checks the shared FDB
state. With an active LAG that has no MLX5_LAG_MODE_FLAG_SHARED_FDB
(ROCE, or SRIOV with shared_fdb false), the sequence would be:

mlx5_do_bond()                          /* no shared FDB */
mlx5_eth_lag_init()
  mlx5_cmd_create_vport_lag()
    mlx5_eswitch_offloads_vport_lag_add_one()
      esw_unset_master_egress_rule()    /* no-op, egress.acl NULL */
mlx5_eth_lag_cleanup()
  mlx5_cmd_destroy_vport_lag()
    mlx5_eswitch_offloads_vport_lag_del_one()
      esw_set_master_egress_rule()      /* new ACL, group, bounce rule */

Does this leak the egress ACL table, flow group and bounce rule on the
master's manager vport? mlx5_deactivate_lag() only tears down master
egress state for a shared FDB:

	if (test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags)) {
		mlx5_lag_destroy_single_fdb(ldev);

The leftover bounce rule would also redirect traffic that reaches the
master's manager vport into the slave eswitch. On a later shared FDB
activation, esw_set_master_egress_rule() would find the stale entry:

	if (xa_load(&vport->egress.offloads.bounce_rules, slave_index))
		return -EINVAL;

so mlx5_lag_create_single_fdb_filter() would keep failing until the
driver is reloaded.

A non shared FDB LAG from mlx5_do_bond() needs the netdev notifier.
mlx5_lag_dev_alloc() registers that notifier only when the allocating
device is not SD capable. So this path seems to need an SD primary in
the same ldev as a function that is not SD capable. It is not clear
from the code that such an ldev can exist.

Would it be safer for add_one to record whether it actually removed a
master egress rule, and for del_one to restore it only in that case?

> +		if (err)
> +			esw_warn(master_esw->dev,
> +				 "Failed to restore master egress rule (%d)\n",
> +				 err);
> +	}
> +
>  	esw_unset_slave_egress_rule(master_esw->dev, slave_esw->dev);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com
