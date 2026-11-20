Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138320;
	b=d/wMQ0fpSeGTiTk7UYtjJqmDVeqXOZEqxTkbNph+FY9eQ/pigOcmbgco7C0yaj4JgHz7
	 J3V+0vLfRZBDIoe0oceyU4J7BerFG+RZQ+3bh/L1IvBble6gDPF4zvkHrvnME6ycQRHlT
	 riGMkeqwubUE680ZLG1B4/QAchuso7yPb78ZIDq0FjBXqArBn/PT/gpRQGlhtnpY+S8dv
	 bNu25CIQdk2vMN42coT1RNr4HvfKztb5NOc6ArlEqlrRw+fXQF7Oyhz7UaJITVE1uVXOS
	 ODk8fo1oSccstVHXFwHhY+mZbNK/bnn/fdv/M4L/iBA3dTuB3gt+Eg1Eni4E1d/BsSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138320;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GyUFCYK0LrY3WwQLSI1PrM//Qah+F39j0NR7hr44dJY=;
	b=o6I4Skr+Z27WJO2PQgrzKReEQB4IN6CctOMlqWclyyAObc/ZaXDTrXczFbf6qbuIH/YD
	 x7jw7Bq/K62cttRSAQdHJIb+AV/K485jRGO9uRyeNCC7XtJvihbMUblw3++6+8ULJ0GyE
	 qP/A2s9C022wr9+u/xRItGff3+ksyO87Og5j1wscGZl13d+Ul6VvGZOfjvGtqycdfpSKM
	 FkuucVWsQfxzatuaV3ZFY1wWOHpR8nBOpp1/9TpL7gcwY+ty7qapIOCCwGSPhaedQPtSU
	 t/n86S+eWWnDgiqJpJv2hJfLRWHu0jpBDMO/YOLm40ceXb/oC6RuHvJZuLjKAq4T5QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cibW3z8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F5C606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cibW3z8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8551A1F000C4;
	Fri, 20 Nov 2026 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138320;
	bh=GyUFCYK0LrY3WwQLSI1PrM//Qah+F39j0NR7hr44dJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cibW3z8Cj4RAx/ks7Jt7C3p/mcUFP9nxZllKFrJqU/02z0KriJxBlLbNKBIdpj7i1
	 vh0bTHl8eQVpJmZvQ6LnpWEJPkARGx7fEtc8BuPgFXqUlmyfQ+yVOEJ4T/ixsoQcHr
	 P6s4NP9BOIaBMZegdBd1/fJ1OxytbB6Rg+TLrg5LYRHuzIMrx4HfwWNHk4Ks1b0kQo
	 P2Kg9SHh4U+wQTbl9kmctCNUswt/Gnas2S70FG5uEjmsuhDJFjmGO+3ADBKOfd0VOd
	 6YHZDjP09GAdRLJXMdfh/3pENCKZaQuzdDd+H3YDnAECvRSWMv+p3qOGSlA//9mcHG
	 UsslVx+tzYlYA==
Message-ID: <sashiko-outbox-224315@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 08/12] selftests: drv-net: psp: test
 socket-less associations and the tc psp action
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-9-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-9-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:32:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Cover the socket-less PSP commands and the tc psp action.
>=20
> The data path tests connect a plain local TCP socket to a PSP socket of
> the responder, and give the local side PSP with tc and socket-less PSP:
> on ingress, flower psp_spi, psp_ver and psp_dev match what was decrypted
> with the local Rx SPI, and psp decap removes its PSP state; on egress,
> psp encap attaches the Tx association to the socket's packets, which
> the device encrypts.
>=20
> Test cases:
>=20
>   assoc_sockless_basic     rx-spi-alloc, and assoc-add / get / dump / del
>                            of a Tx association, only the SPI is ever
>                            reported
>   assoc_sockless_rotations rx-spi-alloc reports the key rotations, Tx
> [ ... ]
> Note that the tc tests require a newer tc, which has support for the psp
> action and the flower psp matches. If tc is missing that support, the tc
> tests skip.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D8

