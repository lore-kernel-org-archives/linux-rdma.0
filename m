Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948580;
	b=GGtv4AP5kw3VNA2oxL+aVJhGVSZnH3BTjLYscQUz5Kq1ibPhI/DzM5K2GDYqHYx04qhc
	 Ch7OlinD6+fecRuQnq9d5csZD6y7P6hjVL+AJCKFRH1RFPhCIdJW34aLqNoAuYtGGZJE3
	 aiAHUhC/hO611WcvUKUp9N2HfGUI0rC7DVm3p/q1bbk/rKMQh3Ubf2x8rW8tTZNgUHNPb
	 wgxGUWrpsGYlzcELiwrX7Y7ueUE9Luk65cr5g6YCPV5HdCOSENHzKOMFg/PcFdeC4EbjN
	 /SxVEKnNey3i3B18u4803yYAEgEYHIRMouMT1CYQ02HmDVg5cYi6eQ/EhzwhxFc2Aqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948580;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZokjEEJU4CFdQBDfhHCPXZksCWOPUXTy6mSLT/IaKL4=;
	b=kc6OsqQx6yifxkzRaVnD0DprTHd9mTJw7iHP1dvRuev0rc9jD42qDaT6vz1iZc7+xcKP
	 Gqh5gYXBHAcR9gn//igki1OXV/3AD9BE26+ouIrZMZR149mt7/kjtkkTcgYevVjLXfoKr
	 YTYbrbMLV1DMvUeW5yd+fBNaraEhKKy6uuMXTgAG5Zte7Iyk/i4xwq5qqw3Bd6B16wSbK
	 J9bdIIrXAlCIwf3LQnNm21H2iOIP3DRawOTeQ/p+wAbj+n8CAprzan0yYL3Cf/W2QaQTL
	 H5BoCgLnfLbHvB8I/QirWUZINWWdJ9gOkyByKNEIBiOVvIqtx0Stl5hYy/6/9o6ZEkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGLzLS8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83248606A32F
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGLzLS8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC881F000C4;
	Tue, 17 Nov 2026 20:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948580;
	bh=ZokjEEJU4CFdQBDfhHCPXZksCWOPUXTy6mSLT/IaKL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nGLzLS8pv0x4n3rnpUQwPzc2HDBkeT58xTuLXIMTxh3rujdZuBDbwBXJAaSJF0HV1
	 64wfvd7ljMl0BY8spqUBciMDwNHVYfBBXnA7IhLe/BAGyjmqcpwm216meEpyZTwWSX
	 VSYeqZC0C9mJ2s63RQnPrE65uT+8I7kaLzkK/ZmujA4R+tf41CdrzQNspfDIe/SPAL
	 vqMstKjkLTOo8ws0iROj9/9dEgu/Q5z964//1MrqMUOQKtkfXZoU/qd0WWzJTXyTv0
	 FWEAMJ+Pn5mXjsBrvamMgE2UEL62DdN8NXr0t4Np90BC+h73S7Y8vGrqLEJdUT1Hmh
	 IAqcAS/tQO+eQ==
Message-ID: <sashiko-outbox-219652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 5/8] ipv6: icmpv6: don't quote decrypted payload
 in icmpv6 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-6-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-6-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> an icmpv6 error quotes as much of the invoking packet as fits in the
> minimum ipv6 mtu. if the device had decrypted the packet (as indicated
> by skb->decrypted) then the icmpv6 error is sending part of it back out
> onto the network in cleartext.
>=20
> as in the previous patch for icmp, don't send an error about a received
> decrypted skb at all: psp also encrypts the l4 header, and telling it
> apart from ktls rx device offload would rely on SKB_EXT_PSP not being
> lost on the way. linux receivers would drop an error whose quote stops
> before the l4 header anyway (icmpv6_notify()). this covers ip6tables
> REJECT and nft reject in the ip6 and inet families; the netdev and
> bridge families are left to the nf-next patch, as for icmp.
>=20
> on tx, skb->decrypted is also set. an error about a locally originated
> skb (skb_iif is 0) is sent in full as before, if its route goes to a
> local address (RTF_LOCAL), like RTCF_LOCAL in the previous patch.
>=20
> an error about a received decrypted skb is dropped before the rate
> limit, so that it doesn't use up the peer's and the global icmpv6
> credit. the check of a locally originated skb needs the route of the
> error, which is looked up after the rate limit.
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/2026102323464=
0.1459291-1-toddfreed%40meta.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Suggested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> Fixes: 784abe24c903 ("net: Add decrypted field to skb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D5

