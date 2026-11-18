Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022031;
	b=uuaC0iqU52134ky2ZUrxJuWV6TnaYCG/TBFAxlIOHuvOCXbX4gpYLGBNrFk838LVTINh
	 whcPpLn6jVAcC+RcCFcJ0x2Dc+YI0pP2pRLQcnvQEv6JLrVfFxkR2J9CSCWrvhccUoc0m
	 KHhsQPFbFBfgG09kuKCmBg9MrxaVKDfeG5YU1KfK+c1cFvGz3Rp0T+hvJi7lWtpx6LYLE
	 /QXd660ncJRH4yC3LGrOiBGV33CWYYsg6QcbcfmDhTOFHRn04RTXCGE6UFdKxepRETVon
	 ZR8pho5tFJ49NuChj3varOj75kMpu6QalZpmtjGoRYlgs8svhEwzLPrw0j2TWRoGFPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022031;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tcqQRZYz9FTQBiTTcGa2vYq2WoUOYlB9x2s8f+rEQu8=;
	b=Iu1mV6cxmhDykXEu9GWWNTXwUC4XPxPsNknuIwBRfXLZR9RJFR/zuEPaKewT3sSozI3Y
	 rV9LtL1jQguSz/DXZmJuSvMwYkQ0S7m4h92b12y+p87CYKUcBigxSuVB0JUKOsREYhNCE
	 jrT64vdVJ1HXH3+BH8479UvQcUeV94JaTI0K/J085CUwdDwlRWsR4naICAPZoNpM7yVNU
	 BlQKOeyoZdYp6wccir6036fxhOeQAb/gp7eCdIj/fjbGof4t3yDtfUHMsSGO3HtkdsjMI
	 81Cjv7xqAwB3rp0FLVdDXkHZ04oISy9ZaHkVkGABzqd3kymUZKAwLgPHqedl4ON11zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikH+P2oj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCBE606A330
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ikH+P2oj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355A21F000C7;
	Wed, 18 Nov 2026 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022031;
	bh=tcqQRZYz9FTQBiTTcGa2vYq2WoUOYlB9x2s8f+rEQu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ikH+P2ojGvcvcIzycFhw7W93I2wny76Pc+ZARcEQJWaQ99RcPDosIqEhyG4RjaYIh
	 U+LYedSsmO+gih2yweiUC4KQuofHDxG+gBnz5XNtoDNFp6fbDBhh1mAiBGxH9N9Cxu
	 YyQws0zUB4Py8h3emlgoc7imlJs6KkXm2ERTsztUM5bdconurXNzUBOBLHaKfdMe5F
	 xwsj6C7wJHZEny/n8d2aMTHvJunIMe3GRbTU4sKWORXnk1uOtkQ4P0P3f4WfLGfFSv
	 YdqF634+YW25HncUBede22olGS2VHSpTKdiqHyLi4uOKFI4oeKkpGKtRzUJc4vpojn
	 EFc0klPRP4nTw==
Message-ID: <sashiko-outbox-221617@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 16/21] RDMA/mlx5: Validate EQE port and GSI
 port before indexing devr.ports[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-17-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-17-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> devr.ports[] has 2 entries, but it is indexed by port numbers taken
> from the NIC, which adversarial mode does not trust.
>=20
> handle_port_change() uses the EQE port before any validation, so port 0
> wraps the index to UINT_MAX and a port above 2 overflows the array.
> mlx5_ib_create_gsi() gets a port already checked against phys_port_cnt,
> but that comes from the num_ports and num_vhca_ports FW caps, which may
> report more than 2 ports.
>=20
> Validate the port and bound it by ARRAY_SIZE() in both paths.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D16

