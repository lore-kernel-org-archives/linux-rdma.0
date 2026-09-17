Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043984B95C6;
	Thu, 17 Sep 2026 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689165; cv=none; b=l+MdrtWe8jZqCad4ve9Ck7tRDOWex+E7gjKYbKvFXWQMrfWrri+ImF6TnnK6EM1AzQ0oLTRew/061Pd23QAxNlhmZ23CrvTH9OwEKr+Sfdh0EVmocy2Jqb4Bv5/3JfbfvEE84u0rZwrleEz3Rl9AfjGFFwcY9DwtzLvzhUiGisU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689165; c=relaxed/simple;
	bh=EYOC4tedEz1nL+NaHoODPWS+jdEB7wQdtBk/tdooHPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W2VEZ55soK32C4eh0mScqd4BqPWkxSShQM3/FqM2Q4iTONmKdiqNBcSz3fwD0XRgndxovCS9YmiL2zUjGSeXP4x5nKWzSqeCNqsFXbElWaHA2BXyg/XqmOAtsVRiauWbv6z2TH5dTt8Ycg8prRhfACLPetEjDzjiBz9YqSTThNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ks/QTZeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks/QTZeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B281F00899;
	Thu, 17 Sep 2026 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689163;
	bh=wPUDOXcMr3Bv8QrQsOQP7MQWkZjZfA1hBQAtbltQKM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ks/QTZeEQ9e14yJIk1Na5YKjhrosW8U+ERbp4m8Rwino7zQs2W3pTEpxGHsrQ3lL4
	 5RgmUHiqi7hi8+T9UeK2i7EXWnm8BQGcAo6JmTlHIan4/wayUiksFs5fR/CQ/sZ8+7
	 orO4gmzMnnP7W09GiSkNMi9PSMxICDHtubNQ27k5M1xoEd0dM9kdDyV/sJQYC46da8
	 jWZSX+Wxe0ljX/VkX+UCS/koaqW4dGiwb28CI1+4MTZ26qsho0iga3Y4XJ7aNmNfCK
	 ppei7xXv5yp312ptTq8QMM6UGoGZ+Xi3WAiKn4jb8qy8VP7cQ/nUs7UpjoimE0E7OQ
	 B9AUxTJJNHtiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/10] selftests: Add additional kernel functions to
 tools/include/
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <5-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <5-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:43 +0000
Message-Id: <20260917235243.89B281F00899@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D5

