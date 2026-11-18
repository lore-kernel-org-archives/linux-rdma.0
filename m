Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997922;
	b=jfAFy4q6AfDuXyOiB7P1e5V4PugEHuJ0RYtang3PDl+s/JFElYUe0bHILg1Kn9RyRi61
	 FOMvLjULgenhUx4FH7Uhl6f6cRDwmnL3VrqmibaLUUNvNKy66j1VgRHOkItpSz7dcQ+sC
	 d1nH0u3ggJDblsXhPJmMBFO4RO6Ml0yIcNexS4kpnuchIInsQ2WitDUCJzZmPv4g9tNtN
	 G1RW4sZ2bzn0s6AvYeNEZrFQ5ArQUOVnVttzNnpgDE8ZDqZmMTFP0QY1ZyouXch7gxLec
	 I5bju2G7HYcBNJYiXFBEZuR+NHJOqg9169LpkcSQ89T5fp5wn8yG3dO/wU6HPoGS7KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997922;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=l1SThaicy8EwL0o4BRq1EqzA9aHY8uKfLxMAmpMfikE=;
	b=VvVW5pmcvCDi2p7i89iN+ZWiTcza4PrGf+j4qqyPOLj/6K62Ke21nKFtDBwp1vdT6qd3
	 /bM5U5nbLRXw8IFhxjwHxK0s3/yYx/eZVZlzfMVlAPpNzPi9sBUh6eEjNB4Mk0PkTUVXr
	 ZVnb8oyId2F9cVGbcWJyhzebDto+AkARIDSLJIOiJcDmlAzU/3Iejz6BR/4lVCghMuqom
	 Zr8PlCeJ6agA5zmLfON2vWWgHptELCj0XoJbKt7h3T2mCQ2IJN0uSfXCyqpdJR+zRUFQK
	 IqTtVqutcfboDvlv/EcCZpBc6MObpb+DfwOdeTwXh9z4iVUVuwWnM4JKo/7DyH3XonQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=brbBree5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C92606A336;
	Wed, 18 Nov 2026 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=brbBree5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE51F000C5;
	Wed, 18 Nov 2026 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997922;
	bh=l1SThaicy8EwL0o4BRq1EqzA9aHY8uKfLxMAmpMfikE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=brbBree53Opl20i5po3ljgiWv+k1RE6Sl7PQiqd4f6nc/jtoYK7+14PWQMoGJ0fYX
	 GCL52q54ZP1OjTNqs8lfBdULhReIFgMcxkkbPhuzxFmMRLVfotX9awvQsSdgxsg7OR
	 UnNBCgBUckJ/HcT4DtNNGdtDL5kVs65YKtdV418DKpfg0Go+oOsBw+vfK5eSCqrkwR
	 r8ypwBkg0/7unmPHNIOcuAUrFzXKTNT+UJeGfpUZh4Cix38+kU28pyhaItGH8znehY
	 3XLXvsYLPMDYs1CP7xm1SsNVVuC/uY0mTJr6cb1lygyT0YV0fJv24d4T54WExZFc/7
	 I0VHyXbc09WnQ==
Subject: Re: [PATCH net-next V2 10/10] net/mlx5: LAG, do not add a device to
 an already-active virt LAG
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:32:00 +0000
Message-ID: <179499792089.3136.10061962693179545978@kernel.org>
In-Reply-To: <20261116103010.1129666-11-tariqt@nvidia.com>
References: <20261116103010.1129666-11-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In this tree, both parts of the patch hit a predicate
  mismatch.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch now
  cleans up the HCA devcom component on its own new -EOPNOTSUPP path…

--

net/mlx5: LAG, do not add a device to an already-active virt LAG

This patch stops a virt LAG capable function from joining a LAG whose mode
is already active. In that case __mlx5_lag_dev_add_mdev() returns
-EOPNOTSUPP, and mlx5_lag_add_mdev() then unregisters the HCA devcom
component. The patch also makes mlx5_esw_offloads_devcom_init() skip eswitch
devcom registration for a non-PF virt LAG capable function that has no ldev.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 3e88b3f51612e..abcab76fced0b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -2448,6 +2448,11 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
>  		mutex_unlock(&ldev->lock);
>  		return -EAGAIN;
>  	}
> +
> +	if (mlx5_virt_lag_is_supported(dev) && __mlx5_lag_is_active(ldev)) {
> +		mutex_unlock(&ldev->lock);
> +		return -EOPNOTSUPP;
> +	}

[Severity: Medium]

Can this condition ever be true in this tree?

mlx5_lag_add_mdev() is the only caller of __mlx5_lag_dev_add_mdev(). It
returns early unless mlx5_lag_is_supported() passes:

mlx5_lag_add_mdev() {
	if (!mlx5_lag_is_supported(dev))
		return;
	...
}

