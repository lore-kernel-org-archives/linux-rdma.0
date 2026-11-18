Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978020;
	b=ITuwWS1GsdidDSKG904O3C13saUwJUXOvkUJLwCDFm1juFI6IFBVHhkIXrqg2cOsXd/s
	 EDNmtI9rWpScIvsRxeYjGrJ6s5LtihuWaJradlJ/0F4TKnxi4mIyZYpfvn8W1/Z95g7yQ
	 kI906eNH6gcglF1dyiBD328VDeC+Ezj93wfBh69ulUrOL6yg0wT/5KMAQCfUIn1mY9cCf
	 Yn/2DZ6bh5IiE2Z2BFz1iFJV1tO4pbzk5+hZ2/9zPJTGIK++ZIQYqB1Grb8glmJcWF78b
	 AEs+JH5M66y0KSIui+OIQVbwYJPKwldNjaLLZaFt+L77xKGz+vc8yoEv3PLdxSFX7og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UAGJMZPuDUESPF1ilqUdyMHhXVkh/KpJBdO4mc2/A94=;
	b=Fo7SOP/E0mGg/oKi8b6q3ONqnnhVsA9YM/wJq74aJujSg53Gb4sMFCeVMEwEMFBHyB1l
	 CbUFa5f1LJYwKAC0Fh46l1wucyFrUf7vcAzpjj+DnEoGnsADVM8XZ6oI17mOcSKWKC2N0
	 7RENH5epmvfU5Xx5PvGnrX+eOQbQpVQZqlNXfvShOApp9niq+PJicOju1jb2r8Pp+uLPR
	 nOmqG250mYqJVfgtQoIsT0hdKplFbEaT7YKbM91jA+B+TD65TSUmEdgCJF9F0VkDEioLd
	 c/2DrLjMvV//hzOBMvTKUoHyayeL/VeWBAexmxFuXeU08VUVCeagFtYmQMAjgM+sirQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=imSQj0la;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6FE606A32A;
	Wed, 18 Nov 2026 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=imSQj0la
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31341F000C4;
	Wed, 18 Nov 2026 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978020;
	bh=UAGJMZPuDUESPF1ilqUdyMHhXVkh/KpJBdO4mc2/A94=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=imSQj0laRaeFVC9hCOSCJYbjsmrjwJplDpBIE/zxVQo2cKT+exDmkKyKUi3x/PSnl
	 qVNO/Qg8U/FFJ+tvoaMPOed+G0xfJJoqHzswg4p22A6seDwYFI2hCjyssBGrFirHbt
	 a7ebj/Z+uwA+DDGyEChbREfnLilTGF2ywd2Vm2el0hc3EdWZLsunRFYraMr3qsXlAP
	 7gPzut1U4Ri6zD1AXGis+GlE4ov4SGqJSIq0ZX0736v7R8cnzmAMvWos0bGDjWJZHj
	 z0vaAYhHQy218j0rjdETC/R/GKGi+fmvXxVviUFBVl/qOXE5Kf3hJTWj5/rFYEphgw
	 CzPsVksEO3tMg==
Message-ID: <sashiko-outbox-220131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/5] inet: frags: annotate data-races around
 fqdir->timeout and fqdir->max_dist
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261118045137.174026-2-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-2-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:00:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> fqdir->timeout and fqdir->max_dist are read without any lock while their
> sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
> readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118045137.1740=
26-1-jiayuan.chen@linux.dev?part=3D1

