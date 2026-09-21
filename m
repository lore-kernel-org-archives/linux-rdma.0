Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBA647F3B8;
	Mon, 21 Sep 2026 18:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016547; cv=none; b=FCVps6VHugwJo6azrROySnvsD2WnASrfYGuLN/ifzKP72YDnCCOXazJbhLFHCTkGj3VLXdY2QLLtGRybRsZC38oBxyA/RN0gGjFZDTbnFjHUoPL+RjP+MDpbP0A3NMoKSqF/xI6zueAjuqRmOqcGhXdKD526qJsEE4qTDndE56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016547; c=relaxed/simple;
	bh=4zPrl65tbDIhRVvX4/jz9YQzwlNez8XtVtN3n/ltXRw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WSD2MrAA4BPdlOfrQqIo+sAzt1rgetUiw4UKjDtdyfZhEq4/W+CYPFepN8GJPj5hfLTVqdHgXawtdZjng3I2uZdAYut9Xxvjl/WF4GNcV4qAt0T3reCKKw+h/lFReXPHeNcvRLGwGtDRc89Bo80DzZ/IsLTflDPyuDdBJoyeiko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlSPyG+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlSPyG+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7871F00899;
	Mon, 21 Sep 2026 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016545;
	bh=+R/l7vhtBnA4csg5TJOPjxpa9YLFTfqV4mFeEq7eLCA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BlSPyG+fMRmlFmph0TAKnUxM0mTbUm251niRbeMhL8VjlqTBc5mhLxlBepMrLttzR
	 JZTv+YttgfQF+Wn3z68bYSnpA1UFSjQF7RWlGrdFQ8b9D1NNyQuXWY+YGSaG430+8p
	 Rzdi6T+/ih2OIZzk/kqpC4qdq5bp3cqSDIxktzA+xrH3b/8/TTM/1D1RcrNpPLpa8J
	 7Z3UG9rgtBX02Jx0Aa7NSDT1JdHXtbTI1R/HdiYznLLNILujNw1Yp1Go7QElrrKXCX
	 IW/GBSSpnxvBmwRY+xjo8/CcuviaXo5d3bWvMFdyneeaFdqK/KzpqHKSiPii3m/CjK
	 bVfR/EnLD5VPw==
Subject: Re: [PATCH net 2/7] net/mlx5e: ipsec: Block eswitch mode changes
 before accessing priv->ipsec
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, borisp@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, ehakim@nvidia.com,
 gal@nvidia.com, jianbol@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, liorna@nvidia.com,
 mbloch@nvidia.com, parav@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com
Date: Mon, 21 Sep 2026 18:49:03 +0000
Message-ID: <179001654385.2160803.10690827205473996376@kernel.org>
In-Reply-To: <20260917175433.4090878-3-tariqt@nvidia.com>
References: <20260917175433.4090878-3-tariqt@nvidia.com>
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

Critical: 0 · High: 1 · Medium: 1 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] By moving mlx5_eswitch_block_mode(priv->mdev, true) to the top
  of mlx5e_xfrm_add_state(), the first profile-owned field touched is…
- [Medium] mlx5e_xfrm_add_state() now calls
  mlx5_eswitch_block_mode(priv->mdev, true) *before* checking whether…
- [Low] mlx5e_xfrm_add_state() now emits the generic extack message
  "mlx5_core: Device failed to offload this state" on paths that report…

