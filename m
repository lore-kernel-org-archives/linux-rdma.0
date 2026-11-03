Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745300;
	b=ZyFF1pPvzvWXWPHdU1+hPpGkLjnYNqmrAqhpkASSvinaWKedfaaU300bMufDPcKLGu8B
	 AukdarCYa7RCsZE+tE0I8cz8zccJ42tVzh+HA8GMuHfcW2kMjsFj4ZRAxksiEge/anqGA
	 gYcukLCcZwlYoHO/PpoyhPOhOJZEeg5PlSNXTqQSAztboYhmY5yF7pUe3uru8l5bmNwSz
	 UpHS6GM+FDlQet0oc604g/4IToaKATLLMwXzUt3cev+9Uwg7USsn/RT0zoUGHoSWx3Ufg
	 E7tAomFm7AelKH6VicrDAwoQhZeEwOWwKW753Q8cizgqKQWyWkoOxpbMkEVIfQYu9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745300;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5NeOwlv8Ll1AyNbf2UIOrU9ZR/o25BoNxVifb7Tv9qY=;
	b=HC1em7KTrFW96SLBmmxIuCVnuVdDybrkcmn2vSTmvUlpZ4wrvbQNVmUjyAPmRgpRnFXL
	 DlyEmcKcYYDyv8fFmkY1L2uDKg7vr3AtndWvtelEQ2Ai5ylbmLbzLTvk2Kdh1F6sKz4B2
	 PSsIjlfaRt8RUrvuwodZPjGn6qbofigN1loAixp938P+zUoHxbR/jLdH8ko2J0c1HM5RG
	 SNPLDPH7DJ+zffiuY9MNITs9iuY6m3c8j/H6VBFDg2lRQx3GrUNEWQDqy+IURg0qNB/aX
	 nH26F/KQE/fle6ShVANzdEPQZr0Bg7XzJozxes1bOZDyK5Mrj5C5j52Uefq2FSByS7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7cB4IIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0124606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7cB4IIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B181F00919;
	Tue,  3 Nov 2026 22:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745299;
	bh=5NeOwlv8Ll1AyNbf2UIOrU9ZR/o25BoNxVifb7Tv9qY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=b7cB4IIeJ6jBNA0djjybfkDM2+91A9h9begs2StDdB5fQF6B7g7mjBtIcB9CnG1dd
	 Nk9GdtIlWbr3m30XYDqZOx4JdQoQhEiTDd2W+o3vBmVm+ATEvasJTuGd6Rl34vNXlu
	 LS9s8cW/nrAXsdNNFeVscj9M6TlTqaAcrX1BU7h+1SBPaCNg2ZcaODSVzWIWuqDW6O
	 jXcpfn/Hbn6K+PEJXW8KwWpJwwKnn7kGg0fWSaHBFyOsqUdkC3r54mWbK8kS0gzqNS
	 ouTqLxTG5dmvj8BvFUpw8xJ6IfkpI9cc7ImTBJyWs+fQemfBsNs3hVAhEtuvjNB/ZD
	 lx3+kVulUFInQ==
Message-ID: <sashiko-outbox-196131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 06/15] net/mlx5: Add IFC bits for new
 ordering caps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-7-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-7-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:34:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add new HCA capability bits:
> - mkc_order_read_after_write
> - mkc_order_write_after_write_ro_only
>=20
> Add new mkey context field:
> - order_read_after_write (2-bit)
>=20
> These fields enable a new level of memory access order relaxation,
> allowing read-after-write reordering and allow to expose an indication
> that devices don't support strict ordering of memory access.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D6

