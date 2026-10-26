Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002688;
	b=Vewa97iiOOYs201gI7PemB9ENhc9sZ1IozcRxNg81wELBJ5qeR5e1CI6iJJPjqMpWv65
	 qLAyifFTsAe+AzMl9KUpN5FsH0bt9xsEWz9Un7+3Uni7B1TJ+NDh/T76B0I6A35k+BwGn
	 hR3/zmtNn0WcS2DklTBMO9GD0nxfzWKpSJOt82d1DF/GeYDe8wn1uwVi+Fo1VJ7XCof+7
	 qbwkY1uaBDwVoLDi38zu5D5nZMu8k59Qh+29bRaE4qazdUMF+pLrutVgR6yN2Qdbpy+9q
	 AZDTT5Yh92TrVXiTc2NpVwn+zZHnBMYT2wj7MM1gadHqcVHhVpph7BwPqWa93KThJ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gx4K3wKYbWqzXsAmQl+300TW1XUuiW6o6P202YOx+VE=;
	b=1kHaTscjAmnQZ7JrmiFJJkKWcE0/2RYfLnslIgca1A55TwqGlLMUZTL2IALlho874Xc2
	 11qceoR+oIU9AgND1Gs+9ziDJL5D3qXGvulHPUr35fOUDNEOZPcF5JczNF13nkjQzPqFM
	 nIDLLAQDOfMkYnermNeRGh6dK3G/GFpCeiObtaKITY8mFC4i64vJeUfcoYzJGSXMHQcfH
	 pF52JXhHKFDFOjUG40CZ39os9fJz1jC8sCkCECycdFnrplt9nX0PF7MkaIw/7vWm2fbng
	 F6aJTnE9gMc2gFG0VCVTeAfNGh1/xsjdzRskfB1u84o6UCCotsZad3ajcDS5ffIS0tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EYKzK8/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4962E606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYKzK8/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46D01F01825;
	Mon, 26 Oct 2026 08:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002687;
	bh=gx4K3wKYbWqzXsAmQl+300TW1XUuiW6o6P202YOx+VE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EYKzK8/cogdtSywfB3RMujFtTXrIINc60NnHSGhzUKFg5ovlQ0qWJVLE0CupS3fZq
	 MKEVYBXJOH/rY5y4xCC1ByQCge4pamwz/I1xmLu13yXlbQH15D58X665ZZzH3cfzib
	 zjBN5zajN8xg42hn5YRMtL88J6Nnji6XDey8z+OlbWOXSVO4sZ6J1OWNKHVD/iW4o+
	 n3S/pKHerNHQHsKuwWSuy7GgJse6SFwSJp63ynA/H1aq/biXz4p8oXnM6lSjCvomoh
	 qR2i8dEsaDOvTsNQJh7KF1dEpUL4aJjFHPx+X11OLUxstnJb5LVcPx1BVsoX1LfyND
	 wJ4EfVgWWX3Mg==
Message-ID: <sashiko-outbox-184672@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/26] accel/habanalabs: Use the SGT_P2P mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-13-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-13-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:18:07 +0000
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
> habana has special code to check pci_p2pdma_distance() and rejects any
> importer that cannot do P2P DMA to its MMIO.
>=20
> Convert this directly to a SGT_P2P match which does the same check
> inside the matching logic.
>=20
> Someday this should be converted to use dma_buf_phys_vec_to_sgt() which
> does the P2P checking correctly, for both direct and IOMMU based cases,
> instead of this hack.
>=20
> Remove the now empty attach function.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D12

