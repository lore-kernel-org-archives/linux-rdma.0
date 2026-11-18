Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001800;
	b=rHbNRDBv7sbceFTRL0W6+o1D5qU/Kz2Y6cWvOM8zw3av8Ihx8A3+G/uZjulUnTUoIPjZ
	 pLaPvdYpmN0gAs2ULPwnRZWN4koTteGrvtSPLPqlzB2xNisRBCeBHm2tZa7I86Nvizkav
	 8YzSZHe8tb3AU9wptKBY9u2dkfbMV1JnI7wgNzB81bDdt7A9vzP/NviJti+JKzgMc9BDk
	 CPVoPRLHTpsgKsxnYo9ZTjY9ZeReuZCCYkNllmbYHJwaP4CYGpE7bpgaD549WZZXszQgh
	 mY8HFXkQbqJ6Qn9UWslS6hkRMAx+ttGIq7dkZznrXldkw4uvr75nUKmZPlAI0FlOHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ocQ3Q7kiTE/f1ihhvbgDXKEAZ8tOr92oDaEBxOt3Dic=;
	b=riW5q2793xwTxrBAtbDiAlx5iAFFnqMEAu/TXQSmQ9QMbmO77YXHHGA4GOQevcL4d3cL
	 Lip0+5Fa90PnoHi/bL2vWw1pe1kAgcs7KbzoVmognnYpZHzmRySWx4EdtC9tM8ukaJxFb
	 J/HpWth78eK5j4tVdCRN2UWlSN8xH8lwQAYBg8tZnGHTniJef2GEPZMgOPj6M90kELfXe
	 iQSVQgGSzYYNgWv1pl4+TixwvTPnsllqViN+gYFsPXJtsMrby7iZKPN80ypcquEFiK5+t
	 PVhltvCfRiPAyJlqF9LQixA+OeZoHWUXC3hKsUabIzr1LG+s+ph6JlIBXaUIqsmxHnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O57sDw0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10719606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O57sDw0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38231F000CF;
	Wed, 18 Nov 2026 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001799;
	bh=ocQ3Q7kiTE/f1ihhvbgDXKEAZ8tOr92oDaEBxOt3Dic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O57sDw0eZk+SKLqczO1VgzPWvVcCBVpafdP0SJZEx/IW37IzXeZ0sMjJkJV6+YvOt
	 08Qp7DEwLO50GkX49nAOt3dmT1aMlPVZtA1PgzBVw3/kzWynRQdaX08OGbHWKV7ada
	 lcP/raMVe+G8IJEKzZ44n+NfQ/BwC8poXTFy/N8TUBox1vzaPlJAp89iQ+nr0lZjaP
	 rVfcOYKG2+a7s002FHBA4d6gDP4MQqV9dNSFPtbb+yPXJHD4Lzg8DYwDatnktVBLqa
	 QR2dW/S77rLR48dZajtKcsnG/I67AR/cSA0gtqapLvV6ho9qoFVXf8kmDisQZG5Yh6
	 E3pNP0vbHuRvQ==
Message-ID: <sashiko-outbox-220830@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC 1/4] nvme: move dma-buf I/O context handling to nvme-core
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anuj Gupta" <anuj20.g@samsung.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118103327.1788667-2-anuj20.g@samsung.com>
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
 <CGME20261118103450epcas5p1163c0878f3f2da3357146301143047a0@epcas5p1.samsung.com>
 <20261118103327.1788667-2-anuj20.g@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:36:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Nitesh Shetty <nj.shetty@samsung.com>
>=20
> The dma-buf I/O context handling in pci-dmabuf.c is not specific to
> PCI. Move it to nvme-core so it can be shared by other transports.
>=20
> Keep the PCI-specific PRP and SGL construction in pci.c.
>=20
> No functional change.
>=20
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118103327.1788=
667-1-anuj20.g@samsung.com?part=3D1

