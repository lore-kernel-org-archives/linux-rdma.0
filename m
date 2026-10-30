Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336021;
	b=VP7FNcG0yAU5VIei9gpDNwIfoyrv4ibQtKwdSIo0ECNxA9cwC3oUcXvCo9SHsS2YJwlw
	 ou7BhO9bilpy4jHxOJoQwtfo40Fm1n9Ld9lI/FcubNiOmLAXTYI0/GCruum2SHjBFPivI
	 gxiFMbcI428fJ/OAD89wcLspiWppZdbLcBz/BUHRzNxmD2QtmHOO3offVBM+u1a83bcum
	 eeRkLDUHzfs8jsPfg4jbgo7LGkW7tQ8+CUgn2l+3GyYfk6xc+ncGghhzLzBqoG4cCw1fg
	 X4Oh/r6YjQQoDjT0oxiQADrKuZpSFrz595hKvqvhgNsq/e7dnZDaM6r2ENsVf3srdCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hRS2+CaA4aqy7sWKnCO+EvDqlmMqUe7IBSVt+yeUvVU=;
	b=joS7ij8xQo5mFeeRVF4jvxl0ezD8+4DZMb2mihaLZ2yaBJLNxWKKRuU8BRzM4RCNcKc2
	 rmE3FH649UObCCwsPfDP7LtI9dAlqSW44bOU6F+e1R5WNyZ7Zg8DBvnimGJBAM3emJo7h
	 QHXKJJrRo2UEu2BROw24svMC2UfcYOx3lyf1VJyYpbTqoPLXRKP5ZyGrd5pQpXBYfC8xy
	 umMjXNHZv708Ky2YOdYvqEo94eEuxDYsSFIDLlZyKDl90ZDxgF1Ds7SDS9by9EXErmHXj
	 Z12myMX78cPUcaup2Jn4fhaQZwqjORv6NPfQ4HgKvVlacchJ0iBjYwlfBQAZpXHhH0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLm4dNiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDB8606A321
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLm4dNiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D841F00A15;
	Fri, 30 Oct 2026 04:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336021;
	bh=hRS2+CaA4aqy7sWKnCO+EvDqlmMqUe7IBSVt+yeUvVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DLm4dNiTkEq+IPKMyG5qrO7oFCVgQ1mUGrqY4SJjBx+Ednela2u1R3VjFM9k5Xlyq
	 B3NBKlmqbsFhFPFLOycvzA7/c7TeVlyfAO4PfMexp4vV7eXywwzccPnEF7XWyNwt4I
	 aqmsMn+MoJL0yFNhI3P997fKj2Cncj7lLWxnp3jMF7DTFNQCLN9l44cdDbw+C4EAc2
	 ITGSzaIdsH0NFy+a8DcQO8r0S0MEDvhTwdDQOPsvoaKJTFr6PngZHyyvwH5nBGzmQS
	 d5gVLEJc+nrJZB7dT5kNYJ6hSSwMz8sAkRQfpuRe8wVvi5tYDZDMqhP129Kn4gSAv2
	 8/SwNh2hPmDVA==
Message-ID: <sashiko-outbox-190336@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 2/4] net/mlx5: Add function_id_type for
 enable/disable_hca cmds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428053851.220089-3-tariqt@nvidia.com>
References: <20260428053851.220089-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Moshe Shemesh <moshe@nvidia.com>
>=20
> Add a function_id_type field to the enable_hca and disable_hca command
> input layouts in mlx5_ifc.h to allow using vhca_id as the function index
> instead of function_id. The new field support by firmware is indicated
> by the function_id_type_vhca_id capability bit, which is already exposed
> in hca caps.
>=20
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428053851.2200=
89-1-tariqt@nvidia.com?part=3D2

