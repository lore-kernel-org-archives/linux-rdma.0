Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F753A48D9
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050188; cv=none; b=L1TC5exIIzYqZWxXsW9ncqN8zKuZHlk6B+Rc86PNQtruP9E/i6a1WHi9jZf7zwXiMlzycefuUCRo6e1EQzNVU/e7D3HQhll39SVZaqnjCQelGHbDp+AdAKiEFyzJYfTLykEX5+JY98mhCnD1qfxADrBwesZg5NvQOFPd4MFXDuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050188; c=relaxed/simple;
	bh=ADA8Soxe93MRKvdU8WoMzIw7NWiKwv4XWde+XmLmTZY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HhuHXbrXkqlIyruTtQcKfKh7sPxV8UDwv6fv6O5zH3ZbAYm6p1G74j+DiOIFKFozuq0oS4QdIivb+Ji6Vdwa7i2Tl8hjefU8zg2ZGDj4XiD7BenvoTkHdFSzpT6mO+9yng3BSeSeTtqcha+AU9tmhUZLd+2n6+HwBKd7IvLK0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grXX/S+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grXX/S+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9A91F0089B;
	Sat,  3 Oct 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050187;
	bh=uKyTMxdE11TA1P/mraStHQ4V7C+5ucldJHKI4CbhhwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=grXX/S+jpms4k2RrT3wbOIPW0tQB9CdUtkagEZEEVG8GvlajyeoP0bB+B7MyYeEJJ
	 HpDNUogKAP3QWrH8yvIRGPR0K16DQgZGj5UQuCpWfs1wKIp+tkq5F7DrTE53dXYSaQ
	 UD0lF8Deff6snGepl+TRmmTND+oGPO6OXSaY8ljPEBfsmqkNPponYQ4AQJCETk5JaY
	 YcToiPOlnRH3y5TEyKOZAP4iwsGNae7tMSaRB7/xkRYfZnBsxyaIs57PmipfcGryx8
	 spN0ejTfib7FjYeazqguVTmxh4/UzMOmDtgKaE03a9IU3rDcUexJZsEyB2+/12h2nE
	 5dZaJbFxlXxRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 09/13] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-10-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:27 +0000
Message-Id: <20261003175627.6C9A91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by netns
> teardown or module unload - and every dereference of i_conn after that
> point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D9

