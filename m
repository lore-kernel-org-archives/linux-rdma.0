Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807745;
	b=g0PeD0hQst397843+p1WsrFmh0URhqX7juwRjWVaUTRy3JAdufXXyhbqzls+87D5ofjr
	 E4W92pOjYLgrR+GwH0WowlMOeoqFdgXn31VpSKxV8Xy6vdrVPTyWtjjQoE19x/M93lad5
	 qQsgC6j4Wyq4si59nGxrmEWPhJBQIkJLO0D+UNj3JOAIYHuPzD5UsHOg9ubmoMuy4K0sK
	 s8C06KK738NgrK0WAd0w3ISPhl10N3qU5R4OHvp58/fhR7pg4M8FMt9aE+sX29aXTiV/s
	 dXlRtWwzNKULsB28B9Cd37Xk/GbkTAUqemI1V2gO0DhuxJpXVFmoXy+bTG45YN57iig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807745;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C8UP5GTPbnzsIOmsgrUDLQ8og2CsI3hWCzSD4Kne3nI=;
	b=POwn65yD6UnDJ4f38VW9n66JG6w1Hy/XErIZdlPyNvpWswXm5hQ8iHm+XZZbXgMbcho5
	 m5iYJhTARFdq9c7qxql+SLJVQ8kbyO8dWyqx62U4oxjD1TpUk+o49MXvi4fGqdtpETyRF
	 vf0mjku3FnVXEXznwmN0Qhs0KwXQRBCJGfXXanGpilW2U25xQP9w03Ya5TY1IrPrrznML
	 ADOg70th75xjfrKMQMIp82HRDiFk15z4cAbLped0vESUaW24JWw5//Rse0NHVBC984m7H
	 +XkZLbOZmonzJbdo2EiTVEBZiSf9zWRpB6LBnnpzNVsvWWxLuvhY38VCUjeNGkRykgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIz8pC+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B898606A339
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIz8pC+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3B71F0093A;
	Wed,  4 Nov 2026 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807744;
	bh=C8UP5GTPbnzsIOmsgrUDLQ8og2CsI3hWCzSD4Kne3nI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XIz8pC+ZKTnWuAey8GmxKFQL6xcuB2u9u6LgiwjlKDH4aQdzmO2uLzEvRjO8AglbN
	 MOnGOZyKe1Fsuk5/szcdLPCO3jhL+eY1j2KULuZa6KPsxWO/hY9mj5AImQOEkpBHyi
	 vJHlnKk7u0Wg5yqSiJojdb83ZCWOFj5OZd9bH8Xua9Q5MNEVtZsF6h7WXMNaNEvl3k
	 UtZVqnlJaIPWKlMT0ZJwr8Z8pdmGVqTSvh7447QEFpWKQsVHVH6+J4IPyOE89f05qS
	 93I5cEnFTeH1tZ+qkwi2QUkVejb+bEWHadEyihflY87DXGOK802g4UiZkxIQWT23zo
	 VyihaBYq1h76A==
Message-ID: <sashiko-outbox-197557@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] perftest: add a ROCm build to CI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stephen Bates" <sbates@raithlin.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261104155023.250706-1-sbates@raithlin.com>
References: <20261104155023.250706-1-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 15:55:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] perftest: matrix.rocm_arch is never passed to configure or make =
in CI workflow
--

commit dee5fbc3aa52f87f3e4be6e0329a0a27dacd8a09
Author: Stephen Bates <sbates@raithlin.com>

perftest: add a ROCm build to CI

This commit adds a GitHub Actions workflow to build perftest with ROCm and
ROCm dmabuf support enabled on Ubuntu 24.04 inside AMD's slim ROCm container
image across a matrix of gfx950 and gfx1250 targets.

Link: https://github.com/linux-rdma/perftest/pull/418

> diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflo=
ws/ubuntu24_04_rocm7_2.yaml
> new file mode 100644
> index 0000000000000..0a4c706ea5ca5
> --- /dev/null
> +++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
> @@ -0,0 +1,66 @@

[ ... ]

> +    strategy:
> +      fail-fast: false
> +      matrix:
> +        rocm_arch: [gfx950, gfx1250]
> +
> +    name: ROCm (${{ matrix.rocm_arch }})
> +
> +    steps:

[ ... ]

> +      - name: Set up ROCm environment
> +        run: |
> +          echo "ROCM_PATH=3D/opt/rocm" >> $GITHUB_ENV
> +          echo "/opt/rocm/bin" >> $GITHUB_PATH
> +
> +      - name: Run autogen.sh
> +        run: ./autogen.sh
> +
> +      - name: Configure the build
> +        run: |
> +          ./configure --enable-rocm --enable-rocm-dmabuf \
> +                      --with-rocm=3D"$ROCM_PATH"
> +
> +      - name: Build perftest
> +        run: make

[Severity: Medium]
In .github/workflows/ubuntu24_04_rocm7_2.yaml, jobs.build.strategy.matrix
defines rocm_arch with gfx950 and gfx1250, and the commit message notes that
this tests compilation across both Instinct generations.

However, ${{ matrix.rocm_arch }} is only referenced in the job display name
and is never exported to the environment or passed to ./configure or make in
jobs.build.steps.

Since GitHub Actions does not automatically export matrix variables into run
steps, won't both legs of the matrix run identical builds without targeting
either gfx950 or gfx1250?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155023.2507=
06-1-sbates@raithlin.com?part=3D1
