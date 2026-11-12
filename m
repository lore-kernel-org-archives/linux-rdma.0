Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476405;
	b=gB1v7OwThDrS84FHmMMHS0EABLPSZBkyMZlAC6gUBqqasQupszm37a2nMNtKj3uIX97q
	 bgVqLaw94a+QlWATsjyBlm08d5YLM4MydQ//ODr72xntNhhnPw4sHmFquNV7RClt5zrVX
	 qSCs1ZW3Vd7jgXbbJ/uG2e8C36LnXH+uyIZ/ewT1p7evSj2oqcCElfPxqYmLVFuP9fSZz
	 tnK2LckK7/rzwS01g7Jllxw1Fyr/hMWJp0FrlXmA0z1L19VG6sgbEVWryvs6+6ffq+F+T
	 gGg5if2J4wao1DHH61iKDKyRKJ+nQ4GmUnG+vgm6xt6+s+Yfc54B2QfRuzC8lobcIBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476405;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TMeLSlgkdu/THkgzUVHvOLjX2ymbR91RP0Axt+hUjBw=;
	b=Rga1gnfn0uEIDtUzvs93iLAKVPtNgR7ZvZbhqE0MChADzxRO+GvhZgY84WyNa3ukkfZJ
	 cu+6mWdMJaBHS5VPzOAGJgpLqk4DxI3EUBnBg08VipPTt2Ruy1dATP/B+Sv+F1xvyq61X
	 QeQIdtO+jzvoL+DMO3UZec7fPlTBaELRPqenRy8ArS6S1XJZrggQh9jsIE1RECYWf6fw9
	 qTH+/iISje7uR8R7CxuAv2+SSy0mc7HyiMIoYLys+E6olBGGiLRcltLXyKM3VwPrQvG7C
	 hyHaaGK8wVW3y6U5tLXROer2J+NAc2vu3kY5tEZADQPguq9TKX6cfQFSaclA2LkXZZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f6ZGJ6cj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F9606A335;
	Thu, 12 Nov 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f6ZGJ6cj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52721F00A07;
	Thu, 12 Nov 2026 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476405;
	bh=TMeLSlgkdu/THkgzUVHvOLjX2ymbR91RP0Axt+hUjBw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f6ZGJ6cjqhN17rDGKPshynKiOmlXX+a+/dd2YmmQPrGA8DFmfjdkwesaBwSIv45sT
	 gzb2qi7pcJJtbUxhCT68PG5/px+TWQyz9EQq/+sz1jn5wSJNpLPlsf4vtYDVDN+j3p
	 Q0InE2cJkuLP+LjAC1yfGPseSvVtj3tAYPL2HExQeXZT0st1ZVvC4yUO/GEjnD8e85
	 ROWeb+V/pTmZC8rrzMeik/VGpM5lrGlPAfn5yE5DcUPIOqXEU5W5HLKiFFwJ4PoSsl
	 OMHdXNxTuLjqurlFGT9CYebYj5/r9r9BkYqe8RjqCWsUOJV6SQA5XCP6mYTn5/KINt
	 yv6rTWKRqA3VQ==
Subject: Re: [PATCH net-next V2 02/13] net/mlx5: Detach auxiliary devices on
 attach failure during load
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, dtatulea@nvidia.com, erfansh@meta.com,
 gal@nvidia.com, Jacob.e.keller@intel.com, kaifengw@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, mfleming@cloudflare.com, almasrymina@google.com,
 razor@blackwall.org, saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me,
 sdf.kernel@gmail.com, witu@nvidia.com
Date: Thu, 12 Nov 2026 09:40:03 +0000
Message-ID: <179447640317.2199510.744399659255139654@kernel.org>
In-Reply-To: <20261110183826.2927274-3-tariqt@nvidia.com>
References: <20261110183826.2927274-3-tariqt@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the fix "doesn't deserve a Fixes tag"
  because the bug was found by code inspection and never reproduced.

--

net/mlx5: Detach auxiliary devices on attach failure during load

This patch adds a mlx5_detach_device() call to the err_attach path of
mlx5_load_one_devl_locked(). The goal is to detach the auxiliary devices
that attached successfully before mlx5_attach_device() hit a failure.

> This issue was found during code inspection and was not reproduced.
> Hence it doesn't deserve a Fixes tag.

[Severity: Low]
Is this a valid reason to leave out the Fixes tag? The Fixes convention
points at the commit that introduced the bug. It doesn't exempt bugs that
were found by inspection and never reproduced.

mlx5_attach_device() in dev.c stops at the first failing entry. It does
not unwind the entries it has already added or resumed:

drivers/net/ethernet/mellanox/mlx5/core/dev.c:mlx5_attach_device() {
    ...
		if (ret) {
			mlx5_core_warn(dev, "Device[%d] (%s) failed to load\n",
				       i, mlx5_adev_devices[i].suffix);

			break;
		}
    ...
}

Before this patch, err_attach in mlx5_load_one_devl_locked() went
directly to clear_bit() and mlx5_unload(). mlx5_unload() destroys the
EQ table, the IRQ table, the flow steering core, the clock and the
bfreg. mlx5_function_teardown() then tears down the HCA.

The aux drivers at lower indices were still bound at that point. One
example is a resumed mlx5e netdev whose CQs still reference the freed
EQs. Later, TX timeout recovery or the remove path
(mlx5_unregister_device() -> aux remove -> CQ destroy) could touch
those freed resources.

This can be triggered by any aux probe or resume failure, such as
-ENOMEM, during devlink reload, firmware reset, health recovery
(recovery=true) or PCI resume.

According to git blame, the err_attach label without a detach came from:

Fixes: 6dea2f7eff96 ("net/mlx5: Separate probe vs. reload flows")

Could the tag be added, and could the commit message say what happens
without the fix (resources torn down while aux drivers are still
attached)? Without the tag, stable maintainers have no signal to pick
this up.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03db..7e762f72b19ef 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1547,6 +1547,7 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
>  	return 0;
>  
>  err_attach:
> +	mlx5_detach_device(dev, true);
>  	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
>  	mlx5_unload(dev);
>  err_load:

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110183826.2927274-1-tariqt%40nvidia.com
