Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62330C168;
	Wed,  7 Oct 2026 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334281; cv=none; b=opowXQhGuwuBljEJcfK4K99ZTH2CpboveQoRWoLI41CXXMmULjnZJZ++4/bK5gnAW7MmzV0l2f3UtXo8lbqtTc7w/7MePTwy/PEbS+29RhXI7ZqTwGQFuxZdGHCwlkTTddrPC2ApQP/TCTdWCTztGAfg3Y281fsrRH+kOLdxPjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334281; c=relaxed/simple;
	bh=okGEdy0TCs17epeisTSHGYVdbyU0laJJ+T2t6Dzzues=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH9+bNfwmOPxC21Fzp2/0pZa0ML+Ib+Z4alBaGSjIj+hw9M61gkCUs6y0Kt+Gbr48834+VLAJDAxAZVj7qoHgZ7OdrwOKiFh6qjuzFWNAkOktbk0MbcAyWbiH2aGpR71X2ZEyD0koiII4cxNETu6QPRS8xjYQ9oBE0X3A0rZczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HETHVJhd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HETHVJhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A64C1F0089C;
	Wed,  7 Oct 2026 00:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334279;
	bh=3TGexGGGG0fwacOWTt8OfO7JPYWc0El5ugFGukBR5ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HETHVJhde1y/SxnZ37Atbj03AMwwHLYJm8OrvoWdS4XHj73Zii+trI5aD71rxJ8CK
	 4TTJ7/2WeCXy1WDJEIuYQkXPTC0G63AFh3nKYxxnOJlln41vjBkyflDyjN1qvescap
	 K9SR/TcSQMkz5s3rqPFQ1QfSeTm1IARav2tY4d0riCBoI55Jl5zbG/Yw1ndAuirwDj
	 8Bj9QZS8kiL49yiyW3GjNPMfNjjOapJj34YhP00hHwoBFlfHxKZKFDC6ImZ9+1o95j
	 DIt1duORSj6cfvaZblVAjY5lYfssc+Ej2+4z+O/gr5wMJ3cyf2LrbiG7MRDVgK7GmB
	 JHx8BrGn/n8vA==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	parri.andrea@gmail.com,
	borisp@nvidia.com,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	dtatulea@nvidia.com,
	fmancera@suse.de,
	gal@nvidia.com,
	jianbol@nvidia.com,
	kees@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	parav@nvidia.com,
	phaddad@nvidia.com,
	raeds@nvidia.com,
	roid@nvidia.com,
	saeedm@nvidia.com,
	steffen.klassert@secunet.com
Subject: Re: [PATCH net V2 2/4] net/mlx5e: ipsec: Block eswitch mode changes before accessing priv->ipsec
Date: Tue,  6 Oct 2026 17:51:18 -0700
Message-ID: <20261007005118.2944625-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930121119.141953-3-tariqt@nvidia.com>
References: <20260930121119.141953-3-tariqt@nvidia.com>
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
net/mlx5e: ipsec: Block eswitch mode changes before accessing priv->ipsec

This patch moves the eswitch mode block in mlx5e_xfrm_add_state() so it is
taken before priv->ipsec is read and before the state is validated. A
concurrent profile change can then no longer free the IPsec context while
it is in use. The acquire placeholder path is still not blocked, and
mlx5e_xfrm_add_policy() gains a local mdev with a NULL check.

> mlx5e_xfrm_add_state() reads priv->ipsec and validates mode-dependent
> capabilities before blocking eswitch mode changes. A concurrent profile
> change can free the saved IPsec context and cause use-after-free.

[ ... ]

> Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")

[Severity: Medium]
Is this the right Fixes: tag for the race being closed?

Before 22239eb258bc, mlx5e_xfrm_add_state() had no eswitch mode block at
all. It already read priv->ipsec, stored it in sa_entry, and used it for
validation, SA hardware context creation and
mlx5e_accel_ipsec_fs_add_rule(). 22239eb258bc added a block after that
read. It did not move an existing block later.

