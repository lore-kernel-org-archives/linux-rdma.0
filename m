Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAAD4BF950;
	Thu, 17 Sep 2026 23:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689168; cv=none; b=W292ItjAcaEd8dFemAk66hLck9WBLAQc60ZrgxNQSLhff5wUWQFH5/GrjlnbTLfSM83yNdg8adTXzlOSz/qH08mgHf77orxB62uj8eBKcV+WWTRC77dA2N3zyYSN8AJUQNyiC7RW9PBmKifS2UwHV2R60lS/i5OGLTCeZHNGYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689168; c=relaxed/simple;
	bh=FLDZHi/oDw9SiyFvQhLM/tpt+9PSbd8Styr1SqtuKXs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AdRmTsPCBe7cEOGmKLqmX+Hoh0B70pXsnhbkRVNe5iyqh6/NCj/z1W+Kb/+zF/ysqwzBH82Mr5g40MBlF2L5R+Zgoo8o0s5AvFvIFwkNT3YGTk5YVqQrKm7BUBL0+qZ6c+VPosA35LnQFAaaMTgswNs+zoP9GjKY5zlq8X+GSuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELFNp+UK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELFNp+UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D9E1F00899;
	Thu, 17 Sep 2026 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689166;
	bh=T9Y0HBe9Rr8UcJGA7aEKw+Y3NAkx53TpIfmzrI+s32Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ELFNp+UK22RN3yqbqt6A00c8ELxwji/R8WLCpJeiq2RU2xKXhmZEnnCPXwxkCPmza
	 dBTjB5tUPkKuRmrudAXjbkvOr02YwZumap3qIQZNUkQHu1paW4i6hnyRsevEpuDnen
	 NJLxj2GtXw7QVO7XEdUrGguw0GLuVvyCk1KiEP9VE7ghNtnKWo84VVhFcFhY/ObW2V
	 SGBmhnUZBUs3tkfxNiDiRMZXQuZvuzuNbbWQ6BZRMTycbJAL0pe0Fb466SyAsb8+0R
	 AfD5WnseOvIyWW2b6PvDTnHPNqqLPWC5BsQrmz3T4BWv3ERtPkEJwVGl7OJJIvq43n
	 p6/roixByRVPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <8-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <8-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:46 +0000
Message-Id: <20260917235246.81D9E1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] mlx5: selftest hang during teardown if async pages slot fails to=
 clear
- [Medium] mlx5: heap buffer overflow when parsing malicious firmware recla=
im responses
- [Low] mlx5: integer underflow if firmware returns duplicate pages
- [Low] mlx5: undefined behavior due to signed left shift by 31 bits
--

commit 68a628cb8bf0f80c85d9912ed7b2b29ec71b2e76
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Add mlx5 driver - HW init and command interface

This commit adds an mlx5 ConnectX selftest driver that programs VFs and PFs
through the command interface. It creates the driver skeleton with probe(),
the command interface, HCA boot sequence, and resource allocation.

> diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools=
/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
> new file mode 100644
> index 0000000000000..5a87d070dc425
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c

[ ... ]

> +static void mlx5st_fw_pages_free(struct mlx5st_device *dev,
> +				  unsigned int npages, const u64 *iovas)
> +{
> +	struct vfio_pci_device *device =3D dev->device;
> +	unsigned int i, idx;
> +	u64 off;
> +
> +	for (i =3D 0; i < npages; i++) {
> +		off =3D iovas[i] - to_iova(device, dev->fw_pages);
> +		idx =3D off / MLX5_HW_PAGE_SIZE;
> +
> +		VFIO_ASSERT_TRUE(idx < MAX_FW_PAGES);
> +		dev->fw_pages_bitmap[idx / 64] &=3D ~(1ULL << (idx % 64));
> +	}
> +	dev->fw_pages_given -=3D npages;

[Severity: Low]
Could this integer subtraction underflow if the firmware returns duplicate
pages?

The bitwise operation clears the bit without validating whether the page was
actually allocated. If the same IOVA is returned multiple times, this will
subtract from dev->fw_pages_given multiple times and may wrap around to a v=
ery
large value.

[ ... ]

> +static void mlx5st_pages_slot_post(struct mlx5st_device *dev, void *in,
> +				    unsigned int ilen, unsigned int olen)
> +{
> +	mlx5st_cmd_post(dev, dev->pages_cmd_lay, dev->pages_in_mbox,
> +			dev->pages_out_mbox, in, ilen, olen,
> +			1 << dev->pages_slot);
> +}

[Severity: Low]
Does this code trigger undefined behavior if dev->pages_slot is 31?

The shift uses a signed integer literal '1'. When shifting by 31 bits into =
the
sign bit, this causes undefined behavior.

Should this use '1U << dev->pages_slot' instead?

[ ... ]

> +static void mlx5st_pages_slot_complete(struct mlx5st_device *dev)
> +{
[ ... ]
> +		out =3D calloc(1, outlen);
> +		iovas =3D calloc(dev->pages_reclaim_npages, sizeof(u64));
> +		VFIO_ASSERT_NOT_NULL(out);
> +		VFIO_ASSERT_NOT_NULL(iovas);
[ ... ]
> +		num_claimed =3D
> +			MLX5_GET(manage_pages_out, out, output_num_entries);
> +		for (i =3D 0; i < num_claimed; i++)
> +			iovas[i] =3D MLX5_ARRAY_GET64(manage_pages_out, out, pas,
> +						    i);

[Severity: Medium]
Could this write past the end of the iovas array if the firmware returns a
larger value than expected?

The array is allocated based on dev->pages_reclaim_npages, but the loop bou=
nd
uses num_claimed read directly from the untrusted firmware response without
validating it against the allocated size.

[ ... ]

> +static void mlx5st_fw_pages_reclaim(struct mlx5st_device *dev, u16 func_=
id)
> +{
[ ... ]
> +		in =3D calloc(1, inlen);
> +		out =3D calloc(1, outlen);
> +		iovas =3D calloc(batch, sizeof(u64));
> +		VFIO_ASSERT_NOT_NULL(in);
> +		VFIO_ASSERT_NOT_NULL(out);
> +		VFIO_ASSERT_NOT_NULL(iovas);
[ ... ]
> +		num_claimed =3D
> +			MLX5_GET(manage_pages_out, out, output_num_entries);
> +		for (i =3D 0; i < num_claimed; i++)
> +			iovas[i] =3D MLX5_ARRAY_GET64(manage_pages_out, out, pas,
> +						    i);

[Severity: Medium]
Similar to the issue above in mlx5st_pages_slot_complete(), could this write
out of bounds?

The loop bound num_claimed relies on untrusted firmware output, while the i=
ovas
array is strictly bounded by batch.

[ ... ]

> +static void mlx5st_hca_teardown(struct mlx5st_device *dev)
> +{
> +	u32 out[MLX5_ST_SZ_DW(teardown_hca_out)] =3D {};
> +	u32 in[MLX5_ST_SZ_DW(teardown_hca_in)] =3D {};
> +
> +	/* Drain async pages slot, then stop EQ processing */
> +	while (dev->pages_slot_in_use) {
> +		if (!MLX5_GET_ONCE(cmd_queue_entry, dev->pages_cmd_lay,
> +				   ownership))
> +			mlx5st_pages_slot_complete(dev);
> +		else
> +			sched_yield();
> +	}

[Severity: Medium]
Could this cause an indefinite hang if the hardware or firmware stops
responding?

Unlike the regular command polling loop in mlx5st_cmd_exec(), this loop blo=
cks
unconditionally without checking elapsed time or timing out.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D8
