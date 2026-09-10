Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7180635BDCE;
	Thu, 10 Sep 2026 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077271; cv=none; b=KlUvycD9Q5VMNOK+3VwxP4Zm8vrYQFFsvWWCWQe4toQEU4EKFiEkuv3qAOdlc4wxYGvOD65xTVBp7JQM0h7eLFTd8vLQfi6NLpXC2gQGdaW5J7bph4chgIp/bwPfRluCbOBDqEyWBpCBv9157FiGz98EOLsgoiqMfDIlvRKCDDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077271; c=relaxed/simple;
	bh=tzjNipFg/UouWyyWl/kd71EAlRhCzjIUWHbJ263yMYc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KCn1On6BCGePvm3lKtnSTR5q3ehouAEQwcLpGXFeAbEmjxD3q3sQoKT4q5ZWYiQzDb2zAoR/fcHwra8+dexsiS/+iIqVKM9gSZlWlE0zRjblc2Omxx1/OUCjhgCsS1A5af8d1JZocCKxNOlW6+bLba/0Je46Hv37dkkL/C2Ynss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqVCEQhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqVCEQhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02B51F00898;
	Thu, 10 Sep 2026 21:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077270;
	bh=xo/bETE04CWbTQ+Cq+DRMuEQM5yUiD0R4sQHF7712fQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MqVCEQhQwPAGINipPi0sInITey70Y+voJPt4pIcQzG8BwieCcEJatbNwnm5TLSq1v
	 rSN0MFScpkCVPm38wJJWAQPy/AAz0B13LvIe6ZFHk8q+UMQJY9hDLj3657VCd8bD95
	 kEoUCQ6GMm08ZbwKcrNNZEEI6YicyR4eII+171B4+bmPz1m7ysbv+YXoGsNlklN6C6
	 fzLbR9ESAJXz/g8Jbkfb279haGocsMg0D6qyAZxX9l4VHMWOcsh0EaErh3JxJvFerc
	 6DUm9xG6ZwMwLLj3cHdqT0jn24GLOdm4YzPxXl8K1UKktRPPjm+DAIt1uBVyMhUjC1
	 AxSRazl2tFL6g==
Subject: Re: [PATCH net-next V4 04/14] net/mlx5e: macsec: Block TC offload
 when MACsec is enabled
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
Date: Thu, 10 Sep 2026 21:54:28 +0000
Message-ID: <178907726819.219967.13706090995168485847@kernel.org>
In-Reply-To: <20260908065244.3799142-5-tariqt@nvidia.com>
References: <20260908065244.3799142-5-tariqt@nvidia.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

- [High] Unbalanced TC-block reference across the MACsec teardown path:
  mlx5e_macsec_init_sa_fs() now takes one mdev->offload_block.num_tc…
- [Low] Commit-message scope vs. implementation: the message states the
  patch makes "sure that TC and MACsec cannot be both active at the same…

--

net/mlx5e: macsec: Block TC offload when MACsec is enabled

The patch takes a reference on the mlx5 TC/accel mutual exclusion counter
whenever a MACsec RX (decrypt) steering rule is installed, and drops it when
that rule is removed. It also holds a best-effort block across
macsec_upd_secy_hw_address() so the drain/re-add loops are not disturbed by a
concurrent TC filter add.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index daff53ba7d09f..a15a0aff292ff 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c

[ ... ]

> @@ -324,6 +325,8 @@ static void mlx5e_macsec_cleanup_sa_fs(struct mlx5e_macsec *macsec,
>  	mlx5_macsec_fs_del_rule(macsec->mdev->macsec_fs, sa->macsec_rule, action, netdev,
>  				fs_id);
>  	sa->macsec_rule = NULL;
> +	if (!is_tx)
> +		mlx5e_accel_unblock_tc_offload(macsec->mdev);
>  }

[Severity: High]
This is the only place that gives back the count taken in
mlx5e_macsec_init_sa_fs(). Is mlx5e_macsec_cleanup() a second teardown path
that destroys the same RX rules without passing through here?

drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:mlx5e_macsec_cleanup() {
	mlx5_notifier_unregister(mdev, &macsec->nb);
	mlx5_macsec_fs_cleanup(mdev->macsec_fs);
	destroy_workqueue(macsec->wq);
	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
	mutex_destroy(&macsec->lock);
	kfree(macsec);
}

It never walks macsec_device_list_head / rx_sc->rx_sa[] and never calls
mlx5e_accel_unblock_tc_offload(), so wouldn't every RX SA rule still installed
at that moment leave mdev->offload_block.num_tc permanently incremented?

The path looks reachable without any mdo_del_rxsa/mdo_del_secy first:

mlx5_unload_one()/mlx5e_suspend() -> _mlx5e_suspend() ->
mlx5e_detach_netdev() -> mlx5e_nic_profile.disable == mlx5e_nic_disable() ->
mlx5e_macsec_cleanup()

In those flows (system suspend, devlink reload, health recovery) the lower
netdev is only netif_device_detach()ed, not unregistered, so the stacked
MACsec devices and their offloaded RX SAs are still live. mdev->offload_block
is initialized once in mlx5_mdev_init() and is not reset by unload/load.

After such an event, does every later TC flower add on that device fail
forever?

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_block_accel_offload() {
	mutex_lock(&mdev->offload_block.lock);
	if (mdev->offload_block.num_tc)
		ret = -EBUSY;
	...
}

The WARN_ON_ONCE() in mlx5e_accel_unblock_tc_offload() would not fire here
because the leak is a missing decrement, so there is no diagnostic either.
Would it be more robust to drop the reference in mlx5e_macsec_cleanup(), or to
hold it per MACsec device in add_secy/del_secy instead of per RX rule?

>  
>  static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
> @@ -343,6 +346,7 @@ static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
>  	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
>  	struct mlx5_macsec_rule_attrs rule_attrs;
>  	union mlx5_macsec_rule *macsec_rule;
> +	int err = 0;
>  
>  	if (is_tx && tx_sc->encoding_sa != sa->assoc_num)
>  		return 0;
> @@ -353,13 +357,26 @@ static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
>  	rule_attrs.action = (is_tx) ? MLX5_ACCEL_MACSEC_ACTION_ENCRYPT :
>  				      MLX5_ACCEL_MACSEC_ACTION_DECRYPT;
>  
> +	if (!is_tx) {
> +		err = mlx5e_accel_block_tc_offload(priv->mdev);
> +		if (err)
> +			return err;
> +	}
> +

[Severity: Low]
This isn't a bug, but the commit message says the patch makes

    "sure that TC and MACsec cannot be both active at the same time"

while the block here is taken only for RX rules (!is_tx), and only for as long
as an RX rule exists. A device configured with just an active TX SA goes
through mlx5e_macsec_add_txsa() -> mlx5e_macsec_init_sa() ->
mlx5e_macsec_init_sa_fs() with is_tx=true and never touches
mdev->offload_block.num_tc, so TC flower filters are still accepted while
MACsec offload is active.

That scope looks functionally sufficient, since the follow-up patch
"net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag" only sets
FLOW_CONTEXT_HAS_TAG/flow_tag on the RX crypto rules in
macsec_fs_rx_add_rule(), the TX path keeps using MLX5_MACSEC_TX_METADATA, and
tc_act_can_offload_mark() limits TC marks to 16 bits so a TC filter cannot
forge the proto bits. Could the commit message state the RX-only scope
explicitly, the way the sibling IPsec patch does?

Related to the same narrow scope: because the block is per RX rule, a TC filter
can be installed during any window with no RX rule present (all RX SAs
inactive, or after a partially failed macsec_upd_secy_hw_address()). The next
RX SA activation then returns a bare -EBUSY from mlx5e_macsec_init_sa_fs()
with no netdev_err() or extack, unlike the other error paths in this file.
Would adding a message here help users understand the failure?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