Pre-existing issues:
- [Medium] The two sibling xfrmdev_ops add callbacks take the same
  temporary eswitch-mode block for the same stated purpose (protect…
- [Medium] The CONFIG_MLX5_ESWITCH=n stub of mlx5_eswitch_block_ipsec()
  (eswitch.h:1090-1093) returns false, i.e. "blocked/busy", whereas the…

--

net/mlx5e: ipsec: Block eswitch mode changes before accessing priv->ipsec

This moves the mlx5_eswitch_block_mode() call in mlx5e_xfrm_add_state()
ahead of the first priv->ipsec access so a concurrent profile change
cannot free the context under it, and releases the block on all error
paths.  The acquire-placeholder path is kept exempt from the block.

A few questions about the reordering below.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index 841ecdc2c4d9e..1488faece80eb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -771,6 +771,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  				struct xfrm_state *x,
>  				struct netlink_ext_ack *extack)
>  {
> +	bool is_acq = x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ;
>  	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
>  	bool allow_tunnel_mode = false;
>  	struct mlx5e_ipsec *ipsec;
> @@ -779,20 +780,30 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  	int err;
>  
>  	priv = netdev_priv(dev);
> -	if (!priv->ipsec)
> -		return -EOPNOTSUPP;
> +	if (!is_acq) {
> +		err = mlx5_eswitch_block_mode(priv->mdev, true);
> +		if (err)
> +			return err;
> +	}

[Severity: High]
Can this dereference a NULL priv->mdev?  After this change the first
profile-owned field touched is priv->mdev rather than priv->ipsec, and
mlx5e_priv_cleanup() ends with:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_priv_cleanup() {
	...
	memset(priv, 0, sizeof(*priv));
}

so priv->mdev can be observed as NULL while the netdev is still
registered.  Besides the transient window between mlx5e_priv_cleanup()
and mlx5e_netdev_init_profile() during a profile change, it also stays
NULL indefinitely when both the new attach and the rollback fail:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_netdev_change_profile() {
	...
rollback:
	if (!orig_profile) {
		netdev_warn(netdev, "no original profile to rollback to\n");
		priv->profile = NULL;
		return err;
	}

	rollback_err = mlx5e_netdev_attach_profile(netdev, mdev, orig_profile, orig_ppriv);
	if (rollback_err) {
		netdev_err(netdev, "failed to rollback to orig profile, %d\n", rollback_err);
		priv->profile = NULL;
	}
}

mlx5e_priv_cleanup() itself documents that state with an early
"if (!priv->mdev) return;".  mlx5_eswitch_block_mode() then dereferences
its argument right away:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:mlx5_eswitch_block_mode() {
	struct mlx5_eswitch *esw = dev->priv.eswitch;
	...
}

The previous first access, "if (!priv->ipsec) return -EOPNOTSUPP;",
handled a zeroed priv gracefully.  Would a priv->mdev check (or keeping
the priv->ipsec test first) be worth adding here?

[Severity: Medium]
Does this change the errno userspace sees for crypto-mode offload?
mlx5_eswitch_block_mode() forwards mlx5_esw_try_lock()'s returns:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_esw_try_lock() {
	if (down_write_trylock(&esw->mode_lock) == 0)
		return -EINVAL;

	if (esw->eswitch_operation_in_progress ||
	    (check_users && atomic64_read(&esw->user_count) > 0)) {
		up_write(&esw->mode_lock);
		return -EBUSY;
	}
}

Those now preempt the -EOPNOTSUPP that this netdev used to return
whenever priv->ipsec was NULL, and only -EOPNOTSUPP gets the software
fallback in the core:

net/xfrm/xfrm_device.c:xfrm_dev_state_add() {
		if ((err != -EOPNOTSUPP && !is_packet_offload) || is_packet_offload) {
			NL_SET_ERR_MSG_WEAK(extack, "Device failed to offload this state");
			return err;
		}
}

priv->ipsec is NULL when mlx5e_ipsec_init() failed (it logs "IPSec
initialization failed" and leaves the pointer unset while
mlx5e_ipsec_build_netdev() has already installed xfrmdev_ops), or while
the profile is detached.  So "ip xfrm state add ... offload dev X" in
crypto mode on such a netdev now fails hard with -EBUSY/-EINVAL instead
of falling back to software.  Should the priv->ipsec test stay ahead of
the mode block, or the eswitch error be translated for that case?

[Severity: Medium]
This isn't a bug introduced by this patch (the baseline already called
mlx5_eswitch_block_mode(priv->mdev, true) for every non-acquire SA add,
this only moves it earlier), but the two sibling add callbacks now sit
side by side with opposite check_users arguments for the same stated
purpose.  mlx5e_xfrm_add_policy() uses:

	/* Block esw mode changes until the policy holds its own block. */
	err = mlx5_eswitch_block_mode(priv->mdev, false);

while mlx5e_xfrm_add_state() passes true, which makes
mlx5_esw_try_lock() return -EBUSY whenever esw->user_count > 0, i.e.
whenever any tc flower rule exists on a VF representor - the case the
preceding commit added check_users to avoid.  Was check_users=true
intentional for the state path?

