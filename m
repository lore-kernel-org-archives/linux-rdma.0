Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948581;
	b=5YvOvPZGrldEOgSeB1S3NoQMPGZveeTsCms9OgxTZnF7KW+T3nYNbuQkbOboviOkvMxo
	 blWyEBJRmg43Uuvi6DjSL3+y9Az8+/ofy92blB85z/SONdW+wu/EbCsNfyTvNse0rOqBe
	 FN5QTZqqijGrjkLnVMz6RkBwZw0IEOMN/ilQ9XbVX3UJVlrp1uWcU32+4vFYPlPYLYce1
	 +XaRSKD8aCGYkgjspUonId8pkiqWxU7M7OibOxOX3QcdegWNwCCkkzjK2gzKU7KdX+YOI
	 TwpPrAnL+ZOsVs/bE1pK079O1/ETQjY7Y2YMUluqmcCw4d1grOi5gTL+eeTOps15sMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948581;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=beHZRlPM6ymP0rwessysrSE2pfkF0wgMynDHext8/fA=;
	b=2jGVzpumSddSED6Rm8NMjruvy15R+iPFMYjaJ6oF+msLYi1tpT0vjx2wJfm7utfY3+Do
	 SNRfVHmaVEaSN+Ft/SDZIRmqmCiFzfwtX65gK8RgkxpSL3YliRtwvC8pAo7VxiuxA35zi
	 CeqRoT+jLXc2eCc1ToSW/H/7xvQSv3FgkkoLYXBaizHMbezE4eTe5QReORaGq9HxRvYd9
	 1Rp54Hr7kzqCERMa2nqlY7lIaD3iLcTI8AGbH7dhtq9Z94ti/hGMjhYonwirWm3tG+QHo
	 nNnCXMsK2V0ABh1/c8rbmifu84bqydF2s8WUJGJRPJJHcMepDTx+qilekeEnfKg3H3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCJkf+ef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0C606A331
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCJkf+ef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2C31F000C4;
	Tue, 17 Nov 2026 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948581;
	bh=beHZRlPM6ymP0rwessysrSE2pfkF0wgMynDHext8/fA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gCJkf+ef9qyyCUaFr2YE6NlXDqO563JaG5Ea/jIjl8HvdhTLZAHAWoG0yeSfTnP7Y
	 +yk9jm5ZsiqQm+CjCxA0iOi0MKP2r6CJZZFqIH1qqvWD7YeMftS7yqKRG0VadSXFIc
	 vqUv2qhCVpCcDJEav/9/0agGjed79N8conkUedA/LTvivf23aPFK4oHRT3IzQiaAYR
	 glwfY7O0Q9zrkRGtdJzsYGIkOgmZARutxNegCGnq8Dw8l8bBPWr/eed3NTf88EP1ED
	 3+N9rNtS5+Mp6Ks7hY7y2lZxLqwcSGLORLj4qnpiagFuuBn6V10AgHmCZ3fBXOqYtv
	 DjyU/vhETK1lQ==
Message-ID: <sashiko-outbox-219654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 7/8] selftests: drv-net: psp: test that ipv4 psp
 packets aren't fragmented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-8-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-8-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> make the ipv4 packets of a psp tcp socket need fragmenting, and check
> that they're dropped (IpFragFails) and not transmitted unencrypted.
>=20
> tcp sizes its segments from the route mtu. with IP_PMTUDISC_OMIT, ip
> fragments them to the device mtu, and doesn't set df. so the test sets a
> route mtu of twice the larger of the two device mtus (at most 65535) on
> both ends (the peer's mss limits ours too), keeping the device and
> source address of the current route, and IP_PMTUDISC_OMIT on the socket.
> tcp mtu probing (tcp_mtu_probing 2, or 1 once a black hole is detected)
> can cap the mss at the probing base, so the test turns it off. if the
> peer isn't on-link, or the socket's mss doesn't need fragmenting, the
> test is skipped.
>=20
> a software filter on the peer counts, and drops, the ipv4 fragments
> which reach it from the socket's address, and the test asserts there are
> [ ... ]
> without the fix in "net: don't fragment decrypted skbs", the packets are
> fragmented, and the fragments go out unencrypted. they reach the peer,
> IpFragFails doesn't move, and the test fails.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D7

