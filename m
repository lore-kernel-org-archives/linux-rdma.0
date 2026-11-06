Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794005452;
	b=q5yw8dPLyLDjEUMM38tGq9veyaopQx7PJ14ouWKkvYpLcuKoD7E9jpgW9gm3OzUskyew
	 OGPFm6eUwP7fvNDVBhqDbU2i0QlF8ItkJBF1RBLNt0vyv19Etvppht5odcsc10oUJfhtk
	 H/oj/su/ifSOqFLb5o7Jwaq+N/3uD2ogA4SiC5MeoJuCMWlzNZVt90CCyydp+xfQ/jwR/
	 u0raNSdcy7yl+8XYM80zEWGzevnsdDTG0TYFG/xQM356D7s2+GFPLjd4jUv12XqvPOV7+
	 wQrX42CMv/2RNM8Gbc+GOkG8zG17Qi3zlGFqZ7lbr6UnBLY2DJHMp+fle+ctVX+GDCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794005452;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=umc1cL9E5d5Sl00iC9/ZpC37R0vUXXYuHxSEr+w3oA8=;
	b=vmv0NuzpUrtLa3uRLA9/Ek7PyPhGfnW2kXEwdPu/yFYu58YBIjCk6fXg6BfqZkDf2Gjq
	 Mwr8nvvrHTpQfqz7w5iQfGJngNFWy14QXcoDwwWhlPq81hcPD0p2Cg6onCybU6ujdnuQF
	 5PgHd/nqludKO74DHXJDQam3mKIedfrSbptdqpQIyFQ400bxsJ6TEodDKa91VXMkgWyok
	 uwipEzcI4PELHt4VnOEpKPoQolotXyOLDZwiaUGDe0l3To0C8n6hm+LN5Na5sGAyMpyBD
	 r3r4bSS2YXELiFi5GXK0DDQA6OhKlWtmd7FYAVMmIq/1u88FLpZvhCn2Rv3gJCNOFjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPQ3G0T7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF6C606A334
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPQ3G0T7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F61F008A1;
	Fri,  6 Nov 2026 22:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794005451;
	bh=umc1cL9E5d5Sl00iC9/ZpC37R0vUXXYuHxSEr+w3oA8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OPQ3G0T7ebML68SypzwKON54pwXMB0wdsbN88q/chRqkSSdR9IBY6PP3ZWD78cNBC
	 jtUtiGqI4Sr+vyYI2HzoQ6OodCwSyBEr2m4JhNx9z8UYtURrcVNzbnnp85iwdPhWmq
	 Uh0DaZBDi0Eqp15lJ0zocfXvHmQlMr4vVmTgDkMTMGPXN4+8DjG8xtp0YT8AWG/eNB
	 3l5qa2rARozI3+fSgBak/T/HKr7pIc5YKRskJqMxHB2IZtXF4rObAPCLSGpyXAuCjv
	 WW35siTAd4f3OPBd5UJe5aVJ4O7ZTZ+5+NQVk8ZzpmS2yzdlUU7679+i/TzDNCmyix
	 hhswojLGinW+A==
Message-ID: <sashiko-outbox-202340@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] perftest: add a ROCm build to CI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stephen Bates" <sbates@raithlin.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261106224821.126399-1-sbates@raithlin.com>
References: <20261106224821.126399-1-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 22:50:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> CI builds only the CUDA configuration. The two existing workflows pass no
> --enable-rocm, so src/rocm_memory.c and everything behind HAVE_ROCM and
> HAVE_ROCM_DMABUF is never compiled on a pull request, and a change that
> breaks the ROCm backend goes green.
>=20
> Add an Ubuntu 24.04 job building --enable-rocm --enable-rocm-dmabuf,
> alongside the two CUDA jobs and triggered the same way. It runs in AMD's
> slim ROCm image rather than installing ROCm on the runner. The -full and
> -complete tags, and an apt install of the amdrocm-core metapackages, all
> pull the whole ML stack: Composable Kernel alone is over 2 GB, before
> rocSHMEM, MIOpen and the BLAS and FFT libraries. A compile check touches
> none of it. rocm/dev-ubuntu-24.04:7.2.4 is about 1.1 GB against 8.3 GB
> for the smallest 10.1 image, and still ships hipcc and the HIP and HSA
> headers needed to compile the ROCm backend.
>=20
> [ ... ]
>=20
> Link: https://github.com/linux-rdma/perftest/pull/418
>=20
> Co-Authored-By: Claude <noreply@anthropic.com>
> Signed-off-by: Stephen Bates <sbates@raithlin.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106224821.1263=
99-1-sbates@raithlin.com?part=3D1

