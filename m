Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365665;
	b=x9rR4n/eqG/hQ44wY4+8z/WBdRuAwdEqG8Fg4NBfJvVX0DbVbRETTa2lgVbXLdOyF1iA
	 0JYiligJ0+e+Cx1HWmzplOxfL67IZiBvNLyT53Girt1LOfZEbjp90/Xk29zGbqPaTVS7L
	 P68j/sVJLU1f7En7m7DxN2x1CKlJbJGP4C9uhLArmCbmFqAtR7XeXORoU31Q3RSbXHIOS
	 vtRX2DG+UR9R3VIhIeGkEYMJeti1CGLBNjtJajUvthz+RCDkR755n01uSLy1F2gURpv7s
	 d605Ie+usIE52Kk+96jKpsICCCy1AuNmDfXo/pUKwldgaRct5bsUVs8gPR7Lv14d1UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365665;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=x/7s27zIWas9CaJqwK35kN4QZZPVuB1GsCvKGEVOl4w=;
	b=0PzBA/PqwfXkPu3WTtW45b1YrGHkj2Bl/zigDNjMJu1JXOgTfLTnZ6fqqVKazMN0RTVX
	 8a6gSV+F/z17jPZ84XwC8Cx/10UhmbPTMNV3haW2AifXAnQCf0eJ4FlhE28US1wOkP2Oj
	 osm/CqeM0Y5y4/Os9vRHmkfnOMTCHxiFNKqsz6lyxHunEdSfct7eB17zY+YBGin7dgz7k
	 TBup+Rh+5hnKdxjCLNeivDw8BOpLo35mPSlYa56IUy4ps+7KfulMy3vA12KedrzpnnMK9
	 qRaABu/5tWGRd6zhLkJMF5fgbl1ht/6YrLS+nO6MQzDLvQbFm85hLZZ2R0v+NJLrLng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7AH4yIP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40498606A339
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7AH4yIP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CB81F000C1;
	Fri, 30 Oct 2026 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365664;
	bh=x/7s27zIWas9CaJqwK35kN4QZZPVuB1GsCvKGEVOl4w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N7AH4yIPwZOYylM1QeRknzWebWXsWv7762VTgP4J2jeVrifgxkhe6U0+iscUcRsGJ
	 Xug9rcqa3Fo3FJR2X6OITz/gnmVCzesIIoZwzo6LwCr/yUq01ZB6znMpUua32LSCxU
	 C97j6ChhiTJMSye615LOGWSfpZ+PmTAxXEOqw//GoLVV4ENfPVPAxKUgMkvaFJR1xY
	 BrfoQleOw+SAqDKXCahFjt1TM9RQOK63/mbfATJvcLPZ0MHc/MGtTEm0dZj1MhJaYk
	 nHmONizdr65n4MK2qaF2sOBOnBxT3Mz/xALw6gK2Z5sU3LfnwDkr5Zthg7vvSo0xn8
	 cyCY3W35BQEOg==
Message-ID: <sashiko-outbox-191046@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-6-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:07:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D5

