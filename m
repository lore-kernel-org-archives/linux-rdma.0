Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D42407CD3;
	Tue, 22 Sep 2026 22:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116700; cv=none; b=D9AtT9V0bXqVCJxLKTKyhHu/fbzhS39gCYJ0aS8c0E56oHTb1AQORy9eSi4hlXamTW6EuzI4M50Un5T2ykDTNpXDMvic0tYTpSBa/lJzFUduS0TkJ6CZ+oYa8Hp+ZYekWT6AlZkYOXZEh48Pz0YPlDFsnQ/QUVtpT7hBaCQn9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116700; c=relaxed/simple;
	bh=mNOBViL11fLZRRQnKJOd83ScVSx8URi/zF95cq49jPw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eCiNrvITQKFXtYDE6gJvz2mOy4J3X8+RFRC+dg8AtF6iNXhZS87A9jlwARe82DabzxmC38g58IdnHxnKwL4nvctOozG4W2lci16QLvDef/Mg6pEplXmzlCeZOr6Tpbz0ghBrC25uAwvJx3qly1skk1iTG8zLKt3RXNwxQq0riFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iueBCeTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iueBCeTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92EF1F0089A;
	Tue, 22 Sep 2026 22:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790116686;
	bh=/RCAM65lvODEghdSKeo8c/g2ZwyApXtTpSYodPGEK1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iueBCeTchq5+lbaZ1rCKQ2saHzLaYuB2X3BoCODPFX6TpWGNO7j65i+VesQm2uoYU
	 XLHDcblU2j26FkazqbMOta8vXfr6vL2dWWMOgy7rMcty9CsWdtVj/DNnFQ73+p2QJU
	 hglzYyteVxb/V7s4ltBZbQPKkk0Hzso24aDxlb78BXdpIQ0QWsSwap4I6OVRDFoo9T
	 oziGJasza0JZX0Qxw8ZtIM4pgpyf9tU+JTPbkhnrOUCNcssMaOo9/pCYZON6K1SqVn
	 yd9bOZx1lWL3CA3ADdLijObr/saiNzCpuiibEdNT6PJf/IC7oJVFjGQnC1DDkfQaJc
	 3nj8vqcNj2zyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 01/10] net/mlx5: Add IFC structures for CQE and WQE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <1-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References: <1-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 22:38:05 +0000
Message-Id: <20260922223805.C92EF1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Building the WQE and CQE using the IFC system is easier than with a
> C layout struct. Add definitions for their layout. Structs for:
>=20
>   - wqe_ctrl_seg_bits (16B): WQE control segment
>   - wqe_raddr_seg_bits (16B): RDMA remote address segment
>   - wqe_data_seg_bits (16B): data segment
>   - cqe64_bits (64B): 64-byte CQE with error syndrome union
>=20
> The VFIO mlx5 selftest will use these.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v7-c6d30e8ce1e4+3=
dfa6-mlx5st_jgg@nvidia.com?part=3D1

