Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86EB5349D6
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167921; cv=none; b=OA0NZLuPktEuTm3toCNYRKcH6pL14Hp7M5z0swUXZYmM1fsOwwrjxwg2RZWPXbK93ukc+6mKYa69bDGEbpWrD0li5JXMlm18q7IV9sCsYrbJnTShMQVUP5cPWV9Gx6MfUw0aaghZg3VpuvYta07MbXDpIw95WBJR5k3FUbDU20M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167921; c=relaxed/simple;
	bh=XDkx3QY5nAsuZeGv6BbqXSEejTn0Ffny9Xr6q7G13/s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dI2nqAqrGB1JOSHStW2xZM3z4Byagi37W50LL0aBujVYLXJIOiWtsvAUijmInI4RfLnHmbBq97yNWFP+AMOB44/NUhlohcL0rAj3gcX4JKrv22JHhZW+q95fw7K4wL1EExV/VXuo3TIz4DOxEbl0bK8tsrMyRtCTU0ONBTf9UnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9Jp7Yf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9Jp7Yf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E02F1F000C5;
	Fri, 16 Oct 2026 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167918;
	bh=ujJHxTOy0lmU5cd26txqU8r2ra6Uy/OtfzShHBw2Za4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i9Jp7Yf9tss2ouwrGPjA2B05H5qMbXzmXeI9a4IzAkv9sxd/3glSYplRS2d0jWYOJ
	 FUTIZ873j1ZNRrg0ygfO0Gymo6169+W7RKVFREUCvxHJtJJ7pd48LwAkOi3/pm5qNz
	 IV8oPOYWqZRpWZ/91bRDDRpKA88MEa4mVdwhJ4fd+Bp/ykBySspI37fwb4z0pquXR4
	 YFDFseEn1dV4jsC2vIVrIeotMWRgbhY00CMH+lMT6rsJ/6nRgfS0Qw4/uPJThAwT91
	 hNQR7PQoOR2ldH3hRQ5aBtMXRc8b7fU6nBe0wwclayNFS0nVZVK5zIxERAwage+2i2
	 jv+C8KpOT0cCg==
Message-ID: <sashiko-outbox-174636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/rds: ib: don't enable IRQs in rds_ib_conn_free()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
References: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:25:17 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> __rds_conn_create() calls trans->conn_free() with rds_conn_lock held
> and IRQs disabled when it loses the race to insert a connection.
> rds_ib_conn_free() takes the device list lock with spin_lock_irq() and
> releases it with spin_unlock_irq(), so IRQs are turned on while
> rds_conn_lock is still held:
>=20
>   raw_local_irq_restore() called with IRQs enabled
>   WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0x=
c/0x20
>    _raw_spin_unlock_irqrestore+0x67/0x80
>    __rds_conn_create+0x1de5/0x2290
>    rds_conn_create_outgoing+0x43/0x60
>    rds_sendmsg+0xfca/0x20e0
>    __sys_sendto+0x408/0x5a0
>=20
> It needs an RDS socket bound to an address on an RDMA device (e.g. rxe)
> and two concurrent sendto() calls to the same new destination.
>=20
> The TCP and loopback ->conn_free() callbacks already use irqsave, so
> do the same here.
>=20
> Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmm=
od")
> Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc3741bb338b5c6d6a4aa
> Cc: stable@vger.kernel.org
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016161525.1465=
37-1-ngocthang2710.1999@gmail.com?part=3D1

