Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795741224;
	b=Su1dgCaC60MwOuKJfW3PWdSvE41t4Qu3ea1rD4PLXmoztx0zW1qQER8swpKKw+05JW0a
	 0CGvfzIyWVRUXZvBuP/RKkMpO8N/dSmXN52vWvv8/i3iBFT4C8C/O/9vMab6fX14Kt0ut
	 F7w1Gy6GVlXiFLCy/m53JJJ+HkGekt7Vero5it2nIqV/nj77422ZPkDFMZET5uvFlAb9q
	 31mfc/krXMxdOvInPqfWWYu+Ttvk5ZVymwEOBYSqWhN6Es/smgDSM0TONpRzSH0SA2guh
	 NlJVDPtQiGtUn0ZDin1H+1XZoXRIat5XLjNcHPfJK9KeBAW3PXqDrshsNiIEPWNHGMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795741224;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N65CsRy8CHza7OEc/gL1Tat3wahREcAdCMv4B/2ySWc=;
	b=mhhQTtjxijZEC5mKbXLnw8A/Mtc9/g4Dir/DXAkeCoEixIDo04Ez44HjSEySGTSZ3drP
	 JZfwrVJoVW0k7yfcREchSjwm79Plddra/sSxqC7rRZ3S4q9nBa6D4/ZPHCWd2iZhswqyf
	 +OiYpq5taq1A3pjRb1JnqoK/Ic+clCzHN+4aWPO1LeHCVbH5/VhmjZzgOw34C3ur2t20I
	 ahlDTTChpOW+BVpaBZW62rtr8mVFlaAOB9rS7th7Y3AAW+PlCLlN+RMn4a3p5A6xnJ1b+
	 OuYksX0HtAa31NUUZVfTowObKVEY44PrzUxQMQ0LhSF8eATDeTjsQ6DdjiX7Mey3YvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1d15hmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA1606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1d15hmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCB91F00897;
	Fri, 27 Nov 2026 01:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795741223;
	bh=N65CsRy8CHza7OEc/gL1Tat3wahREcAdCMv4B/2ySWc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m1d15hmp4cXgQG8SB6rhy0DVSanoD01EM9s13/ogQI9gt2BVuCWMhQFUVkmkddRSo
	 l2EIxcR6Gzo6s4vxkcJ4NmEUC7gMgO55jhpCdQz6mfZQim1yVEU3v3JeFrdOs7oG0J
	 6hNQYNwoLKKw+jsEjo0GfoxDCzx71mgpjyJMkXjqarjQBNgGhA+HjB0WLuiV6rGuwh
	 3exzB3CzgdNU/oJcrdZIGCGB9bIPHDYfR2Yml4hNrTvMki+wvTHvpvHfFRJ4ifVu0/
	 WVsqsRBFBS+b6dEySCHUyJ9NbGPDPB9rBcQGWTn0ZfNWQeQY0+WxYvlAwiACMi/ynw
	 Vsa+TOxg5NEhQ==
Message-ID: <sashiko-outbox-236384@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/siw: don't complete a fenced READ twice on
 flush
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cygnus Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261127005304.366336-1-eritque-arcus@ikuyo.dev>
References: <20261127005304.366336-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 01:00:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_sq_flush() completes a QUEUED READ in the TX slot, assuming the READ
> is not in the ORQ yet. That holds only while a full ORQ fences it.
> siw_check_tx_fence() copies a fenced READ into the ORQ when a Read
> Response frees a slot, and siw_activate_tx_from_sq() copies a READ into
> a free slot. In both cases the READ stays QUEUED until the TX path sends
> it, and a flush in that window completes it twice.
>=20
> A peer can hold the window open. It advertises IRD 1, so the ORQ holds
> one READ: READ1 is in the ORQ and sent, READ2 waits fenced in the TX
> slot. The peer then sends Read Response 1 and a FIN in one TCP segment:
>=20
>   softirq (TCP receive)                 siw_cm_wq worker
>   tcp_data_queue()
>   |-tcp_fin()
>   | \-siw_cm_llp_state_change()
> [ ... ]
> With this patch the READ is flushed once and KASAN stays silent.
>=20
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127005304.3663=
36-1-eritque-arcus@ikuyo.dev?part=3D1
