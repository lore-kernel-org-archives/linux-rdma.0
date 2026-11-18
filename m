Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010658;
	b=MT2ErVcr5gsk56vycnZ3ONBFkGFk+LNz2SfKLRwGB+99Q51sxbeBHu3gwaBA30W/JEII
	 uSa1vS+ozWqHPwAoyBNlkeqx7JgSBPKlP8JFbQQ5fJfdN1SYDAdKv3t5vS3pOGK1gcFC6
	 rTNs4g/T0jwyPZFKbXc/6TK5FFuUX89RHwA6WP4caYnodoEsKNhr0V89fPkNs4/Nxiu04
	 QU0s7rtxGTu3mGcPd7x+rl/Ifcj9/t6fTA7ffGceqJeHGor6Hkz4VOquSIvVidhiwwDiK
	 EdTicFE/0TSjwimloaUN0Fm57wBYX7HEIPhUFHmSY8pgMbYDdO3SZhmi5kDt+f8fCmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010658;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V9WjGEOWnUsG/VCyddqUoxObE3G8lF9jSbsI/LNkKd0=;
	b=jPepJeUeaLKx33eXAhdzcDUjralG2RwGAtAn10G4MgJdo1IqI2STMiWWP5H+zHPh113d
	 ckmBNcSDZp6VUsKDi7CQb+pLXJvUWL6ZuDdGaczKNBwUM9cuTjDTE7T7SEXCpNyj1ISiJ
	 Gro5J76uQ7nOvYdybLFHzD84XxnHx1JtpqQ0TzY+0MtCidi4jvo3FVVgKkRfhl+tmFL8y
	 c9z+CLVRomKaHvucVKERsSx1ioKX4A6rKR80SgcEIV2DaX7Rb8+HR4eGqCHQSTwl1pt6q
	 v+QqltgCS/CxKtmlFZI0lkVcNZwJbVoi3Pzn0U1VCwDgl/0Z0c/PvU5RKsRAfqHlPuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CaLkNFWR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112EC60A2604
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CaLkNFWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4071F000C4;
	Wed, 18 Nov 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010657;
	bh=V9WjGEOWnUsG/VCyddqUoxObE3G8lF9jSbsI/LNkKd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CaLkNFWRXiT7axtojEHiEURLYCc1sOxsbSvFja5uTccZGV+rBjP5bwf772pps7kHw
	 CQjAOQ6+8H75sdcolOhLLe3HGo0awRqKaw46noeZ2S7taIlEyusKmDXI5ugJIS2OOJ
	 haG87DAfzSRdSZQOFcalAlAhkxcCLsO+h69hbSXON9ZDHQoZkrc95gP9uEnyKf2Bxy
	 xDrxiBY2ALIyw7NHNvSfpdr+Ve4M301D4Us0trZiArguPf6TpBYf1hcefDiPVmY4Ew
	 W+TfVjgnx3YSmslB66M6YhImooUqDtYzLXMnQEodu7syMpR6uz04Xtdio2PTtBNWai
	 1f+rvPKjoPp0w==
Message-ID: <sashiko-outbox-221135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 06/11] RDMA/mlx5: Select the AH core device
 through their PD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-6-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-6-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Akiva Goldberger <agoldberger@nvidia.com>
>=20
> An AH retains its PD through ib_ah->pd. Use this PD to access the core
> device instead of accessing it through dev->mdev.
>=20
> No functional change.
>=20
> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D6

