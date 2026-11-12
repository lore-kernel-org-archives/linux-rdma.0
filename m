Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490209;
	b=gs/wJjVZHrxjK0u04/Z6HVr0pbM6kviodx0JlcqxLaQEWcodnUtJ8X83gT1WRGmt/ua5
	 F+3GpTMUjEAr0FYaKThsEoBHaJOChFmzEbVww9cX6mf94X/xHGU9HYqYX3b8lOsWWuwrq
	 UMxeXqbibkqiwuyAzWSU4qky/IvyIaqO5bxbmUc0S6UsG4peEqT+LuttgmoytRDNgOMpl
	 xKSAHZn34AyGNVXVJyoZ1oHPw6jpDU8HelHmqxcSsIc1JlFLJ/2L7xqJYWqOy0uldZbkh
	 uCyrFQqgawOhzOTt1RzLycknrebHRY7OZu82uM+6xK0EH7/JX2+UkhcthIYgJuDbzQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490209;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EQEz73t2+dQBMCfDeYWc7ElzpUll+268CW8sfUkmsLg=;
	b=gWZOVwtzeRHTszS2YOUWE0Bh1cs2f0eYR6b3BfqLLtGt/dXrzp8F6P+7gRUIqhDcJVzr
	 wa/hNhi38hUGUy9MyFB6qT/+YPV5nIOYoaPIWV55kaD25XLmSx/P/8OytpcMLx2OoE1Z0
	 FFpaYTQT3OTRPOqwVEhmKtWaWPy+kA3pdQNoyvrRPEhlPFk21y+e4YQ/fPZUD8GQWTHm4
	 kFGHcM/tDWgsg8rX/PvMy9qgINOXRrNvgFcBzm3EK7jXcwtZXgbewQcSY0JI5GDruCHCa
	 IcCI85xfyluEenwy0ca8zdmwlxU8lhmYloJlvaX0+Nf05Ogp3F+ZdfY5g/qpj9Bkmyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ovm8V4hf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C71606A31C;
	Thu, 12 Nov 2026 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ovm8V4hf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D558D1F00A05;
	Thu, 12 Nov 2026 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794490209;
	bh=EQEz73t2+dQBMCfDeYWc7ElzpUll+268CW8sfUkmsLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ovm8V4hfsfoY+7ha37Zr4Qlfx63UDMr5T+xbDyxSFra3Eoek6Y+/34gQ5EI2NNusp
	 2Oc6rbABMGUwrI/dBU6VkM3plxVFwwSQgPps+z6+wzAf1JYFOSdgVAK9YmLEJNCt1Q
	 fXtJo+rKgW/zNzwlexPIUPlILY2nbbdJ+FWODbHV6/7yUH9T29vsenDAEwtDZZXr/5
	 E+El6w10ejfL7H38luaEirFT43lnZJe/SvAvXlbo4CbgkslFHtCunaXag/eY3xV7l6
	 ESRNXrzUdt15c5MA70RSZo9nQc7DgySalA5ki1vLvJUUeMDn/LSvIctYJoyBBJjaoc
	 piH35fawT3hEA==
Message-ID: <sashiko-outbox-211184@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9 1/6] net/smc: bound the wire-controlled producer
 cursor to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-1-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
 <20261112-b4-disp-0287c16e-v9-1-e5e8fa688177@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 13:30:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import the peer's
> producer cursor from the wire into conn->local_rx_ctrl.prod without
> bounding it to the RMB. smc_cdc_handle_urg_data_arrival() then uses its
> count as a raw index into the RMB, so a producer cursor past
> rmb_desc->len makes the receive tasklet read past the RMB, and
> recv(MSG_OOB) hands that byte to the application.
>=20
> Bound the producer cursor count to rmb_desc->len when it comes off the
> wire, for SMC-R and SMC-D. Leave the consumer cursor alone: it indexes
> the peer's RMB, which can be larger than ours, so clamping it to our
> RMB would under-credit peer_rmbe_space and could stall sending to that
> peer. Conforming peers are unaffected.
>=20
> Fixes: de8474eb9d50 ("net/smc: urgent data support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-02=
87c16e-v9-0-e5e8fa688177@proton.me?part=3D1