Before 22239eb258bc, the only mode block on this path was the late one in
rx_get()/tx_get() in ipsec_fs.c:

    err = mlx5_eswitch_block_mode(mdev, true);

The previous patch in this series ("net/mlx5e: ipsec: Block eswitch mode
changes during policy creation") says that late block comes too late,
because the table lookup already touches the IPsec context. That patch
tags a5b8ca9471d3 and says "mlx5e_xfrm_add_state() has the same race".

With the current tag, could a stable tree that has the packet offload
state path but not 22239eb258bc take the add_policy half of the fix and
never get this add_state half? Should this patch carry the same tag as
the policy patch?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index 841ecdc2c4d9e..cf721ef83d597 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -771,28 +771,44 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  				struct xfrm_state *x,
>  				struct netlink_ext_ack *extack)
>  {

[ ... ]

>  	priv = netdev_priv(dev);
> -	if (!priv->ipsec)
> +	mdev = priv->mdev;
> +	if (!mdev || !priv->ipsec)
>  		return -EOPNOTSUPP;
>  
> +	if (!is_acq) {
> +		err = mlx5_eswitch_block_mode(mdev, false);
> +		if (err)
> +			return err;
> +	}

[Severity: Low]
Should these loads of priv->mdev and priv->ipsec use READ_ONCE()?

They happen without a lock, before the mode block is held, so they can
race with a concurrent profile change:

mlx5e_netdev_change_profile()
  mlx5e_priv_cleanup()
    memset(priv, 0, sizeof(*priv));

The !mdev check only covers that window if priv->mdev is loaded exactly
once. With a plain load, the compiler may reload priv->mdev for the
mlx5_eswitch_block_mode() argument. The reloaded value could be NULL, and
mlx5_eswitch_block_mode() would then dereference dev->priv.eswitch. KCSAN
would also report these as data races.

The same question applies to the new mdev = priv->mdev read in
mlx5e_xfrm_add_policy().

[ ... ]

> @@ -1262,12 +1275,17 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  {
>  	struct net_device *netdev = x->xdo.dev;
>  	struct mlx5e_ipsec_pol_entry *pol_entry;
> +	struct mlx5_core_dev *mdev;
>  	struct mlx5e_priv *priv;
>  	int err;
>  
>  	priv = netdev_priv(netdev);
> +	mdev = priv->mdev;
> +	if (!mdev)
> +		return -EOPNOTSUPP;
> +
>  	/* Block esw mode changes until the policy holds its own block. */
> -	err = mlx5_eswitch_block_mode(priv->mdev, false);
> +	err = mlx5_eswitch_block_mode(mdev, false);

[Severity: Medium]
The commit message only covers add_state and does not mention this new
NULL check in mlx5e_xfrm_add_policy(). Should the check go into the
previous patch instead?

The previous patch ("net/mlx5e: ipsec: Block eswitch mode changes during
policy creation") moved mlx5_eswitch_block_mode(priv->mdev, false) ahead
of the !priv->ipsec check. mlx5_eswitch_block_mode() dereferences
dev->priv.eswitch without checking dev for NULL.

priv->mdev can be NULL while the netdev is still registered. If a profile
change fails and its rollback also fails, mlx5e_priv_cleanup() zeroes
priv:

mlx5e_priv_cleanup() {
    ...
	/* bail if change profile failed and also rollback failed */
	if (!priv->mdev)
		return;
    ...
	memset(priv, 0, sizeof(*priv));
}

netdev->xfrmdev_ops is not cleared, so a CAP_NET_ADMIN user who adds an
offloaded policy still reaches:

xfrm_dev_policy_add()
  mlx5e_xfrm_add_policy()
    mlx5_eswitch_block_mode(NULL, false)

At baseline, the !priv->ipsec check returned -EOPNOTSUPP in that state.
With only the previous patch applied, this path oopses.

The previous patch carries Fixes: a5b8ca9471d3 and this one carries
Fixes: 22239eb258bc. Could the previous patch be backported without this
guard? As posted, the series is also not bisect-safe at the previous
patch.

[ ... ]
