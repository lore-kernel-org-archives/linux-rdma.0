Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336033;
	b=pwNYR0sAIYNWH0ux/nZXJNYAy47ZSZRMFzgu1/Q+YoXSTiAGtWlT+s3lz+gKrIzvyVWn
	 zlcBWGoCTCA/Cdm80SXIIJlay/RiFz2ZqFVctI/Ncm+GdzH7RLKVCWcH9VFpO6W6JJFXl
	 2/z8SyDJ595gP9Kc+NtSZZWHlntYBWZvUwMQ5xhOxO6tIocx2JnJ8K0kNKqqrIa9GYf4a
	 6ZmQi3aoEazEafTaUThiVow/xr87VYKwPFkFh36msBJRMXNaHwhPQVS1vyQd6BN3cjigF
	 HOan1EWg1VJW570iNVhA3IJpKIrH0rQoBm7kLliMDZRrxsSN/WnKqq9I9CVNby9iBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336033;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3YU2aLVLOpkh2V3vu6PvKV7Ue9E7oA+3plRfwATGgdg=;
	b=hSo3FFJ/50aOd5OEHylYC7NOiNBa3OQ6HkTxu3XP0G419dZcA5wVL0RAmrpQ56jGC72H
	 kWmZa7aiDJHk+bE/kf7SldsGWWN5LfQPT6D8F841D2UvVlmYdR38+Yi8kRA+u7HZxO4iv
	 /dvf/Cy5AISZy6dsYsieQ9kXAoR2FtvqENfLuTgiWNIfM35W4roqH8jrpLgKtMVK5tn1U
	 +ykBFRugKZ5DtHhfktLi06l9RyOMBwMruI8BKosdGGojMZ3R69IYf9MOeo87+aWD0Xq7v
	 9ML1odWV/GXm/V9YmorbtZXnMSXXgI6Mq21qteqz3jKvcfv/gL8wr5x8Fx6IUa+B8jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bza+hfUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD150606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bza+hfUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8CC1F000C1;
	Fri, 30 Oct 2026 04:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336032;
	bh=3YU2aLVLOpkh2V3vu6PvKV7Ue9E7oA+3plRfwATGgdg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bza+hfUEEmEj2xxxNOvrKdzEyyin0d61fgXw1ifx1iZQtydXON0IS+j7N12tIoPQq
	 R2BM+brE6mn1ijpKc7fxFHaCGvFA0H2118m2h+SfjRlqhUwFYZcVgpTfZK59a5+WSL
	 XsIWp7gMF5M0qTMcMjsmpevoaltbm1Bx/aWX/FUqof3rGZTzdR2eg7ZcQ7ChST5kSP
	 huLyivwfSyJSZ8BYOze8Xze/8TVcmwO6jBCOD+ieyHdAHWSNlHdcvkhWwrJvxp+Ma7
	 K58gc9OICPzO2lOQyF8yDkYdvieTo4xrb+uNp/0TM6x/qkdhOD5rq2qKMPVFbVxG0g
	 K9PM05E+zDeiQ==
Message-ID: <sashiko-outbox-18474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 4/5] net/mlx5e: resize configured default RSS
 context table on channel change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260511172719.330490-5-tariqt@nvidia.com>
References: <20260511172719.330490-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yael Chemla <ychemla@nvidia.com>
>=20
> mlx5e_ethtool_set_channels() rejected channel count changes that
> required a different RQT size when the default context indirection
> table was user-configured. This restriction was introduced by
> commit ee3572409f74 ("net/mlx5e: RSS, Block changing channels number
> when RXFH is configured").
>=20
> Lift the restriction. Validate the resize upfront with
> ethtool_rxfh_indir_can_resize(), then fold or unfold the table
> in-place via ethtool_rxfh_indir_resize() inside state_lock, before
> mlx5e_safe_switch_params(), so the preactivate callback sees the
> correct table content when it programs the HW.
>=20
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260511172719.3304=
90-1-tariqt@nvidia.com?part=3D4

