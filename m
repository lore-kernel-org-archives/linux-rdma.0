Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978024;
	b=jAE2FmQ+B0p2qcQN1rQS7hdkwVehjFtC1ep8BsLGMN9U9sOCBTdNS5P1RQzD3omhQBME
	 co/8ymq5/cmCZrarDKHg/jYD8E1pypy9Jw9HwUtdb19xj4tD/S4wL6JMPusmR3xa374NZ
	 gvhrwTQr4hun/u8XJVDbmCv16uTqp5umFxxmjc6T4UU2tYixbL3+AJenNQyM9wEvpfmBH
	 ih/JToPM5QKwzWD280Qy3BzQLaqUklBclrAHDzOHDhQ539YcTPYWaRQN+QKE65KVmasAN
	 hVZx/3W+xt5CglmzIbRNk3sQGTW3GzWG5M6GxXomlUjyrG+ALno2qzmNcr7ZbXRAmgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J5rG0z0pLAIblYhJgIpbeDDyd8/A3FdGShjlSO9BeL0=;
	b=tSz8fb4EAnBkV+fpGff/NVOvHz2bgGUYJYEbU31Zutpbh8nLhRHO+VHRF6CDdIsXBXEc
	 xF68qhJMbQpu2Rsk15orOfH2L+6umMe9gX4LFfSBSc08OgqCKvQNY1Q8kwpkQfO0foXJ5
	 q4K3M9b0LvUxuJUBhFgz/WtAGH0Bpnm8J00HcXsk1vPi6iTOSkTd9x6BJNuvEUpY0cKXy
	 mt2Kz47gjR/CXY1HLDFjSO9sNS1bZQaPuo9+SF2B/Oa1MxUW5e7HVEbohIb+wvjgPlqqF
	 8PAFCWx33iNgo11RUBv/PvTm8KckypUnwu5fnm31HY/dNX0cPSrviL25mLeB/IcTVnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TH8hG9/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ED6606A32A;
	Wed, 18 Nov 2026 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TH8hG9/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675101F000C4;
	Wed, 18 Nov 2026 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978023;
	bh=J5rG0z0pLAIblYhJgIpbeDDyd8/A3FdGShjlSO9BeL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TH8hG9/H+dY+sc5sCImQ1G4g35ISzHdc3agupDF7f+LngWs3GrSK6romknjvydrhQ
	 mDSviEbuwF+f+ATIYGs1/LpQ48chUKBCx0CcotxEr+gNzj0Pb4Yzpu/jKJbU4M1ZXR
	 UvLDdykZaDKNYW+566SyaeIJSZ6066LVQ3ZTOpGwrW+zgITiSAdfMBgScX/VUfOSPj
	 rgnIi+9BQr05Cxd1cBL7IuepojqxmmJDM0uAwMQO8ixQnulDWzHsXgD3QXDtaKdR6y
	 LeA+UtmYggVi6sTFuGglpzfUGVr3DRyN36GYqSJ15GuXO/lpy4OyZaDME4G43+bWXt
	 o0bJhmNak0nJQ==
Message-ID: <sashiko-outbox-220135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 5/5] net/smc: annotate data-races around smc
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261118045137.174026-6-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-6-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:00:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> autocorking_size, smcr_buf_type, smcr_max_links_per_lgr,
> smcr_max_conns_per_lgr and limit_smc_hs are read without any lock while
> their sysctl handlers update them with WRITE_ONCE(), and the SMC netlink
> handlers toggle limit_smc_hs with plain writes. Add READ_ONCE() to the
> readers and WRITE_ONCE() to those handlers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118045137.1740=
26-1-jiayuan.chen@linux.dev?part=3D5

