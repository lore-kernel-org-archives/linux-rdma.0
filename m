Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423117;
	b=u/KVZap2bqNwh2jAdHwDFc/kkg5JRTdj3S7tWs+dZEmQZoBqeahK8sMBNuWIB2uL2O/q
	 RjPpLZNlRN4tYxH3ZJSUFV/HfjJNpGxbqhj14wUUWzA7QBoF6EgHPgkvctzFdjAws600J
	 0kn62zkMKuuCj7d0nktmdCHpWhS5KnynXQFkApyd2DUtPOhSNR2dAVfUdRwXKMDEf4nEF
	 YrIhm6ICyQKg+Ji0HiorxtAwNXP+Fl7YN9N9cI9dBFwDcP6iA9w8qzZas2XmKIwAWj0iG
	 uS6gEm4aTwUv5Lb/GVqP9VwRK9Dm9PKWh5mb75Yq5yerp534jao9VK2iP/O/ybsHUnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423117;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5i3iftGKWe+bEdWU8T6EVkOL5ACpvmPb2Y3M7qfMdwI=;
	b=RmwkbmhOpwQ57SGZm+9UfV1zfi1oFRDUYRqxxZzkSBTBtOa70Ikvdw/qW+MLbgNz8Cgl
	 OjG9u0SndTcYKODndi3X+7H4EkRyD4ubfMxjWxFqUfxOGOfjdndaKCk6Z4213cYm3835R
	 eUxf10Ar0oLA5oTLS4Gd9MUCMLGQF00DnbD5UuFRiUWGnJoqnz8CUWYjqJptN5CqAhawM
	 8j880YDPL+sWfRZcefoq2Nuygo5RX3Yl/uImD9Mok29LAa7kNTkH2yVtmUKHaCralKY0w
	 Cm9RVAHG3JZBe8CuCL2k69Jz7fT9fsVFxC4AxYP7D9chgH/rURZNGm6ouXy2nO09zzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O8aTBzjF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214A606A331
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O8aTBzjF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B5A1F00A06;
	Wed, 11 Nov 2026 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423117;
	bh=5i3iftGKWe+bEdWU8T6EVkOL5ACpvmPb2Y3M7qfMdwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O8aTBzjFq5YmoV8IWnrAnsDqkpQA7iBU17R3HQ+MmCyS1bDGPKR6pT2Cf5L6J59WW
	 lhTvZ49XXKgyb52Xqkj9N777qzxprCdlPJoC7cAW8oQZWCWagfcSnWGu7RoOMvsIBT
	 Vo2fSvz3c4KXCSabLHc8vWqo2k8cNfRSHfEsfkn/I94YDx4B13uL1MzFONfCpIOrdc
	 sjFwLisLvOYKfWwQATceN21udayDdZS+ZGmiMhu3SvAXdlCK+6m5k0umuX5bJEcGp6
	 XLFz72zsSTg6sgNaPmIYXAe3SbyLIA9S1GK9nFp6iw1im7FOd8MYSXPWw7WFMT/i4D
	 gVReXvNlorUwg==
Message-ID: <sashiko-outbox-209499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 2/2] net/mlx5e: Batch ICOSQ trigger RCU
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110185005.2932568-3-tariqt@nvidia.com>
References: <20261110185005.2932568-1-tariqt@nvidia.com>
 <20261110185005.2932568-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:51:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> During channel activation, mlx5e_activate_channels() triggers the ICOSQ
> once for every channel in order to kick NAPI. mlx5e_trigger_napi_icosq()
> sets MLX5E_SQ_STATE_LOCK_NEEDED and waits for an RCU grace period before
> serializing the trigger with ICOSQ users in NAPI context.
>=20
> Mark all channel ICOSQs as requiring locking first, wait for a single
> grace period, and then trigger all of them.
>=20
> Keep mlx5e_trigger_napi_icosq() with its existing synchronization
> semantics for standalone callers.
>=20
> 248 channels, rcu_normal=3D1, ip link set eth2 up:
> Before: 3.095s
> After:  1.794s (~1.7x faster)=20
>=20
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110185005.2932=
568-1-tariqt@nvidia.com?part=3D2

