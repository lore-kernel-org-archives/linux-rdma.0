Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C65F51589D;
	Tue, 22 Sep 2026 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116707; cv=none; b=GEedn6SJnpmLAwg9dyF2GBu+ufEq9h8LMZUsrnI8vjG0nt8jqEhF3SOiiXQ/im5j5jLcMZvFX2kCh+k/AOPnWppKJGlvknzCKz8Q0XAkDE+rHnMNmWzD96NCT5yAAKuMLJXhZi4FVDDpIJQpk7K16POmrSvMRn3XpuVHNrFQdUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116707; c=relaxed/simple;
	bh=LhvhMsB/Rmpbdd77UtB7W222BAqgLTvl6re7OivyXd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jx+8fgbH3s8jFijNFNGLQsr7PY/iVjUes0204+YGlsnA0uAK76faQNFQUtSvgvVMYGKu0HrQ+mvAnc1ooQ6UA7wTR5V7s51p8gvymlQLh6Ae8Rh03iiP3vNLnkp3aOWo9vHzyZX35CCWqorzGwHUt5HT/ldlhG6s6vQJGNVi+cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyZdT2yD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyZdT2yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F1E1F0089C;
	Tue, 22 Sep 2026 22:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116688;
	bh=6N/RpENozORmvwuvnofz4kRrj5OeMAOlpT2bNz/S3fw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZyZdT2yD17jM8fBCKPIJMm449JmrjZoOU8VzVdF5a2WSzsP9H9DRwB43yaFzoQKd5
	 IrJijXGjrb6Kb3i7nGWNg5+fTmgaPdoCmVc/krcTcCN6OfEIgcZQ/cdylwH65eINFY
	 bF5/cTZfA7P24n3kBoW3h6tKNY+pcCsur+eAgK4vMz7dBKWiyFWtYNHiTkYFPNn3X5
	 /j7nazv3Y3CJn4XAOz23KnyNW4nEie8s2tBIWXd/Q5o7hVKn/AIGZMezr7Y8HuaA0h
	 TCplEkoXwB5ZWyrcX+TI51jFnmXSip0A0ht8jKqKAH1X3UIgC39WrCk9CKFbWu+fo/
	 sP+4SNMqm38Kw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/10] net/mlx5: Extract MLX5_SET/GET macros into
 mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org
In-Reply-To: <3-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <3-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:07 +0000
Message-Id: <20260922223808.30F1E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Extract the entire MLX5_SET/GET macro family and their internal
> helpers from device.h into a new lightweight header
> (include/linux/mlx5/mlx5_ifc_macros.h).  device.h cannot be
> included by the VFIO selftest because it pulls in rdma/ib_verbs.h;
> the macros themselves depend only on endian helpers, BUILD_BUG_ON,
> and basic C types.
>=20
> The moved macros include the internal helpers (__mlx5_nullp through
> __mlx5_st_sz_bits), all size/address macros (MLX5_ST_SZ_BYTES,
> MLX5_BYTE_OFF, MLX5_ADDR_OF, etc.), the 32-bit accessors (MLX5_SET,
> MLX5_GET, MLX5_SET_TO_ONES, MLX5_ARRAY_SET, MLX5_GET_PR), the
> 64-bit accessors (MLX5_SET64, MLX5_GET64, MLX5_ARRAY_SET64,
> MLX5_GET64_PR), the 16-bit accessors (MLX5_GET16, MLX5_SET16), and
> the big-endian getters (MLX5_GET64_BE, MLX5_GET_BE).
>=20
> device.h includes the new header so existing kernel code is
> unchanged.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D3

