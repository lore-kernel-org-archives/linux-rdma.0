Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8C3BB136;
	Thu, 10 Sep 2026 23:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084710; cv=none; b=Hdf4fhjiIJ27psRJqhUFbsDOYuLslSX94UWDGfw3TF+azVsRgP5+prVVBTkka1kzvteMz/4nXCHaHv9qZxGA1Pixcju/bvYgCMZNVA0TjkR5pI32aSgizrNSEGfl7ng34X34y+nPDxq1jCPL5QPQJlWowQhZ6K9In07vt9Quq1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084710; c=relaxed/simple;
	bh=Kg4LZteL+ARnBHp7vXz82+ksWMKh09SXtugnfoi9gt0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O2i0ZurZXo4XURhexh2ufTZP/mAGD5wW2064jBNL5j5ZSpoDBn16MuBpAOWRAz0vV6LVH3HFtIOLc00dXGHb0rSVRZ0MuJlgtp/H+sDiYE6xw2sorQmGGDVCXSy/YO0U4Bobjjgrzstq9DacjpA6y0QWd8WVhwPz5HV1JhDYxfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzYdlyuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzYdlyuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65161F00893;
	Thu, 10 Sep 2026 23:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084709;
	bh=1VjkuDb1kdbWjJmudrsGP+r5e5EsGCAhOm+6aiN3IJs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OzYdlyuZ3QN2GaznBd7gqAxq8xnxkipvOhH99rYMgGPcylDoX4tosra7/p2Xlcl14
	 2vd1doxXgNPDnjK73tgzcHBoY3HhBQsCE0ZzpCEd8Sn9Xe/0uwiXeGFaJyY9kML7wg
	 2nY0P99kOfvWumlOrNhkf1CpwRysO2k7epzFXUVyiftJZiHKWpnvVipMKlXz7PRkXN
	 asEeiJotpEMBMg6Anfm7gqtzudw+gfmw+UA9YARdbHF6rU0Y66p4ABvZmfR8E2PGFe
	 QIAoq8jXloI13RlutkMPETsXxIxXtUiKXk9PO84kO3BZJ+mB+9Pr23D7SCeRj2RtNM
	 F/Z18QgcPgGNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/10] selftests: Add additional kernel functions to
 tools/include/
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <5-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <5-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:28 +0000
Message-Id: <20260910235828.D65161F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> These are needed by the VFIO mlx5 selftest in the following patches,
> which includes some headers from mlx5 and also needs a few more
> MMIO-related features.
>=20
> - DECLARE_FLEX_ARRAY in new tools/include/linux/stddef.h (wraps
>   existing __DECLARE_FLEX_ARRAY from uapi/linux/stddef.h)
>=20
> - dma_wmb/dma_rmb barriers: x86 uses compiler barrier
>   (DMA-coherent), arm64 uses dmb oshst/oshld (outer-shareable for
>   device visibility), generic fallback uses wmb/rmb
>=20
> - ioread32be/iowrite32be in tools/include/asm-generic/io.h for
>   big-endian MMIO register access
>=20
> Assisted-by: Claude:claude-opus-4.6
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D5

