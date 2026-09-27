Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489171714AA;
	Sun, 27 Sep 2026 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790496126; cv=none; b=DT7FAoHvQI48LeQ/d/VDZfavBf/q+t/S09i3z5PUgFX22XOV4TXGNO87SKNZehv5FsjMp1VzrrAYuDS1y9xMdHPuctXw2HEmzeNUqH1zeTZxwczFc8ZZDO5A+9IV32ck6D7xYip0ZateY1+d/y9EEg/3Qi5FyYO8aC4STCUugfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790496126; c=relaxed/simple;
	bh=eV6lb/jVRv/7XtDU1JaubwY0ps80b5Vrphmu+8G6ywk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bDyb1CxnPvq0cfGGj0ANM8QORFMr2Zd9enm10CoN4LlUAUh7Gt2PLQoMoIrueFJU8vNIahp+x59LrlAVUioxtw/Yy46sd1jFEt9Kxxy6xwHSs5TRJiZ6XQvy8Ona5QLG01wVNwtj3xWP73qBOL+8rbgD5fLIbMI/mdQfVDfXaM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQvAJ1A7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQvAJ1A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FBE1F000FF;
	Sun, 27 Sep 2026 08:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790496124;
	bh=da1QAS7xooJsMMtRBHlxyLhgedYX/7cOocsMm80UBJE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XQvAJ1A7uHH6dTVRQDktyvNgwlh/GIWEfBNqChp24U5t/D+xgmMmP4RW6WWNOR5qA
	 BTkoZhKHKWXVEEkZeLmQ+bMk5KIEWbSOLsaa3Jkl+VLHhl/9Yp+CdygaDezs0uE7Of
	 sBvFUWtq/ydp6ehwzSnRygR5dSMEFVkQTYC22Z66OeZuYpTPzGzYDRhvcprKMI5zSx
	 Fi+dqfhLrTmTXqAKjqYUgOaRlviHn7+mPDHN8OF36q4WSLVJwzzoU4934tuRrAyOE2
	 oGBc+A1KzGHp1AUxoObfP1gM8Ki1OGQ2JIGONnuPDsMhCCWP1OHkY7QR1B9X/QmI2q
	 aZZiSMD8Vfhog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: Hold a socket reference for transmit work
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260927075120.3695060-1-nicoyip.dev@gmail.com>
References: <20260927075120.3695060-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 08:02:03 +0000
Message-Id: <20260927080204.70FBE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> SMC transmit work is queued without holding a socket reference. After
> an active close has cancelled tx_work, a received CDC message can queue
> it again while the socket is in SMC_PEERCLOSEWAIT1. Passive close can
> then reach SMC_CLOSED, call smc_conn_free() and drop the last socket
> reference before smc_tx_work() acquires the socket lock. The worker
> then accesses the freed socket.
>=20
> KASAN reported:
>=20
>   BUG: KASAN: slab-use-after-free in lock_sock_nested+0x97/0x180
>   Write of size 8 by task kworker/0:1/11
>   Workqueue: smc_tx_wq-00000000 smc_tx_work
>   Call Trace:
>    lock_sock_nested+0x97/0x180
>    smc_tx_work+0x5d/0x170
> [ ... ]
>=20
> Fixes: e6727f39004b ("smc: send data (through RDMA)")
> Cc: stable@vger.kernel.org
> Link: https://lists.openwall.net/netdev/2026/09/09/105
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927075120.3695=
060-1-nicoyip.dev@gmail.com?part=3D1

