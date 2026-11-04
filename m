Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793824658;
	b=ynClIB+UuT+m3b7TbSB2w5kBLBzkA5PKXAID3+rATOAxkUxN/iaOHAKzfurvmKIxJdw6
	 Q9sfgznYa7kDttLSQ2QkHsXQpupf4jhPJzlslF0b0sSZxGV/ch8A8Vmsujq/pJhyF/MEP
	 Za/RSxEhcrttpcVqySgy6S305UFHc2kwJSM8cT+ntijIi7q42kh9NzErUjFogmxQpX8kd
	 BArelfUSdS/diaUHbN8id5QZJYEJPbSmFE8hVhuhcWP/TDQlIOStLutxR/5asYWvxWAbi
	 aIk0LpaNaQPCjY6N8Y7JHYXLBxCVg29vujLtJIifeO0PuiygFgbkw0HJFdHZ2BWj9Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793824658;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EbjtyfKcCB7+MwHF5aLbDcoRB9nlcDDUdmQEnUIpIhE=;
	b=zx3jB3A3Q3KXHRjN+8XhrZXRmGA84224NSoBh4VEYhFbBiAfrNGnbH+t4GrLRMPokabJ
	 FXWwaNkLzZaz2tj2EienQyzfndPcm6Psif3nK2wh5XadrlCycn9Zs/3AoLEUSMYjYCTXd
	 rrSC/7j/1y4EsjG6pR+7FPzusgBdn/y1YmfGGETKpbI3D7e8B8i264orUqxqdzqrlBGZH
	 ZErdTbIX6qC4a8AePvTqGxn6R20F8gZG6YbVZwZ5B/HaWlEbLQaShjbWfajpL1UXSYeTC
	 wZIc98WnFxEgVvQtJnKL3qdUnR1th4Kc3spCUYBwOQuoQbYbuKhQf58puSuMz/XxtHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rv891jLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C637606B2C7
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rv891jLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCD11F000C1;
	Wed,  4 Nov 2026 20:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793824658;
	bh=EbjtyfKcCB7+MwHF5aLbDcoRB9nlcDDUdmQEnUIpIhE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Rv891jLVrTt5eMHYTMlYjFrqELvXTKwMH1bXbzlJlHgBSMXMvOvHUeSzpgyvXd6FA
	 UzLKBlevAiTRePbm/xu0y+GPAYajwfjCBwXPW7hfZsQ8EPwg/7EmbGIA4rTzTAkpJT
	 AsOdvar2NofVQWRh+TarZCzqNhPIvJVzvH6MANjdv38lvkSDCDy0bI5ordexNhazCq
	 nL8fIsX/vPpyFuFlyMKX1WvKHkOAucW0IfjPY953CVsbzrJVitYJ0dk/OooC+oCKeg
	 Kb9BG1DNthT5NxQeLyJMPdYnEwhARecyoyjLoWbR/fYAxoKo3lkmYjPRlSfXx9O17l
	 58YgwCRII8iyw==
Message-ID: <sashiko-outbox-198023@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] perftest: add a ROCm build to CI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stephen Bates" <sbates@raithlin.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261104203301.1677350-1-sbates@raithlin.com>
References: <20261104203301.1677350-1-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 20:37:37 +0000
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
- [Medium] perftest: unused matrix.rocm_arch in CI workflow and commit mess=
age mismatch
--

commit f80ce07d3d5d2a3f4581f598c3afcf67e5214052
Author: Stephen Bates <sbates@raithlin.com>

perftest: add a ROCm build to CI

This commit adds a GitHub Actions workflow on Ubuntu 24.04 to build and
install perftest with ROCm and ROCm DMA-BUF support enabled inside AMD's
slim ROCm container image.

Link: https://github.com/linux-rdma/perftest/pull/418

>     perftest: add a ROCm build to CI
>    =20
>     CI builds only the CUDA configuration. The two existing workflows pas=
s no
>     --enable-rocm, so src/rocm_memory.c and everything behind HAVE_ROCM a=
nd
>     HAVE_ROCM_DMABUF is never compiled on a pull request, and a change th=
at
>     breaks the ROCm backend goes green.
>    =20
>     Add an Ubuntu 24.04 job building --enable-rocm --enable-rocm-dmabuf,
>     alongside the two CUDA jobs and triggered the same way, as a matrix o=
ver
>     gfx950 (Instinct MI355X, CDNA4) and gfx1250 (Instinct MI455X, CDNA5).=
 Those
