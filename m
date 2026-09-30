Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9E51A151
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788350; cv=none; b=bOwcecraHF4M585xgnzCtAl/JMq2clawW1KpwUqTwBC9T4GxZvGQOqBmAIKU58lpmkdJvUYe8/qCsfk0MwVcrTP2/mfBEp/GMPOJJnNWmmMgNT2qwACGah9eO4V+ApmedShpd8bQmyKbh8+JYMm/PKfoYgfIyo/VzboEUc4J1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788350; c=relaxed/simple;
	bh=Cx5xKE0dd1HmDghc6ryr2nyHHF9rEK1Bf469fjfhyTI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=itsI2vIC2SJgwtbB8AXrZIuQzBlw3oCPuDTDxUAA1J1zWPby8rmOWtSIbPuoeNKs12cEu0z5R6O+iHOVLSsxf+9hOXCrFCFlyBVzMDZRdR9Zsujqh2nfqL9lgnWLIkIE3a3M8egBhJC0co+Ac6nlZSsRjdxAOrj9ytKfXJ7QZSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BN7kMkGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BN7kMkGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1871F00898;
	Wed, 30 Sep 2026 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788349;
	bh=Cx5xKE0dd1HmDghc6ryr2nyHHF9rEK1Bf469fjfhyTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BN7kMkGKHyqjyVqTzSJ+ZRYEIzA5ZRBarFcDJ5jr96XLmyi90TrLfySTT5Hi/nojd
	 uKi2hPJ5f4V+FonvhpRrodMhT27AbrFjKRrIfl+zDOkE2LbQAtY4CFvcqFmO3FmjpD
	 xtK/w7ejNu5XMhStIVnUpgPwuFrKRbEvsE94n2bZ62mHua8wPcqh1i9AEXwzWknOca
	 Gar/2LxTchl0iXdAF+lewmcWzC7iUghFw0SZ43mg9EE31GGC6bQ2y9QhZncL3+eG8s
	 mhFjzXlnDBfxaWbJscCnu9K0FjqA8VIUGGeubanQ2++6kzsb2b2WrRx5bXmFBlRUxR
	 dM7NskdKSflmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2] net/mlx5: Lag, split aggregate speed into oper
 and max helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930170406.148548-1-tariqt@nvidia.com>
References: <20260930170406.148548-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 17:12:28 +0000
Message-Id: <20260930171229.1E1871F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Or Har-Toov <ohartoov@nvidia.com>
>=20
> mlx5_lag_sum_devices_speed computes the LAG aggregate by summing oper
> speeds across all ports. This has two bugs.
>=20
> First, it relies on the assumption that a port whose carrier is down
> will report an oper speed of zero and therefore not contribute to the
> sum. This assumption does not always hold: when the link partner
> disconnects the port transitions to DOWN state but firmware may still
> report a non-zero oper speed, causing the aggregate to include a port
> that is not actively carrying traffic.
>=20
> Second, in active-backup mode only one port transmits at a time, so
> the aggregate should reflect a single port speed rather than the sum
> of all ports.
>=20
> Fix this by splitting mlx5_lag_sum_devices_speed into two helpers.
> mlx5_lag_get_devices_oper_speed reflects the speed currently available:
> it queries the vport state of each port and skips any port that is not
> UP, rather than relying on oper speed being zero.
> mlx5_lag_get_devices_max_speed is state-independent and returns the
> maximum achievable speed used as a fallback when speed is 0; for
> active-backup it takes the maximum single-port speed instead of the sum.
>=20
> Fixes: 28ea6036dad2 ("net/mlx5: Handle port and vport speed change events=
 in MPESW")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930170406.1485=
48-1-tariqt@nvidia.com?part=3D1

