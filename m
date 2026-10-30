Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384783;
	b=3tRElCuF4j/QUgBr+fudSRdg9dQ66MusdkfB9cXyMhylAJNyvX8ulSB/D5wSfsEL8ORx
	 lZW2fioiduWsbwGgwieWIKy2B/ZXB0BIBEdo3EAr7AT2yR/uDxQUZD2gmNl1mbZZqGEOJ
	 rk7X/nfgtQyIucK/d10rh/7eDWCcVPALrsoh3rToHIxbUjm+dkTju8B2pdu5FI+RY020/
	 8zY/wGa5UdRmmvUduj4e354ziy3aHqdaySsipo7cvpinuC/pzBlW3fo2QKbEIIOcJxP/A
	 70Ozn8M7Trf2VJ3bzaqv2e8ZOM1MTvNlo+iLaWs2yCwK6AMQOPI+Y0Zasz+K/KhDtzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384783;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jNCw8cl1yBkub7ke+2knS2Mah2NdHT9kMOAgs0f3sVo=;
	b=emZblAANe0hWptFOKY1NJcym8V1q4dTiC+0AcAd7CC2za0SzdrkJrgK+K6sFPBdCM8Pg
	 S5i2jfd7kSmBuDqGd9vqHirlUBnctgAbNwyOQeS2vep0bag+kVU9ngveSYrKiI5L0vxY8
	 TnLsvn0wYnEniuYZvy/w+2M4iOv+6DKX46G8ALwTCsUDqjnm9zQJQDzyfch8SXscClVKS
	 3hWOgU4vWUWcyQv88O8ldjS+9TcQPT99w+8DFbl/R0pY1883Al7uMpeVKMihXLgwcvTPr
	 HR77GKjiD2FIzIrCbJ3B0rliSoqaZifjv+SMn5iyY8kZf79Q3iWx2ay3e7U0zpsLGRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2NlZsYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6CA606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2NlZsYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420161F000C1;
	Fri, 30 Oct 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384782;
	bh=jNCw8cl1yBkub7ke+2knS2Mah2NdHT9kMOAgs0f3sVo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m2NlZsYxBV7CyaWn/wJXLaYaGgc7mfOCzPIgOKjcgmPiB54uu2aGoc2osRM3HJG8/
	 9aJPTjOz419ROlSqWKF5mEE5wTKiLFru6mcWPYtAX485ScJ/Iqf6DSUVu7aNHLf754
	 M/pBwpNp4G4+ZCUWmns5IK5KnYN5zhNHYXMyLvcxnmsbZlQ+Xc4nOVhoYXyKnrM7gx
	 s0J8DDTk9tR/Oh244GzSjQcdeSoFi6r1PP1BOqMcqgNO/QxCn3DFjvyNS+HHO+RCTM
	 cY4mzxiaVoDYtiXpV/3yTbPbo1TwK4jSuDVqSIPUebLCzKhWhHZFAgrEfPH4CLX2Ws
	 4oeGdeuow5fEw==
Message-ID: <sashiko-outbox-191407@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-4-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-4-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:26:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation model for QP by using
> `UVERBS_ATTR_CREATE_QP_BUF_UMEM` and `ib_umem_get_attr()`.
>=20
> Add `irdma_setup_q_pbl_from_umem()` to allocate the backing MR and program
> hardware pble directly from the pinned umem. Proper umem and pble cleanup
> is added to `irdma_free_qp_rsrc()` upon QP destruction.
>=20
> We retain backward compatibility for legacy 2-step registration if the
> UMEM attribute is not provided.
>=20
> `irdma_alloc_iwmr()` assumed there is always a valid PD, which is valid
> for regular MR, and QP. That is not the case for CQ. This modernization
> fixes `irdma_alloc_iwmr()` to take in an `ibdev` to avoid a potential
> [ ... ]
> inlined in `utils.c` here because `irdma_free_iwmr` is statically scoped
> in `verbs.c`. Combining was considered, and we think it belongs to a
> future project.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D3