>     two were picked to cover consecutive Instinct generations: HIP source=
s that
>     compile correctly for one generation may have microarchitecture-speci=
fic issues
>     on the next, and testing both catches that. fail-fast is off: a failu=
re is far
>     more likely to be specific to one generation than common to both, and=
 cancelling
>     the other leg hides exactly the comparison that would say so.
>    =20
>     It runs in AMD's slim ROCm image rather than installing ROCm on the r=
unner.
>     The -full and -complete tags, and an apt install of the amdrocm-core
>     metapackages, all pull the whole ML stack: Composable Kernel alone is=
 over
>     2 GB, before rocSHMEM, MIOpen and the BLAS and FFT libraries. A compi=
le check
>     touches none of it. rocm/dev-ubuntu-24.04:7.2.4 is about 1.1 GB again=
st 8.3 GB
>     for the smallest 10.1 image, and still ships hipcc, the HIP and HSA h=
eaders,
>     and device support for both matrix targets -- llc -mcpu=3Dhelp lists =
gfx950 and
>     gfx1250, and both compile.
>    =20
>     7.2.4 rather than 10.1 because AMD publishes slim tags only through 7=
.2.x;
>     every 10.x tag is -full. What this job needs is a toolchain that comp=
iles the
>     sources for the targets in the matrix, which that image provides. Mov=
ing to a
>     newer ROCm is a one-line change to the container tag if a slim 10.x i=
mage
>     appears, or if something here starts depending on a newer HIP API.
>    =20
>     Like the CUDA jobs this builds and installs only. There is no RDMA de=
vice in
>     a runner, and the project has no test suite.
>    =20
>     Verified by running this workflow in a fork of the repository across =
both
>     matrix architectures. Both legs passed: configure accepts every optio=
n, and
>     make and make install succeed warning-free.
>    =20
>     Link: https://github.com/linux-rdma/perftest/pull/418
>     Signed-off-by: Stephen Bates <sbates@raithlin.com>
>
> diff --git a/.github/workflows/ubuntu24_04_rocm7_2.yaml b/.github/workflo=
ws/ubuntu24_04_rocm7_2.yaml
> new file mode 100644
> index 0000000000000..70790377d85a0
> --- /dev/null
> +++ b/.github/workflows/ubuntu24_04_rocm7_2.yaml
> @@ -0,0 +1,70 @@

[ ... ]

> +    strategy:
> +      fail-fast: false
> +      matrix:
> +        # rocm_arch is not yet passed to configure: --with-rocm-arch only
> +        # exists once HIP kernel sources are added. Both legs build iden=
tically
> +        # until then; the matrix is in place so the workflow does not ne=
ed
> +        # amending when device code arrives.
> +        rocm_arch: [gfx950, gfx1250]
> +
> +    name: ROCm (${{ matrix.rocm_arch }})

[ ... ]

> +      - name: Configure the build
> +        run: |
> +          ./configure --enable-rocm --enable-rocm-dmabuf \
> +                      --with-rocm=3D"$ROCM_PATH"

[Severity: Medium]
As reported by Sashiko on v1 [1], in .github/workflows/ubuntu24_04_rocm7_2.=
yaml,
jobs.build.strategy.matrix defines rocm_arch: [gfx950, gfx1250], but
matrix.rocm_arch is only interpolated into the job display name and is never
passed to the environment, ./configure, or make in jobs.build.steps.

The new comment in jobs.build.strategy.matrix notes:

        # rocm_arch is not yet passed to configure: --with-rocm-arch only
        # exists once HIP kernel sources are added. Both legs build identic=
ally
        # until then; the matrix is in place so the workflow does not need
        # amending when device code arrives.

However, because the "Configure the build" step in jobs.build.steps invokes:

          ./configure --enable-rocm --enable-rocm-dmabuf \
                      --with-rocm=3D"$ROCM_PATH"

without passing matrix.rocm_arch, won't this workflow file still need to be
amended anyway when --with-rocm-arch and device code arrive? In the meantim=
e,
every push and pull request against master pulls the container image twice,
installs all packages twice, and runs two identical host-only builds.

In addition, does the commit message still match what this workflow actually
does? The commit message states that the job builds a matrix over gfx950 and
gfx1250 to catch microarchitecture-specific HIP compilation issues across
consecutive Instinct generations, that fail-fast is off because a failure is
likely specific to one generation, and that both targets compile in this jo=
b,
whereas the workflow currently compiles neither target architecture.

Could the workflow run a single build job until HIP kernel sources and
--with-rocm-arch support are introduced, and could the commit message be
updated to match?

[1] https://lore.kernel.org/r/20261104155023.250706-1-sbates@raithlin.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104203301.1677=
350-1-sbates@raithlin.com?part=3D1
