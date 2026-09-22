Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E347532E;
	Tue, 22 Sep 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116696; cv=none; b=h3knOuiuC0mL6XVpjKVtfy2CNWq2lPZC1QzrcEyOcRoT/7/W2I169YFVcQlXB5hLnr80uktRZRD8YzBZ+Gqch4LT2wNQA92a1SFd11bDP9WA/spAPRbvydrKKIQ63Ffx6V2NICK0xq8eWp5oLAHa8N/nY1BrscF57Se5SmNphAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116696; c=relaxed/simple;
	bh=aEi0HW45C10UKbgYKbjDOZprv9eycgPs/DR+OUjFfyk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZFLnQhukY1wGNlRM2w1SZ9OujwGj2ucmFwhQQbK2Cj/UUiZV6kVYveGWeNLMxoJ8dxBGAdDsUz5F/X3+Z9d0pGGeCqkWHUiH730n/huXFrRs0tG1WAg6s7S8IVH4A73SK27WAp/1gu6QlHbue1hLri+oya1o7NANXdthd6WWKCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EU/ZTimr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EU/ZTimr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DBB1F00898;
	Tue, 22 Sep 2026 22:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116684;
	bh=qIPTEHl2znyYxTUBn4o4sRNBgkeC20rcoBEjHmrawv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EU/ZTimrJM/iSKN2bx4ZBct/vX1R1i6Xo2y4c9VdEEdfNOwgKvP5d/jMZsOkQID8v
	 yVCqwWGw65vq3uXYQGXj5/zn9LVzSxLNWAY9DdeUdKczv5mE3jIDwuTJVCYwPQxT3B
	 tUrLubzhBAuk68iBcBcjpEsm4xOZXZDlasjP5mASOQnva3XE7dnTtgfBv3J/dMrups
	 ion9IsCXF3tkjn5BLvjdP3iW+eVoiZxWN7RPFuo5X4z2rI9PHM4qdY6Z189CzU8eFL
	 sQC6n8KkiiJ6iKTTlbAWZ579x81RhNmGzlNXlxK8TRdn/TEgMdFo0DNLwWa0sLE2tj
	 UafrBjsShAW/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/10] selftests: Add additional kernel functions to
 tools/include/
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <5-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <5-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:04 +0000
Message-Id: <20260922223804.87DBB1F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D5

