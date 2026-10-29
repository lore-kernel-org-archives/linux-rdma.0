Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299382;
	b=viXhdIQhcqEBCuYfh8dp3PTytyntsHJ/IfizZ3yp/yQcD9BTyoCMJvh6KF5J3HO+QHhD
	 p2qpLjO5GFUz9huI9ah0zAns5GSMxK7beLcoGKk5LEHm/mCD9tLwg4cTVJWmlSe95/8HG
	 VmaxSnI1blV8Pt/dotMDRvk06gpDiZ/qUKxUYH8bel3vW/mAhlGNrbJaDah0mjSl40VfP
	 Rf3dG4UMdeuVZOxX5oQgW5vWq1v6+k69xdJ8EkvSa5j3Vj8fEiq6ifMTlakLE78zH+ap/
	 uN1r43gdQYLrNSTXPRYFCDnxRNJpr1lQ8POiA7v3vQ/06NEUS4ni7VDNnMKMWAxEseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299382;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HipQiKxa6S9TazkksME6YHiK5appE69UK4AnztJgegA=;
	b=fhEYxuP2reRLX0WEt83ibX7fAJ/chRDDT2qRtdlSefqsYKNS88yUupnhBw+w63g4tuHY
	 NE+7bhASKt3LkicC6DBoP54HrPVLAZGaYTb/H4n6G/GSZKcHyvbegEMEkSsPAx0pbHXGS
	 bMZPoQg7LnQKVQHNpjYdbe0WqDTObsNNKq10ixlO3M8YmOcSrrXYZLYAOczC1u3ALU/58
	 W8lVVCtsgM8hkkQJf95b+8Z3vwKMRe5TeSWVSOOADZIhd9YKNciOMz7dM4ECT89Hi1x2b
	 CaliAk5QR/KuaC5KW2O9TIAuR1Zr5xtu1DT/cj0IITY8LxrO9d0yrE4B721q0xj1JKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EV9aZaqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322CF606A330;
	Thu, 29 Oct 2026 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EV9aZaqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796841F01828;
	Thu, 29 Oct 2026 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299381;
	bh=HipQiKxa6S9TazkksME6YHiK5appE69UK4AnztJgegA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EV9aZaqTiF5qssVNKORFHa8SJSbWMcubC2W6d9v1R8rZSdtEkdwrURStcqWblrDjK
	 QmmvQbbl5HU2hHDJX+DNCQhZoEJ1EOsOM5S3cP8jnEzEHmnLgthEg9W9IemQXhzb+D
	 qKDwXFJjRfHsCfxFnck7600vxhwFOigulJBO6G40vtF0nTzmgMBnj6qri7C7/fyDjr
	 rxk31M4IpjT8OrysTCg+MbxxMM8wW0cpWW2X6Vkw0+IWMRfDcVNYu4t8+4gyy1+O3x
	 BoQOt6pUklWWXMk/0DUG9uSoO6ZN5aLe8bNkd9ijM0FL1TyUap9GJwWLFFsB3aKjD3
	 0L5L+4ro64cFg==
Message-ID: <sashiko-outbox-189823@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v8 2/4] net/smc: bound the receive length to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029-b4-disp-33001ace-v8-2-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
 <20261029-b4-disp-33001ace-v8-2-f9bb96e17827@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 18:43:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smc_rx_recvmsg() sizes the copy from bytes_to_rcv and starts it past the
> bytes MSG_PEEK or splice() already took. A forged producer cursor drives
> bytes_to_rcv past the RMB or negative, and with a conforming peer it
> drops below the peeked count when a MSG_PEEK|MSG_WAITALL reader sleeps
> while another recv() consumes what it peeked. Either way the copy reads
> past the RMB into the reader's buffer: the second chunk runs long, or
> the start offset leaves the RMB, as smc_curs_add() wraps only once.
> poll(), SIOCINQ and the deferred accept read the same raw count, so
> SIOCINQ hands it to userspace as is, and bounding recv() alone would
> leave a level-triggered reader spinning on a socket recv() finds empty.
>=20
> Make smc_rx_data_available() report at most what fits in the RMB behind
> the peeked and spliced bytes, never a negative count, and use it for the
> copy, the wait predicates, poll(), SIOCINQ and the deferred accept, so
> they all see the same length. Cache the RMB length for the unlocked
> wait, and drop released bytes from splice_pending before the consumer
> cursor moves past them, so no reader counts them twice.
>=20
> Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
> Fixes: 9014db202cb7 ("smc: add support for splice()")
> Fixes: a4b6539038c1 ("net/smc: fix data error when recvmsg with MSG_PEEK =
flag")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba=
616c0920c@proton.me?part=3D2
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-d=
isp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D2
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-d=
isp-f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D1
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-b4-disp-33=
001ace-v8-0-f9bb96e17827@proton.me?part=3D2

