Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2152730F92E
	for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2026 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790662034; cv=none; b=fxXrPbUPQfpBh8FSZ2PtGsSv23gZ9qLGpJBpfYARX2wpMSMeIW5nIiiQgtSQrskfaMu3E5UmZxR6YYyUOK+b30P3ZRoN3CpmvN8N4yFLeM7myBK9KIwTMDHOzUDO5NY/Hb85WM5lzUKn0425pUk7JDF4+PyEEy/bNVgSTeJ0KCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790662034; c=relaxed/simple;
	bh=avWvVHxuLYaJhGPfwam5C+hTanE9swYkV8/u62Tu5zc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N+WEXrwM9zLezokUCTIVdTyWCd5Hw9XoLEGhqbBDc3HYpG5+QGB9MFyONJ0P16yb750fyCROvCTseUn5S3jKNGavdXSqv8ouZ+pZnpzMp2aLsuHy9ye5OvzVinwCdPAmdkhUbfzWVoyOz7yQv4CoZXhYJ0xRcfoiHKsFSj2NN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JY1aACw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JY1aACw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC871F000FF;
	Tue, 29 Sep 2026 06:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790662032;
	bh=ZeFy2u1CQ0B52tohL9vPmD641UiazMwetuYR9KEOrCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JY1aACw4Lne3epAvM0v4XUJooorIhUbXgM+cqXlmnlm+W6Y0KbUqw1mfYsCCc6Rc4
	 PMGWAITj0fLzPNMU0Eq4vzwO5IO69BzZobBR/M/tRPGnGWC2gRz8Egk657MKvzKcbK
	 f/0cHrkTjwkFjs5LMy7xWUGDJl7glML/g2NHebC6cLWQatnnslsSJ2ztU9rYk9okXk
	 CvALk5Meh9Q4SYi4gF24dlxzdpbNhSw4kP7R8TX2w47LhCsTYh6urIwRgk/tOkmDQ4
	 V7OABCNugeAbmNTYy8V3VDvyf12ctv7+MfWmOumOR68dr4S21kyUXZQALksCAjqFmg
	 tOzOlMst9adUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Honggang LI" <honggangli@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260929055853.164026-1-honggangli@163.com>
References: <20260929055853.164026-1-honggangli@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 06:07:12 +0000
Message-Id: <20260929060712.8AC871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
>=20
>     payload =3D min_t(int, res->read.resid, mtu);
>=20
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packe=
t`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
>=20
> After fixed it, the active side of RDMA READ failed with error code
> "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
>=20
>    int resid	=3D dma->resid;
>=20
> This conversion set resid to -2147483648. `copy_data` abort as length
> greater than resid.
>=20
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929055853.1640=
26-1-honggangli@163.com?part=3D1

