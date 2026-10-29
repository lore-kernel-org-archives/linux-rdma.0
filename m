Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248590;
	b=rYBozGBjYTGB8PRGINfiK4ySmC5eAdtPaFhOmyzDkEPZNf5W0qlxMz+HYuEA9UdI/4CW
	 H+NldmcgqRiYKThs+0+GZQw7+7G4bv2Q0tyqfvsAvg7DEi5/uyxbw8iCfxtR36LInPpQW
	 dTk58NyFZ0DzZ+JL20rejwvIwqtPbXkjlixfYmJeRtqoYq3rXBtH+F77dLO3HpfQJNS/u
	 LxZu5A2MeCjN5uo+EXLd0Mt9TKdkGYpX+UuJpn+M/kifFSF8iXQvpw/NHYHIkqWoeqzIx
	 VvDcNfJ/1dYiYRim/lePafhiAGLqU0697fwpvW1NB7sqww54xeVOO0IwRFMlZ+SAdQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248590;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ifuDMZD3KIPB+g4q635d8etlZMjsm72hVYcAE00tGNE=;
	b=KqSe6GIV5DoSV8+tmrH+elR2KdJKUQ79U+mlqfNvSjDWI6pLfpiYNAkjIPW7hHalirnD
	 D1crK9VNKki8T4QB84svlRfwUKBYRryZ/DNf2jZmJuokfDpErHyoPclVPCn37M4y4tEpd
	 N4zEh8CX/IyyXq+irZc/88YU/g4px3TnAh2UKTEHr4D8BjtY/Ur+OCgNxWRZwA3JeyzXB
	 igsfememI6lrWYiL8u3zjiy1HAec71Jucxy4gsYmstGiDvIrPfMQvKN4+AaxMhV+SoaP6
	 9CsrQ5t1pYK7ma/9iVgbPup38gwwFd4RXUcVEAS3a1U/8DONkOw8TZnblak9sfLCwGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGR7gTmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2764606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGR7gTmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C79C1F01825;
	Thu, 29 Oct 2026 04:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793248589;
	bh=ifuDMZD3KIPB+g4q635d8etlZMjsm72hVYcAE00tGNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RGR7gTmUW+0ElCCVLWGMaXmCNORsgxYIMdOWael8rAiIftCagvI9eQeV0Jd1uvuiv
	 dl7pu03ywE4jfeed6Y8Ij6+CPRwmn9UYokCLr4OVbDLgR68HYJEW+Oehdh1i3rkCxO
	 TkSjJgFH1z4OTosdOipKYA/w0EKB5UKaMdXUb0/iuWe/GTvR842emFooyhPfBUkYU2
	 3PyC8jquMYftGRAzbrWm0LA0m6bPNeECnk2zahIUjo/eSilpKYj1FoyKvhoc3kHcy0
	 A4YKl8JdQ6S7iRD2Tg0ruzHilp2zyUoafKUb/3rBfsTKf8yrOBHzp+oRfmIce8gfxW
	 qR8b6YS/vntfQ==
Message-ID: <sashiko-outbox-188705@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] RDMA/rtrs-srv: Balance the session device reference
 in sysfs setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuqiang Sun" <izaiahsun@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029042719.75868-3-izaiahsun@gmail.com>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
 <20261029042719.75868-3-izaiahsun@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 04:36:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The session device is initialized in get_or_create_srv(), and the
> reference that device_initialize() takes is meant to be dropped last, by
> free_srv().  Each path takes one more reference, which
> rtrs_srv_destroy_once_sysfs_root_folders() drops when the path goes
> away.  On the failure paths of the path sysfs setup this does not add
> up:
>=20
> - rtrs_srv_create_once_sysfs_root_folders() calls put_device() when
>   device_add() or the creation of the "paths" kobject fails, then
>   unlocks srv->paths_mutex;
> - rtrs_srv_create_path_files() calls
>   rtrs_srv_destroy_once_sysfs_root_folders() when a later step fails,
>   but the per-path reference is only taken by process_info_req() after
>   rtrs_srv_create_path_files() succeeds.
>=20
> [ ... ]
> Fixes: baa5b28b7a47 ("RDMA/rtrs-srv: Replace device_register with device_=
initialize and device_add")
> Fixes: e2853c49477d ("RDMA/rtrs-srv-sysfs: fix missing put_device")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5 kbound
> Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029042719.7586=
8-1-izaiahsun@gmail.com?part=3D2

