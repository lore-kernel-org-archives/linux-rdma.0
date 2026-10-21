Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580905;
	b=bV1OIbrc9ayJU8Q09viNHIyyshy6prRRcOXky/+UlKlP/tbgzOokW/TAnBPH52ZIclkR
	 R/vQpaiOZFkbOdaW2ZZvcPVUkH4uPKPPExodfmLmMd3Ic6mtMy+2opHMHYf0kOPQL5kvg
	 CrTY+IVUGPc2p6D0qf8oxQ/u7ekel6K+DYtCR8e6/ohrEnCy0G9OlL31mVTi/YXcx/tHR
	 PzrWO6qYOyQLT/P+DseYDoZqzI08sOFptFHoqFFCABfzpgfq3wW7X4BZe7oXgXNM7/Fnj
	 uFEmhKPT4Jfvak4I6GKiUvIOZoRJ+u13cTQSf7zG9E87ecvB3Ih13o43x+nymQeYqrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580905;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sjoVZSck9apVIljewBkplOdJfY0Pk1ShLfCVvksBic8=;
	b=rCkYyetrzzNSFMXahbXeEWJhcI0RVkubRfopEbII5rsVRb+fSRyzY5B6ib7lGsBIi6VE
	 0kMMMDBAfuJanh3/iD/xkkoZfkElgK/WkYWkmDnH82HB/NDbAZqQgU4kA2IJRDSQO5rln
	 wAsKBrO9ZKf0kxrvC8UMWjEhCevsA8COqBw19may+cNhcL0bcig0n9kudN39ASWjvzYVb
	 d18tTcfiJiKSx2mD0yYRfOW82ekMt/c4E3sazavrSku4tgPt5Pq/oxJEOjnh07134mFse
	 qeqaOzhfwSqcKmx0Wm/jsSL8c0PvMEzQRQo1x+v72kak1aoFOgXqpxAezCCEz8Bom5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JuPu2Pvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498B3606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JuPu2Pvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37AD1F000C9;
	Wed, 21 Oct 2026 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792580904;
	bh=sjoVZSck9apVIljewBkplOdJfY0Pk1ShLfCVvksBic8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JuPu2Pvrm1J817FiihTF8FplJj/sY7H3JDoIqb6f2nnVmuRdVt7HAsmauvvLgO1xF
	 QPd1ISdNFfa6tervtkX3KXp0oUnHKWaMqD/+FmN70b9hH4AjFny/m67JwDc+OKSZUt
	 lz6xvclwRzv+gD0HaIV5tQqO9OcwMmzk9LYzfe6NqRgBSWZJmPgMdmSg995SsRc+b4
	 CqnxFLwrVJO4NOHz258FhbK8PjZo/xCu5DqwL45ViarldhxZa1SAbhFjynQDaG6Qu0
	 XMxyQ9xibn1xydk3ugc+6Mu/D32VAMbMIx42kdi5Ol0TzOSA4K4uEviigswM4sOOJ5
	 sWvOgDext7tcA==
Message-ID: <sashiko-outbox-180144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Use only loaded devices for PTP clock
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021105600.3481485-1-tariqt@nvidia.com>
References: <20261021105600.3481485-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 11:08:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> The PTP periodic worker and PTP operations access PCI registers through
> the function backing the PTP clock. The PTP clock remains registered
> when a PCI function is suspended, so these paths can still access the
> function after it has been unloaded.
>=20
> To fix that, serialize clock hardware access with the clock mutex for
> all clocks and fail callbacks with -EAGAIN when there is no loaded
> function to service the clock. Additionally, tie the worker's lifetime
> to load/unload and use the devcom lock to synchronize with peer
> loads/unloads.
>=20
> Fixes: 8fc3e29be924 ("net/mlx5: Fix crash upon suspend/resume")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021105600.3481=
485-1-tariqt@nvidia.com?part=3D1

