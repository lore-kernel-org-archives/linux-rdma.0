Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445023;
	b=p548h60+LkTRszFSZw2DwQTGfOOOhv1sLHrQV/YAz5FEljTC8mp+VONLmWlxYUxMOP83
	 EHsK/FmHoAIdJcqHF2JLX57Npjdqxrd90WQghspQvvGJpqyPijFQPsCetaZbd/Ip+jRLO
	 8PqTKVHIH4vfLN+uV4EArHDdOSCqC45tPL2WjZs5Jl/D1qeX+QwXSrDop1HNkesNHqzwM
	 Q46wwaUGP8tMbOep23OvOPI5kAobjCFFj//g8kJe647rVkr/N0nH21x71eiSQx6EJJAT9
	 4kITOh0j4emK6ljz1/P/IY/TBGQFihC4PbLXl2Ri9Djz4tpnpAjHsUsYFAvtWC6WMcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445023;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oXrBHfLYt6bQEB33iijrydxoOIfBh7HHRAZ3p36hyi8=;
	b=TCevzlU99FI2do2lPc0VUEaWKp0tyMpewNX6xKg9b2abe5WGIdsWcy/aQgrtpLLzrhWS
	 dlvZfOLc+jks+XHXzMMzOQZqUaxXCacuF5O6jIj2pOcWQZ4IL/5blDCf9ZSihnC3NLcF4
	 9lHVP1JCX/7badHoopEd9TbRvlqASCV4mBTwPG7U37KqsivsWc/tpbGGILb/N5H2kz907
	 depWkJ+3K4vsHuk9PX/8DI8RE3YEoq/c/L4OJnrj9ilKKR+YDf+mQKJ1uL5xpPLdpv0PP
	 mNiHIzqrUhknxdQfN41bCegA2dtOhL4WnE71WXFbxrMe6bHiLL0g4tFgGXsB3s8OyBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xf0OU0Zk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61484606A881
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xf0OU0Zk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EFF1F00A0A;
	Thu, 12 Nov 2026 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445023;
	bh=oXrBHfLYt6bQEB33iijrydxoOIfBh7HHRAZ3p36hyi8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xf0OU0Zk0nR3isE6cQSmMRUw8p5UvBf1CEJL60FNVZ0Si/HJzyRjwrMV0V0TAJMhn
	 pgfHLDDRkm19O1DKYItAkJczsLoIXqa9WKa3l8p0xnyRgb5nvils9KBSOG69le1nwC
	 CLgZ1sn2CvEVGa388yulizY9cLq+TwHA9qty97LzHix7O1iAsAI9oEpX4a4y28PWAX
	 ZZYz8JVC1FS5/+mLx3nV5YpogKi+/lolD18Hn8oFgKoWSsCRn7uxKh/JRX+Uu2qztW
	 ZZC3Wrr/Q3rroi4T8Li05MzrO+9CsuzoKEapOAA6+y5Ld7puPSc+AUeIUSrMlYkxwJ
	 R/0yLpnlDMAXQ==
Message-ID: <sashiko-outbox-210009@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 06/15] net/sched: act_mirred: don't send
 decrypted skbs from egress to ingress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-7-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-7-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> on transmit, skb->decrypted means the device must encrypt the packet.
> For example, a packet of a ktls or psp offload socket, or, with the tc
> psp action added later in this series, one which psp encap attached a
> tx association to.
>=20
> on receive, skb->decrypted means the device decrypted the packet.
>=20
> a packet redirected or mirrored from egress to ingress is by definition
> not going to the device that would encrypt it, and on ingress
> skb->decrypted now (incorrectly, for this packet) indicates it was
> decrypted by the device.
>=20
> this is less of a problem with socket offloads, whose packets are by
> definition originated locally; more of a problem with socket-less psp,
> which can also apply to forwarded traffic.
>=20
> mirred also drops the dst, which for socket-less psp carries the tx
> association. clearing the bit instead would let the packet be forwarded
> in clear text, so that wouldn't work.
>=20
> don't send decrypted skbs from egress to ingress: a redirected one is
> dropped, a mirrored one isn't copied.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D6

