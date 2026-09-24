Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE1552B1F7;
	Thu, 24 Sep 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271955; cv=none; b=XVfuDYcz/DIE5iiCcWHl0suMG8ZxLHIulnWfY2O4husRSkevyds4aSbL0lawrg4P2ODeAFYdlq4vwlCcGxiktMz+TPLISJRHhT6lVml+gjcNVIOS8EKI4abPSaMxm6zge2V9iWcQ0IbCGZkKcydlYWxRDLtiAum8w77SXsYZOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271955; c=relaxed/simple;
	bh=TLR8QLlEDbJmTPIv6xvYinA4ZW387SlN0r78YzB5fGE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xxx63gLioVg156ll1fiC1LuaZsAksJKRzNTlYj0jM1KrQ5FQuxt51FiTRrHb0g1eNlbMqUQfoJfJ3FW9hYAEDG3K/MWVs3Gm8mCSX7dChKbCwmF4/qsqBHj+HVoKx1n8bwHcv5yljmgAKNxIvuA9IKy/SUazrJSiHHOuuR6wU1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h50wIbDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h50wIbDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE341F00893;
	Thu, 24 Sep 2026 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271954;
	bh=A5JSihLL3AexJrOk2t7nhyGjuXU1Pu2+NWptWbs28N8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h50wIbDIyMi5XaCl0gwlT84Z079HBjvwBhvH1GALncDnnkYH9kKrt7VWak3+m0v8z
	 PQQTPQq7tYVxMVAp+GG0Hq6//G6Sf1gZqthfy1kq24e2w2SS+BnhKSeQ8JlhOCcKCj
	 kgRXyJ2KcOft2XURbcd52ko7675z6wOu/145y44KFYkSH8E4lAzOBMxcwDSpVDRRF8
	 CUqFkPrxyE3RFnVlnePgn3DQ65/QhtEG0qAx2B7D2FNB5RK4zVpk3dIAl0fu+5uPgV
	 mDTYZOLGhOuQC5T23pK0G+nYVkbjGdtaYuCuWgOfUi+6DtFVopi2s6cCk+a804nRw6
	 NKrmtDrrehM4w==
Subject: Re: [PATCH net-next 02/13] net/mlx5: E-switch, do not leave an
 unpaired devcom registered
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:52 +0000
Message-ID: <179027195273.2160803.652686618277857534@kernel.org>
In-Reply-To: <20260923103830.1183-3-tariqt@nvidia.com>
References: <20260923103830.1183-3-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] After a failed initial PAIR, the new branch in
  mlx5_esw_offloads_devcom_init() leaves esw->devcom == NULL, yet…
- [Medium] When the initial PAIR fails, mlx5_esw_offloads_devcom_init()
  now calls mlx5_esw_offloads_devcom_cleanup(), which unregisters the…
- [Medium] The new cleanup call runs at the end of esw_offloads_enable().

--

net/mlx5: E-switch, do not leave an unpaired devcom registered

This commit checks the return value of the initial ESW_OFFLOADS_DEVCOM_PAIR
event in mlx5_esw_offloads_devcom_init(). If pairing fails, it calls
mlx5_esw_offloads_devcom_cleanup(), which unregisters the devcom component
instead of leaving it registered until eswitch teardown.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b62601682..e7d92d9bde16d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

[ ... ]

> @@ -3572,10 +3573,12 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw,
>  	if (!esw->devcom)
>  		return;
>  
> -	mlx5_devcom_send_event(esw->devcom,
> -			       ESW_OFFLOADS_DEVCOM_PAIR,
> -			       ESW_OFFLOADS_DEVCOM_UNPAIR,
> -			       esw);
> +	err = mlx5_devcom_send_event(esw->devcom,
> +				     ESW_OFFLOADS_DEVCOM_PAIR,
> +				     ESW_OFFLOADS_DEVCOM_UNPAIR,
> +				     esw);
> +	if (err)
> +		mlx5_esw_offloads_devcom_cleanup(esw);

[Severity: Medium]
Does this mean the eswitch can never pair with a peer later?

Only mlx5_esw_offloads_devcom_init() sends ESW_OFFLOADS_DEVCOM_PAIR.
mlx5_devcom_locked_send_event() delivers it only to comp_devs that are
still on comp->comp_dev_list_head:

mlx5_devcom_locked_send_event() {
    ...
	list_for_each_entry(pos, &comp->comp_dev_list_head, list) {
		data = rcu_dereference_protected(pos->data, lockdep_is_held(&comp->sem));
		if (pos != devcom && data) {
			err = comp->handler(event, data, event_data);
    ...
}

Before this patch, a failed initial PAIR was rolled back, but the eswitch
stayed on the list. A peer could later re-register, for example after its
own esw_offloads_disable()/esw_offloads_enable() cycle on a mode change or
reload. A new peer could also appear. Either one would call
mlx5_esw_offloads_devcom_event(PAIR) for this eswitch, and pairing could
succeed at that point.

Now the component is unregistered and esw->devcom is NULL. The only way to
recover is to re-enable offloads on this eswitch itself.
esw_offloads_enable() ignores the outcome, since devcom_init returns void,
and still returns 0. Nothing is reported or retried.

This seems to have these effects:

  - mlx5_eswitch_is_peer() stays false for this eswitch.
  - mlx5_sd_all_paired() cannot pass for socket-direct groups.
  - mlx5_lag_shared_fdb_supported_filter() keeps rejecting shared FDB,
    because mlx5_esw_offloads_devcom_is_ready() is false with a NULL
    devcom.

The commit message says:

    a registered component that reflects no actual pairing is incorrect
    state to keep around.

Is that accurate? Registered but unpaired is already the normal state in
two cases:

  - The first registrant: there are no peers, so send_event returns 0.
  - The metadata mismatch path in mlx5_esw_offloads_devcom_event(): it
    breaks out and returns 0.

Could the commit message mention that later peers can no longer retry the
pairing?

[Severity: High]
Can this lead to a NULL pointer dereference in
mlx5e_tc_query_route_vport()?

After this branch runs, esw->devcom is NULL but esw_offloads_enable() still
succeeds. In en_tc.c:

mlx5e_tc_query_route_vport() {
    ...
	if (!mlx5_lag_is_active(out_priv->mdev))
		return err;

	rcu_read_lock();
	err = -ENODEV;
	mlx5_devcom_for_each_peer_entry_rcu(esw->devcom, esw, pos) {
    ...
}

The iterator dereferences devcom without a NULL check:

mlx5_devcom_get_next_peer_data_rcu() {
	struct mlx5_devcom_comp *comp = devcom->comp;
    ...
}

LAG can be active without devcom pairing:

  - mlx5_lag_check_prereq() does not look at devcom.
  - mlx5_do_bond() falls back to non-shared-FDB MLX5_LAG_MODE_SRIOV when
    mlx5_lag_shared_fdb_supported() is false. That is the case when devcom
    is not ready.

The callers are mlx5e_set_vf_tunnel(), mlx5e_update_vf_tunnel() and
mlx5e_tc_tun_route_lookup(). They only check mlx5e_tc_is_vf_tunnel(),
which does not look at pairing state.

A possible sequence:

  1. The initial PAIR fails.
  2. The bond forms in non-shared-FDB SRIOV LAG.
  3. A TC tunnel encap or decap rule is added whose route device is a
     same-HW VF/SF that is not a vport of out_dev's eswitch.

Before this patch, esw->devcom was non-NULL in this scenario, with
comp->ready false. The iterator returned NULL and the function returned
-ENODEV.

[Severity: Medium]
Could this race with a representor open and cause a use-after-free of the
comp_dev?

This cleanup now runs at the end of esw_offloads_enable(). By then the
uplink rep and the PF/VF representor netdevs are already registered, via
mlx5_esw_offloads_rep_load() and mlx5_eswitch_enable_pf_vf_vports().
Userspace can open them while devcom_init is still running.

mlx5_esw_offloads_devcom_cleanup() calls
mlx5_devcom_unregister_component(). That does list_del under comp->sem,
then kfree() of the comp_dev. After that, esw->devcom = NULL is a plain
store, with no RCU grace period.

On the open side, the chain is:

mlx5e_rep_open() -> mlx5e_open_locked() -> mlx5e_rep_activate_channels()
    -> mlx5e_add_sqs_fwd_rules() -> mlx5e_sqs2vport_start()

mlx5e_sqs2vport_start() reads esw->devcom holding only rtnl and
priv->state_lock:

mlx5e_sqs2vport_start() {
    ...
	if (mlx5_devcom_comp_is_ready(esw->devcom) &&
	    mlx5_devcom_for_each_peer_begin(esw->devcom))
		devcom_locked = true;
    ...
}

Suppose the opener loads esw->devcom and is preempted before it takes
down_read() on comp->sem. The other CPU can then finish the UNPAIR, the
list_del and the kfree(). When the opener resumes, it reads ->comp from
the freed comp_dev.

esw_offloads_disable() already has the same lockless reader versus kfree
pattern at teardown. This patch adds a new trigger during enable, right
after the reps have been registered.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
