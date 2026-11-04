Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810635;
	b=aJfHdGx7b9lMLcwKZ6OmS5dRLf+U1zRGZE1WIA5KGi/7vAKID6HvEzxNMnFQbbc5tzyc
	 4ZxLLBx9AyCGqbYKW/6doHrLz6R0KI/9JRjyxeKUhvGStBL/EPDnbBLyH4q+viSjYGbuY
	 xvj6FQ83qB7ztb0hlJKImYihoDeXHbuHGW83xWRAYzJ4K++PhflZ5p3epfc7Ys0JMySYL
	 KLLI/f+Og8fowYYRuxLDM4L2H9EzvSVegV9ao5uwQ0b7H8q60/Op2zI6mnqEfQQgQC7NK
	 Ie7EH2HNzPzymLi+gQGdLOCdqIbn4TR1XiSn++gzgoi7Ow1lr6AJoLQGYWrnslLw+5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810635;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aQ04UU0WdvIRQ5jHpwG9gu8oPw2FlhE+rTStVoHxutU=;
	b=GffSgW6LfSoTy7g/whpx25n/aa0tpX3hRncJyDaXA5L7u+JMODoPImZpRw3s/+SBBR7X
	 vnbyodMVSke9sdZ7pUGpgc3z15hopKWeQ0uuzLRFQcWr/bksZzNLRs/OfexEZajcHa8xw
	 juHoewnV5NuRkytX5qMNHakpyPPwxxMQJ1DbqyhXQzMImDra6bq2Q8V81/Py+nHqCCuy1
	 4XX9J3QP81QXjvk1NkQWOjcS2AbWpY7QQkHHV7r34R01ApJnU+0ghYsEGtz4gL6OSPPg+
	 RNmalXm0OUDrKN7zv7M6/H73D6M9L4nWSwH3V98JK5yMBPOcoN0HVyzo0hyu48BEJbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WzbBFSJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35281606D803
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WzbBFSJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07871F000C1;
	Wed,  4 Nov 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810635;
	bh=aQ04UU0WdvIRQ5jHpwG9gu8oPw2FlhE+rTStVoHxutU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WzbBFSJf2bSbISEzr2CSMlCJM//fr0kglM6WHrjqpN7Q2D9RpMq7cEt8CAb6G+mRd
	 P2pq+/zEgmDhFq/eT0D5R1Qx+Vxn0lEv1dW2bOw3kW6tY1z4LdQrGQNc9t2PxTo1FT
	 /izy8rzwPWri1gYQK67sOZu8ute1r6kLYiUdEEmb2mfTzeIbLPik7ZDm+nOPN6XCUM
	 6UtWHl7pAcY5eBgjBdlKlLM6UgRmMhLRc6w8FbeqdC6DU7ZvtX+8TKz+671cGh0qdX
	 2LremxqGdujIzagGL1+XS0i1YuYDjj88R4mnDIWOCvIitUOcpRWohNbHOevIaMfk9r
	 yli/NGdPg9H7w==
Message-ID: <sashiko-outbox-197676@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 23/23] RDMA/mlx5: Advertise adversarial mode
 via ib_device::adversarial_mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-24-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-24-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Set ib_device::adversarial_mode during capability init so that the
> uverbs core layer can report adversarial mode to rdma-core and enforce
> that only adversarial-mode-aware userspace opens a context on this
> device.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D23

