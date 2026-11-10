Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284471;
	b=mamIDUeKGCwTgZ9/j5Pv6k3/JUVjBvCFX2KB2NBNE/6Q8XwvMB1yuaI7zW8dcY2fRXE2
	 nOW9uraYfsc8Q/oshtyENYoB3tSY5PhjAPD8L7M63JJ0wltLCUCMPM1GxHAgSrO+mK3Xx
	 Vjca7tb26Fpx47MP4N98wW7G7ABikOR32i8hlGlFKVRAle40LfycGjgZkzTh7gN2/r+wg
	 XkLE4Z0JdSrfcZYvKpcVpx72e0/T5IbGNyOKVchKdCmkOAlVRLWzLJ9yfbTWLLRr3ACor
	 eLbChf2GxKqnHiCGyv/f2txRhCQ5KM+GTrnCvxPyVucrd0YLRH+CwrvX9ZNVSkv3QDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284471;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6DIo7bJ4dadnZcorH+F6AlGfkjDz9D0pBxLoKXAx5SY=;
	b=yAz1Kbfo+iUiFN7X8R7Ne0rShvDvOXOdtXS4/iOf5x1mw+fTYettx821REHWiS4O3JL3
	 ne4rsg/FLWCEggph7bLxJOKV6VRBU7cUoHRtxuV0roZWWmA3mLGaKbHgYmD42TACf4Wt4
	 4PLUs8Y3KyWX7kh5pPlgi7wEH0VKV6CtM+bmjIuWOmB050uL1kQxumzhIwa9cjVsLRmAK
	 onSyag47hKKcF2fBr8nar9sS37h6QfDsd5e2EOiuErrlBBrtDBV8CYEBwpCLnhMRN+Nz/
	 6jbAbcZR4Oj7d6LS5IjbDR9zem3kVOulYhgvSy9V+94CQTRZtrdWGIW6Mm2gHN9TfIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fogp82My;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E71606A32A
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fogp82My
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806CD1F0089F;
	Tue, 10 Nov 2026 04:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794284470;
	bh=6DIo7bJ4dadnZcorH+F6AlGfkjDz9D0pBxLoKXAx5SY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fogp82MydGH8MAUPknI7ELFWMm3eXCrX9gUwcg5e13uopil/JN9iliegYG9fUdPz3
	 0NlqOTKOetkChMutIC56iKCMLP1l6UCVi+DJa0HOaTYCBVnU1LYZU5CCYewQSFN7O2
	 mwDzoPn+p/3A1oGUwzsHhzh9yfQSkv97js/KIwOcUndP5pBAZccdyW0TIWScazMSrs
	 GhqF6aEWxWngxDWT2qjQ8qRM5dSXOjsk2HpwqxsinyGK/+RwGPNT2yLKD4IkjInBDV
	 HVPsVCmPObanHCjFcAuHYNr50SqoRhcBHA/wPWC/ZvxJuK7p3nuL4KeI21Dzehu0/w
	 LCamYd2xUQVHQ==
Message-ID: <sashiko-outbox-206186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 02/13] RDMA/core: add the UET GID types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-2-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-2-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:21:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Ultra Ethernet runs over two encapsulations: UDP and IP. Each becomes
> a new GID type. A port can then hold both UET and RoCE GIDs, with the
> transport following from the GID a queue pair is given; the driver
> enforces that.
>=20
> These UET ports build their GID table from a netdev, as RoCE does. Added
> rdma_port_gids_from_netdev() and use it where the code tested for RoCE
> alone. The CM has no use for a UET GID, so RDMA-CM never makes one a
> port's default GID type.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D2

