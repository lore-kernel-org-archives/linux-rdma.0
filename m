Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827061;
	b=TlsKqp4JeKjktZjQhc3BsdkusCEviiwAFUSbn/95Ys0No7Mq4OIMPShHd/0bBQsqVIDW
	 OkTdR4jlKaQEtCbgiLZxg5rTeDRO4fV2Y9LmRZphcvAmp9qt6FHK9+TxvSs0Gsj9OZMIt
	 8GqNldva98rzGyNuKOel50lz01o0B+Ellj4dWr282T0Qjdmzy8qlOpHptQVlBGBl1Dr7/
	 XP/IzmINd5u9CLbDh6R7B9XuapKlCQ5Qj8jDEA2bBBKjlpS20d/BzsAoQvlwYbuQJDLak
	 5mZjv7YwCvQjAZI91INWVqUHVHD9BAMABFah4WehHfqcXwcZIzEAt/c+6aivccA/0Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827061;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x0yXsYEuw8gN+TUjYST7qo6euELru7ZFSF6bZl3hSQU=;
	b=C/Q8H1In0S10//IrvoYblxDaGPBAMCM1aUF4G7tBaInNDX/lXwVQJJGC0rdtvp7E1UQs
	 pgOI4LZw8/ePCdLvtNRWHVq41arEBClQpU7JYddgYYMdzj1FlLsl21ZPbog/gHifa1Ung
	 C/LOfcKP+8GofumD0DFYWeNHIeRbg0LHerNiWsTd4Cx48y8pt4CTfw51hqAwSotiZw//t
	 Uyv6KAPsMQKY/SD1ZHDck0HCXBvncKb58PkDaQYHe45dlPan7UzdB7rohMPyYn4u4gBXn
	 UUEe+DktFQ0UiaZ6I+atG16OO7VMh28Xn+9/doz3YQGeo13n5c7loUCV7KT1tft+rlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InbTpxXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5ED606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InbTpxXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ACB1F01825;
	Sat, 24 Oct 2026 07:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827061;
	bh=x0yXsYEuw8gN+TUjYST7qo6euELru7ZFSF6bZl3hSQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=InbTpxXjoY5Zb0093BGln4n7o0y1CD/IBdkphbwMyhahFBfVrIBWE7fjHyFarLIYz
	 L/fST489paGYCk6wL0IDiIJLpWOPPP6WUnQW4O32d3ope8TRbB7usmYDt/mQz3SRk7
	 4RmNRRY0w6/S4BVI+ZgV4OKOTJqfI3zuFdKrL9A8kVDV810XLTOGoF7Ac4VNP9LLIn
	 muAEuL+pK9JfXQiWgsZHSLLe6bRP3PCLPErnYqsGaA1C9cQEFiV9UUyCg5fn4W+8Fb
	 9lKfFVdpev17REhw97ulLrII2hLLYH+PRP9deZrBHRZu8WMqKH4nNeBcXzmxv/14vv
	 DR+e5F6FygvWQ==
Message-ID: <sashiko-outbox-183584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/7] RDMA/zrdma: Add internal headers and hardware
 register definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-4-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:31:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add internal header files for main driver logic and hardware registers.
> These headers define the structures and constants used by the subsequent
> implementation patches.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D3

