Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138323;
	b=2h6x8kqUpsedCwU5nmGEVsmcLtmzEYqW3D1oenzS3MLotRw8S+o3IQQXLdhkg6TJYXPN
	 XEIHOQuMs6XGa/V11RWPivlIPmk95bigVlEbTanNxOdmT32gQqHm4wJkTxmxT3CxZ+Cfe
	 DaRt+bXtOuz5U5oI2Cry7Ug9DM8yCrKOHWw7/QV3jBeZ/bZImZpMlZg3ftUvFXqCk2r/W
	 02s92Zc90dPxJqfCztBjxYBi4Kccc0oDt3o8QXHkhlB8IANT1r+Q9cWyOe49gYk0QN7Xc
	 jGY8LTdWDR9l60Jke7//nKE/9egvaOVuMJ88x8U5q+PjfCmV//jgWPPKluFjR7SQSaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138323;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ECyhqSxzoEa4fGcAvR92iUykL2UovBNll1lvQtQYeWA=;
	b=Dr5P00KtRTxuRVCeRjj65HcnMLCZpcADaxPpxx/lchXF1sdIb8Crfoeru12TVurtQiLZ
	 3kTvAgvyWxLpi42sNtoYz2Db0U2OQ3cl5Vg5K6P9GeAv5OowqnBY11Mq6LYve7mVKsVvA
	 5pvdRAk1clGM6GQwokNCmo1lm36G4nAYqeiyC6WDuActP/jgRqrZJGAI04wJ1tjKqkgxk
	 sF9pPRJaxMMCMpgOm83X1T/9CnatQmgPNCNDfATRaSPPEMiy2AvExmqeuxEdMVzeCiLF3
	 aFUEOBDsq0863dVo//iL221ArkZqhchWR+w9aqTMCjDxYMsj6FT8q/ipzkOBUIxkfLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DpBkgFSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01906606A326
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DpBkgFSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7158F1F000CA;
	Fri, 20 Nov 2026 01:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138322;
	bh=ECyhqSxzoEa4fGcAvR92iUykL2UovBNll1lvQtQYeWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DpBkgFSABgnCdm7z4CB1IklOkmLdFfQ45+9kJW16eiKHFP+pJxqa1YQFq93EVghbn
	 7bDbEYtADDTFHqKK8IoggxbmTs7Pz4bVAUzRayj3XubPJAn/6zwk3ovqsX9a/iKK/y
	 g3j036Q6V1Uo10GqLaAbSVIL0wpdXnsm04qBuFh3+u6c+9YRyHtzNv+c+gMnXziGKy
	 MT5ztkPXzLcneBCWYAusm/FQffQwp4L2lFM7pX0AqPX1CWhzsR8HPRKfSS2fcyThce
	 WfxrNNnF6ixDgesjqFE6FPq7xLwXTeWvsAtSHpKVXQuXsdzJ6gGgpbRklyMkMBrix0
	 ULO0DuV86XOAA==
Message-ID: <sashiko-outbox-224318@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 11/12] selftests: tc-testing: add tests for
 the psp action
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-12-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-12-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:32:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add / replace / delete / flush psp decap actions, check that
> associations which don't exist are rejected, and add flower filters
> matching on psp_spi, psp_ver and psp_dev, out of range psp_ver and
> psp_dev rejected.
>=20
> The tests of rejected actions match the kernel's extack message, so
> that they don't pass on tc's own argument checks. tc itself refuses
> decap with an association, and encap without one, so those kernel
> checks aren't covered here.
>=20
> Creating associations takes the PSP netlink family and a PSP device;
> the drv-net psp.py test covers actions using them.
>=20
> The tests need a tc with the psp action and the flower psp_* keys; they
> skip without it (dependsOn).
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D11

