Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795835441;
	b=f2pQOoYr0jYXIJq/9/yG6c9Fop+td6j33gmzVAZoighEk4x/o4eacSOVSi8TJg17DEv9
	 S5LjEIhwUXsU8vm277SuOnnPMxiNfFHMLJCiebwQY9MMHTpzo3D/aDklcjlxKQFzYgRp7
	 8YNUgAnG2LYX1GKyTn/YfbDCMBJ8rNm/HGfrKoYSDysytF39TCECbK7PGqp6b6ZknF5KV
	 WA25ZB9hZQ5Mz0egdcmigD+z0ZLEVQyz8LSzITlkwaPeHxSwN4ooCesJYpdC2bsn3ydJ/
	 xCij9vueIz2sb/ppqPjCeDnnjvONngAZQGuax8TyFUaVdlAycg81i4EiQjHwSwztWVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795835441;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9qxO2k/5k40bMKbElmsAoEF8T9nZYAZF2OZRfR96RYc=;
	b=cRt43AvRxBjO5Yf7GE6a4xZVCsDDrseHqom4Ynx06qynB7MHTIojaAj6peO6hRp0vCsH
	 8SYVMseBdddEX9rSBvHH2senSq42ccgQpTYzGzlEoA/jkG8Rziqp0PifoyohWKFB8MXBM
	 XPchH7rpI6wGyEEN5y8QhJCwaQ4tz2VOSuZpU3UCzg+uhpyE8hZrpanbDcCOghB1Cu74T
	 eA93seMQGzfZFFu1lKpLH0Bc8mvFmXw+YnC56Tsti0FKFNIfBlGkfSFebL1ypCyMcjaEl
	 aXEXpx+Ji/e1xJg0D7UQB+HwTA0FsB6mhth7Mr7ZYD96oCE0mUzSR4OBgtCWllWbEzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUI8tf0y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763A6606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUI8tf0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE82A1F00893;
	Sat, 28 Nov 2026 03:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795835441;
	bh=9qxO2k/5k40bMKbElmsAoEF8T9nZYAZF2OZRfR96RYc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=KUI8tf0yAblyC41y21IOlINeAvfvdkoykwFvXWTZLRj8pbLESVd8rRp5+PBOBig9+
	 EA2DAx2/koEDxwVvPAlHmxu3LYofbl4kzkaQx4+LzWk4A6/mZUR5+ChqJyQJB0tzDf
	 23ZCIgoFyZH7TtWQ4N1Hd2K6IG1e6E2TMsD5s733MHgp8bEEeaWn7VO4DJUbrsmesF
	 klNbtehOuBx//HClSwJ7x2AXR/ZSeHlGeIeJq/xnB6oTmGCTXF3nu7KgyogGAouhRC
	 +lefuWTkp8GNkSwWmoFGPakea9dxm9j+VThwzRsp1H5bO3frXfpbTELOCGsJukayDI
	 Ad5BNpF0Q7C+w==
Message-ID: <sashiko-outbox-238431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: remove listeners before dropping their last
 reference
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>, linux-rdma@vger.kernel.org
In-Reply-To: <179583481252.4059565.5258024221855710290@jaeyeong.cc>
References: <179583481252.4059565.5258024221855710290@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 03:10:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> irdma_dec_refcnt_listen() can reduce a listener's reference count to
> zero before taking listen_list_lock and removing it from the lookup
> list.  A concurrent lookup can find the zero-reference listener and
> attempt to acquire it during that window.
>=20
> Serialize the final decrement and list removal with listener lookup.
> Perform the remaining teardown after releasing the list lock.
>=20
> Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
>=20
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179583481252.405956=
5.5258024221855710290@jaeyeong.cc?part=3D1
