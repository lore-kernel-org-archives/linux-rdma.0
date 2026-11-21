Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220592;
	b=Jfyz2pH2M1LAbW9phzhbGNooHMP3zHhcDb0OoDSFGR7Lz+XCsoImF48v90gjTs+QN/W6
	 Q9STHP9gmyzzNJkcu2a8oxDmK3SyMyh87d4781EC7PrFmjm/T99H8hLoBjq5kU1B47xw0
	 h+7XcA/HdO8WaOCHBMue/o7Lds47Up8RXHPruMWjJVu6ngzDPs08cJSvQMx7uc/i6ah00
	 jUGUDiyJvQa7eXoE8pj36fd4UDVhHt1t36ExwKV7pI0zqy7Z6hgu6gJN42xVep+gdnA7F
	 m8s8bjPN11Q3JOXiQtkaRgZWlv7spk4j4XFxZPHRrntzEhpDFu3UcdgiFqsYvS5XLQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220592;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u0Nny/WYUYwYLpcGQV/jYZ9MZ3mO4eRtGvYwDHBEtl4=;
	b=ybyDin3pEGUXkMv8iRnuYPMrMqMDXxh7jNKv2WIftGrMPodHIcHDoPvCZh84QfRRk/Rv
	 U94RuNbNSsNf4SfVGAEgF7wCivuHxhLMGb6eexlQZ5ysgiZjKfcFOM6sMa4wnHr9ajaN5
	 YTX2ajqzHUh8ZpUz8RI40P65SRXOBf6Z0P205+6Z7zOdJfut73jq/JtaFnjJai9lMfcNr
	 BAEPCJaOvvvYOolsidFj2TrDgTLtdgwG9xJyLRLEtX5Rxq42SWpWbE7IMika/9QoLeonR
	 0IksfyDkcXDe2tXw1vtEQHzdiJ+4WkyLUcvuE2pd9etq5oMbZpIHdkuyzD7jAIh48/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YthImK15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CBD606A687
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YthImK15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7650C1F000C4;
	Sat, 21 Nov 2026 00:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220591;
	bh=u0Nny/WYUYwYLpcGQV/jYZ9MZ3mO4eRtGvYwDHBEtl4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YthImK157wHAvcARPH03ad/f/Tfq3KRsGiQ54Fsh829Dma/pSCKpzFmlGeI+BxRdz
	 cuP6Ny1t4/CHKrIS6ihGY8WB7V3mPnBL+6/xKUGSr5qXODzTP9wlKMkzaaAw61sEsW
	 WYmyeCdzOe1b8mSUnI+2rcX9AF6k0xLrBSgamGJR9c81yzW0gIKBvlaf103r5QPusS
	 4C5mhCXinBf4V14egB71uStkq4cK06DKwoXLtiOWXqVEbSvAjn2vQRsw/xfLfIlmPy
	 SB4FzFS1VUWx9HAwr727Mv62oo6K3+eyPH7Ih3IY69yCIsjmBkRdv5DaZuG545Erqo
	 KHW4wqKWXeBgw==
Message-ID: <sashiko-outbox-226399@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net: mlx4_en: report the actual RX classification
 rule count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artemii Mashanov" <ralerrdirsardx@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
References: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 00:23:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx4_en_get_rxnfc() treats the input rule_cnt as the number of
> rules it needs to find for ETHTOOL_GRXCLSRLALL.
>=20
> With room for four locations and only one rule installed, the
> ioctl succeeds with rule_cnt still set to four and three extra
> zero entries. When the buffer has too few slots, the ioctl
> succeeds with an incomplete list.
>=20
> Bound the scan by the rule table size, skip empty slots and
> propagate unexpected lookup errors. Return -EMSGSIZE when the next
> rule cannot fit and set rule_cnt to the number of copied locations
> on success.
>=20
> The source-extracted ASan/UBSan regression tests passed.
>=20
> Fixes: 820672812f82 ("net/mlx4_en: Manage flow steering rules with ethtoo=
l")
> Signed-off-by: Artemii Mashanov <ralerrdirsardx@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121001414.7242=
36-1-ralerrdirsardx@gmail.com?part=3D1
