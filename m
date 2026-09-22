Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA31C4DAF90;
	Tue, 22 Sep 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116696; cv=none; b=DZU9zEChxfZYqrt9IkGAwcnVmANF3e7q5VXqQriQqCl1ZZJtfKD/1DQ5XzGCdBXvV8+iyete9UcG59oXpAfyuSE5TWXWVGiJejSBIezVEHFY15rA7EkIWyccxkKm1qGSZmO7NzkAWMKK54OqZ6aaUDHFXOH07gNz+YDEfIDKI3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116696; c=relaxed/simple;
	bh=XOtSeaBSEJG5Nyu0X/2yfu6QlkZfINwxz0nOuYYlE0I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RzLTQ5zgFvFdxmCPh+g5evTHKhhC8pGNrw2zHK5wQdvlnAhD2H70b3/CqhxY3L+xkS+uJsIhN/wEdmhV9UlL140mC8frducOFC8HrfVoa9u5IOrovDlubj3ENTdaXj8SmyJSSbtjGarnqFaZGwT49gBqelEEW0/NHwqahmdSOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frvl2gKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frvl2gKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3471F00899;
	Tue, 22 Sep 2026 22:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116685;
	bh=1//ShhnULQsAqUGIEA2Ml+6e70gM/W+I5Wd+7Id+92s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=frvl2gKEXAuhWndlU8S+4EsfPG1QAyzEpOmbKeFtLMn1w4CNqBQ0q3MNdMXU2C8nc
	 Xdh+zl5woS3C2DZPzsVK/Are/4oe8N1QCgFF/w17gfvA8eHCY12G+k+du+/AwHZRR2
	 /R07UMHycLq/C3J8ZnKseX+7aVJBmmcHL8sQ+zZIZC26oczQ1rJcwY16IEPuzQW/YM
	 iWAPJ9YRWMsY5LULavm9D5TeRjFJlqmrxF6XpeCozdTU3fKaJJGM+voTFP17WPc037
	 dDCKcG6FQriA1M9OnzAGL+/9QEwFStrPKFtwbwucRBfqk6uZcq+xW7ziaDmtGmr4Ll
	 BM9hGQoNqzvQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/10] net/mlx5: Add ONCE and MMIO accessor variants
 to mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org
In-Reply-To: <4-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <4-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:04 +0000
Message-Id: <20260922223805.2F3471F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mlx5: missing array element size check in MLX5_ARRAY_GET64
--

commit f06ec3773a4462f249bea83375fa4f6bce249d9b
Author: Jason Gunthorpe <jgg@ziepe.ca>
net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h

This commit adds ONCE and MMIO variants to the MLX5 IFC macros for touching
ownership bits and accessing the init segment using IFC offsets. It also ad=
ds
MLX5_ARRAY_GET64() as the missing counterpart to MLX5_ARRAY_SET64().

> --- a/include/linux/mlx5/mlx5_ifc_macros.h
> +++ b/include/linux/mlx5/mlx5_ifc_macros.h
> @@ -85,6 +85,13 @@ __mlx5_mask(typ, fld))
>  	__MLX5_SET64(typ, p, fld[idx], v); \
>  } while (0)
> =20
> +#define MLX5_ARRAY_GET64(typ, p, fld, idx)                              =
     \
> +	({                                                                   \
> +		BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64);                 \

[Severity: Medium]
Should there be a compile-time check for the element size here?

MLX5_ARRAY_GET64 performs pointer arithmetic on a __be64 *, which
implicitly scales the index by 8 bytes. If this macro is used on an array
with elements that are not exactly 64 bits (e.g., 32-bit elements), could
it silently compute incorrect memory offsets and read from the wrong
location?

The direct counterpart API, MLX5_ARRAY_SET64, enforces this exact
precondition via BUILD_BUG_ON(__mlx5_bit_sz(typ, fld) !=3D 64) inside
__MLX5_SET64(). Would it be safer to add a similar BUILD_BUG_ON() to
MLX5_ARRAY_GET64 to avoid an asymmetric safety gap?

> +		be64_to_cpu(                                                 \
> +			*((__be64 *)(p) + __mlx5_64_off(typ, fld) + (idx))); \
> +	})
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D4
