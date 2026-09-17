Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B974B402F;
	Thu, 17 Sep 2026 23:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689163; cv=none; b=ABf87GHKVa3SECBsbXoYPCIJxOQ5r/pOOZcIQUXhPQAnZPROdN4Ry2ZQPRNiolbvP8ltmby3aXime5Dy7sxVdJZWRodoUG36lO+ZP/a1URL8OnkakAgMgPV8NAQVA5z0hASxph6djnvoA27BONNS+bzmwzck0zRS3cjN+N64Ylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689163; c=relaxed/simple;
	bh=2Yf432fsvvucm+zMkKmMixM3oIhYiY2cVNw1BcZ01Hc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z7McV7M06BqS0XQaI3cEMB6j8iKmpBbi7nkwyJgAsDoksNFnlqiDR0/0bht9yisfeLo1Kojqlxc2WNULSIK8CQkVR35yI8zzKwfaPOUUPx4cs7y9GrFldZbsIHuIJAVG1HvjkaCEQZT7x4cHd74mUNFmnAOyb16UyDIJjuYjKvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mj5YO3Gd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mj5YO3Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E61F000FF;
	Thu, 17 Sep 2026 23:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689161;
	bh=UY7A+0daidfBlkEVpNfAv+ZVkWZpSPoZqm709c3YIdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mj5YO3Gd1XL9phXpgQvQZQ0MT36cFcmeALH8Lkid5xxVUiV3h21sOmFkO1T4i2GAj
	 YM2iAa9DJxvP6Evypjo6kfJ8Ghij7e7Muu51Els0oyMiaaS0ytKRgJ6e9bpxXvQMlo
	 2soe6hnevsGnwCRaXr57U5z3uNmo/O5J6KsacB7gZlt+Ea1VQD2dpWRfYtD+yE8Hj3
	 kU/3DEF2Zl+iaHduJkcb4bJR+EG/D5/ItoDXLwt2VcV/hZ5mU1l3H19kMlRKFsISSk
	 N8gz0Xh4MTJjaZ3qnxHCmS0KKysDh/nc7mIBIt5b7ZivYMZ4XVbRiolQNECTnVNfD+
	 j84WKaixAxUfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/10] net/mlx5: Extract MLX5_SET/GET macros into
 mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <3-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <3-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:41 +0000
Message-Id: <20260917235241.842E61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] net: mlx5: header mlx5_ifc_macros.h is not self-contained
--

commit 0109c2f8560d36d799afcabc263cdbca6ffef5b4
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Wed Sep 16 23:49:51 2026 +0000

net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h

This commit extracts the MLX5_SET/GET macro family and internal helpers
from device.h into a new standalone header mlx5_ifc_macros.h. This allows
code that cannot include device.h, such as VFIO selftests, to use these
macros directly.

> device.h cannot be
> included by the VFIO selftest because it pulls in rdma/ib_verbs.h;
> the macros themselves depend only on endian helpers, BUILD_BUG_ON,
> and basic C types.

Is this commit message entirely accurate? The extracted macros also use
pr_debug in MLX5_GET_PR, which establishes an unstated dependency on
kernel printing utilities.

> diff --git a/include/linux/mlx5/mlx5_ifc_macros.h b/include/linux/mlx5/ml=
x5_ifc_macros.h
> new file mode 100644
> --- /dev/null
> +++ b/include/linux/mlx5/mlx5_ifc_macros.h
> @@ -0,0 +1,133 @@
[ ... ]
> + * Extracted from device.h so that code which cannot include device.h
> + * (e.g. selftests) can still use the MLX5_SET/GET family directly.
> + */
> +
> +#ifndef MLX5_IFC_MACROS_H
> +#define MLX5_IFC_MACROS_H
> +
> +/* Internal helpers -- 32-bit */

[Severity: Low]
Could this header cause build failures if it is included first in a new
source file or selftest? It relies on u32, BUILD_BUG_ON, offsetof, and
cpu_to_be32, but does not include <linux/types.h>, <linux/stddef.h>, or
<linux/build_bug.h> to satisfy those dependencies.

[ ... ]
> +#define MLX5_GET(typ, p, fld) ((be32_to_cpu(*((__be32 *)(p) +\
> +__mlx5_dw_off(typ, fld))) >> __mlx5_dw_bit_off(typ, fld)) & \
> +__mlx5_mask(typ, fld))
> +
> +#define MLX5_GET_PR(typ, p, fld) ({ \
> +	u32 ___t =3D MLX5_GET(typ, p, fld); \
> +	pr_debug(#fld " =3D 0x%x\n", ___t); \
> +	___t; \
> +})

[Severity: Low]
Does MLX5_GET_PR introduce a hidden dependency on kernel printing utilities?
Any selftest or driver pulling this header might fail to compile if the
printk headers are not already included, which seems to conflict with the
stated goal of keeping this header lightweight for selftests.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D3
