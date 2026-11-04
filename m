Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782398;
	b=rzLv0C5KWR3T3bkYjv6uQ0gywnKjcqgghxwxJr5AEA3oW/mqgknYcOIXMJEt0M0gWDqh
	 3ulpipHQvzZKUBuDvsOaRcW53B1wU+dVu13FxNlEw5m9w8zTGe7FBhBmPfut7hI4wA5Un
	 NBfgY1KParYCPNhInYMTXcs/DtYuQjwrxEs1dDEHXGC1AigSFCUB2YfAD2iUXrre/vUvD
	 KwJUlsnzCUwUDUChLF1quoT4qQZ1xA3+Ht8uugrv8bMU6nC+Y8Y0SpTe2whmxGt1SCES9
	 4xbY0UezI7haxYVRdB7dMguyL5KOOk0+6C1w8b/9b9mtpVkUjT+wkE99HMvoMh8LNVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782398;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KvGsrUwxXtn0f5ShJ2oWjpR1ZQmufpPz+RLCJsUixPE=;
	b=ZmQS4VSxtwsLvptCCDeWzaKspTQCRiyfkiXvVvTsuZ7te9csTOCyFf0Hb7MioALTfqkY
	 1nvFImeU1ADqW+mx1qLitkkSe6b3ngG8gG/d+//kd1wsJp6o8miOISkh0Q5/aFkEoAcry
	 VixIpXP8LIRGM92aIlYldYQQD05Ni2oAeO3jobYqCAjThdfn/+q/9IGPnRVtrGgeBeoEM
	 qa4Ww3Qkmg8jxSezEhNT9XpAuhDOFS6442ArTb3GlWmoHRQyYjbJYVAgodfsIiT7qY0CB
	 rJA+XiMSFSwdAPPgf9EEcPwIwQMRtNk5Xtm7t/rFWI3UlUePQCEI+DGH/1LMQvgExPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fgcLsmzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD178606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 08:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fgcLsmzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BD31F000C1;
	Wed,  4 Nov 2026 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793782397;
	bh=KvGsrUwxXtn0f5ShJ2oWjpR1ZQmufpPz+RLCJsUixPE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fgcLsmzo8Yyygok8DV+TZ6Vlx+wDa9yLpjp3f8re0JM3Ago1D2Q3U2xpAYreZ3AuX
	 ATlZyUOBRLGQnW7/DMDCxM+GZPhBIno79JQq9T0mybDvVDPUACCD91KOWcVZaspCLc
	 g091IGZ3FydHzUIPTpBrQc/eCIrfVn9xu5otTCjXVSa9s/1Gx7miTujSQPPKzkN7y1
	 ODlS5WULh6WtsxFqyiKPZrzr4hU1n8YnOfxp7kFH6h7MjnVFm54jtoxGn0i9Lodbrb
	 HIphULjojhpyU66LMZeMErawsCuHcZIx9R5AsHsyxcwNuzoRtaYzlrbTfB5vIbzcuh
	 1sr7MDPtDvjqA==
Message-ID: <sashiko-outbox-196893@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Register client event handler after
 capability check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <179378222423.73361.3247716499619173751@jaeyeong.cc>
References: <179378222423.73361.3247716499619173751@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:53:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rtrs_clt_ib_dev_init() registers dev->event_handler before checking
> IB_DEVICE_MEM_MGT_EXTENSIONS. If the device does not provide that
> capability, init returns -ENOTSUPP and rtrs_ib_dev_find_or_add() frees
> dev through out_free_pd without calling the deinit callback. The embedded
> event handler therefore remains on the IB device's list after its storage
> has been freed.
>=20
> A later IB event walks the dangling list entry and accesses freed memory.
> The issue was found by static analysis. A focused out-of-tree test module
> on an x86_64 QEMU/KASAN kernel temporarily cleared only
> IB_DEVICE_MEM_MGT_EXTENSIONS on a SIW device, exercised the real
> rtrs_clt_ib_dev_init() callback through rtrs_ib_dev_find_or_add(), restor=
ed
> the capabilities, and dispatched IB_EVENT_DEVICE_FATAL. KASAN reported
> an 8-byte slab-use-after-free read in ib_dispatch_event_clients(), with
> both the allocation and free originating in rtrs_ib_dev_find_or_add().
>=20
> Move the capability check before event handler registration. The check is
> a prerequisite for successful client initialization. Registration cannot
> fail and init returns success immediately afterwards, so every installed
> handler is now owned by a successfully initialized device and is removed
> by the existing deinit callback.
>=20
> Fixes: 667db86bcbe8 ("RDMA/rtrs: Register ib event handler")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179378222423.73361.=
3247716499619173751@jaeyeong.cc?part=3D1

