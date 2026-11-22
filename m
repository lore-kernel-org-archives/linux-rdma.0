Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359273;
	b=zTkGNXKZvaR/rhDOViIMIGN1Psx4z++SzDMq+2FX/pVCuJHD9rwQ3G3Yed3eZSo27f/e
	 9Yl7MVI2mO/tAVIkB7GsRW3Zplgt7njtn7nxKORuX38lnFph9WqfmLKk1ddOzapLji6pk
	 O7YofjuCBfN+4j8gNjW9aMuJh/JaHCd2ryPfJjtw64HPgWXg94fz+s6wSth+inmGHGIKV
	 lVNlObsAA8wU4Z5+SNJ1Q0TvrV3e8vPOqGyxM8RHX9csWpNg2pa4J2gYlIlIi6RIy22Vb
	 hSSKNwG8ihrX5Klw9oMzjZmC8DBE8g6DzYOAXluWUalpbkN2oDQJLICb4zMPmy/KyjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359273;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZXbeKHorw/FCU5B1C/p4iIDjLf0wCH3UTCNCoz8tM/8=;
	b=4mxgdnMYv/xJNYT9qBEV4Xp7cl2UfeCcAODp/1nd94ZbAEICb8AU7fg423PHkBG2hxHw
	 sBa516wwEXTsQQY1s0ZxjidQe2GgOwaRwDsyvbVjznbG0/Z6mx0aweInVP0oPQ9GlJQ70
	 hyXQyPGiTy8anDPdVb/JjDXK3gmbhCQ9P9b6GtMIQrYpFVkiDQq7IVH1tGZaQWIQ5a/G0
	 29JwJljNr//Vjf5znr8uK1ecd0cngEm1i5f9reqOGgrlN9IJ4orBuTZEHs1ckUjgoitju
	 Y/b7b7NsTJRGhrjUmEPJSN1ZjV9vZQHgNy7xNjdhenq5eGrt32031vQ2pWkgNjIY8Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPhdfmrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9433B606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPhdfmrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E11F01561;
	Sun, 22 Nov 2026 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795359273;
	bh=ZXbeKHorw/FCU5B1C/p4iIDjLf0wCH3UTCNCoz8tM/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QPhdfmrE0QzJaY5oCR2ibT9iP9WF5/zk79YabLK/Wjm69TTnyRvEfiFTR8hPRfGkM
	 pFuFNhqbF+4ltrpvwsc746MraKD0hQ9vnMcGbI/cFkPLPfve9kLNj3pjY2kTSdV/Ww
	 vyARgbsUXnn5MDyBrM9xJ1U6Hur7PEj5HAvGojTWTnyqgzW0f2i/hdJr52g8tv9mVa
	 r/WJVxAEODyTBH7jwjUNqZkJsV2V2WhHRcR8sAKZrUIVoj1R0clFkDeTFyiFYzHt14
	 H7yS40Tg6mk5bXq2CC6BgJzmh86wqUTy8KxgB3T6wyyYbhBB9KFza9u0sigIO6kGzk
	 WG+peHbPYLCFQ==
Message-ID: <sashiko-outbox-228023@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5: fix a stack over-read in the QP
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
References: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 14:54:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> dbg_read() formats the field into char tbuf[18] and passes the return
> value of snprintf() to simple_read_from_buffer() as the number of
> available bytes.  snprintf() returns the length the output would have
> had, not the number of bytes written, so when the string does not fit
> that value is larger than the buffer: the longest QP transport string is
> "Invalid transport type" (22 characters), so with the trailing newline
> the function returns 23 while only 18 bytes were written.
>=20
> simple_read_from_buffer() uses that length to bound the copy to
> userspace, so reading .../qp/<qpn>/transport copies up to 23 bytes out of
> the 18 byte stack array, leaking 5 bytes of stack.
>=20
> Enlarge the buffer so the longest string fits and use scnprintf(), which
> returns the number of bytes actually written.
>=20
> Fixes: db81a5c374b5 ("mlx5_core: Improve debugfs readability")
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122145152.1473=
-1-chenaibing@cmss.chinamobile.com?part=3D1
