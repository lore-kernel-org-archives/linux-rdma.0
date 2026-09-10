Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6C3BFAED;
	Thu, 10 Sep 2026 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084712; cv=none; b=gkalw6HMGQpBa31kfANg31MARlKinP6AODwYLYfl/x6MYVvcWjFxYEUyXozusNtnaymo2GzaS/uH85Q7+wrJawx88rtScHaoWjB+GeSXoJCeKVa0/dzoCBOykPw8rFQYnV3iYFgRhyLbche/GLPsHqIu7bgNpBPDx7fWJrV9WOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084712; c=relaxed/simple;
	bh=881zKzhmi0+0PCMUHPpAiID/JeARJUZmCSRVzqIa2nI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eBCoFvB9UUS4LCgCCEQrV9xJGOg9KJ5KiD0b9zbx24s11CPk4zVGbRBJeFyLYMtnK/V5INhR0cLbI2wdYnYQOcyL4r+3yvVW456+We004m5gGfHiMljBOks4tNb4UhLrvzdcV3mSwwE/Xqu6R19ozYAIWUEcOgFdt8B0bRJ/Pdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKoOvJFA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKoOvJFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69131F00898;
	Thu, 10 Sep 2026 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084711;
	bh=cz3OgeiE0lhxPwAKdE6g3U6m/GmO37VyT2D5bTa9Slo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RKoOvJFA4L5pz4WspDIrP3bbV9cYQX1mk/J6mNIgNHHEc0B0e/8sI6+TV5cGkgbsB
	 CcQn70454xiUDfIuemlvlHgeX2fiidh1aShjKgzjWAZIJsC6gIPkSb3lUeens4jB/w
	 wLpNj7GPk9uLhzKX+AWTtawlLEGvK4m6trjOCeGOx0QUbjclbX7iKF75alSy7Bzx0v
	 xYGnjcv+tVYptzhWjFWAkGEFOz6lrcnuGfb37xBYQAUYagm1ejo9aZya4Tw20OuO1r
	 NfzebI1J8g24xn4JNV5tjbHWaZJHuzYa8BP/ddhViI4CcQuMKFrU4eyd6z5qFcqA9o
	 wmBKvkn+JH5wQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/10] net/mlx5: Move HW constant groups from
 device.h/cq.h to mlx5_ifc.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <2-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <2-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:30 +0000
Message-Id: <20260910235830.C69131F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Generally the IFC file should contain enums for the fields it
> defines. Move the ones in device.h that are relevant to the VFIO
> selftests over to the IFC file:
>=20
>   wqe_ctrl_seg_bits.opcode: all MLX5_OPCODE_* WQE opcodes
>   wqe_ctrl_seg_bits.ce: new MLX5_WQE_CE_* completion/event modes
>   cqe64_bits.opcode: all MLX5_CQE_* CQE opcode values
>   eqe_bits.event_type: enum mlx5_event (all event types)
>   cmd_out_bits.status: all MLX5_CMD_STAT_* status codes
>   query_hca_cap_in_bits.op_mod: enum mlx5_cap_mode
>=20
> Tidy MLX5_PCI_CMD_XPORT which is an alias of
> MLX5_CMD_QUEUE_ENTRY_TYPE_PCIE_CMD_IF_TRANSPORT.
>=20
> No functional change. All existing users of device.h and cq.h
> continue to see these constants through the include chain.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D2