mlx5_lag_is_supported() requires num_lag_ports >= 2:

	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
	    !MLX5_CAP_GEN(dev, lag_master) ||
	    MLX5_CAP_GEN(dev, num_lag_ports) < 2 ||
	...

mlx5_virt_lag_is_supported(), on the other hand, requires
num_lag_ports < 2:

	if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
	    !MLX5_CAP_GEN(dev, lag_master) ||
	    MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
		return false;

No device can satisfy both, so this -EOPNOTSUPP return and the new cleanup
branch in mlx5_lag_add_mdev() look unreachable.

The commit message says:

  "mlx5_ldev_add_mdev() would add a newly probed device to the LAG even
  when the LAG is already active"

Can that happen today for a virt LAG capable function? If this check only
prepares for a later series that enables virt LAG, could the commit message
say so?

The same mismatch seems to affect the eswitch change. A non-PF virt LAG
capable function never reaches mlx5_ldev_add_mdev() here, because
sd_lag_init() only handles PF SD secondaries. So dev->priv.lag stays NULL
for it, and mlx5_virt_lag_nonmember() is always true:

static inline bool mlx5_virt_lag_nonmember(struct mlx5_core_dev *dev)
{
	return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
}

As a result, the new early return in mlx5_esw_offloads_devcom_init() fires
for every such VF/SF eswitch:

	if (!mlx5_core_is_pf(esw->dev) && mlx5_virt_lag_nonmember(esw->dev))
		return;

Before this patch, a VF/SF eswitch with merged_eswitch would register
MLX5_DEVCOM_ESW_OFFLOADS and send ESW_OFFLOADS_DEVCOM_PAIR. The existing
MLX5_VPORT_MANAGER() / !mlx5_lag_is_supported() gate further down does not
stop a non-PF, because MLX5_VPORT_MANAGER() requires mlx5_core_is_pf().

Does this drop eswitch devcom pairing for those VF/SF eswitches? That would
contradict "it is a no-op for existing configurations".

The commit message also limits the devcom change to "such a device", meaning
one rejected from an active LAG. The condition, however, matches any virt LAG
capable VF/SF that has no ldev.

Once virt LAG joins are allowed, devices that are left out because
mlx5_lag_dev_alloc(), mlx5_ldev_add_mdev() or
mlx5_lag_register_hca_devcom_comp() failed would also be treated as
non-members. Is that intended?

>  	mlx5_ldev_get(ldev);
>  	err = mlx5_ldev_add_mdev(ldev, dev, 0);
>  	if (err) {
> @@ -2536,6 +2541,10 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
>  	err = __mlx5_lag_dev_add_mdev(dev);
>  	mlx5_devcom_comp_unlock(dev->priv.hca_devcom_comp);
>  
> +	if (err == -EOPNOTSUPP) {
> +		mlx5_lag_unregister_hca_devcom_comp(dev);
> +		return;
> +	}

[Severity: High]

This isn't a bug introduced by this patch, but this new path unregisters the
HCA devcom component, while the nearby failure paths in
__mlx5_lag_dev_add_mdev() still leave it registered.

If no peer ldev exists and mlx5_lag_dev_alloc() or mlx5_ldev_add_mdev()
fails, __mlx5_lag_dev_add_mdev() returns 0 with dev->priv.lag still NULL:

	if (!ldev) {
		ldev = mlx5_lag_dev_alloc(dev);
		if (!ldev) {
			mlx5_core_err(dev, "Failed to alloc lag dev\n");
			return 0;
		}
		err = mlx5_ldev_add_mdev(ldev, dev, 0);
		if (err) {
			mlx5_core_err(dev, "Failed to add mdev to lag dev\n");
			mlx5_ldev_put(ldev);
			return 0;
		}
		return 0;
	}

mlx5_lag_add_mdev() treats that as success, sends LAG_DEVCOM_PAIR and keeps
dev->priv.hca_devcom_comp. On teardown, mlx5_lag_remove_mdev() returns
before it reaches mlx5_lag_unregister_hca_devcom_comp():

	ldev = mlx5_lag_dev(dev);
	if (!ldev)
		return;

The comp_dev's data still points at this mlx5_core_dev. Does that comp_dev
stay on the shared component list after the core dev is freed?

If so, a peer with the same key that probes or reloads would get the freed
dev back from mlx5_devcom_get_next_peer_data() in __mlx5_lag_dev_add_mdev().
It would then call mlx5_lag_dev(tmp_dev) on freed memory.

A peer's LAG_DEVCOM_PAIR/UNPAIR event would likewise call
mlx5_lag_devcom_event() with the freed dev. That reads dev->priv.lag and can
call mutex_lock() on a garbage ldev.

Could the component also be unregistered on those allocation failure paths?

>  	if (err) {
>  		msleep(100);
>  		goto recheck;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
