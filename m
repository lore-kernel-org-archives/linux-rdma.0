Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873972;
	b=R5mtkb9lNx39HEmMCUH0v6BlPmp+KxkXfNoGGnh/SB4hkvsaj7JOGA0giDLQqhhjXt91
	 /2Ng7E4bO8tai0FI/ClUyW4YtUNdRANUDYkzsG3mRQzkcLQfFQHhK8p5lxN7RQfhiT6ER
	 +4GwW59w+U9s/WCOf4cb6RJD9OKqiao/Wugkbm0nJFFfSOzr2cu+s7tIvCY6avhsrxy2P
	 MF3MoiVp6sY6RFQhTd9XnCOHhgGEqg3l0tt2sXndzYYRzMCVV9ydzrEZIp/0T/ZXulUa2
	 TBxYWBeQImIzIfesrPuGOPIxszRpGFhLT3zXkW3IqEbZsUE9+7r8cvBx91B72eLxsRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873972;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=piXRLwwlQ2YwnJkQvK6sFGLDTgkz41fUnz6cSk/EtMo=;
	b=JnB3qlbCW4vb3cdT7b/kY6DSmCQGW73r13RYLldNdoEGW6zh+BMwWuBsvcbzFKSj/fpn
	 XlZWCVGd5FJ+0vHt3WyfVb7iRDtiHU4CFVINjWwPJk30S+mAFSV693NBB6e3NPMheyjM5
	 fbkejLS7/IJ/3/VbmI7iBEviBiEptBmgqt32tMxtFANhrD9vEXQu13Fg5coQOYqlvv4LJ
	 MOGmIuuMn+aqb6WNsYAuv9clUEdscn9R9tfqB9Bg/6qEsDC9kRCbb1Hyi3Scr6VYm+0P1
	 jzw7bWEUPPDziGx3deLqJ6mXiytJba6RAq6t+MZVkf3deXdtbNd0Wnfm8peg09mQ5+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnG++yvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C37A606A32E;
	Thu,  5 Nov 2026 10:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnG++yvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180591F00A16;
	Thu,  5 Nov 2026 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873972;
	bh=piXRLwwlQ2YwnJkQvK6sFGLDTgkz41fUnz6cSk/EtMo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RnG++yvOtAs+Sjvq9m/Cfzs0+dKJ+h0/sw0z09afy/h520NrUNUJkvsQ1KtZAnirA
	 kpWpmU5quQfmFeFEiT5OtM/RcNtdq6APeIb4JCPx5fKPkE5uM+EfAXsR5ss93sNGBp
	 E69JIeWDPJctcZ1WTrFWZnF/mH+YGguQJoKATvLbgKPKHJ1wbBFJFFtgwrBD2cySJs
	 qHMj1fGmQrGOjuRvqgoA64LT8ym4S+gWNNORgNnxp3l0xAS4jhs9W2ENA++0Ay5iBb
	 Pp+jXBAh53PIrLcRmJe5F4RgrPdusXiOdjyBwSVJ8F7YIILFqAkClvMTEH3rNvz4+n
	 I+/xtJqyYgQyw==
Message-ID: <sashiko-outbox-198838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 12/19] PCI/P2PDMA: Log detailed ACS routing
 diagnostics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-12-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-12-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:19:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> When P2PDMA rejects a mapping, existing warnings identify only the final
> ACS or host-bridge result. They omit topology, live controls, divergence
> ports, cache state, and intermediate routing decisions.
>=20
> Emit debug-level messages for verbose calculations and cache lookups.
> Report both paths, decoded ACS controls, directional decisions, host
> fallback, and the final mapping. The messages stay silent until enabled,
> and the existing warnings are unchanged.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D12

