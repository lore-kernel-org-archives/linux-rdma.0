Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD55BB520
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418458; cv=none; b=tCOF5t9N/3frcjf/ba7PaenqCZwR06hE2sskKaP+gH4Zn4irrlyeMrH7g7aeTZwL8Lv/cc0HyYAQwonTci/bP5NiXeA9xyQDy6m++F4dmulg6qCXFhinyXIyZkYbGIuErBHiowM/8pP/aeN/7D22xAj8ajmyp+vOoumiM0Pc9A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418458; c=relaxed/simple;
	bh=aZJxKnPLgqrGN/U05+zaczoUk/3RwmqalmDTq0sY63o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TBy5E746zweKc0gIdbMWxV0uaoS6nr17X93AX565a2Up/3wnGMfC56KaICa+oNvj8ArPCqipEm9CDT+bnleuEUk0NUBxddTvCgziddxBlJ41c66Au9mL5m64GR3+XVB+qMSGC/J8VOT6zLbfOR+JmsuNOy5NhN7zwE4Csz76agk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPTeGMso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPTeGMso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810FA1F000C4;
	Mon, 19 Oct 2026 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418455;
	bh=CQrtlMd7c8jfncNNpKPLsIY09/JllTgT/kERIvmSjV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NPTeGMsoJO2dr1fWIlQNFnAgLH0AU3yiBjacdWRyfzWYIIW7HLVUAcWM7ZGrYAOWS
	 qwMUvgCrzz+iIkOnxcBAP1h9EwxoGDbXg0lDboPO6WjS+Mfc+f8Zbfjwxakm9ujaq3
	 zhiyjqSH4ACrOXh+bPaVfLMHhlwJCR7iw00Rfvm/LiFoldqOm7j2ZLclbOJR/NvJay
	 uDC8HgkKh+Efn171qGF+dC1BWuUNnEVlC6Nu3uLdw8F66PTrul773STJWOmt75ClYg
	 BTEIT9voyx06OM44+CxTKKbG7NHUcc3Jgj4iLvrlm7vpmv3qlKs1kZqYhKbaYkvurN
	 5h8raaveVRX8Q==
Message-ID: <sashiko-outbox-177253@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] RDMA/irdma: Suppress PF reset on HMC error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-6-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-6-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:00:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Seyeong Kim <seyeong.kim@canonical.com>
>=20
> [ Upstream commit 4dc9c884c0aafac1e8d37536d88d485135e26883 ]
>=20
> The irdma driver currently issues an unconditional PF reset whenever the
> HMC Error interrupt (PFINT_OICR bit 26) fires:
>=20
> 	if (event->reg & IRDMAPFINT_OICR_HMC_ERR_M) {
> 		ibdev_err(&iwdev->ibdev, "HMC Error\n");
> 		iwdev->rf->reset =3D true;
> 	}
>=20
> request_reset() issues an IIDC_PFR to ice. In practice a single HMC_ERR
> can trigger cascading PF resets, IOMMU faults during teardown, and
> teardown of every RDMA connection on the device.
>=20
> i40e handles the identically-named interrupt by reading
> PFHMC_ERRORINFO and PFHMC_ERRORDATA and logging them without touching
> device state; see commit 9c010ee0ea5f ("i40e: Suppress HMC error to
> Interrupt message level") which removed the reset as "not necessary".
> This patch mirrors that handling on irdma.
>=20
> With this change, repeated HMC_ERR no longer produces a reset storm and
> RDMA traffic on the device continues uninterrupted.
>=20
> Signed-off-by: Seyeong Kim <seyeong.kim@canonical.com>
> Link: https://patch.msgid.link/20260619050044.1807044-1-seyeong.kim@canon=
ical.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-6-sashal@kernel.org?part=3D1

