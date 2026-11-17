Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794940571;
	b=ws2yIlEcSnEbRA8mWQrjvd58+Xu81bbUdS9lwk4uVcxhgae/d6YbYBVBCLIniBUwClN/
	 VsnSEp5W0P8QDYaeJkGTrMqnOmxD1NNRNH6Ryt9Lwfi33XEdKRCLfFtl3Ak5Bbx5A71th
	 xF86rmkrlkKhPa0Hy3Hn6XsU/1MF7ME5d/4YqAoCOemWGN7eWmwyl3HUU+e0uriwr7OPb
	 xiWvyzHOrrf80CzNBeXKk3aotKO59803M5dE8+aqgb/jJ7gnGaajXQhb+j/Bgh/P4nXKC
	 iBQjdkptajANxjvl+xJAUrcQdno/gWP/P3AfC3QW8qRn1MOJDVYq8lKYSg27L3uIQIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794940571;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7K468bn84rBUkeYp4dCSBkYRf9vewik2SKr7zXdNJ0o=;
	b=3KWGghY4c4IrxrCuqY7SHTOQQAI/LbcLzc6T9bnCEtzGYfWyXOO7QZsq9zQy/YT3h1w4
	 brq9XKml/3pUP1q3iyu4PYrylsOmqMUlr4h7zQLSHUESnEqg0SCG3tRmqHGuO92uVXZDO
	 0a/8CMOEBaGe93u04YWIqHZP3MSmA77eVF8KWR7KBfCF0BbLUJK+rpsRRTZqU9OzOGtTY
	 tPyK6EO1HeiI6hQqbw6qOMAQSvQhV5DfShb1aKidY0tnDCkv/kSNIoMwdTX/VZ/yP3coN
	 Aa9GFsuG0M2YDtuAQDXXKt07OPs791M0XiJyDp99FScpbcWQzMxqLXjNezIsHH6u43Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ii3z0tgM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38858606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ii3z0tgM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E996B1F000C7;
	Tue, 17 Nov 2026 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940571;
	bh=7K468bn84rBUkeYp4dCSBkYRf9vewik2SKr7zXdNJ0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ii3z0tgMMxYnMYod11TIP1qo1NUau9+zRrOIzF85HU5r3AWJD5FDbCP6ZTcR6iN6d
	 6gqMNq/Nixr+cvicoOWRZqmiTSPGena3smwdlgYqElwm3RKZvdtiquzHrwx2qS+7XQ
	 cTD6xzcZw5n9Tksk90msUbbRmFMulNxGnQ6EuoOSr78D5XkPrhnzj3C2F1Fd/qjh8q
	 3Gm39FFFSugvi3ZOHLRWpuDZDUia0d8F0+FBbAXlTo/4Cm6ZzSJ+GWVqq8ccdOyPZl
	 tld+z+ESTf6DbO5XCwUoGQmfDcejcOWENAhm3z+piTovgPUnYPdijT+BhkzLkZf/PC
	 CanfJ87fhFbKQ==
Message-ID: <sashiko-outbox-219363@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/mana_ib: Enable RDMA devices on the
 CDX bus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117182043.149267-1-kotaranov@linux.microsoft.com>
References: <20261117182043.149267-1-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 18:36:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Zhiyue Qiu <zhiyueqiu@microsoft.com>
>=20
> Enable MANA RDMA on CDX by depending on the shared GDMA core and matching
> the CDX auxiliary devices.
>=20
> Map non-PCI userspace doorbells with pgprot_device() to match the CDX
> transport, and report the Microsoft vendor ID directly.
>=20
> Allocate missing DMA parameters before GDMA setup using managed memory.
> Register a cleanup action to clear the device pointer before the memory
> is freed.
>=20
> Signed-off-by: Zhiyue Qiu <zhiyueqiu@microsoft.com>
> Co-developed-by: Konstantin Taranov <kotaranov@microsoft.com>
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117182043.1492=
67-1-kotaranov@linux.microsoft.com?part=3D1

