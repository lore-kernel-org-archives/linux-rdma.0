Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138318;
	b=LRRKsXXaO1a6h7K7LBqoPTGxBFSyMTUf2fUZeNp6BQ9eTiJYTfRA4WssIaZQRV/fe/m1
	 AC6HYAP8Coon3oE0AbVxC9lhyHqJZ/U4y9Rr7E7/SMn0GpNaR0/FCGTRQ3ccx1pR7Ot/x
	 1IB1z3mJWVvKr3i2iQfsU/s01hzbatRqWuPOzQoMo8LlBQnnvz4pzxqq3I9jigJfLKftW
	 HUUC7k6pu3AWTwflKW2mFToH+NHJual9pdOoaWgeRe+JvwIE3/bM2XeRePIwtCX0DEenp
	 OCAnEj8AHBfcdgzTe4ReWkHub3l6CqBCMw6yFE5Ke4I39s4phPtkhOGFzTm3dFKwDyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138318;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TpEioTKCLPMQ38HNZfg4Rn41Mwd1dWuj6TARJD6xetE=;
	b=zsZ8mrEUmLX9EDlFFQWcUKOeCaJif9+sgNzvgZ1FFX+DdSCUhJp/1sMr9raNfJfV0R8+
	 zwXHs6Tbfe7tiyGxkfeDUvLfil+l1dn4dMjkb8dYmpkwx+Y3hJW7PejK2kSQoKMyUadpD
	 OQtN5mWfWG3yDMxDiPR6I6FLVHlbj1a1j1ujpBDE5rfPyJyrtlSG4TcbzCTCyDsGftHk7
	 nH/fgr8sKAotmK5xznfuyyKQ2LGvgSR2ypd8sHDTtAFvivQGdNSWkzdwDT04As97Zg8sS
	 5Hiitf75xWiyGfOaC4rhupwF/LVW/FCBOsFe09R30v2OFQJpDuMn48a1tQug5fbvz0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9w9VSIm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22563606A338
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9w9VSIm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D627D1F000C6;
	Fri, 20 Nov 2026 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138318;
	bh=TpEioTKCLPMQ38HNZfg4Rn41Mwd1dWuj6TARJD6xetE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a9w9VSImnt+3ht7C6QCl37lZBok1JfVKN1EX6nMvCA9/Dej/etx3CVHuAn9LAV4rV
	 Yenz+gENSCtu1Ew/RaHjqVygdlyqOKI7eFjSyZsH1WqgB2dHAUDUROol5p7ZybdhlG
	 mNv0eHidn5A+85oyup75ORS8m3FaKTyqR8e/wYFuYiFziPjrB+4zZVAAbeDbuOvx39
	 /d5/7BYAcUDF04VcoQPfE/YAg5v9aFOI7a1G7bWeQ4qV6JUobQR2ex2XORh9DqPZ0a
	 5LTR2kIWVKVj1hPz/Q6m9bHbgB7tg/m16PqcUt0KWAgY5c/BY2jf2bEB5rNxhZVYoT
	 WMYKtgCd4ZrCQ==
Message-ID: <sashiko-outbox-224311@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 04/12] psp: add support for socket-less psp
 associations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-5-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-5-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] psp: missing kernel-doc entry for sockless_assocs in struct
  psp_dev
--

commit c762835dd18f3e2173c0b94d65dae1e6c0d9077f
Author: Todd Freed <toddfreed@meta.com>

psp: add support for socket-less psp associations

This commit adds netlink commands and an ID-based registry to support
socket-less PSP Tx associations and Rx SPI allocations.

> diff --git a/include/net/psp/types.h b/include/net/psp/types.h
> index b8905efbd604e..be383f8e65d07 100644
> --- a/include/net/psp/types.h
> +++ b/include/net/psp/types.h
> @@ -107,6 +107,7 @@ struct psp_dev {
>  	struct list_head active_assocs;
>  	struct list_head prev_assocs;
>  	struct list_head stale_assocs;
> +	struct list_head sockless_assocs;

[Severity: Low]
struct psp_dev has a kernel-doc comment describing its members, so adding
sockless_assocs without a corresponding @sockless_assocs entry will trigger
a kernel-doc warning under W=3D1 builds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D4
