Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712359;
	b=jMoGX5TEajd5lJ1xc1nNrcSHkJUR6nbNHo81zV9Kwew1LV0Qf6Z0wYXYtPHTGj/6I+TY
	 M6qmzuQtJ0Y0vkskYF0mQaBS8l6IYEnMD/ypF7qszhTSdIbVo0yQGKtw14yA1d92frVQg
	 OtY5uFWKwkv5BKwIIWP0iGM9fG98S899HR9ly2df+DygjHVKFlQEA7WEI8BwulJumKuIp
	 EspZKuc8pvqH3+JkpeYKOu4B2776bYsdaomNRLEzTznokiAi4Sk3QW9rdqNVCdGHddweU
	 SEQzucRK1hhaHtxE0hEbdU5ZrOKR0/ypsaev1YuXEIgV0tRddwHvX2FbZ/64O2Sw66g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712359;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rlb8XKAG/M38r62+aakmQz5BuJLw4GtMoMIqt140Ehw=;
	b=p+X0DcXR3xhTHDqFc87TMcILOlBESf11UoEBq54jMODY2KKgxfrQm8RXLAzCtZoKm9oc
	 7L7fpe5RKYjcvEArslD/A1sCB17hfQb8Nju7oGX4qVGwvH37M/6zoEkJxf0fzyRHZQRhz
	 rDMzK2FLp6ge3kKP7ntGxA5H9Hb1OFEdCD+dYXg5jZR3R9VB9FsI91T3QggMU5aJ7FolL
	 XbQCcDr3EEiJISAoPwXnSlaQ1rYBiwgw18WuI+1hG6rMEiAxbUMuH4K8/JVUZlc2U0Rhu
	 QtS5WMLpkuWXVD+V1RepiK2k0p3kTCUOb7Tvm47XXGG/NT12EDom7KAxyKxyJzapZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GD/p2/X1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686C8606A328
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GD/p2/X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DD01F00919;
	Tue,  3 Nov 2026 13:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712359;
	bh=rlb8XKAG/M38r62+aakmQz5BuJLw4GtMoMIqt140Ehw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GD/p2/X1vEZnFtUX1VZ0nEBwj+ly0Q5/iZkEbRgSZJwwKw2nFOruNhO7GldbtkNO/
	 IVjCanYyuNDd6a3k99/2CYL4Ii/IFHBKjezBzleTuc8q+/qbAElggj81y2vMeSebS0
	 dyFsad+pyQV/7AmgD2+LZCgYf0PbbKMNVIj2LNdjN/TNPX2daet+Bz24XWW6PCcRQP
	 n/MEC8LquEFj0pyrMa458gjwRDy/lVL/konyBCCqYYmcWttzsjPG7oEGUzyb/HUs+f
	 V33/sv2X+jGYW+g9XNPDD38IPnplfQCtZZce8xnbZa/vpArW2w93HVFFS1EsgzO6j5
	 pEfJHR5twhFXQ==
Message-ID: <sashiko-outbox-195337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 5/7] RDMA/zrdma: Implement device and port query
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-6-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-6-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:25:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add implementation for querying device attributes, port attributes,
> PKey, and link layer information. Also include firmware version string
> retrieval.
>=20
> The device attributes report the limits of the hardware, the vendor id
> and the firmware version, which is taken from the driver info of the
> network device. The port attributes report the state and the speed of
> the port, which is taken from the network device on every query. The
> immutable port information describes the RoCE encapsulation of the
> port.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D5

