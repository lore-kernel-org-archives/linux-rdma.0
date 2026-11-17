Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948578;
	b=BKxQPuire6e+eNQv79eB2NnYR+jena7s2KIcoGQPavvffGZTm0AqUcq5CmO6HhKr23zd
	 2XqNlBNXH4WjZ9X0ohz1LZ1H750BhA++FHF1DsIcdDpSUXwRtuJZflE9MAtGzHuZ6GMVW
	 Hy1jHusTUZmeE7PRFcGg0nGURfwhx2864FJBHQYjulfM5DlrKqoKx6l/5E8i/08f+U3y9
	 gU3F9m07jBwiS6/UUrLN+02Znydghh4Rrh4ZhXFllF4Y3kunc8Tda+mLivb0RqPTgGLCm
	 tQveUzx4KpgkdCt86CzldzmWswVwc7bOjj63qn18gmXnYdyR3P1pkWJy3vKoDHGttow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948578;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5qNCnboOJLA5VHA3WxyR9JI9SfkHfGMz4prC+TQUGgc=;
	b=dVA4Erza2tcVOjO/78X0SLjlrGijKVbhUhAvHyPaX6K8s2W2cyq2V++z8+rrecTWXn+L
	 sDmfZOoEh0bCxmb8KqRw2oOq3joDP7nNx44HXqXw8/nTThib5PCGeWKInDwz/IPd0UCvK
	 0HV3ZmboN8aUZe+tFeRSXjKjx3TQ6uN7YsViCnc2S8pAbBztQ40198fWv87kUlCx8/W3c
	 dFGZJrkYiAtDu+50ao4Zt6IDHSKdC0YZlh1TRg/cLFZBnwWFBBO3ilBVOhqftF5kXUrrO
	 PN0+d4lh/+y6J8ApOb5ykfJ/wGLISk0fyyPKEG/zT/o7dIGIjiWAYV31+FpBn7lwf5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXSeDJIF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ACE606A32F
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXSeDJIF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C401F000C5;
	Tue, 17 Nov 2026 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948578;
	bh=5qNCnboOJLA5VHA3WxyR9JI9SfkHfGMz4prC+TQUGgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XXSeDJIFrou3VaaTfby0PwMWTtXsPVAC7nKiO9A6FM7jX6JcpJ/Pdtnk+uCjy5ABZ
	 19ESuS+JMHqDgwA2e6cIi2sJ77KHewCDRMMRLx411TT2jfi6Pb2x/yeu+883fENR/o
	 xUEui3RhET6cje6arn+b9A2WWBuhatdF4jnzBEuMYgiO7+z/1Xq7HNz2Nk3Uj+WcnY
	 fq4JlQ8irNR9sjD+mY1heAQLugyuRe6OlZUdnb2hOyYOyF8HQrbcFeeUq3w8qQUR9P
	 1fm0qwWlT6pZY88uEEVR3cL0NugBi3JFwr9QkRmrb16wJpAtC5Hj+OU7hqrpyqQSts
	 LxXBpAYflOFLQ==
Message-ID: <sashiko-outbox-219649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 2/8] psp: don't encapsulate ipv6 packets with
 extension headers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-3-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-3-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> psp_dev_encapsulate() inserts the udp+psp headers at the transport
> header, rewrites the protocol of the fixed ip header to udp, and writes
> tcp as the psp next header. so tcp must directly follow the fixed
> header.
>=20
> if the packet is an ipv6 packet with extension headers, udp+psp is
> placed after them, but the next header indicating the l4 protocol is on
> the last extension header in the chain, not in the fixed header.
> therefore this produces a malformed packet.
>=20
> in addition to being malformed, with mlx5 this kind of packet goes out
> unencrypted. since the tx association encodes intent to send encrypted
> packets, drop such packets instead.
>=20
> a psp tcp socket emits such packets if certain socket options are set on
> it (e.g. IPV6_DSTOPTS). refusing the combination of such socket options
> with psp association would be helpful but is not implemented here. since
> extension headers can also come from a route the datapath check is
> needed anyway.
>=20
> the check also covers ipv4: the l4 protocol must be tcp, and the
> transport header must follow the ip header and its options. packets of
> a psp tcp socket always pass it.
>=20
> Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D2

