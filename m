Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948579;
	b=5plJ8N+IZWrklIkfhWw9FpPB3Gk7CeZAoKPUIp/rDvZZ4yva+4L+XsusM99RbR+Q/ZyM
	 Bv0AuNH80DeSTcXXoJlj38ipRnjKVkpQSr9SWYmCtBtNkQl79fBxzUPfo7hK7uWZfuoGZ
	 ITe9xWLTOSZaHe29e+OS60ebityrpRhOySlPKZCcoq5gOG8q1eVEYvYWyRKo22ZUFiaOB
	 1On5AYwT4eSVHNtry5tlYxm3PA9lW61WPiqYDC5PkqNLG6iEucFAGSqBRByZ3URb28wJH
	 JH7iBDTJZwNrcF5VMkrZGIr2s+4k7al73uJJ/tzKPgP+RE4zPftx9RDoyjQdD/1ewXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948579;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q8AUIl9Iu5svrjp6b630LI/Z1MQvTmrj4DznTTjE0EQ=;
	b=tNucQQk3moAA7/v/YAJm3LtJlKeTjDc30L/sCmyHigdDPfrbZ13JXyGfYXBAWlyRCZUL
	 CGmWhnrDDvPjMMCNCM3fRJ54ITEPIEZsu2W2Aaqd/nHP9XguVsboKi8DH47tVrSSemSRW
	 qPxiBeOt58rUY0tMj0aqgoqFMbSgYgE+9fdIwa+JIDVkx/qYhZpLS8OXDuIzY9/9ThBKI
	 83XkI9VO58jT8xO0An3utJ9WQlJ456kStBva5wMle7MSECZKWtie3wijLNj4kCbHqYD4d
	 3TjsUjQBR0tlAQ0yWtyE5dYkIqeo+Q3Lk0txVJG5CIwOVaIW0+Lz+ZfJJFNBBgK5h2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gY1Gt1YI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A1F606A335
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gY1Gt1YI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077001F000C5;
	Tue, 17 Nov 2026 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948579;
	bh=q8AUIl9Iu5svrjp6b630LI/Z1MQvTmrj4DznTTjE0EQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gY1Gt1YINBrEO3ct28qioh8IYLg+RLnALWbM0L2Q1rkSwHEARztdfx1viXTWNxv03
	 DD7knFii43STSif8ppglCfeFCE1KimKOJnANhq3V0ZEo10LecPOk2zsd3okgcDCBEV
	 x4Ygz9KCcNgjDvG6XAPP1+7yKB9Sjin9OwiimptRjhK41RuXwI4oaRC0OK/VUtjdOT
	 qR6eQXyM6shMTVNCFVCUqwvqHZQWdz2JIf5+ztY11tEm6MbkaN2d97d76976QN1USH
	 x06WF7fTRWspMolpclQBxxvS0+kEQXK9+Feu2k1X1pesCxDattDyR4nICGmEf22qm3
	 ZEqkBz1nigx9Q==
Message-ID: <sashiko-outbox-219650@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 3/8] net: don't fragment decrypted skbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-4-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-4-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> on transmit, skb->decrypted means the device must encrypt the skb.
> if it can't do that, then the packet should be dropped, not transmitted
> in the clear.
>=20
> ip_do_fragment() and ip6_fragment() on a decrypted skb produce
> fragments which have skb->decrypted unset, and can be sent out
> unencrypted.
>=20
> tx of individually encrypted fragments would not work anyway, because
> encrypting needs the L4 header, which non-initial fragments do not have.
>=20
> ktls could encrypt in sw before fragmenting. that would not work for psp
> offload which does not have a software fallback path.
>=20
> tcp sizes segments to the mtu, so psp and ktls socket packets normally
> [ ... ]
>=20
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exc=
hange")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D3

