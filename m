Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401951;
	b=DfcsE07m07rlt+puF74qcWVRYRUnkm2Q+SMrCVRvJPhkZUaVGN8cq2rUqaoKWaLcOxWn
	 q4dgFZ5ujoUDFM6YhBJWxOXUDWZVMzhv8pATHDoACsuBF1GGgboqMptOoSnMQsvxKGwqP
	 g1/PYmR9S/Rk+xDPRjHUm6vDkyy8tC8J41WwbMoOXv89OGS9AcKsqTHRi1GYweK8IYjA0
	 3vWhQY67hz/gLB+y4wn9a2U5sGuTK4u1EINNzx6x2qpHdTuGFKyDSWNEb39xK9Fnl99Tn
	 AArGdRo/+QV1n98WRXWUHnRoKNtyWbd3WpfKO2RH6W6QmdPfQmUv//A/5Ng0+IZN82Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401951;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7pWQ13DW6l7PAhKyniXg2wVMsA1M9GB6tHx0jnbmghs=;
	b=t0UYZzHfRv/om29BZOrALdOJK7/XdnmO5iWOdlgAdRLF0SwnwsvBfswY02pn+QmEGaNX
	 1NIGUH1pQelRtjyCZ9ZeUWYubrdNxqq9AOKc9K9OcZwyUi7eoIhhBpddPDKmfGdXCztpv
	 3oTgcmRUYheYf0ibBQ/60G4ZrdGGylYmwZU3otscxcrXwV47G1dYk+mMvm+hKMzECkNRS
	 W7x4qdK2dkfly6hUgRakhXwjDCB8wdtSYY3qHLgCvNO3lROPMPEMeg215yDx+hoUsrH6q
	 mdeYFDKh1fBedioFgNeCX6EmWD5lrAQYcSs5lmOHYqd5IzQooPvc8PGclVgY6OIRLBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzASDlBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F0606A887
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzASDlBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44D81F00A06;
	Wed, 11 Nov 2026 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794401950;
	bh=7pWQ13DW6l7PAhKyniXg2wVMsA1M9GB6tHx0jnbmghs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PzASDlBx41Eq9gA6UH46ft88VGFVcVliyb4gfGj2a01O26x3palARcuPrKMdmVrNO
	 eoMZ8IL/REs7SPlxeloy7+6Wyy3hXhdM6JpnCiFUH0w94e4/3PnwT0jhGZYC1KLRKy
	 CTI0hpcnD9rdDG5J8aGbuwb1j21397YORJan2k29AvadxMvDXG4GywgVWlPLH9UN7b
	 C8HwDsyBNxgec9HLi779zofGvGAbQzTevSHrTOLBvHEPJI1hn2B6qtKCChXYLXw4Bh
	 0uXEE7Rk527aolgucbnoI/gBWFfX+foJZEffVOltdDwRuhywX5WXYIG86zOa0PAbeY
	 lM8TGUqdbXnow==
Message-ID: <sashiko-outbox-209029@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v10 5/9] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111121417.1265896-6-kotaranov@linux.microsoft.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:59:10 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111121417.1265=
896-1-kotaranov@linux.microsoft.com?part=3D5

