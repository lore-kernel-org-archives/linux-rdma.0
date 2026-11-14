Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794664654;
	b=skwxfRg9dsUpWO5br2dU906wAf5pUoFwWDpXq1Pp72Vky1/iCYOdaGWWqU3Bw5J32yAp
	 vigl8VM81NHJh7cVB2Fi1d4OTNW9+JrKxAsfItu6GpbBuWHT3+vvTM6l6UHo5IT4C9EqI
	 fLifD01qPpOH1A1WwTkhlpI/sJSIakxdV4g9nhlkndLbaS60OsduOxMEgUL+gHAq2cR6A
	 8qj4lGuoobWHBI3+nRIl1e6KcE5EWa2JjEZjeHBuXMbOSw/0Um4kJyO0T3JDAjnu96wcA
	 Znmvomiq2R5+L/WXmZm6O9bavzALcnMqXycvFQQCONaRFctUftR+KOqCglkLi+0PvPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794664654;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7XMIMPnX2FNV2ZVuBuuAfrmDZ/UMs9vI8kkjfWgStys=;
	b=jETxawRjhqo/4FXn/KOfz+jovVRJmDe2QM9v+vBC2tRgGK/HYnOkA+EqnRWzz5QjI53O
	 BZtFzI+S115awWvqMErhfziNIWhBnb3CxPcmTYa9wTwS2sGNDd9cd++lSr9fgo7MaGG08
	 NbyFPIs0o7z2fWKjzC7Hqrw3HppIh9BVZpyNbHtex6c9vTkdJQOxx9oCZ1vgUW/S6IAxK
	 /W6Aft8x2oJEQDTvtPgbxqQrJD72r9wNllhaLWX1XKFqojJLqWrTKtJ2cACZXMsOkFhUL
	 8X/BUj3NtBh4G/D47I2YdnLk6/6omFCIZ4GDUrMMebvVo7UYyBszYDDNDKaVLpJFVAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1tosnVj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735B606A327;
	Sat, 14 Nov 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1tosnVj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E151F000C4;
	Sat, 14 Nov 2026 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664653;
	bh=7XMIMPnX2FNV2ZVuBuuAfrmDZ/UMs9vI8kkjfWgStys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V1tosnVjR+urPo6lXkiapyoNc2dFlkPx+Kniw8dTKz1OeVfI1De9mLtIDxsn46ZIw
	 Ign1qvtkgYOha4kdEtQI+hvSsfOlkKFk8/y2USr6nJ1woegVCOkCREBcVH+4dTMFLV
	 dLcSC3oX4EH5Ay/S2HGbrjDCVRlVPO1qo8S/uZPRe7on+frSgqgcqK0IC0AvlE7v0Z
	 le4sJdSRiRPtuY7i60JxiJ2ESQAMbIXB3LutRMaKINef50xVy01hz7vYFF6RGDp/Xl
	 B4FcQ580JChHwf90SVFkhvLZg6RwpZegpqi0jmHwZlesUQ4z/NufALA3NQz3P1Z31t
	 7rtgmByUzi/dA==
Message-ID: <sashiko-outbox-214597@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/2] dibs: loopback: reset the client id when the
 owner unregisters a DMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-19244662-v1-1-39b256b70ca7@proton.me>
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
 <20261113-b4-disp-19244662-v1-1-39b256b70ca7@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:57:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> dibs_lo_unregister_dmb() resets the DMB's dmb_clientid_arr[] entry only
> on the last put. If an attacher still holds the DMB, as when an SMC link
> group is freed while a peer is still attached, the entry stays set after
> the attacher's dibs_lo_detach_dmb() frees the DMB.
> dibs_unregister_client() then warns at rmmod smc and returns -EBUSY,
> which smc_ism_exit() ignores: smc stays in clients[] and dibs->subs[],
> and a later dibs_dev_add() or dibs_dev_del() (rmmod dibs, ISM hotplug)
> calls into the unloaded module.
>=20
> Reset the entry when the owner unregisters, before its put, as
> ism_unregister_dmb() does. The index stays allocated until the last put,
> and the attacher's writes no longer raise an interrupt for a client that
> gave the DMB up.
>=20
> Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-19=
244662-v1-0-39b256b70ca7@proton.me?part=3D1

