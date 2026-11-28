Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795865344;
	b=v5THdgA61iNPv+0nPR0o9H+WQ1BkBLdkmm+nCm1IIESF87FUVriocIESfOtNJffN642E
	 4A5Ua/yPXMfEjrQA0PgdpgEoDmFql8/T8/M9ea0Kmw/D4o6QTzhorkKFpZsd/kfI26Hcy
	 FEMIFO64SjBYpbbWzD7FlUb3jLrvlxRjMpQ4pRPbVKBptRh2bWTACNcPIA52ZOUfgIUpI
	 D9I08uN4A4pzpIwOD2ycpuCdC4QBXAuVPp1BJm7wyjMUHgV+9xftXgx4wwGSca87no0IB
	 kksT/xm208CHNnN/fWhZdrbQcqT0k6zQT+mNNNIv+sWIlZjk2fOTaMNXLz1YFzJ/1Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795865344;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8NS95ZTP0cURDMi38JEJv2dFh+ueEHSr1OUHaHwKwm4=;
	b=Eiu3unbWsh6CAUPFMrmwOWoHGU/6EZd+5xcGvEZEkKQ/4CIcuYaZG3hYSQd1Fv2iYx/t
	 PAMxbRmubXCf2WUf/TKPz7tzjICV6lSc8CfkGGK5bbWR5F++J07VBBSYi5eJDXp1uT20d
	 MF/xlnkbYuIMyjtNJbKRlw6Pi3IVv1mGUlcPPdr3edpSx7HO5A2voKccm6qV06TwAJmVB
	 osjvVdzii1YefEIpHOl97NySDwWWhuKsTYj/SIFZFrdPLcwRH+rXQb75GtswQr0hxD8w+
	 jZ0/suoi4hPNwdFtxCPqJLG310qFkYva6W+Ma3H4JD5HW/GZ8cFO9HUMVLDJArq1QVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T62HMt15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C689606A31F
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T62HMt15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03901F00898;
	Sat, 28 Nov 2026 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795865343;
	bh=8NS95ZTP0cURDMi38JEJv2dFh+ueEHSr1OUHaHwKwm4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T62HMt1567p0bMoCM7rkHnXXvrGfrWCEIOU2tar1xKhNe6jdqrKUHNgXf7tBtihKE
	 YYIrVP8R1b53X6POomUzcTP4JoSoJkIWIlYyHiy9Z7O8Ntgyb6W5l7041/P49CNZE5
	 PXoWOVi8Gcb7NZAnuyD2PRwdGm3ScZNAlpG9RUrXNAJfNEpvHrTec68uxE0fO90VDv
	 d8dfKawL/6HSR9nffbt48LSSAFpBXLCJK3uJIiIIkLWaO0wdMjUk+Aiye5vsgAAYBZ
	 D2AjwsXOix53ROZ9hyZNzDBDstht0hcvEN673iZjvkYUiijwePcD5hJklO272dNP9B
	 fbP7fB8zuCo7g==
Message-ID: <sashiko-outbox-238661@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/core: Fix slab-use-after-free in
 kernfs_find_ns()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
Cc: =?utf-8?b?bGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc=?= <linux-rdma@vger.kernel.org>
In-Reply-To: <20261128112149.7118-1-habilerenturker@hotmail.com>
References: <20261128112149.7118-1-habilerenturker@hotmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 11:29:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In drivers/infiniband/core/device.c, remove_one_compat_dev() unlocks
> device->compat_devs_mutex immediately after erasing cdev from
> the xarray. device_del(&cdev->dev) is performed outside the lock.
>=20
> Function-ladder:
>=20
> Thread A (nldev_dellink)              Thread B (cleanup_net)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
             =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> nldev_dellink()
>   ib_unregister_device_and_put()
>     __ib_unregister_device()
>       disable_device()
>         remove_compat_devs()
>           remove_one_compat_dev()
>             mutex_lock()
> [ ... ]
>=20
> Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in ne=
t namespace")
> Reported-by: syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8c2fa00c27ecafd148f5
> Signed-off-by: Habil Eren T=C3=BCrker <habilerenturker@hotmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128112149.7118=
-1-habilerenturker@hotmail.com?part=3D1
