Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048927;
	b=BeRkVBH5Skw0DKLwYHeYsxNVfMQt8hLkALb6IcbZH1vnEC1Y+C3kSl56hLqYqr1xGXif
	 kb9sglJFFi/wd9ZVuFWmwTjRhLKLqrXPLyKv5IU7sDEIEAnGmc2OusvME5D64h7vKHxb4
	 UFcnTnVljyuYw3nNyBTA0+LZTj5/eGQcbFu72dX9EWwa3Q+5kEdSLrmvHmEAi6AlT31+Z
	 tWFPd0JFj1GBt1lEvMHF4Ly/Ic/eCgzpuv/Q2VQcs3sbwaivwd2zB12eKxOI887gJzpIn
	 ftHsrOMObJBFCUX0GpaUdnK+Tyu+HIRKoKbPvGiFxpxcjBcXbiwPpoDJSWhz75cVHlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048927;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=n9yKvv6T/ICVZEulMSkJHyFcxdZ01zu33oYTiajU2ro=;
	b=co1B0U9VuFQPhTms8t3nqu64g2XPUmMw5gqjodD5l+YPcBxAmayp0wnDD80AXilmxySb
	 59jFlje1KGQV/DRz8xe3GNBfBIf8YiBKNR5vog7WxvNd5fqYvCR9UgWPjHkPdoy53A7dl
	 0pH3fFQq4w3zmz+kgdrMX966/jYpIodxzfSbjdnemrsuw5C7lefyUddnGOFrVzmkbZIq6
	 1KrJI5Hmn3BiiMfPZnEIgjXyIdQkHak5m4xsBZOAdbQtSQM0nasJCplA2d9zx81msv85N
	 3PD6jPGwtUzchxGYSLsb+JQK3x/fG65FfsQXuWWMRa743SwJOeHVkKMretlZJ4riYbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnKzjt1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ED9606A330
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnKzjt1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F4D1F000C5;
	Thu, 19 Nov 2026 00:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795048927;
	bh=n9yKvv6T/ICVZEulMSkJHyFcxdZ01zu33oYTiajU2ro=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VnKzjt1a/Ng4FkyKBLjSuhpKtEZuNk5dkvySevSzoA6Wvzp5sB27gIUXoXFKl6mrF
	 e3Itf8NVXk+PYYq0Knqp8x4xYK3jkIF9llCDU7Dt4f61DlwJFUKSOAMqHX8PS00JgG
	 Z5GYjdBd5Gzu+vf+/RxIx/guql69T5GNpLwmdC01fiMmJaaOpMA0r8YyIWXhhWlP9c
	 M72cnmDsbK/ojI+c53m2Lc00gNQgMsR9m4LZXp7mMEDnkUmtMqmKdP4/zRTTbFaaet
	 kSa0UK5DuX1eKw9gvQyGQRfz7eEf6KUK1uI+oPw0W0tct9kv1XtfiP5tgXUz9OEJhq
	 gHMwygORRGcdw==
Message-ID: <sashiko-outbox-222259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 3/3] ionic: add devlink param for command
 timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
 <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 00:42:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
>=20
> Some device and admin commands can take firmware longer than the
> driver allows to complete, for example while a PFC configuration change
> flaps the links. The firmware is alive but slow, yet the timed-out
> command and everything queued behind it fail.
>=20
> Make the timeout configurable so it can be tuned to the firmware
> behaviour seen in production.
>=20
> Add a permanent devlink parameter, cmd_timeout (u8, seconds), stored in
> device NVM via a new device attribute, on firmware that advertises the
> new IONIC_DEV_CAP_CMD_TIMEOUT capability. A non-zero value replaces the
> device command and admin queue timeouts, and the firmware heartbeat
> check interval derived from them; 0 restores the default. A new value
> [ ... ]
>=20
> Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
> Reviewed-by: Brett Creeley <brett.creeley@amd.com>
> Co-developed-by: Nikhil P. Rao <nikhil.rao@amd.com>
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-b4-ionic-c=
md-timeout-v3-0-2cdb8fca15fd@amd.com?part=3D3

