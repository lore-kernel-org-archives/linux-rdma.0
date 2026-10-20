Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510840;
	b=qhXjmTfooE6fHgZjaQ57eVaznRQ/m5dzp+ihVC9g4Pzk5fsXM6dgEIzLBtNHYxuJcuud
	 IN/ILZot0kk9HYqh3MJLxjw4kIguacXpEydLIeyP6CCDenx90jWDGSXFS9VNzYdTEIk/q
	 dD2Al8we7U1fNlr3iIPii1sNkdk1R5Oqhs5aGtDzj7fF1ktxITjK7rzporSMmrmEV6AB7
	 iPVLgyx3SVosWQn6BxlaESxqDMFKBbXCS2GE9EXa7cricp9w0NlF1FLIbKy9UlR3lIsrg
	 Dg0Ipt4MTGxuoRMmmyvTR5tc/aEc7GVq6sa1+nfTpb7Arm9pmRuCoMegClF1yKc1dow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510840;
	h=Received:Message-ID:From:Subject:Reply-To:To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G2fNdckiOKuScPmOHJEzluAyvgJvabz1hSuZja0Buzc=;
	b=GSsEI5Sx3HhKaM66jTbRhVFRA4qaBicVgwORcfoKzY/+RGPhZk/vd9q3mIDRIFhwmnhg
	 jdiBsBb5yYsGPMGw7EqkzE5nwIuNW4RRVEIFQHpvoFMiEXl6v6lEk1MdImfryJA8w9Q/c
	 jmkmq5wCYmcITnJOenItro4AGfCogtf7UR9Wt+7Fxj4xVHYM8Xh7AWKZDjouMG9uzxAEl
	 MsuFreeo7aeCd+1XPUvYOeu+rz/NtD0YqDIcZT6lvvjjRUWYiGb6o+DdQC5Uv+7pQTHQp
	 S6f4HrF/6JAARh5o2mg/yMwip82V9KBVxlXJJ3j8/vKQjn5N73mRTmf+Od2f6xyS1Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EA8606A328
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 15:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD171F000CF;
	Tue, 20 Oct 2026 15:40:40 +0000 (UTC)
Message-ID: <sashiko-outbox-179269@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Stop asserting for RTNL when closing
 channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261020153659.3440902-1-tariqt@nvidia.com>
References: <20261020153659.3440902-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:40:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
> required for closing channels.
> But the driver has been switched to using the netdev lock a while back,
> and this fired from a flow which was forgotten during the conversion:
>=20
> mlx5e_tx_timeout_work()
>   -> mlx5e_reporter_tx_timeout()
>   -> mlx5e_health_report()
>   -> mlx5e_tx_reporter_timeout_recover()
>   -> mlx5e_safe_reopen_channels()
>   -> mlx5e_safe_switch_params()
>   -> mlx5e_close_channels()
>=20
> The RTNL is not acquired here, but the netdev lock is, and it is enough.
>=20
> Rather than switching to netdev_assert_locked(), simply drop the assert.
> Upper layers (networking core, ethtool core) provide locking and lower
> layers (NAPI helpers) assert that the netdev lock is held.
>=20
> Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking=
")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020153659.3440=
902-1-tariqt@nvidia.com?part=3D1

