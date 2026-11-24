Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795538623;
	b=APe8PalsV9DyI8SzUAbTHm6hi5sftxgVKuqwPUcAn3ghzRJsFAAlExVXvZvRQzxkbmkI
	 Buyc41SGP8qkA042Wsyb7TVG2eOFgseQv8oiUtrgVaNOnlC9Ti8TPYOeIbJwAiekrwC+O
	 n5BsUUbU06VdEwU7saN4Zmmz5ZgXFbVG2By+H0upFs6m3t2Zw2/i9N0pH/m02ff9frGoT
	 qYS9exGV+2hIhttzXrQFCSvpEoNfqIJZdOD9RI1cLjljrnVV6jtl+PiN3G1XWYFuDQGzX
	 GP32Z7igzLw+Jiy/OwWgHGrp6OMxqdZnL+luGMM0BqxTRTuOVZSy9xiqAAiQnwgRXhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795538623;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lqnklQq9VIO/A5jr+DKMjVb0vbYWB/UQ46eDdeOnq50=;
	b=JnkFOGdh+RDKYNAg01idkwYVTHXno8enXApkSL4rpLoX9IJDiixdbNk5//rwvJ1xDTch
	 bxg4enKxXlCmdnSWPrAZiqZcw+4SItMbYjF17uUacB3kLI0VFpwKLTVLUt6oAg3T8S54y
	 SoBj5chEYOFiznkAaEvQxArPxpmyUaeb1R6DfbRbjlUkFCV5r4eHNRDE/g2cuyK/42tnA
	 czOLOmSYkgOdwO2NB9lG9XmqOrK2VOTuxh9En166Qt6b4CEAu9plDIkAnibfwGeFAf8U0
	 PHV4F8Jm9Rb4R9UXJ0WtFSyENnWfDHStGdXamJXmwx7L3Jcan9qE86oE6YtOuFD3BCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjh5FskG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13507606A323
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjh5FskG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED71F000EF;
	Tue, 24 Nov 2026 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795538622;
	bh=lqnklQq9VIO/A5jr+DKMjVb0vbYWB/UQ46eDdeOnq50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jjh5FskGXkMhfnM+XeBgAccGEe4QHGzrrdB4gshNM/MiafT9EmXzmt2y8/4KMoPgM
	 /5epDGmH2AjOlJLVC3uZP5mLUIC3tlbMv7lLljmRHytlVoS/8ViecPDo69UvnuEyKv
	 yNvVIMLrdyeLGZ9U6Wxylp/UQTwnQnD5GmXPSH5yowxfBOquFzusDU0VoVvhWGdA0h
	 VrWkILlbgKdhgi2rsKGD7Ta0SR6WCDNeCczPPE3yGhFmHE1CcoJ911ItIvmjMW1iTm
	 7K/roHSa5CNvBqWMEc1DFCjh8fA9b8vEI3a2I3yFkOWvII83SMHu+j/L15KswvC7c6
	 Gqd48BMTeNSdg==
Message-ID: <sashiko-outbox-231584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: Fix slab-use-after-free in kernfs_find_ns()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFiaWwgRXJlbiBUw7xya2Vy?= <habilerenturker@hotmail.com>
Cc: =?utf-8?b?bGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc=?= <linux-rdma@vger.kernel.org>
In-Reply-To: <20261124163151.50468-2-habilerenturker@hotmail.com>
References: <20261124163151.50468-2-habilerenturker@hotmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:43:42 +0000
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
> When IB device removal races with network namespace teardown
> (cleanup_net() -> rdma_dev_exit_net()), rdma_dev_exit_net() calls
> remove_one_compat_dev() and observes NULL from xa_erase(), and
> returns without waiting for device_del() to finish.
>=20
> cleanup_net() frees struct net while device_del() is still executing,
> causing device_remove_class_symlinks() -> sysfs_delete_link() ->
> kernfs_ns_id() to read ns->ns_id from the freed struct net,
> which triggers a slab-use-after-free.
>=20
> Fix this by moving mutex_unlock(&device->compat_devs_mutex) after
> device_del(&cdev->dev) finishes, while keeping put_device(&cdev->dev)
> outside the lock.
>=20
> Fixes: 4e0f7b907072 ("RDMA/core: Implement compat device/sysfs tree in ne=
t namespace")
> Reported-by: syzbot+8c2fa00c27ecafd148f5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8c2fa00c27ecafd148f5
> Signed-off-by: Habil Eren T=C3=BCrker <habilerenturker@hotmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124163151.5046=
8-2-habilerenturker@hotmail.com?part=3D1
