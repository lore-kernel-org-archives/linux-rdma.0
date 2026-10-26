Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007556;
	b=spPvPEzZT3itSfAY/hQxYJ8gWD6rcwEW6Bz0QsoCwp3Nr/Gv3vDa31lF5isGr5WnFQLq
	 Xs9B1phXhMaQlNRpIgDJjebFgfCO56/uUjaCgqlxewM3UPci7gK+UmMldkoTGug0LknlE
	 K74ntwgXuHOEVWvshNuHo8ZkiNH0dAYTsSi+1PmL5EiCNNGDhlWkx2j2i4K4v7CIkXP1l
	 OlUMLhFyJ7H7PLd99y8lU5IxbFR88pYa7v6I6J2IUDmm8fqrLSnULC9wyP6GNLdb1abj5
	 imJGjxgqjxBHrM4kekHanad1+fibVGDrzNC6ZKXUNfpA3XVduKclwFEIhe6A8xx30vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007556;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1AyvIYwnywPYL7MPqoFBt4IVNIIe2FtccRkHa5nsyrE=;
	b=3geokXA4eSFUmsMQTg4gnJXSNWVpt5UNWVlIHdkdrRcSkw+CVpbZt7AQ3jqV1WFjluV9
	 7XIhbMMrDoft+H8ie6hFPQxo5jvxpQk487mAM5xe6PgGESmfntnJkVJRtpqoWjzRyNECq
	 p+U40uDcZvxUP+sRzcZcWnLEGnfPioZQMP3uswLFBv0PQ6rTDcmiz6vaTRnJhFfwDzv4W
	 eHHkoaI7q9UycHomyWHIpS4aXvGkgVTUJoJxtMrxC1zWg0nhLYo83eTk4FG3lzvq2yLMJ
	 UZFjeZesj38DwPOQVrRpp49oyo8uO72DiWCnhi0Xc6TANXlWAyrTsMSlHw80/RQbZ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Enm3DKhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB2A606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Enm3DKhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF4F1F031E2;
	Mon, 26 Oct 2026 09:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007555;
	bh=1AyvIYwnywPYL7MPqoFBt4IVNIIe2FtccRkHa5nsyrE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Enm3DKhgw5LGyCsIJwN8hYvUuaFkKlBhyAqbReYrLB9a0c6O+Bm/dDl+qnd417r9a
	 3xm6KeRVVnHRDICn+/enceb4hTGW/nY80jx+en6lF16P6u0LvOB4rKqXR4x3stRJEJ
	 +Ocfv/00bVK5sK7/0P6dXa9V4xq9PlN3kH2WjhgBbSso3dznYQJdpSApYbhJUf9ef/
	 KFbMBrFHio90ItOmFDSBeray0hUXgrmG0Q6vAEYRHPk+TWIuG0RvoNsshWCgJnssXb
	 ZXCEf9iIey54GGcLNWKdgUIdhU3AKlHQfGLKalxZODQpp7skXex33kkmmQuLqa+J3t
	 LAT17wT7T1jCw==
Message-ID: <sashiko-outbox-184817@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/26] dma-buf: Remove unused SGT stuff from the common
 structures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-21-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-21-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:39:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Now that all exporters are converted these compatibility things can be
> removed:
>=20
> dma_buf_ops: map_dma_buf/unmap_dma_buf
>              Moved to dma_buf_mapping_sgt_exp_ops
>=20
> dma_buf_attachment: dev
> 		    Moved to attach->map_type.importing_dma_device
>=20
> dma_buf_attachment: peer2peer
> 		    Moved to attach->map_type.exporter_requires_p2p
>                     accessed via dma_buf_sgt_p2p_allowed()
>=20
> dma_buf_sgt_exp_compat_match: No compatibility exporters anymore
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [ use dma_buf_sgt_dma_device(attach) in dma_buf_detach trace point instea=
d of attach->dev - apopple ]
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D20

