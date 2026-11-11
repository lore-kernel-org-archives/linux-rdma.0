Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389768;
	b=3+U7SLhBsdxxcB0uup0/l16vPSo/ZAFAXQCZY+PZGKrcb3td9qI0155943Calc2FrwD2
	 ke0W7bnyeFW5WPL+m0WDtSPJhgAsorWjm7YoSM/Nbz2bHLPzSpX0upgiJpLTSt2kDc7Hh
	 PTU6Z2sMrjQcKlcTkfLoc8Rs71odtfVgX64FvuVkjxXSXxAq6KM2/nu+GWjPJkXJq+ali
	 VcRwqgHH4UFY2GZIKduUyQfQ1+EEtnK5V/TSXMSULsiNuBI5crWAxF+dqQrhntRlEcb0p
	 aBWMWNxvT7wG3PGtLLQmrkER0pijUWszYCuB+0B5Y8AN5LqH4FbkoN3dS8M7epecu2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389768;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MtiNLl/Cpt+IOpr9Ztv3KliDou+hYUr7uwT92aNMqQA=;
	b=bHKa5rpKrOWPaBbpVCXfnFlVNqyD7z9ODCHJZuZH0ubTJsGZNxtATKioZ/CXuqgQkSI6
	 n9AZ/Mh/QT7D/eVX27lL+OrSzkF14dHeb4KH0CcSkelh4yNHCXXz/PmyhH0ZyKGAOYalM
	 wdoUOkcQwA5ekWSg15VSscOE0wbBSz2raGnv8towjZrYkI9w29l3xRMpLNfejM1yqlL3/
	 KRpL55o8CfriwF9Jn7VThbS4/9NwfTesIWNnLQ4Xc/IPiPoay5+4FGkhO1FuVaV2/MXfc
	 3KY3Tu8oa1XwmttXM9sD6M9mckUHS65wNTuMwrxGJVjO07VqGBU5YUBenj24ak7iDkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KKlO/Y9S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9214606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KKlO/Y9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C271F00A05;
	Wed, 11 Nov 2026 09:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389767;
	bh=MtiNLl/Cpt+IOpr9Ztv3KliDou+hYUr7uwT92aNMqQA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=KKlO/Y9SHN+j9XiLHT4GsnClzkjtg84GbTa075dvq80w0p39B9uc/9Wmh5xdyRaFw
	 lYIwm3IeLrY6XTcX6eeRh/hmo+cXUk0ng7e2cNVOQgvCZbGLWKCo4BCvz3hnpNBPN9
	 18svzmCaw6rvJuAQK2qcl27syFEl2RdcUbj7h0mtCElJBv0t7f8cDmP7BfmexqaXBE
	 pCdsP7yVzlS69iMI9Da2EMxk4ZrlOAggvqwvBai6O2MLqsxD52KFvhCXUe+NXH9UdN
	 Q2R87Z6QVW1QvF3rO+Wj87ywNDVCtPREjIUK/OWmAbH7qrsu3wJloHCYIukBqEECX3
	 Gcm5gMHUu7WSg==
Message-ID: <sashiko-outbox-208705@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: publish APBVT entries after hardware setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>, linux-rdma@vger.kernel.org
In-Reply-To: <20261111092505.3121847-1-lee@jaeyeong.cc>
References: <20261111092505.3121847-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 09:36:07 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> irdma_add_apbvt() inserts a new entry into apbvt_hash_tbl before
> sending the CQP command that creates the hardware entry. If the command
> fails, the entry is freed without being removed from the hash table. A
> later lookup of the same port traverses the freed entry.
>=20
> Removing the entry on failure is not sufficient because another thread
> can find it and increment use_cnt while the CQP command is in progress.
>=20
> Serialize APBVT additions and publish new entries only after the hardware
> command succeeds. Since the allocation no longer runs under apbvt_lock,
> use GFP_KERNEL.
>=20
> The issue was found by static analysis and confirmed with a KASAN
> reproducer that forces the CQP failure and retries the same port.
>=20
> [ ... ]
>  init_module+0x210/0xff0 [irdma_apbvt_repro]
>=20
> Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definit=
ions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111092505.3121=
847-1-lee@jaeyeong.cc?part=3D1

