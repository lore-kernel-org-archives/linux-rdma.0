Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407547;
	b=HPw79YkeXPy1LHwuuItQzDqoJ9S+sGpH+cQ7psoNLRDy2kGWu/ZGmYi6wfDDN/3PZagy
	 1WjHr5Vu8+uwpqPvONyEUsIJHytaox8fZ6k8ApoFpbMlFZbtwpO8ZUPu7lJ4+6BENwDWb
	 CahacICMu1lfdqzToo7QMFnAEE8dToBu0YUOQVWSwxAW/rd27TM+ZI6FYE/0canVS5qGA
	 MfAMlfmdahjEkBqWCstIqzPGyf6m75jmH1CoDAdUWBQR+N9vepVtMvFsvR9JkbG5u/1Gl
	 jkQihbJmMuDQ/VTzQRk8M1ywbuKoG/qn1o0MPo1eAJqU3Y4V1p3C/449ndW2itMmhqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407547;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FdQYuI2Y1YT2b83AHBuq3cbu4MsLQ2eL0AaLqP9jrg4=;
	b=2mZXh68ai4ifPnjDkwas6/4bzfSgBYoFjbReQg8/c+PATMrCl7AA28ZV2kf/qCxmmc+W
	 52A/ViQOnx/OYnGXnq5dEKnWMYbWUT9JSOwRvqOpEjZ+C0A2hnKMLfEizcysMTew+tdpi
	 GcwBLdbYh5pC/jPt3+v5FRh3QFRaJoHc6KMGaAK9h4flTitNO1L+hVXIXAB/ktnCT0/+5
	 o+brWS12A5YunkOUe4NG61QISKAPUVHDIeXWQdYWeomh1rzoa5fp8kE9YDqiZUFln4bMT
	 YhmlewfJ70oYGbRwYjxVWpQtf1TjNAEaMT3eZATc5QLJkZcLOHs+pMzc0SVrqXRCefg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+QVc6E2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55116606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 04:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+QVc6E2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A3B1F000C6;
	Mon, 23 Nov 2026 04:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795407547;
	bh=FdQYuI2Y1YT2b83AHBuq3cbu4MsLQ2eL0AaLqP9jrg4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H+QVc6E29DSj7wjtqOkHhNeTosygdKXOnVTeEDSlUkQxbBPgG+mKBLmb0/7rpU2v/
	 wY068OGwu9LQIi0DZVSgISHU/fY0FMbr0EPMvwJxz1sCJUIuU1HCrPCABToUndCSJd
	 z995aBikb+fY0J9W9cbz63iXLmkY0e/qh5Yp0v7AsZs68mY62xo25dYum8pUutpk8B
	 NTmLj2FsXcSGsTZsb3r/Tys9WhrHIXxShRJgnsIn/YmVFMiwY617Icxl2Z9tX1p+52
	 9A8aO7CVhwnblQLModFFNTaPPutwcdZa8gC5PqsQ3G1LoS7eehKgiM/s2aH3oD6N+q
	 sfru6w+jUEH/g==
Message-ID: <sashiko-outbox-228651@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] IB/hfi1: fix error paths in hfi1_mod_init()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123041556.1888113-1-fuwh1120@163.com>
References: <20261123041556.1888113-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:19:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The error path in hfi1_mod_init() is not completed.
> Fix this by add some goto label.
>=20
> Fixes: d63730192f59 ("IB/hfi1: Reserve and collapse CPU cores for context=
s")
> Fixes: 48a615dc00ae ("IB/hfi1: Integrate OPFN into RC transactions")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123041556.1888=
113-1-fuwh1120@163.com?part=3D1
