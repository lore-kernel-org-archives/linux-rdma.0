Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001528;
	b=xwBmwjYEoRSlFv6GsI67iR5KvAlGLxMgNc04F2MVCshPeITdk4e+fx2iR3VaS9CdJFsg
	 tq3uXUnRUOtPFwnKBgjqoo9EKAdyKm7S7voJwBDwz6Vya0vNrzRdvkLUnQcvyNLw72R1u
	 RH7a9yL3PvcL7usmYhoef2ZnN5E2FrjkTndCxLrydgbwPhFLwZWLyFlFn04+dpjL22R6Q
	 5CTHteIb1mJIqLQ2bq4IClJ0EWAm7CAui525bqeR7IOxHErDn7sa1fXqEivNT64p2adQF
	 NQ7FFIyVawt8wj1wmUR6VBviQyEUq/WYFCbPsP60tc0PSEuxpUHg0iwiI8lVCMLTtZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001528;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hPDyYjNmbMyFXG/Ni4qWfFodFKrwRF46JqIlh/SwjCc=;
	b=WLQm6TUVA+Ba52ZtX+KTcL2QCGIIorYWOfBEdD1OZ8OJzmFAL008I8cYDsHeL1bEuovX
	 IAFFLGMArkVkNyDsdReErKL2fIOoevmpTHETGoM0UQ81ITbTFNbljmZpOyXfPWA8JlQOf
	 OUGxXdl7SIpQFoRYmUzMx1GyD/EF/Nf2AHLUKjq5iV89B+HRCb4WMIV0lfYdMvBd7xbbk
	 473hf7ihRW9ncBAHuGyqXXY6JQpKBbKuAm/7HJQa/GFAK55Rb9jU14Df4vQSrY0SXhwSB
	 VIi/xxQ+N1vnMHZ2A69qB8hy+mHuPJQVnwJ6IYj5bSVUxARvGZ7zbsIcTrLYT863u4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8QvHKDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004C606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 07:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8QvHKDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FEF1F01825;
	Mon, 26 Oct 2026 07:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793001527;
	bh=hPDyYjNmbMyFXG/Ni4qWfFodFKrwRF46JqIlh/SwjCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8QvHKDeuq0yzAsBKbrzDFnOuJn+wyTURTnz1brvv+m4/sfISS8ve6K7sRC3IkZv8
	 XZjg2aEq90saUyqZFrUpxpHEQmIy2HRdPanuQW6Lw+OK97BsXYi85kv73j9oICnlFl
	 Ww9mBlyDnsBgSvA1UGScVMl4biglI5doY4bEQO3ZB15bBmSYd1vVTiPuPjpxJg33qU
	 HTcwun3lJghqk8CTXuJ3YuNlunEDLH/uIdrsqqJxVZLmpAtIWKDN6hByKxP1mWIziJ
	 /IqTJtU25EVC9Yt08kzssHn//5lMIjnt6hCpdOOZpXtcWsxkhl36gWxWLR0bfBSLb0
	 AH3mNCIqqrHFA==
Message-ID: <sashiko-outbox-184668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/26] dma-buf: Allow single exporter drivers to avoid
 the match_mapping function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-9-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-9-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:58:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Introduce single_exporter_match into the dma_buf_ops so that single
> exporter drivers can simply set it using a static initializer to use the
> mapping type APIs. Provide a helper macro DMA_BUF_SIMPLE_SGT_EXP_MATCH()
> that generates the initializer for simple drivers that don't use P2P.
>=20
> More complex exporters, especially those with P2P, need to implement the
> match_mapping call back to extract things like their DMA struct device
> from the dma_buf in order to do the P2P calculations.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D8

