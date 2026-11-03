Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745301;
	b=4YcOU8nVBhMM/WfIoaom+au2hvC7QDgynBfyBXRNZpD4Lia+OXsrdd2/ZHbVxBiX/xuV
	 fHJwxyYe85wJMV6W7ZMxgpReDJwO4jBzUiRWch88sLYCLjgy/6gN51RnXSttIkJ3M5QZd
	 l4ApLR0pNTqvfzej1cp0sy1/Geh1OkBNtHzVhoBGboCB8YqfpR2bhdweBjfj9UYuSIKA0
	 xF3Xks9Hftp8feptW4I0Xt5AWvarWJYcaRJ2k62ztSSO7WT2YYluOIo5Ws02gaXxkX4Zu
	 PellDW76M3Kf6RPRd3kS7/WXWjui1xYLibBdokRrfDm9Ki3q4tO1nuCfEofM96xOBLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745301;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ap0K3OQmROPArG5ae27Dzkw8Ytg3jPvevhc3ocJgH1Y=;
	b=n6T0P1DmVyA/EF042975QZAyzp3KiFT+6grSdeEjTV7m5z3//i+OTOGcRexXJZAS1wD4
	 LEkCRp25MWAk7SVkfauPEE/rGJfn85Fn7eRyF5eli27vrsWjTzBajiUpMr/fa3ll4gKb1
	 18hVXv91nuEOgaJ5w/Mdcm5p6lgqLBwHetkUsS8stvXeGDHhmskvTpmWTgBGyFNhisEJH
	 UcjOjByTLDY7sa5N4RbSH/YJSpD73sJE21kkiaNBz7KOknIsoQvJzEjmnRFBe3zkWwQpd
	 Bn2gGtGdEROkf+mUvmzBz+1C1ktFONYwIWe1ApvpYKiMtqreZQ+yDNw2MoOdv3kazRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh6YloHU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF0606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh6YloHU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D83B1F00A02;
	Tue,  3 Nov 2026 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745300;
	bh=ap0K3OQmROPArG5ae27Dzkw8Ytg3jPvevhc3ocJgH1Y=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jh6YloHU1dbALQgIZTTIcDsDd/kZAroDB0YSfo+VVrCCc+vMpziBqXRRp3QwtDK2o
	 lyZvO6lhLyFf2oo16dmoqazms7TGLUAbW03LdwEt3Y2UV1zrvbREORF3BnXQNWSMF5
	 TiegaW8xP+b5HzFKdZSze1OyORO8jPYLRH4i5ExTKPGsFXWbXqVV+ZlGPK/FmvmHgv
	 8fHgfcJ/irSgSqlOhmcKQq6/fVguJQsuaI623G7QvX+L3MA8XBD9ipPjcyD9CsG3AE
	 Bk7dPEgQf3I2Vzj5jD4uNMzrxGUiyahCN+JWyR0XNR6UUOzGx03gqVVjLaL7pO8udd
	 zdqoKWqlS6u8g==
Message-ID: <sashiko-outbox-196132@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 07/15] mlx5: Consolidate mkey ordering
 setting into a single core helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-8-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-8-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Consolidate the mkey ordering setting of all mlx5 consumers into a
> single exported core helper. The helper takes the requested ordering
> level (strict, relaxed or unordered) and sets the mkey ordering fields
> according to the device caps, so consumers no longer open-code the cap
> checks. The unordered level is used later in this series.
>=20
> Switch the RDMA MR creation and UMR access-modify paths to the helper.
> As before, strict ordering leaves the mkey context untouched.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D7

