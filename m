Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792103AE1AD
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936947; cv=none; b=bVeFayOgkdIht9NT5fY6Bpx7OsLNVN3G+uoHjkS9LmdIu4jdWK0Z5uKqGtOjrXdDh9XRk8dLKEGRaHOqWjijv79AwigRVUsZdy8AdvoCmUa9sbp3sfs3IGCBHPjf+rpJKUVMb8BOZHkS5zghxvN8FdrzOI6plkCX9OqxuK07Z20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936947; c=relaxed/simple;
	bh=LXaVI2wCMVyp3Ihy3N1H2SaoKvqKLQSIAlfbMvI9p4w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p3IOhXRRumjyRXbOUbq9YtelhHXiGi7XTvuE68VLCBazHOBQWX1FqRSQTeVxJv+w9JyECsf4ojITTZ62r8LkRIGwDOZQUMINsTF2vTnD/BwUVlvcL01efq50gsy7jTRb1M1T2uvqk4dsLBAS8gga8MfPhnRMMVszm8vfSaD3x7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAeC4ulb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAeC4ulb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E3A1F00A3D;
	Wed,  9 Sep 2026 06:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936946;
	bh=SFMq9r041JdrRdu82ciT3i1IHBCRfgyi4MkE+5feMTs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bAeC4ulb3CbtbgHzBLLzbwJt2/zeZyQqUNW7dRm2Y8tNN1oMA8ihyVHRf0hRLtTqr
	 vYxIcwj9Q0WcQHUQCQkPkHhJfYRHCHO4DipJ/ToytGpanPG17GzD23KB2976440zMO
	 ijy8+FTu4gJyV0tPq2kPGRO2Gm8Hq2s/FuTeQ++ZJnYx7aMIH4XqTGsJ6p+knWACBe
	 dTbL+twqsgEufR4rmo4YQPuv7o2BTi/j+zbWIVcEcMqlPveoF/Q1w+WES5HYtKCRAi
	 AYxvh2SN444V2Rt7rZSFf6mAgAe0Seoi6JTVLx328glNvk9+KpJ2Ko8ZdNfZmhX+Tp
	 vjyEkXYDoocvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 13/14] selftests: net: gro: Add PSP
 encapsulation and encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-14-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-14-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:45 +0000
Message-Id: <20260909065546.37E3A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Casting a statically allocated byte array (`psp_scratch`) to str=
uct pointers violates strict aliasing rules and causes potential unaligned =
memory access traps.
--

commit bedf89d5cc02c2e4bc6f000e8888dc6adb4414c6
Author: Cosmin Ratiu <cratiu@nvidia.com>

selftests: net: gro: Add PSP encapsulation and encryption

This commit adds a PSP mode to the gro selftest which wraps transmitted
frames in PSP transport mode and encrypts them using OpenSSL. The receiver
decapsulates the frames for unchanged geometry assertions.

> diff --git a/tools/testing/selftests/net/lib/gro.c b/tools/testing/selfte=
sts/net/lib/gro.c
> index 7a333155de1ab..fe4a4c0e17ae9 100644
> --- a/tools/testing/selftests/net/lib/gro.c
> +++ b/tools/testing/selftests/net/lib/gro.c

[ ... ]

> +static char *psp_encapsulate(const char *pkt, int *lenp)
> +{
[ ... ]
> +	if (proto =3D=3D PF_INET) {
> +		struct iphdr *iph =3D (struct iphdr *)(psp_scratch + ETH_HLEN);
[ ... ]
> +	sport =3D *(__be16 *)(psp_scratch + l4_off);
> +	dport =3D *(__be16 *)(psp_scratch + l4_off + sizeof(sport));
[ ... ]
> +	udph =3D (struct udphdr *)(psp_scratch + l4_off);
> +	udph->source =3D sport ^ dport;
> +	udph->dest =3D htons(PSP_UDP_PORT);
> +	udph->len =3D htons(PSP_UDP_LEN + PSP_HDR_LEN + l4_len + PSP_ICV_LEN);
> +	udph->check =3D 0;
> +
> +	psph =3D (struct psphdr *)(udph + 1);

[Severity: Medium]
Does casting a statically allocated byte array directly to structure pointe=
rs
violate strict aliasing rules?

Looking at psp_encapsulate(), the statically allocated psp_scratch array is
directly cast to struct iphdr, __be16, struct udphdr, and struct psphdr
pointers.

Because the tools compilation environment assumes standard -fstrict-aliasin=
g,
can this cause the compiler to incorrectly optimize away reads or writes?

Additionally, can this lead to fatal unaligned access traps on architectures
that enforce strict alignment, since a byte array is not guaranteed to align
to the requirements of these structures?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D13
