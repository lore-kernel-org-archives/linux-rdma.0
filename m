Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795713586;
	b=CTtZ1nvPjNCDM2PraDK5rSAVPbht+6mqhdOZ7CUHvrawT2I0W1/DoAM3tCwcw0cOwiai
	 IRFG+6FNatylHI4ISfEzQLO6YfIbsEd0ZGMuIYZeg1QWp1qkS2SncbEiAJ0cl03IVaDHm
	 zdiQ7LucL3lChwjTrDu4s8AUiCAUEHPuJ0AL2bC/zBvmEq4eeKOnv066tcQzuJ1XFyCGK
	 fbkTR9lC36l2HrJhKP1AoorL9ZNW4mUY11rgxhemo8v9x5jPdIkiBeDZiN+nZ8HzHFIHk
	 Aq5OUJlCtM/UXS49e7J1X0WZ++wbiqnTVFpsYwjWPQMi8u+mly/HO2ikaHZ7bAdWyyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795713586;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IfKg48VhGkQM+GvrRvefbqkH9K7RGEaxhYUK4xuuIlY=;
	b=MBZohHqFEl7JXa241eqpyM9YqEiEu9b33hQuzldCMetqmFelHVkUMu1VZHDtoQsIin8d
	 Db6lN9fPPOgANBge8Y2Ei7B6c/aUvNHzbNtLo/iosd5eNLstWsKq5UCkRqUg4drqcCcf2
	 xvPa3mTE0RtZlSuRGSQZMOWHAkNgcO8BgOuew/6Dbu4L3Nq4mO/8m0LjYK6WO1K1rbR4J
	 Kgw/+slXFGxGAvLDVmYdBe9wS3Q/kKmXp5M7Km2JlemZaLlG0qtG3pkuEiFmoD8MeAFea
	 Xw2HFHl81nqBBw88/dW6GPrzv7D9gpXiDM9TytrsuXH4qkAsBoDW8gABimyE7/F2h2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4j1O9HX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE2606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4j1O9HX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1691F000C4;
	Thu, 26 Nov 2026 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713585;
	bh=IfKg48VhGkQM+GvrRvefbqkH9K7RGEaxhYUK4xuuIlY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4j1O9HXZtIAt5GHDLYd106141zT0LhBDvMBjkSZ4xHDda7x949J3h0tUJcvjhg9p
	 TmI4H/uaacRcVNuH9it8CB5ehlOUhdo+bt2W1yk0XnQy0L9jvjqMsCJuaMdrSdOvWk
	 ZIjO+03IRV3wRBEpH68FC91n59ClgJh4xaOac82zRuQ8ZkeZmmoiK9d+dLOyFsBGNi
	 EUh21+0T8BACoKQ4opzxU//Pqse5WDwy34u9Cex9WVY/TKBquL+FqE27VBwOHwIstu
	 PuSWcV8uy7kTC2+ZqXwDioNSyB7T5rDIuOdIiX+AVt/DRWXCzeQ6R00PZIuU3BaKyn
	 xqVFcZxdXgj/w==
Message-ID: <sashiko-outbox-235970@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/cxgb4: Use dealloc_driver op to fix ioremap
 leak on alloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126170841.11048-1-serhatkumral1@gmail.com>
References: <20261123165128.GL179082@ziepe.ca>
 <20261126170841.11048-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 17:19:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In c4iw_alloc(), if c4iw_rdev_open() fails, the previously ioremapped
> BAR2/on-chip memory (bar2_kva / oc_mw_kva) is leaked because
> ib_dealloc_device() does not unmap it.
>=20
> Refactor c4iw_dealloc() to take struct ib_device * and register it as the
> .dealloc_driver callback in c4iw_dev_ops. Move ib_set_device_ops() and
> the xarray/mutex/waitqueue initializations earlier in c4iw_alloc() so
> that all ib_dealloc_device() error paths invoke c4iw_dealloc(). Guard
> c4iw_rdev_close() with dev->rdev.free_workq so it is only called when
> c4iw_rdev_open() succeeded.
>=20
> Update c4iw_register_device() and c4iw_remove() to rely on
> ib_dealloc_device() and ib_unregister_device() rather than calling
> c4iw_dealloc() directly, and handle the case where cancel_work_sync()
> cancels reg_work before registration runs.
>=20
> Fixes: c6d7b26791a2 ("RDMA/cxgb4: Support on-chip SQs")
> Fixes: fa658a98a2d0 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and=
 T5 devices")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126170841.1104=
8-1-serhatkumral1@gmail.com?part=3D1
