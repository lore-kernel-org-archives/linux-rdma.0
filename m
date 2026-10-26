Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044724;
	b=LOJrGqGsep5S3eGJREE9u48ahV67VPfDcMquQ5fue/RZDXNByuKowrok+32DtblPUWuw
	 fdkJIm1DfkoFn/tZOTRNU6ETeVS9XhhpZBmMoJH1120Hlw+Kdm7eN3TUs5cJ+VQnwM99j
	 S3BJtM1x04DvJm8YEhnuD7d7bp6/XY63shJeTu2gXk2ojuub51ZmCc+NEEL5tJA4wF4bG
	 xdZNwXlGUGTbmwYi82XL8Wq0gKZPIXdbkdbLEfsTAqiQC1rM6BgDimwrLYxLBLsW/14Vu
	 nmE60wHdsLUHPpxmahuD4K0iqf64e4OGCWkeY/kvM0T7BNqzyQk/4BLYI5HqiTbJsLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044724;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=7gXPuKPbe2d9wp4E3pTUVsY6Y2MD/gSJpN8xN6R9Sfg=;
	b=p62hS2BYy1HkjMS93Ie5lACQ6UU5kg6J3+v44f61P/T2QcX1cxKoY+fntiApqO3xJ6G/
	 QtNI+sOTTIBVIcsGKcLQ1qH5gnAzXHVTE6B9SAtes5OGRPFWEw4qBFzpM7p0Mvp0MaTtc
	 1GamzjGVhiH+LIWU4Md7OS4vfcSdSTpCkbyBkXNPWAXywJVGM455kJnotAIsaKr1Yc26A
	 lfGIobp615bip6CjXSd7P9MMnAYvIZE22MkcXGKGUEyOwU6/S1Mq/93J9A7FRgEGSZWzP
	 nqqktYDHxlRxAPM4mzaIGHGN7F4jnjAIyEUUW2p/17NTNMt6git48ShxdAw5oAZ90Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Gh/8p4P6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6F606A31D;
	Mon, 26 Oct 2026 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gh/8p4P6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9BD1F031E0;
	Mon, 26 Oct 2026 19:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793044723;
	bh=7gXPuKPbe2d9wp4E3pTUVsY6Y2MD/gSJpN8xN6R9Sfg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Gh/8p4P6MdMkozfF9bcxdgxaWSiWbhpVZ4aTAxO64vLlj+8zpi5JwfqB8fCiXKs3c
	 FlVInkCS0YR/Z5dq5dBxSUASbzZ4u9IQmcel5GPWzTtpiZpUeMlJHr9SHpHcu3zny9
	 GXtrFMSCqm0jQzkIdFkXtSylsGtwpm8RKErLUXogSHH9ol6N2+QkkO55lJyHYJVrgC
	 r0tP6y/TCiwm2fABY1F7UjRlvFO8u0UxV/cAVK08Kh1ehPbC+yoYSWUssZ/xbAaDr2
	 XX5KqkZUt8OCp2S0ao3XgCxMwPdl5auOMsTF9e07+GfCZSfZLQbdGOLtY+EHRA5/T4
	 Msr43iblfdzKA==
Message-ID: <24c5adf57ed323848b1a1ddf38a21fe3ac296755.camel@kernel.org>
Subject: Re: [PATCH 0/5] net/rds: move sysctl-only code under CONFIG_SYSCTL
From: Allison Henderson <achender@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Joel Granados <joel.granados@kernel.org>
Cc: pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
 horms@kernel.org,  netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Mon, 26 Oct 2026 12:58:42 -0700
In-Reply-To: <atzRTslzb6CAKPKX@redhat.com>
References: <atzRTslzb6CAKPKX@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sat, 2026-10-24 at 17:39 +0200, Oleg Nesterov wrote:
> On top of
>=20
> 	[PATCH net 0/2] net/rds: fix init failures leaving built-in transports o=
n a dead core
> 	https://lore.kernel.org/all/20261021195837.142802-1-achender@kernel.org/
>=20
> Allison, Joel, I am sending this mostly to "complete" the previous discus=
sions.
> I won't argue if you think these cleanups do not make a lot of sense.
>=20
> And of course, I can't test them. I just verified that the kernel with
> CONFIG_RDS CONFIG_RDS_RDMA CONFIG_RDS_TCP CONFIG_RDS_DEBUG builds with
> or without CONFIG_SYSCTL.
>=20
> However, I decided to abuse sashiko.dev and sent the cumulative "not
> for inclusion" patch, sashiko didn't find any problem:
>=20
> 	[PATCH] net/rds: move the sysctl code under ifdef(SYSCTL)
> 	https://sashiko.dev/#/patchset/atyHdPlxALv0Nnyj%40redhat.com
>=20
> Oleg.
>=20

Hi Oleg,

Thanks for following up on this.  I think the cleanups are worth
taking.  I applied the set plus the two net fixes, and ran it
through the selftests with both config settings, and things look
like they came up clean.  So you can apply my tags to the set:

Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>

These are cleanups, so they should go to net-next, which is closed
until the 9th.  Everything except 5/5 also sits on top of the
earlier net fix, so once that lands and net-next is open again,
please resend as [PATCH net-next], and it should apply cleanly.

Thanks for working on this!
Allison

>  net/rds/ib.h        |   1 -
>  net/rds/ib_sysctl.c |  33 +++++---
>  net/rds/rds.h       |   5 --
>  net/rds/sysctl.c    |  26 ++++--
>  net/rds/tcp.c       | 230 ++++++++++++++++++++++++++++------------------=
------
>  net/rds/tcp.h       |   2 +
>  6 files changed, 168 insertions(+), 129 deletions(-)
>=20

