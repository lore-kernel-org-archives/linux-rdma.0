Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799748;
	b=ZOu08Dpi6G/p3lA3/WlR99SxPkJLYyVKX8p1f0CRBy9Xjy4GjjhMg1ctfDnN7z0FoZgs
	 tT9wpM//4M/4XMv/7xe9ZX7iqAEx89A1cni583DkGARggb9DA1FtjFYjEGJyRAD5Q293Z
	 Gna9UM9dUyOmPhl+MXzZepsBAderyerf6QiDLE2YiiUdv8OfIp5H9A9xYIvFbP2ebl3Si
	 DPYSsN++a7FXFzrxMEV6IRN66lx/xTRhXDjdLjJ3yT+iLUaVLL/+ejSchG8lfP7XKmrxZ
	 1duF+4BLsv8QlLcBeLgnpD5dCF5W1AubdsCrpsLmINLaxSf73euCyxwq+t6huUj/A7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799748;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tgOSRsFRy4yBFYkq0A/GJJi2TZTxbokD0oQCAU3dcIo=;
	b=nIZcoLARxS52vmZfaUJmVK040a0Eita+vwoTHb6whTEKmi6YTRyCb+IYJ5bxwRfYa/9/
	 xcQt9DFcAWPFlvFzH3lFoJJMPcHYAWMblmN8d5uOoeKKkdKOHeEjUJ6nKmXuOxDMyTdpD
	 ZJOxsfyeg/6v9qAXCBDLx4VSSnWp9y5gXwKxg0C8cbx2A8Oe6By+6zL9OjQJTc3IzYsjj
	 Lf7KKDiufDO3EdQbCZ5WYVGxOpaMlyVgknDIDihzgaw3bPxBAxnmnj4uvwIvySW1cz9kL
	 zolmkrgzk8prh0l2uFZSnhwr0iypkIu6N2rGDbgvzYIkd/DRt6uMNU9nTTlaAU3gCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RzS6ZEQs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC4606A324
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RzS6ZEQs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B9A1F01829;
	Fri, 23 Oct 2026 23:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792799747;
	bh=tgOSRsFRy4yBFYkq0A/GJJi2TZTxbokD0oQCAU3dcIo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RzS6ZEQsYFw3mMqc/at8y4hF29cO7aLzjr4GvQrKDQcqvKza8Gr1c+W8GO/nWOYa5
	 pVJ2Dlyj7inO++c7YI52sdOv5hQj4HAnY48/hv+5NqcWqYfT1ok8pKTN1ZHtNoFu+m
	 I75uL0+TxXYvPujCCe/69YpAvGjvsisAB9H9zKVVcDXgZjYPdn2k+2SqxHMjm9pohd
	 /kUcNpYvXlyOaF6w5DXsc8OE+32AytA/DuSX7oQYBEg4Scx0evJ9LRcxidAjby+AyC
	 /zmv6h8yRSNnaGs+jk7fa9wIed/hzSGVr1UMRrtxS5u9dhC6hSUjjPbpAcd/nUyqd5
	 h8KRuWksN5dMA==
Message-ID: <sashiko-outbox-183442@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 4/4] selftests: drv-net: psp: test ipv6 tcp
 socket with extension headers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023234640.1459291-5-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
 <20261023234640.1459291-5-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:55:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> send on a psp tcp socket in three phases, and after each, check that the
> data was sent, counted in the device's tx-packets, and received by the
> peer. phases:
>=20
>  1/ no socket options.
>=20
>  2/ an extension header set on the socket.
>=20
>  3/ option removed.
>=20
> the test has a variant for each supported extension header type. for
> the routing header, the test enables seg6_enabled on the peer, which
> otherwise drops packets with a segment routing header.
>=20
> a software filter on the peer also counts udp packets from the socket's
> [ ... ]
>     tcpdump -i <dev> -nn -A 'ip6 and src host <sender> and not tcp'
>=20
>   shows them as udp, with the test's payload readable
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023234640.1459=
291-1-toddfreed@meta.com?part=3D4