>  
>  	ipsec = priv->ipsec;
> -	gfp = (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) ? GFP_ATOMIC : GFP_KERNEL;
> +	if (!ipsec) {
> +		err = -EOPNOTSUPP;
> +		goto unblock_mode;
> +	}
> +
> +	gfp = is_acq ? GFP_ATOMIC : GFP_KERNEL;
>  	sa_entry = kzalloc_obj(*sa_entry, gfp);
> -	if (!sa_entry)
> -		return -ENOMEM;
> +	if (!sa_entry) {
> +		err = -ENOMEM;
> +		goto unblock_mode;
> +	}
>  
>  	sa_entry->x = x;
>  	sa_entry->dev = dev;
>  	sa_entry->ipsec = ipsec;
>  	/* Check if this SA is originated from acquire flow temporary SA */
> -	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) {
> +	if (is_acq) {
>  		x->xso.offload_handle = (unsigned long)sa_entry;
>  		return 0;
>  	}
> @@ -806,10 +817,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  		goto err_xfrm;
>  	}
>  
> -	err = mlx5_eswitch_block_mode(priv->mdev, true);
> -	if (err)
> -		goto unblock_ipsec;
> -

[Severity: Medium]
This is a pre-existing issue and not introduced here (git blame points
at 8efd7b17a3b032 from 2023), but while the goto labels on this error
path are being reshuffled it may be worth noting: the
CONFIG_MLX5_ESWITCH=n stub has the opposite polarity from the real
function.

drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:
static inline bool mlx5_eswitch_block_ipsec(struct mlx5_core_dev *dev)
{
	return false;
}

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_eswitch_block_ipsec() {
	if (!mlx5_esw_allowed(esw))
		return true;
	...
}

The caller just above this hunk maps false to -EBUSY:

	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
		err = -EBUSY;
		goto err_xfrm;
	}

so with CONFIG_MLX5_EN_IPSEC=y and CONFIG_MLX5_ESWITCH=n, does every SA
and policy offload fail with -EBUSY?  The sibling stubs follow the
"allow" convention (mlx5_eswitch_block_encap() returns true,
mlx5_eswitch_block_mode() returns 0).

>  	if (x->props.mode == XFRM_MODE_TUNNEL &&
>  	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
>  		allow_tunnel_mode = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
> @@ -817,7 +824,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  			NL_SET_ERR_MSG_MOD(extack,
>  					   "Packet offload tunnel mode is disabled due to encap settings");
>  			err = -EINVAL;
> -			goto unblock_mode;
> +			goto unblock_ipsec;
>  		}
>  	}
>  
> @@ -893,12 +900,13 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  unblock_encap:
>  	if (allow_tunnel_mode)
>  		mlx5_eswitch_unblock_encap(priv->mdev);
> -unblock_mode:
> -	mlx5_eswitch_unblock_mode(priv->mdev);
>  unblock_ipsec:
>  	mlx5_eswitch_unblock_ipsec(priv->mdev);
>  err_xfrm:
>  	kfree(sa_entry);
> +unblock_mode:
> +	if (!is_acq)
> +		mlx5_eswitch_unblock_mode(priv->mdev);
>  	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
>  	return err;
>  }

[Severity: Low]
Placing unblock_mode above the NL_SET_ERR_MSG_WEAK_MOD() means the
-EOPNOTSUPP (priv->ipsec == NULL) and -ENOMEM paths now attach
"mlx5_core: Device failed to offload this state" to the extack, where
they previously returned silently.

For crypto-mode requests the core swallows -EOPNOTSUPP and returns 0:

net/xfrm/xfrm_device.c:xfrm_dev_state_add() {
		if ((err != -EOPNOTSUPP && !is_packet_offload) || is_packet_offload) {
			NL_SET_ERR_MSG_WEAK(extack, "Device failed to offload this state");
			return err;
		}
	}

	return 0;
}

but the message is still delivered:

net/netlink/af_netlink.c:netlink_ack_tlv_len() {
	if (extack->_msg)
		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
	...
	/* Following attributes are only reported as error (not warning) */
	if (!err)
		return tlvlen;
}

So does a successful "ip xfrm state add ... offload dev X" now print
"Warning: mlx5_core: Device failed to offload this state"?  The sibling
mlx5e_xfrm_add_policy() keeps its generic message above the label:

	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
unblock_mode:
	mlx5_eswitch_unblock_mode(priv->mdev);

Would the same layout work here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
