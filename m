Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404811;
	b=i7FaHjK9splJGe+6PfjPfpEniIvYUyaiz8LQsZQ6ZcfrMNb50nnJ6ok0meW1ED73WvoU
	 Ar2bXVFGepowLG4tD9CY6e/hKXOa1ZLaAGqMWuWpndwtAAgNNgA7ZVGPBlTezFo50OpJD
	 mpapBSPWQ3fQdqBFyaMRVOq/nHfwH7orarDfSKYuI3mrw/89641QjPMx5/8vdSheaNsh1
	 PlLJuPbWCLFgDzjNCp18tCoM7tHaTXeHzYu87W5EQU/C6Qc+sCa7e7RcY/1KslaeF4e4M
	 V0GJGWa/dRm6YrDuJuu4+aHhTvAm9jLxXkogqg5D1h2P/JDsTneXYuYRDIu17OEspJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A+S0o6hDLvVAEwCoCl3eTir9rbDQiMHs5grQH8mrBU0=;
	b=eqMJG7HImCgQ0A+tX6cMsi+OBCHjTKV73hlDACAZbxgqvTUd+Gys7ddYP0iz0JfFUYsB
	 wGyOk5s/eMecMZ7EnjUXpseJhd87FXws9KtMSBvDMv6nYrAbnBAdQ016kVtvTR6gjoJWh
	 Apo2KehdEX56LfgACzpDK5hht+FqTkYqyYCo71raL1cVFHZhmTab64u46VrHhTELG7XAw
	 m1d21DCfcX76JygbP+J7mFDHQLSvH8hXb4dPi6J5QXafb4ozZYu/eEu2PRJ0CKiGtV/CS
	 UcrbRKN0Nv/b5EVnWK0rxW79puPq2FlBa3pvHxXTyAgEAoBVI01CGeQx6iFk3LqpXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fs831qCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314E5606A32D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fs831qCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B21F00A05;
	Wed, 11 Nov 2026 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404810;
	bh=A+S0o6hDLvVAEwCoCl3eTir9rbDQiMHs5grQH8mrBU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fs831qCkVqqqjw3NLwp34woJo869gAtjQBcpEOuknQzcYDr1sYWleSRqf3bwXbTQy
	 coBy6TBl4HWE6eMRPQYox3I0xWolCEZ4aSYNmEzSkcwmgykNKZqqjQ8P2oNu1ieX11
	 hzIaJpk+Q7qiznsHYuWGZU9eK/yXPV2H3GAfUezZkYfmVY+BM1gkPeL+ZwYYPtOVoa
	 ejunHWp0svZbqDqjqb67PrscPRXoo/8+RyGeEXYZ1f4rxNEVMXeE5AZAO2YzXZMxnC
	 k+paIIRV91Zwv9cM7hD7Sc9FPpg5XcQ+LS+Tl1BFx05tUekyXsfvqF2KH4wYTIpLyj
	 yRgf+0QDFHv4g==
Message-ID: <sashiko-outbox-209095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 10/24] RDMA/mlx5: Remove duplicate
 mlx5_ib_umr_context struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-11-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-11-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_ib_umr_context in mlx5_ib.h and mlx5r_umr_context in umr.h have
> identical layouts: an ib_cqe, a status, and a completion.  The done
> callback used mlx5_ib_umr_context via container_of, while every other
> site in umr.c used mlx5r_umr_context.
>=20
> Remove the duplicate and use mlx5r_umr_context consistently throughout.
> No behaviour change.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D10

