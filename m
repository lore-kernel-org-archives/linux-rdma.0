Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4FD4B5CAC;
	Thu, 17 Sep 2026 23:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689164; cv=none; b=l8iPLeUergmoymffDBUjz6nNFCrqxdhzUXH16tn0pK7lFbWgv3QLI3Lcy1Mj7pNA1pzgbVRr61PZRl6JXz+MLaNJUTT1/I19Vrvv37up8dtZVSAePXwjmq0otNfb4zwTqKdVlzuiJzNCphJWxKnXiBbYg4oj64KbMqBSa1nFtHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689164; c=relaxed/simple;
	bh=CjRJfjYf/ZQ6owBpG3e2xkxny7AV3wpoXB6UQDsTzFc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SlF+Nbay6H+asZb9BlM2iJtvW3WJKsfraZNWYvG4Os8g+wsGF2/wbEGt3V54hg7il3R0zajXEX9gFAhKhZZ4ieOr3MRx840XyC8mHsZO2o5mBjpwi1YstXmLRQW28O2+1IC+nEoBV4YVkduHeg6Musz2piN65gN9ftn55BXODQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m65N8v/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m65N8v/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99E41F00898;
	Thu, 17 Sep 2026 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689163;
	bh=6zGDjReEjWhnveiiWHVUAJ0E7xd5jhLvLiDNJ6XvKS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m65N8v/eobYXJQEfpuBydia8y7N2SbD0MtJcIE8qAojYv9AlKgx40mVosjScJcp/+
	 vQPUFI11tvdd0owcWsEka/6rD2h94jA8DHdrndJawYE838Rp541w8jA87eYOc6DJde
	 Je85qo2RPP1ri30wnTbVFxZ8injufsPUxDg8tquEytQorALNVfa10CqDU5uYObbytX
	 D3l93YJ4i0nD9sLuVol+qSXK6zjfFAqtwQaOmAfcAIoZElYLr+qKkj90s8r3zG0nWg
	 nPzjNDIvaoN1vmd2IqHo6N4OTuaW3HEFLRNjQe1NcJShVGfna1xqctWitxZ8Q/6wAk
	 24FLVQl1USK5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/10] net/mlx5: Move HW constant groups from
 device.h/cq.h to mlx5_ifc.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <2-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <2-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:42 +0000
Message-Id: <20260917235242.E99E41F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D2

