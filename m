Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947428;
	b=ZebOO/fFB3QbsliixYebX3dBpejOZKmGp+q9BerQs4F4eB0Zzqwkm1lE9gRn+TZUOHRw
	 P507MNhMBjh38O88H9w7UdbnFskOVipJ7G7HqqgCTrk5mLOt3/YPlfUd42zwL94SRO5ca
	 G3ODmvYDKjzLwHLIEulspjCvIbQeQz+x63fUlwZNkNUbWnhXWkaFciXhSkCBgyXeTuNlr
	 EZFDsbPR7VtEX9VQjDevKVIFlCsMVU2iP0gEv1v+nhwXYKX3GGmHyZeT+J5rtWPkIvL4z
	 5fkFR4fDtHBNs+DFa/W2712oijC1IUs6me6odFDsw6PIex1lBJTt1ytngZHjkVe5MSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947428;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NC906qccF0wvrPD+igXNTOXnBHX+DEseOotQIMDHBqI=;
	b=e17XTlwKb5WK3trlHnC7x2/WVWNDEczQzlKEIcgXEkPBPcjmO11qcFAK1ASuaWjlRfiF
	 JYupwibJYeFO5eSNP4M20Lg9A6lxGhOI5a/xnCRl+BkUEonvsSI7iL1c9yKPDSRcq/xL1
	 aOxi5yKxnjqvM4t9p26RFUyEFFkx03oYlRd9mwNPqmuQru6zvj6k3QAZH01bxM8YD5V+W
	 wabXoBinDZQtdbIkwJzBhDS7HFh2BfymQ714oTeqaNOhrvje6mfjTrx7fa72dyXZDMLAT
	 f7Hw1NkWWS8gjf6ThgVEvmDYjzbSutfelBqusoD7xMfem4TetE6d62CAU8smPD0QpuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3ruutwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E943606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3ruutwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45ED1F0089F;
	Fri,  6 Nov 2026 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947427;
	bh=NC906qccF0wvrPD+igXNTOXnBHX+DEseOotQIMDHBqI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=X3ruutwoDhTtOtUZW5DXn0daFNfht5zgEEvgXd7RnK3wITVyka1VltnHKS/BGfM1a
	 nq+plycE8HaPCL5LkInEAoKjb+8moqUTXX5ulYBomagUBdYzrv9OkOi04ZS6JDcEWp
	 kThfEsn0PFgOZ/2EXXfqPW9/IwAZKgqATCMd++Bh2Aow7ckAWQEknSFg7fr2pQFqiS
	 C8rzmHkc/nOuHMOfGwDm1x83KfBllfax9khMMlrX++Dh9aqq4sTS8lEHqspSPJKW2g
	 owQ+4HFRfsirNHLm5JWFwV649FSsET/gzmUhSmPBWiSc4PN4/P4GaaTv2d4Hi/fLu+
	 R1ppYlnLrC/2Q==
Message-ID: <sashiko-outbox-200917@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/23] treewide: Rename dma_buf_(un)map_attachment()
 to dma_buf_(un)map_sgt()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-1-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-1-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:47 +0000
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
> These map and unmap functions only work with SGT importers. Rename them,
> and their _unlocked variants, so the scatterlist based interface is
> clearly named as such before further mapping types are added.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D1

