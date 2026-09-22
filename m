Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7159516160;
	Tue, 22 Sep 2026 22:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116713; cv=none; b=e6y52CrO/AoE94nl/c4AqSRigmd49N1rnmDN4M4FR1K77JzKhqMkee8X4xJIQKEfgltEA9J1t0SuWCz0jdGRTLScGXgVjfN50qmPLcku4vv/AmIdAvpsZw0I7M92BAvr5zgWiYyHEYxEHD6KYOYuSzQ/0ep8cW+1cYhZpw5GraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116713; c=relaxed/simple;
	bh=RgEfiZZTTKV79jM6egY+nWUx4LyAtE2H99TnYTLA9ns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r6uf5136+kUmq2eHCbSHvy0VHB17r226udh2f+jRxyoT46ghC7a/0yXuCCFqG3wso+522Qqb2aGo5pUXhhBFNk8TkBPhel9dLPWaGpqrePzm0+uz4neHuW0C9RuNVs+4f9csl992uzbHgVw9gnjb36Z52kO7pmvBzPo2s4ZS0ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0q8SGQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0q8SGQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AD71F008A0;
	Tue, 22 Sep 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116690;
	bh=my+frk4+w9bBjS28BiutqnnVxn8d1uWuXkOFOwI7Aq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n0q8SGQtRwRm/Vql+seSZOAReD8MTul1Gwc2fUTOP2euanttRc5naanaS04ORIJed
	 Fkt1RxckVRMc/5ftLUVX4W7MfUkjXUW5AfgG4LWCN1Rm1ZK3eEVilbxU2K+lnn3Z4E
	 eypahvmLMmrjiG6OM1Nx3fNXK2l3ZicWuk6KWg/joVrp2BaNQdhKC4rALvkZVg9kNU
	 awMPMQAesn5Hu/ZEG2gvuHgYdvvgHgWT8nUXx24cq8b5mjDjzrxwqRPo9Xms9i6Q0K
	 qLJel0+Swjc82lNGPpCTGT9bW12oz8nKR/anK68KU9uzTLW47+7GKlE8owojPPNKfB
	 FJAYEx4lTjFDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/10] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <8-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <8-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:09 +0000
Message-Id: <20260922223809.C4AD71F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mlx5st: heap buffer overflow in page reclaim if firmware returns=
 unexpected count
- [Low] mlx5st: undefined behavior from shift by 31 on signed integer
--

commit f9f4134244715fd3ea4fedfb4a360ac94a2c1857
Author: Jason Gunthorpe <jgg@ziepe.ca>

vfio: selftests: Add mlx5 driver - HW init and command interface

Add an mlx5 ConnectX selftest driver that programs VFs and PFs
through the command interface. Create the driver skeleton with
probe(), the command interface, HCA boot sequence, and all resource
allocation up through ALLOC_PD + CREATE_MKEY.

diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools/t=
esting/selftests/vfio/lib/drivers/mlx5/mlx5.c
new file mode 100644
index 0000000000000..5a87d070dc425
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
@@ -0,0 +1,1414 @@
[ ... ]
> +static void mlx5st_pages_slot_post(struct mlx5st_device *dev, void *in,
> +				    unsigned int ilen, unsigned int olen)
> +{
> +	mlx5st_cmd_post(dev, dev->pages_cmd_lay, dev->pages_in_mbox,
> +			dev->pages_out_mbox, in, ilen, olen,
> +			1 << dev->pages_slot);
                        ^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
Does this code trigger undefined behavior from a signed integer overflow in
mlx5st_pages_slot_post() (in tools/testing/selftests/vfio/lib/drivers/mlx5/=
mlx5.c)?

The hardware configuration sets log_cmdq_size to 5 during initialization,
allowing pages_slot to reach 31. This would overflow the signed 32-bit 1.
Could this literal be 1U to avoid signed overflow?

> +}
[ ... ]
> +static void mlx5st_pages_slot_complete(struct mlx5st_device *dev)
> +{
> +	struct mlx5st_cmd_queue_entry *cmd =3D dev->pages_cmd_lay;
> +	void *cout;
[ ... ]
> +	if (dev->pages_slot_is_reclaim) {
> +		unsigned int outlen =3D MLX5_ST_SZ_BYTES(manage_pages_out) +
> +				      dev->pages_reclaim_npages * 8;
> +		unsigned int num_claimed;
> +		unsigned int i;
> +		void *out;
> +		u64 *iovas;
> +
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
Could this overflow the dynamically allocated iovas array in
mlx5st_pages_slot_complete() (in tools/testing/selftests/vfio/lib/drivers/m=
lx5/mlx5.c)?

If the hardware responds to a MANAGE_PAGES reclaim command with
output_num_entries greater than dev->pages_reclaim_npages, this unvalidated
output count dictates the iovas assignment loop, overwriting adjacent heap
memory.

> +
> +		mlx5st_fw_pages_free(dev, num_claimed, iovas);
> +		dev_dbg(dev->device, "PAGE_REQUEST: reclaimed %d pages\n",
> +			 num_claimed);
> +
> +		free(iovas);
> +		free(out);
> +	}
[ ... ]
> +static void mlx5st_fw_pages_reclaim(struct mlx5st_device *dev, u16 func_=
id)
> +{
> +	unsigned int npages =3D dev->fw_pages_given;
> +	unsigned int total_claimed =3D 0;
> +
> +	while (npages > 0) {
> +		unsigned int batch =3D npages < MAX_FW_PAGES_PER_CMD ?
> +					     npages :
> +					     MAX_FW_PAGES_PER_CMD;
> +		unsigned int outlen =3D
> +			MLX5_ST_SZ_BYTES(manage_pages_out) + batch * 8;
> +		unsigned int inlen =3D MLX5_ST_SZ_BYTES(manage_pages_in);
> +		unsigned int num_claimed;
> +		unsigned int i;
> +		void *in, *out;
> +		u64 *iovas;
> +
> +		in =3D calloc(1, inlen);
> +		out =3D calloc(1, outlen);
> +		iovas =3D calloc(batch, sizeof(u64));
> +		VFIO_ASSERT_NOT_NULL(in);
> +		VFIO_ASSERT_NOT_NULL(out);
> +		VFIO_ASSERT_NOT_NULL(iovas);
[ ... ]
> +		mlx5st_cmd_exec(dev, in, inlen, out, outlen);
> +
> +		num_claimed =3D
> +			MLX5_GET(manage_pages_out, out, output_num_entries);
> +		for (i =3D 0; i < num_claimed; i++)
> +			iovas[i] =3D MLX5_ARRAY_GET64(manage_pages_out, out, pas,
> +						    i);

[Severity: Medium]
Does this loop have the same bounds checking issue in
mlx5st_fw_pages_reclaim() (in tools/testing/selftests/vfio/lib/drivers/mlx5=
/mlx5.c)?

If output_num_entries from the hardware exceeds the requested batch size,
this could overflow the iovas buffer.

> +
> +		mlx5st_fw_pages_free(dev, num_claimed, iovas);
> +		total_claimed +=3D num_claimed;
> +		npages -=3D num_claimed;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D8
