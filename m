Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799747;
	b=KPgHXwFBLVpDPTBJUAHJeGkZCw9JsY8NVW2mhH6CNc3ZIUjVl1/GW4EyU6IU0yY2vuDi
	 nX0G6QhF+IQnYWMOUjC+5ZJbdXcO9WjGOqQPbc0OYAY5zmcLUcayFKJMHw89DpbwzpSwi
	 FZtCQ9x80VPqOH/iJMW/bzBAbjaBNoCosrgDy6sCvk9Vk6bi/3QgtyOSmggwJ8zHYZD+R
	 Kgpk4wdCsgIL2uINu16tQ0MDqD4s1HtsGBfdbinUPEQfhgEjMmhpp4D99pqPs+a6XXQQo
	 suMJXZdyZUzZAQAFFWqfmNa8bfje06T0SUv9QHBqGLjKPCSXA0S6cpkKU1XLf42Cs+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wSZZtyh7t0U0uX5zfdMGAc2GKTTtKQzvW6JzK+wtn+8=;
	b=aR9mgHfb5+3RqYYJVeVKWDvyBAU81vZ9CAOiw6bRcA+rFEG4HAoPTYbDx7n+NLfXrxB7
	 ATA8hjX9s0XTSktqjZRm+oz5UwATRupUoYPtU4MQlw28AVnxqrsT0bQ8Pcoy+e+6HuTgG
	 HssfWyUQMkOzWKib+VHIekqgA9UOauAKULqDlN0ctbhpNqDCvOmVDEyfLUrDzv5rNKTMQ
	 xqAVnOSL5MrblTETCQ1LjI8u65D9Ytq8booKJghb/mzqMRcTli93b2XI8BmuwOpGDVcuu
	 0RkoryznBrJGvMc89FmPQUsPD0mnsIJ4PGHw6xldV/gaKLnUoQ78WPi5WU8tpxle1eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLywMNse;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3E8606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLywMNse
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3E91F01829;
	Fri, 23 Oct 2026 23:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792799747;
	bh=wSZZtyh7t0U0uX5zfdMGAc2GKTTtKQzvW6JzK+wtn+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OLywMNseP7gIQQlBACKeXhHgtXv3QaPKdTMI0vcY3CM29efVi1/uiJZlCEb+UAsq7
	 yzdF+EWnmeA6XwqztYjyYlt6GQ0Lvn5B07Qb678J8FZNWOUtEEBDJ7b8qfw2pbRvgs
	 lngcFcXf0bQyNKZOSFOwu/KVSbv1l6nstPb82dTMy5oqWhw434f3uVqT9bMr+fC86K
	 JpYPQgeHj2rkZlvjk0KFF94b1W/u582v5Mp3HAZ3CBEmzwcw6osE5xbDPXJyL4jks5
	 gsKPrzV3dIGt/GdaLZtjP7Y0+1DzGhwGSLp9lrqjkGNVgMYtQNhwQCOVhdpTcB1Z1I
	 npJRUcrOUC93Q==
Message-ID: <sashiko-outbox-183441@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 3/4] psp: support ipv6 extension headers in
 psp_dev_encapsulate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023234640.1459291-4-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
 <20261023234640.1459291-4-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:55:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> psp_dev_encapsulate() inserts the udp and psp headers and rewrites the
> l3 next header to udp.
>=20
> if the packet is an ipv6 packet with extension headers, the transport
> header comes after them, so rewriting the next header of the ipv6 fixed
> header produces a malformed packet.
>=20
> a psp tcp socket emits such packets if certain socket options are set on
> it (e.g. IPV6_DSTOPTS). with mlx5, these packets also go out
> unencrypted.
>=20
> fix by walking the extension header chain to rewrite the nexthdr on the
> last one in the chain instead. the walk also rejects packets with
> extension headers that aren't supported in transport mode,
>=20
> - NEXTHDR_FRAGMENT. this could work, but udp+psp would need to come
>   before it, which is different than how the other option types are
>   handled. for now, keep fragments unsupported for transport mode.
>=20
> - NEXTHDR_AUTH. changing what follows would break the AH ICV. Also, AH
>   adds little incremental value when used with psp, whose ICV already
>   authenticates the payload. AH remains unsupported for psp transport
>   mode.
>=20
> note that the stack doesn't fragment ipv6 tcp packets, so a psp socket
> won't be able to exercise the tx fragment path.
>=20
> Suggested-by: Daniel Zahka <daniel.zahka@gmail.com>
> Fixes: fc724515741a ("psp: provide encapsulation helper for drivers")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023234640.1459=
291-1-toddfreed@meta.com?part=3D3

