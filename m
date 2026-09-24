Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4A05326B0;
	Thu, 24 Sep 2026 17:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271960; cv=none; b=XftJIJSHVbImeOWSgFHvmpAjtogPhYROWG+m7/3HuNV43grYp0RP+Um9NpQsVz7Ryi4y2nLbN1bMktICNjWKOARiPldFCudcPR5B3+7MsDgzwKqeINA5duTliCPD258pv9jvEP9TCgh8jW7itnMyFKN+Ge7xFGR5VjZLhQYvxdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271960; c=relaxed/simple;
	bh=yH/jxvc6qs97dylshbXZ7hMnItkysJgoVwvRoAQmoxA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gOBfm06mxiRGIfgPpHZ8ZyiJFTvoWioZXVrCBSiSnL5CrKVDYnPgwH+EWpCNakAA3+malnPZIHrs9ZQA/n1fDukPuIiteKOldkBkJvu+XXkcST+ltdIy0TJ30J8QjLl3lXk9zo5UXs3Wmbo1VdC4f3HsGLxGigU79+kkL/4jk7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JME3xXI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JME3xXI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61C91F00898;
	Thu, 24 Sep 2026 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271958;
	bh=owoQKz+v874qyMiTsWjfU1l/a8W/Yx5aXS7a3jd8S9U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JME3xXI1QdGGusPRdqmySqILKI+W4cX+aIHNO7fh0Aciec/Xu0Bn4hg9BFa6jrJg6
	 hrGma3YxnlyWWc/TWPGDoOEN/e8C3PduSEabF+T7OXdAKxD8v49TqNJHS68iOwoRfk
	 E8HdeDf/j7dDNddpvJ7z8W53pjaXtOIlF6CirBXWzR+7JlEdJvuyIIKcq4BsnJg45c
	 PIOrpeMFAA9zcwV3btiL1I46a2XcGldWOwC9Pf7fw1FqYeqVN6ZXHD23fUQ61/tTZe
	 YUIY1KNrr7Vl5KJWMzwrd0ZcWG381W+jV+jclBEvN7MSM6QyTBbBbffnHJdLiJyvZ/
	 v1qGfVFLQ0e/Q==
Subject:
 Re: [PATCH net-next 06/13] net/mlx5: LAG, size debugfs buffers by port count
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:57 +0000
Message-ID: <179027195752.2160803.12405289208983982491@kernel.org>
In-Reply-To: <20260923103830.1183-7-tariqt@nvidia.com>
References: <20260923103830.1183-7-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] mapping_show() in
  drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c used a stack…

--

net/mlx5: LAG, size debugfs buffers by port count

This commit replaces the fixed-size ports[MLX5_MAX_PORTS] stack array in
mapping_show() with a buffer allocated by kcalloc(), sized by
ldev->ports.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> index e9b8d79d2d21e..44296789d6567 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
> @@ -101,14 +101,18 @@ static int flags_show(struct seq_file *file, void *priv)
>  static int mapping_show(struct seq_file *file, void *priv)
>  {
>  	struct mlx5_core_dev *dev = file->private;
> -	u8 ports[MLX5_MAX_PORTS] = {};
>  	struct mlx5_lag *ldev;
>  	bool hash = false;
>  	bool lag_active;
>  	int i, idx = 0;
>  	int num_ports;
> +	u8 *ports;
>  
>  	ldev = mlx5_lag_dev(dev);
> +	ports = kcalloc(ldev->ports, sizeof(*ports), GFP_KERNEL);

[Severity: Low]
Can the loops that fill this buffer write past ldev->ports entries?

Neither fill path is limited by ldev->ports. The non-hash path is:

	mlx5_ldev_for_each(i, 0, ldev)
		ports[idx++] = ldev->v2p_map[i];

and idx is never compared to the allocation size. The hash path passes
the buffer to mlx5_infer_tx_enabled(), which takes no length:

	mlx5_ldev_for_each(i, 0, ldev)
		if (tracker->netdev_state[i].tx_enabled &&
		    tracker->netdev_state[i].link_up)
			ports[(*num_enabled)++] = i;

If no port is enabled, it falls back to mlx5_infer_tx_disabled(), which
also writes one entry per port. mlx5_ldev_for_each() goes through
mlx5_lag_for_each(), and that loop stops at tmp < MLX5_MAX_PORTS, not
at ldev->ports.

The two bounds come from different places:

  mlx5_lag_dev_alloc():
	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);

  mlx5_ldev_add_mdev():
	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
		       GFP_KERNEL);
	...
	xa_set_mark(&ldev->pfs, idx, MLX5_LAG_XA_MARK_PORT);

ldev->ports is read from the first device's capability. The number of
PORT-marked entries in ldev->pfs is capped only by MLX5_MAX_PORTS. As far
as I can see, the only comparison against ldev->ports is
mlx5_lag_num_devs(ldev) != ldev->ports in mlx5_lag_check_prereq(), and
that runs only when LAG is activated.

The old stack array was safe by construction, because it and the xarray
limit were both MLX5_MAX_PORTS. The new buffer relies on an unstated
invariant: ldev->pfs never holds more port PFs than num_lag_ports.

If more port PFs than ldev->ports join the same ldev while LAG is
active, reading the debugfs mapping file would write past the requested
size. One such window is after a new PF is added and before bond work
tears LAG down. Since the count is capped at 8 and the smallest kmalloc
object is 8 bytes, the extra bytes stay inside the slab object. On
debug kernels this would still show up as a KASAN slab-out-of-bounds or
slub_debug redzone report.

The sibling commit "net/mlx5: LAG, allocate port-indexed scratch buffers
dynamically" makes the same assumption in lag_active_port_bits() and
mlx5_lag_print_mapping(). At the end of the series, mapping_show()
still uses kcalloc(ldev->ports) with the same fill loops.

Would it make sense to state the invariant, clamp the writes to
ldev->ports, or keep sizing the buffer by MLX5_MAX_PORTS?

> +	if (!ports)
> +		return -ENOMEM;
> +
>  	mutex_lock(&ldev->lock);
>  	lag_active = __mlx5_lag_is_active(ldev);
>  	if (lag_active) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
