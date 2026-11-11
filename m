Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404808;
	b=cvqhjFWkIGMNwT0Me8BX4jJZnpz08Rqx5bExN5GvrHsXXzf4ZtAlDDwHPYuM1JsQjh5c
	 5IIOASmjAHH/6vhlAqDEX6HLKE3OhYEFGFa1HrqwShWOtMOIUcbLwN342ALvP7XcBgCF6
	 Rajx97AWM89ym/ASYhXS/rdxV+k5CSUPFDF2qSUaEOW3pSo135frfE7O492AWyhRuyDIc
	 +SX7XLocy0ykPFO+eisbK8wQa/j41Xs7bx3lQ3Ryp5IE6wXHGHSXzGcEZsogIOA1TOJ2M
	 0GAkJIiTZHrIsNFvteGEW67bQ/8jeHpwU6n0s6z5wwLYEb1tH+tZnzJdzeFlpDydI/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404808;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ehtBPGv40VgIO/IkeBHmQBm2jlxJ5IaBapF1d8aJMyQ=;
	b=hLLcLY2UCkS/yoD4+A51r2yX+UfTDkbKpEFOsFoR3RW6dJsOpQe+AIDc42hOrSZSgZWe
	 O3Ou/C61/XOfTG0q72QbGcLKJbiL98y+JpS6k1qFXSZ4MbB/mqLGS8cmltxZnVg+l+WP8
	 Ie4EgQAC+nuWfFfZu+SUloKpGxinenRGgFkq24tmczH8UCe6CDEdS0JE5+qmAFYeoY+Pc
	 Ob161G/u3+hJK/scLjudDknMRaa5Ps65mFfMzoHu3f/UcHpqD9SwO6KkIzgZenpuXXvTA
	 9SO3b0bSE1yRqocFOcN+l2QJAVDsgXwqByp7H0Gcpq/LHe/EHYnl3fu3XMTjYb03KRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AS6dQDRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5FC606A335
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AS6dQDRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E2B1F00A06;
	Wed, 11 Nov 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404808;
	bh=ehtBPGv40VgIO/IkeBHmQBm2jlxJ5IaBapF1d8aJMyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AS6dQDRaTvzUkPm7nCVIL13j+OsjqJmkODM10aviGhy40VwUwRAH3OddLrECf1j/B
	 H+NTABiTjZQf4TG2xRVX37czNf5geHTXFwWhswjb9XUnuK30acsuNeOgdpI3q8OV5r
	 D28USRIgtEPrlOEfWWqf8/fYvo67TCFNwInCKk6hgrIkTaNzs1PSPddH1QWYQ86AC0
	 YA6TEaTRce/vAA3noTvvVxVJk3pqn0e+ScJI1+N7lP3K+J5EmADJ3aPzAAhzx2E4LZ
	 ThXCyas5h+RIZy+DnY3zZ7YUWnlDW4UvcroTegeQsJ8GBpAMKPj8OGNTwZJM7eA5lK
	 xi0fNGNX5zcoA==
Message-ID: <sashiko-outbox-209091@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 06/24] RDMA/mlx5: Reject QP transport types
 not enabled by FW capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-7-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-7-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> check_qp_type() checks the FW capability only for XRC and DC. RC, UC
> and UD QPs are created even if the FW does not report the matching
> capability bit.
>=20
> Check the rc, uc and ud capabilities as well, so that QP creation is
> refused for a transport the FW does not support.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D6

