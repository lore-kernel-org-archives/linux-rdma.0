Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404807;
	b=PF66oXHW27zNATSGg7Hi0cy/S4U1qlFbLsTD1HR0A0QxP/Rlgu8s02gnXZroeclGsuot
	 mgpSC5NZONlJoZeBkkw8j5Grnzlwr24DFkAmJLEfG6zfR9k22QtK2W7jhzkbNdstWPYWK
	 mBs6ABMtPgoyQ27QocEt0PxYYADbqOFHGVqA4zdllwWMVirUAWn4xJxth0T+OUb2QeYFk
	 YYKNCheaml5mA3T5Wlowxofn7qOa21iFy7JTET/dH75FTFUD/LqEQLknPbaXZeNcC6/xm
	 QjdJyoMif8pZRiORY2CyLK9P1BTHH42Av8re3i72DgaBLDoXw2KjYTko2tuVT/05MqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Js/JVHhE+btAfawi3KZl/H0WY9t65LiFXmtflMJQrvQ=;
	b=y+gwmW/NDqWEygIITjTA2RnrFAcww9MXbVod1HU3NRjUKtaUwHjxpj3tMTfQ0uJi70do
	 fvMBGB/F8orL83zbCGAGTEhsDD/V3XNr0sZnR3GWRSsE/dgBQSegfhbBVWMAGCtayt9k5
	 a4hB1GeGynJ9MYJh8Ib0+tyWzJZ/t6aWxXpISHI1v/ZVQzwYOY341RAc/aDIwRKgMSaw6
	 6KPxPovk0W6tdmBE9qbh3jq11wwOGxEnwqpCiG61HanUiRymHH2LtiwTR06HT22XmEHUV
	 B/TwTG7Z2MXtTW9yWI803OB5EqTClu49KVLW9nQiS0HoPbb6eEy7vFdrvFFdr2Sit9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdvuZdzg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1EF606A326
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EdvuZdzg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534701F00A06;
	Wed, 11 Nov 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404807;
	bh=Js/JVHhE+btAfawi3KZl/H0WY9t65LiFXmtflMJQrvQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EdvuZdzgubHusBva7X9Vr74BcRgS08IK+UtL34w/1E6+ufedxih67h9fKeAPBJKRh
	 1NAVnoo7CAxou3IDliusstd9BsL4ujP0Q0BsNgNr2kG3qQz6LzMfMtOfZJltGnTkiW
	 +6ZL/ibR14sDxVKKhSTdPV9CYzArb6WOL6V7OIRHl02vMxhEuqlOaz7KChnpQ6J+FL
	 7QNXnIMDNkgk/DxX21s94UaH3yNHZdLn825QQakGFQToaqrxc0hFJuX3592G0IJToB
	 5kYBFyrIBANFSkeUuBGMZ6B+Cs0ImhOreNEtAg8GbdXVvK81Z/dh1NGVZE8qIMJ5ly
	 vqGm27XbVrFsQ==
Message-ID: <sashiko-outbox-209090@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 05/24] net/mlx5: Add macros for reading
 log-based caps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-6-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-6-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Add macros that can be used to exponentiate log based capabilities.
>=20
> When a capability can represent more than the used version (u32 , u64),
> value will be clamped to the largest representable power of two.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D5

