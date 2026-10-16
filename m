Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2648DB4F
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174679; cv=none; b=BdUI/FBC1mSq8oEPiF0Pk+bbStUO6ZLTw3nzL1+MN3pYGbkRt3BMU7VUBNM/VjlX4HxzGLqCaHrrj+yk6pD2bM6nIr7+6twCJXcyWhKpxQDTjkPOYG4egNKRCBvSbELYuJe3qchF7RGhdRYupiKciQPk639O82fsFj+8QeY0HDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174679; c=relaxed/simple;
	bh=SFHVc1IMGltYC1O9Jekm5mxiBSI2lnsMNJNqnHWl0rc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mr9jUCpaCW9CYuszZjnhBhbQLzOO7p+kTzJi11pxcqnI45TbmprGm3+bIrswKZlNzL3hLL2nHwzoJTn0XeIeQd5G5f97hXvLDCrB+Bwd040vrywVgXkMGd5cZsNt2vJbZgdwt35eNdSzPDpGQ4fB4NXGSUiOqNqLLyYoFbc8uFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpFePnvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpFePnvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577511F000C4;
	Fri, 16 Oct 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792174678;
	bh=SFHVc1IMGltYC1O9Jekm5mxiBSI2lnsMNJNqnHWl0rc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CpFePnvF2WuG2A3yJfw4l9Iw3k65Z/kP4Xv/HoKk7GXYvvgljiVuvK0jYTh5cRYUn
	 pNGlB0CL7Rk+gm583pm08hTm9KyLsdfWd/fJcRaDNFX0sWxSn08/8hGELU/fgqZIks
	 PRPA0nPYYr4IXuZD0NS4I2LaUUEjwXQhWpRIZ5sybQJAniXv25vNDJ19j9qACu6g4L
	 xOo8MrfZ5sc43MrbZ7DBjgRZLxfMxrW9GyrzBytsZdxC+Byx9rRYPpUS5AFKv3fFh+
	 ApZEe0eFcemlTaQ8zHFX8rU6moIZeKNYtoBsZ0tKuxS5oz6eFCRyPIDA9cfskOFzgx
	 E8Gi62irkf3uw==
Message-ID: <sashiko-outbox-174764@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Fix PBLE_LEVEL_2 FRWR generation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016180901.3292775-1-jmoroni@google.com>
References: <20261016180901.3292775-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 18:17:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When an FRWR is posted with only 1 page mapped, it uses a
> direct mapping, with the page-aligned DMA address provided
> in the WQE (reg_addr_pa). This address is obtained by reading
> it from the PBLE that was previously populated during ib_map_mr_sg(),
> but it did not account for whether the original allocation was
> PBLE_LEVEL_1 or PBLE_LEVEL_2 and just assumed it was always level 1.
>=20
> As a result, it would program incorrect addresses if the MR was
> originally allocated as PBLE_LEVEL_2.
>=20
> Additionally, multi-page PBLE_LEVEL_2 FRWRs were also broken
> because it was using the wrong chunk_size.
>=20
> Fix these issues by correctly populating the stag_info fields
> depending on whether it's a PBLE_LEVEL_1 or PBLE_LEVEL_2 MR and
> whether more than 1 page has been mapped or not.
>=20
> Tested with NFS over RDMA running various fio scenarios, with
> and without a modified kernel to force it to take the PBLE_LEVEL_2
> path.
>=20
> Fixes: 137d264c6f63 ("RDMA/irdma: Add 2 level PBLE support for FMR")
> Suggested-by: Stefan Metzmacher <metze@samba.org>
> Link: https://lore.kernel.org/linux-rdma/20261012161135.494544-1-metze@sa=
mba.org/
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016180901.3292=
775-1-jmoroni@google.com?part=3D1

