Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948581;
	b=I0C+9uPR8sO+5zsaUrpNkf2VMtnALnZlTSbvNDyerFlvbCX++jWorLe/qg+AfDEi9mEF
	 8ZmoVoSakL4IUORYGdJGE8B3ZgDeRaxNJ8XSrqjBd8juE9fTAS0tbO8muewEK4g1UvXib
	 lYvw138RaJagGl6q5G7LaDSqiIx8Qj+gliNShrvflz9aUH3Mj5RQQfGBrK6ttuxtvjenV
	 KjxmPsMFw5vtdXNW/yxrBcgctkGQhJp9jaxhHroN9i2860D6JAEjv+26pNQMFY9065P4c
	 H5TWt5uaeT0CtBJTOv5AFsHVXmhqUmAcU5kztm2h7JRaJkl1kkJU9sCm6jTlURKnUQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948581;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O/BP+yz0dhCCat8G7c06cwLjiq3FdjhEj37h8uCPj8g=;
	b=Iu85QZqfyzskNooZLrBgqYFg6/Su4yLJG9Bw72dGgZhpl5sWw1HSy0whJw2Lz/bxEQ5K
	 GHVVHFjJcD0yc/81oIn5QNCFfc880u98D2p5jO1bU4gMq5HXx6QJjd/rR9eM1qD2mfmCz
	 t82y9zWPPM69AHFUU4jPSf+Cud8E+pYm0we3u5efyzzIBnVHvUf4bGHbkZ+tFvRRjVavV
	 UVfcFNyRgGYArWPfcM+M4eLJdK/9FaL2DyIa8OVqVdRlDX5Bn49UlrEh74hQ+uRlf+jMV
	 JeGjnxLDcyLayBKcXoGMuSIqH2gwW+fstAPRO4ojTMDGYUOyuWthkmTQoCuZCFXoE9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3sS9kTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5618F606A32F
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3sS9kTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63E31F000C5;
	Tue, 17 Nov 2026 20:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948581;
	bh=O/BP+yz0dhCCat8G7c06cwLjiq3FdjhEj37h8uCPj8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3sS9kThSCUuEeDqsx2dl+5EkOrz9dTPiJ6a8GSI2vpDyeVc1SM1TqUdngIZy/lZ9
	 /XvNwBNZA8RRWB09bULmV0MwbOa1DXso/sbRi3ixoeEMNJCLapWwsUvwsIVN9V/tud
	 DgQoAWBEDD6j+ViMMTDU+ykVC6ODbGAD8vbyKaNPYagMdcYiziL0SBB6LblKdO0lY3
	 74z7FFmsaN3ET/m/ZIpNvBjjxIeqoTTbG2Vsgg4HMKzCdMXc/rEFw49jUKG0gvMjSs
	 Jsk6VhtZ0H4/uKNqRty0yjPZPgstnLVQ/WgS1QbQ5/dH/SuIF8IJ84G+L0ZG3LVu/G
	 carutJ3oVK6tw==
Message-ID: <sashiko-outbox-219653@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 6/8] selftests: drv-net: psp: test ipv6 tcp
 socket with extension headers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-7-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-7-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> send on a psp tcp socket in three phases, checking the device's
> tx-packets and what the peer received after each:
>=20
>  1/ no socket options. the data is sent, counted, and received.
>=20
>  2/ an extension header set on the socket. the packets are dropped,
>     tx-packets is unchanged, and nothing reaches the peer. the data
>     stays queued.
>=20
>  3/ option removed. the queued data, then new data, is sent, counted,
>     and received.
>=20
> the test has three variants: a destination options header
> (IPV6_DSTOPTS) and a hop-by-hop options header (IPV6_HOPOPTS), each
> holding one padn option, and a segment routing header (IPV6_RTHDR).
> [ ... ]
>   tcpdump -i <dev> -nn -A 'ip6 and src host <sender> and not tcp'
>=20
> shows them as udp, with the test's payload readable.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D6

