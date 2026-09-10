Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D6399036;
	Thu, 10 Sep 2026 23:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084708; cv=none; b=egZtotKXirTabesr28vC3eDpEbC9RDoXhkdgaZJE/v6p/Oryax49bDhjngGGR3MC0W0sk+Wm/Dg4884rpEWwNc3SVYq1YmK6mkbZGcvmvin9wBg4FNcxkPou1d7JqDoMzan8oFm5CoauLqoeX5EY+DEMab8KYxK+35G8Xy83Yn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084708; c=relaxed/simple;
	bh=z862yz9HFKGKE6ggqwRXywk+15czFb7AIieCPR6n7L0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b+IiWIdm1nEGMr6BJHt8trjmk3ButkSCiOOJbbw6LDBUtjVF7FZFo8IewfYzVTtwj9yzRbSGEG9fXJDqyV6mE9U4kQd/UyR1+TLlJv9kH18IQwMcPCoYDqLlZeIdYEg+/njcFj9GSjw3Zhsr/J4d8sTKm2FjYW2Aa8wLD7Zjt3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Giuuvjsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Giuuvjsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC41F00893;
	Thu, 10 Sep 2026 23:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084706;
	bh=l/Ya2cwDe1qu4f9lCmj7GeXZtkCcIbS74ulvDbOxpTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GiuuvjskP7AtA2HS05yRDfvQCntLxiX6UFwNz7tzeqd0TWFUs4rP5bF6ImZr8oNk5
	 xZ9YBGuZrimPckpWcQoozkt6kOI8NwH7105amxb0EwSC7JRJO9rQXNCht0M7Ldbomj
	 dKvtch8QUlq4dvdAlTYPN4dMwA/tW7Fnhpxm3M2F3MBziamLlH/Iv+nR+5Ru1jEqaa
	 zxPCoqtPSJfBPujhl4QJxr/Hl5d1kzZfTzpZa/U0HNeWhFEifwPA7RTglNCbLHhvhT
	 hrdDHVRo7eMJiUK29pXzaAJltJxjO4QpDWDa5OCT+Pedcj367Lww68mYVhdK8x2Hwn
	 Ts8DDZNP0I88A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/10] vfio: selftests: Allow drivers to specify
 required region size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <6-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <6-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:26 +0000
Message-Id: <20260910235826.ADFC41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Format string type mismatch for size_t variable breaks build on 32-=
bit architectures due to -Werror.
--

commit 4aa3e6c27ff1032b734b64f7f2efb3d24be4bc07
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Allow drivers to specify required region size

This commit adds a region_size field to struct vfio_pci_driver_ops, allowing
drivers to declare their required DMA-mapped region size. It updates existi=
ng
drivers to pass the size of their state struct and removes the hardcoded
SZ_2M allocation.

> diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/te=
sting/selftests/vfio/lib/iova_allocator.c
> index 4a660f636f497..f70172f9ceb95 100644
> --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
[ ... ]
> @@ -50,7 +52,10 @@ void iova_allocator_cleanup(struct iova_allocator *all=
ocator)
>  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t siz=
e)
>  {
>  	VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> -	VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power-of-2\=
n");
> +
> +	VFIO_ASSERT_LE(size, rounddown_pow_of_two(SIZE_MAX),
> +		       "Invalid size arg, too large (%lu)\n", size);

[Severity: Low]
Will this cause a format string warning on 32-bit architectures?

Since size is of type size_t, which is typically unsigned int on 32-bit
builds, using %lu could trigger a build failure due to -Werror. Would it
be better to use %zu here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D6
