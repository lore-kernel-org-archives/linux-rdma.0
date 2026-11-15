Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794728545;
	b=HmcHmwWM20oQmskYF08cPBstEWnctr6W0lN765l+KWbTXNGdpnl3r8IGHoCa7ilhROIA
	 nMeiPj3/ISUlOhEZaO4V8v2GuMVV49Xg6IxnO6Skogsda9wUpwMXuJCHrXUcryfH4rcE1
	 ZDKV1bOV/nXN5j3h32K7B8U4HgBR1tVp0T+fhdiJhgJNpqqTeb5+b3ReHvl7tzuAocGkN
	 woHvo/yMT2/h4fOaK7Hr/bKW+c3fxRe5JUqBP+D0gWPjGM01kqe1O4HxjnHpPeg7HvLJu
	 A4IGGLgOZRTzxWN/8IQAB/e90eoI5KBw3lgoznibtS9QZdt71uq0xR1nZH/y8UrnV5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794728545;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jU8F/Txk3Vnj9LAqRw08EenoSS6NByQIXdLBwWDVrt0=;
	b=jg1ItQ97jZ3WAHQDqkdiaIgkNUW/LWGrp8gvjy06pZ5QCay68JW9+iJU209mqDjRQCoB
	 Z1sRxEe4q5PAnSPSLHvUVUCYL5A00rQgc2DrNbwEgmIJLz7qMUOqGXXLLkq//x7aFMV6P
	 6rIPNl9BtiYV5nOkuVY1DCxfv23yPzQhpDaWyuTHyAuHu3Kp058NtlbsSKZyp+E7g3nma
	 aXmyTio2TPz5eGZ6Z4m9227Tm8SB4XOXzP6E8AftAarBMbCGaIZCLvBNSauEx+u5onPiG
	 7Di/DuEcli/W2KPyztZhVB6WmoscUaC0JgNbfg2qBmc3tHtjT3bWOF67bejbnyNos8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxOsuiFw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EACA606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 07:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxOsuiFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3071F000C4;
	Sun, 15 Nov 2026 07:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794728544;
	bh=jU8F/Txk3Vnj9LAqRw08EenoSS6NByQIXdLBwWDVrt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JxOsuiFw6o4qs8PQNdOQ0CouqNhGW5FMSdDPYp+lCchaHGVXP1FHb7C+FBWl34tqU
	 MTlckEXMYChPir9s7QPXIbLp8I4v7ruTV+Sl5pw9imU2ZPZ3IPWJyCgHZXXVafxi8S
	 Bl8jbDI6G2ARt3vAXKmV/yf3JLIrqRZ092VP3OwDiaAIaLPVxPoE47RZg4OU1GIN9i
	 gJG7B7dLV/df889lrEmtAzDdrv0FkP3XxYvpb1zCnkr5bUbWOAMHA9VzZbgzJlHYV7
	 zZTz9nII5onIgEUbyuiZhSnyWON60udfzdZSD2wM0sJAHgnsif93O/5EUE5gfw+T+p
	 DVdNL2iLLOBaw==
Message-ID: <sashiko-outbox-215266@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix XSK pool corruption when switching
 channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115072934.353341-1-tariqt@nvidia.com>
References: <20261115072934.353341-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 07:42:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> When the device supports tis_tir_td_order, mlx5e_safe_switch_params()
> closes the old channels only after the new ones are activated.  With an
> AF_XDP socket bound, the old and the new channel hold an XSK RQ on the
> same pool.
>=20
> The old RQ returns its buffers to the pool while the new RQ is already
> allocating from it. Since the pool is lockless and expects a single user
> at a time, it gets out of sync.
>=20
> Close the old XSK queues before activating the new channels, the rest of
> the old channels can still be closed later.
>=20
> The crash was hit by our regression tests, with a random sequence of
> [ ... ]
>=20
> Fixes: 3b88a535a8e1 ("net/mlx5e: Defer channels closure to reduce interfa=
ce down time")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115072934.3533=
41-1-tariqt@nvidia.com?part=3D1

