Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138320;
	b=zHmHK+MCwDiRGdn2QqSH8qxHtjRySk6t8WgKlNVrczqPh/XS6J2ha6UIUPSxdcXOQX/l
	 BhkgKJcVYHPStN/QxBAomoi3UOR6F4cbmMAsberMvTlvzd7mM7n5aTGgjVX1eZA1WLOsq
	 Zoj9t35hdtlLC8b9bhgVD3pWx0dh+WTyU2/jRDVKtjzhM2RGf96fkpCIKxW0EjVexpO2c
	 zFu9a2gqubBtZ2myxlUpYctqUX2uJkS4DBwz4xkgvUkyzzormsMorLYCgxpYV2ThFPfi5
	 e8z5ELhSYSzqkS1/9orwsv0bKqEKXmw8GdjXtc8wKgmu+aduy7fylLJaQ8RcY7NAgPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138320;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8odw56CgrF4G/WUl9C3EiLczErrHmHzC04N7MRhPIZI=;
	b=w2vFHKmkTj/w81kmCXVkYz5sOnzxAjerXChSFR72qTMqLXqUKkEyUh7tOcGksempxgAA
	 IqsZjlyQdv3QLAQke5M3NWGS75XotkqyobOoHXea9YWUJ5nROa2vxZiCLQrxhjNlahC+p
	 syh4xlGWAwllFwi5OdGIv80unMcyfXtxajJLYWvjgYP6UAVnB6hDUr3S6LvexFgZFgd73
	 +KsLCOp6zTn5brsgCzcUGWGZ0pGPqgTkAouts8fmb4O88VnUdAMuiA8aEDGC1pxQee842
	 9P6zYIoBogeGo3eYq2eeqgsQEgKZ980MuL/IoVi+0Yh2Y/3UpsXyg7iLhEuc/wfRZ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeurciXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEA5606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeurciXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50DE1F000C6;
	Fri, 20 Nov 2026 01:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138320;
	bh=8odw56CgrF4G/WUl9C3EiLczErrHmHzC04N7MRhPIZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WeurciXYGrDT4ZJ+6xYfqI0Gp6ullyzOFHfpmdVmZf7/NkRzoNoc1X1J+5rsoGkhO
	 fOLX3VIsD1kWPRJFlLYibFFr/93UmR49Qr+WotZJVtNa2x1nfS8kcwxGHzRU4uMZOo
	 95c2H1gDiZZO0t0ULajSg4KkRvejLCENSPBusxuJvpp+J3waJU20mZWk+W5yP8XUxQ
	 BR0N/qHJlgLo/XSaAkjAY27JgPDxnRYR5MEuTdWP3o4zJEdH0srJvvQZ77pvx3Ws+d
	 jEYoiRhAmWT7JuuYOdZkg/dMSw7t+6gZ4VmezUoMRYCm6ZWXufuzTxcMECU4Re0Yle
	 8J8gbGH52/uWQ==
Message-ID: <sashiko-outbox-224314@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 07/12] net/sched: flower: add psp_spi,
 psp_ver, and psp_dev matches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-8-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-8-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a flow dissector key filled from the PSP Rx state (SKB_EXT_PSP) the
> device attached to a decrypted packet, and corresponding flower matches:
> the SPI the packet was decrypted with (psp_spi, with a mask), the PSP
> version (psp_ver), and the ID of the PSP device which decrypted it
> (psp_dev).
>=20
> For example, to take the packets of one Rx SPI (allocated with
> rx-spi-alloc), and remove their PSP state so that they can be forwarded:
>=20
>   tc filter add dev eth0 ingress protocol ipv6 flower
>       psp_spi 0x80000001 psp_ver 0 psp_dev 1
>       action psp decap
>=20
> Together these matches tie a rule to one Rx SPI, in a form which
> hardware can match on (offload comes in a follow-up series). The SPI is
> [ ... ]
> Note that these flower matches only ever match packets which were
> decrypted, even if the mask is 0. So "psp_spi 0/0" matches any decrypted
> PSP packet.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D7

