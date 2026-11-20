Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138317;
	b=V2ZMnx/u5wliwX3kLw2OEwNp8MhVLdYatw2Yum9BT2ZsyOAXbhKgR5V0GAPm6ZjKjd8W
	 cCPtdPDHv3Crf0BhPV0vh5lGFepi53V7Xk5+U1O+jAYHxV8zTrhHK1y4Mt0Yi99WKbxdd
	 gsRqSAhdiNqaUiqrCIiXXcBexO4STNTgClTyj9yU531NbX/6u8MRZVLh7jmcTF10xNfIA
	 xMI+F+NtXi8axZ9pQmLcV8WdFTLEDNQwJcLcP20UmSQZIzVkhwZELAWD5F5kpNcG1WG/j
	 kvADA7k6GZtoil91+qpUdMuOtSgXB3NwkJdDRGL23Qht6fB0qjvOjqiWqRTeMKIuX7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138317;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jk6nhaxz6gdvq3rZnXt1ATh3YxKvwKJIQKGjXxg780o=;
	b=b2i3kQDXz1VVuZGhEkaMo7ymxDO7O/5bFjdk2FjhLlkUQIAO9GS/nUg7zmOSS9CZJrnp
	 FXnx10KyAS7+SEFsSMvOP0bz5Wnl3jK9bSL1W6PT2ixWm0zRGukf2STaD0KblbJHr4iBE
	 idQmZOcytQaUZqEPnX1o1eA6Z755ZpItLloSih/uYjd+NH+iflZTSOLZWFSKtgoNczM0P
	 U7xNBJlNByiiy1UTaACYqwxbWFtgDJSo+hejzwPDXj+ZNhyp+oj7NaGfhwMFK2Hpjppbv
	 pPEZ0+abbYf26T7Ahg+6w3/hw7eLfkpZnAcu/NZKaU+QWl6gTKKH3J/seJvES0Yx0QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zjxqq53x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82162606A334
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zjxqq53x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352021F000D0;
	Fri, 20 Nov 2026 01:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138317;
	bh=jk6nhaxz6gdvq3rZnXt1ATh3YxKvwKJIQKGjXxg780o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zjxqq53xL1ivHxcxv9vVQyZyLiEqv/WbO6Wpfm1J1jGjXzneKBdXO0mE0c2xJJ5eJ
	 CoIQ+83pCmWH/nbmgw6FkXdxCiaRwhNtpOW69DsRd0h5kDYnjWqcOy8NrseIIuFol4
	 i7ZrixqiCswhGFrSHn7FnHLHz5bu8TfGm4u1wB+7GgndNrZSsh806Ixm4mMmmrY3Uh
	 T/8WHJe4H8JAl7vVUn1fm/t3AwHiBoWyc3AzRXA4kBuvt5Fp25Hy9cWN3Qzr0D1yfg
	 UHnGbFPyipYmP5q3DINH/kQ2W2L9QXI6901NVsV+iX1OMgS9z0TSUL9EGWLVko6h3+
	 WvxCJQj/cR01Q==
Message-ID: <sashiko-outbox-224310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 03/12] psp: declare psp_assoc_set_tx() in
 psp.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-4-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-4-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Socket-less PSP associations will need to install a Tx key the same way
> sockets do.
>=20
> Make psp_assoc_set_tx() non-static, and declare it in net/psp/psp.h.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D3

