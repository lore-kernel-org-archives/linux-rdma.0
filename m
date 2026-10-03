Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CCF3A6F0B
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050192; cv=none; b=LTxh/OYFbAwLdYfbqdH6MQv4eNyVSlc/eRnkr9jVDDB2xYMoxJPKs1Bfr4r0onpp80GY4mxgrFEqqIAPzxOEzEGfMWnR2GcRTpfJ3Z1ycGkSOIBWsAhd6P8vY9i+li2o7n7/BoymUqXAEHbkHDDIWAjdQWmUrL5unh7zMiD+hbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050192; c=relaxed/simple;
	bh=1AsNx59MIivzGrcm0QU0X9Mm0OSfKsD7UWDgZoHueHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y9uP0tgy76VOHAburrld4kzbpH13JzDsSzaeQDoezrUKC3QdbkI6Afg916+Th2/zlHTYNKlUuwTeqzVtomUpfboL6JIVFV8u0CyXAb/IlM1h7v2vFhH5Ow8tKlbZnTZEnSu6sRFAjlXCuAQUTE9S2J6z5b1ryeNYErsQErtA/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZU2r4QE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZU2r4QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EED1F0089C;
	Sat,  3 Oct 2026 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050190;
	bh=CZe1e0q1JW4i+MTEu7C6G/5adNQlDunaUs6q0mlE78w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iZU2r4QECeWE4fQ9GmN1CuuSeztcWbs+VoEfymth1UwS4fZ9HwVlzwqse/P7/YGSQ
	 7DcNjnMfIfwN7encfUxzYsW0KK6NGYFg0Yg4t8A7Sff9gMRp2oY2d7Q4+mtRevebah
	 g0TOtj4hdKQoCvs3lMlJlpDcv6yEerBYnCGIaZruk9NRhodaAPDAn0NelGgFbAtamd
	 nMZ7+Z5EshWdLsjB12GDCCPKPtjXd3F6MuVF/Q1yjTJGUqO70ZX/NwEaNxJ+c/OwyJ
	 vw+9bI0PuKcSafk6gXMD7fLbTF3H+iOw3Waxmy7tTqnohtzdwdszEDuUWCxvMzDpW0
	 DBYa0Gklr1aZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 11/13] net/rds: hold connection references
 in lookup, sockets and c_passive
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-12-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:30 +0000
Message-Id: <20261003175630.C0EED1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Hand out real references everywhere a struct rds_connection pointer
> previously escaped bare:
>=20
> - rds_conn_lookup() takes a reference on the connection it returns
>   (kref_get_unless_zero(), so that it only ever hands out a live
>   reference), and
>   __rds_conn_create() returns the connection with a reference held
>   for the caller on every path: lookup hit, fresh creation, lost
>   creation race, and the passive-loopback lookup, which now also
>   holds the parent while it dereferences parent->c_passive.
>=20
> - The rs->rs_conn sendmsg cache owns a reference, which is dropped
>   when the cache is replaced or the socket is released.
> [ ... ]
>  them synchronously before the final put), and the sendmsg cache is
>  serialized with rs_lock instead of UEK's socket flag; rewrite commit
>  message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D11

