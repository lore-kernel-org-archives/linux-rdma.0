Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769784;
	b=SRPxgfPbq0XHeU4e4hair4FCdEB51EwQj1INc1d7V1a0xJOIUgsoioEHGB1LQCUk5tI2
	 htPyGx1RyddOPdzTc0ARHKDX5txHuWJ6WLKQOtl3mDhjokybHnFcJPuYw01v46v3QzO9s
	 jN3zvkFxLj375p/ry2zpxmkeGgfCBVKOUPmNPGZIKAJf1vWBpUnxk57nsYHT35GmtmXrF
	 e7enWUX+fI9xPXf4Tk8pXVu8ToQS5LmSDuwFoQneLzk2SPsk7ETZpH/r2Z3yjZAwXBxco
	 /iJKja34QsJZLRr2jupMcRaui2klwcQvAeuW0XDnqQKtFOF8MxYkCF1v5QSKGxAGZAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769784;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8oQZI4qS6/Dre1FTzjKIHLDXJGtqK76PZ9L5dOy4RVA=;
	b=zFwdkOFcBkjv16/GT8eS1joXqPR8YD9j3amA7PZPaVZfEMcFAl99c+njuFKGrjSd0Y9E
	 JBePgEbsT/I2lXWqRHHOnF9ZGJXyyFfZaVwBuk7WWrnmJYP8dIdLogpLs3c+5ROWpT0lu
	 WupGllXAYeStU4oPbx7BhSFsRcujXbQaWo7E0tEnVwx4rBqKtOGlAd2zoJoKtHbmKvfdq
	 bIApjjoruuLUYFeX7Mu4sle53xhcZjPzBpqMRLmgYEUV7T90D97crmDro49sTDFnp3srY
	 TZA0VXvjtWlVhFRiDcO8cwZGwvVyeKotq2tzNjyoALD0DaBAKudP9yXQw+MB4oJvJZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ssz9nCio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF85606A31A;
	Sun, 15 Nov 2026 19:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ssz9nCio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C58A1F000C4;
	Sun, 15 Nov 2026 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769783;
	bh=8oQZI4qS6/Dre1FTzjKIHLDXJGtqK76PZ9L5dOy4RVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ssz9nCio334ME4ezvk8om0jN4I3e9B1Q1pJSy0ns9unFvbyvMrONLbDwjAX5vlZtZ
	 1XAxMc3muAx9GPY2he7jHo917Ey9U7mhofOPQyzv+ddx/VIvcIpuamCY5JaALuiPfe
	 2vSDHhGOWab6js5i5G/hxVM9cRDZVJu3NHkpAX9P2zNHIAWdMxRnXv2E0m3FjfOOAY
	 4ae+gZqmeTtf7T/g6C1yEgErlxRA2umX5aGdT/HnIOwdXOnnlC2g9BNSykaqs0iRW6
	 UZRUeEuooCDw52DWTfNvHiV9GXM0XhDgaA/KxR20hMRrLHOJ5nTgQ3Qg5usOID42qj
	 i6jRVPE67A7cQ==
Message-ID: <sashiko-outbox-215739@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] dibs: loopback: reset the client id when the
 owner unregisters a DMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-1-3b7050bddef7@proton.me>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
 <20261114-b4-disp-4e6374c2-v2-1-3b7050bddef7@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 19:09:42 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-b4-disp-4e=
6374c2-v2-0-3b7050bddef7@proton.me?part=3D1

