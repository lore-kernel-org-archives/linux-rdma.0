Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD043522697;
	Tue, 22 Sep 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116704; cv=none; b=GQJruaztVGYC9o4sZsmTlNl3qInhIIJcynCNBteCH31hnAXKdb7vzh0kZoWUwWRsxJlAMAWAHZoe/NBO1Ug4V2qB9GGclv48kP/B8bPIRJE2WNhyMzwK0wUg5MHKmnnTz/Z1uakMuAhELao4glhD0NJTK57grp6haPlZ31ENgyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116704; c=relaxed/simple;
	bh=6Nk4cq0pQisg3OtYrP23Jb5fNSWGEKlCLBizhkKVV0M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L+IumxvkXdsulIGl2qJamdjQj4bEbXOr4ZyfRW9cQljURC0ndf2gHXTToDIPNTUEza9DYMuWORGKR6XErkbxJvJjdUhwoZ5TOC0bnGnYhfNjvE7wU10lJ0yNfV/9YLB4vu32Rbb6kyNVhG/UZVdoaWUjTPleTn/SU0QJCwB17Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qt3VaeBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qt3VaeBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E17A1F0089B;
	Tue, 22 Sep 2026 22:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116686;
	bh=uB43QfLdOFiW21hWJ7hSO8UZQtQW3zWu59ELi4ozqlc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qt3VaeBXNyEnxFMf/TOzXBvpOX49E27JFVqtmsBRaDmSrGwbVb4dxgtPTe9InHBvn
	 WLcuU7lvQRmIYZJj1eRUliTL4l9VYJnevC8NhwhG+aJZdFKaAxZNf4YiroMWZMM+ZA
	 SFvG9gEElKb1+4u+Urr8o0P2NSETp4/qzHF4bI4jFkcPwYlC1nj7nW2HLhDBiJmCyl
	 hF9jrRlMPNKfWAssS6iUMrM3dc5t51mu5C37cTvZwlEt997Oyp9fGAcoUQU+r7SNFQ
	 s58It695MLiViWWFKAsfDUi9l7e3KgaX+spCT90K0+D9BHMJP8zC6qQKzsMxGh70tp
	 k9+EEXP4/unOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 02/10] net/mlx5: Move HW constant groups from
 device.h/cq.h to mlx5_ifc.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <2-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <2-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:06 +0000
Message-Id: <20260922223806.8E17A1F0089B@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D2

