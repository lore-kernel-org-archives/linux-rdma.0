Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48653ACEE0;
	Thu, 10 Sep 2026 23:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084708; cv=none; b=oxB1Lzk2iv/SlLi/6N3Duxw/Ic6cNR78i9jyYiM0oiB+YuFX6rDbaVRrhsflpc/iEo+MO7O8jYVAgn0l6xX61FaquFK/iRXtWnhyt3BGWgSkFU14CdVaPHYo/bwm7l+C3+Lh076bb+r339iueUMs6kAxHr4gfGxxZTIWn5PEBPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084708; c=relaxed/simple;
	bh=gdusUC91wWd9YzgWpmvyHV7+nYuzaAS/UkCZsALCwio=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X7k/36XmrBU+c/Lf63lGnpAbrrhaFFP+UNCTp9wNkqtT1QkkJHuBS6FW3318rjbpCyFmckD6JQybj0GCC6cvKy3pAqJElVNdfuPKaRTc/muZDU/T+MBROe7vB13niuOCeCjwEyVw0LjEjlGYls9Vg2qsB+504c9HSHjrNiqW7/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YjjI0Isi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YjjI0Isi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B081F00898;
	Thu, 10 Sep 2026 23:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084707;
	bh=gdusUC91wWd9YzgWpmvyHV7+nYuzaAS/UkCZsALCwio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YjjI0Isi71PzmBYgqU/xHKbiNjLQXg4yXOA62Br0d1pCOTx+3ua9ioM/jSFLz02JN
	 fjpggFoO5OXGKdmHzXwZIPmoC0VmHGjs0bB2i8pNFwZThwCJYO9MeM9tjNIxoDk8pC
	 2Ng0bctarxIdMnAd9cSv/s1msCD1qXzMmemzQXUNis/GZx2XqxOdbKpBlxR5CvGdy2
	 IfAtFd3rrGYlJeq9Yk970AO6skM6SCbCnYAO1FyP3HX6y4ekcDWBSl9XqFapeMAFj4
	 WZOizoHx+bg87YYXabmOWHCmMZspsy+cj6ApXltPH1FmiIP9SAp1VQlC+rPZOaZ6gf
	 LVq39aRyq+reA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/10] net/mlx5: Add ONCE and MMIO accessor variants
 to mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <4-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <4-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:27 +0000
Message-Id: <20260910235827.64B081F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add MLX5_GET_ONCE / MLX5_SET_ONCE which include READ_ONCE/WRITE_ONCE
> semantics for touching ownership bits that hardware may read or write
> at any time. The kernel driver doesn't use the IFC struct for these
> ownership bits, but the VFIO driver will and needs these helpers.
>=20
> Add MLX5_GET_MMIO / MLX5_SET_MMIO for accessing the init seg using
> the IFC offsets. They embed a readl/writel using the IFC struct to
> generate the addressing.
>=20
> Add MLX5_ARRAY_GET64(), the missing counterpart to
> MLX5_ARRAY_SET64().
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D4

