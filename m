Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947433;
	b=DC2oguA1XGPsQWqR4NYgNPz5ib+H1Un3sXoAjd1bS870z5miY1qkCfyhfzX3N2kyvk4/
	 VTW++TpKUYmfwDYz9Qp7R1AFpoSj5/H3eknvW6sSwP5VcBqyed6yWCvorf9X//8s5CHDt
	 RnAaYcAl5TYgyPxgG6LQedbI+MBvf+VGD+ObrWqEYS4eNE4SDEFuRZfwjtYfE0968RYPa
	 JcyrbgZYU+5MhAaVD0amYzu0+RMvLeEn0lsZpkF6Nq1DhghxG9flC1ERM0xrJY5SLBqoc
	 3jZnn5Jcni9llpyAG2CkRBlttfsBHlgZZC1rCbxIObfNesvvkN6N3Rm9liY/UtNa7eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DV8j2ie07XbU7T3SXcvmLkAhjAJx24yQLy9B0XYZbL0=;
	b=tv/Hx7J/l6PQmIdWuFPLT0bbWVTduMQNVr3cmlDRCarUts6NDgajCgb0YFIwSIloeohd
	 ro0uYOl+pGDRKCi2ZLtzO/vWGVC7lKare3E7gUZtUtukBeUBWyryUdk8/qzEvSwy/EfDL
	 7Kb65ZTslCCN908JS4LInDbx1QApQFj7GPs0J2NghRPQ9yZCefsRpE+A1cAhXVvTpjQFF
	 IErTLn14Ue7ZNT2u4C2Ttdt+Ka4wJqDoyzhZ4ojPYbCcUsVx6MByH8Mn0ljtPEgBY8cbr
	 1LetcskLONgNbU1XrbShdODF9Vj/BHsr5kyW3SGnBEnn7zsgnYV0hgxZicRruGrx9bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3OqaSpo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E2606A32E
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3OqaSpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F241F008A1;
	Fri,  6 Nov 2026 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947432;
	bh=DV8j2ie07XbU7T3SXcvmLkAhjAJx24yQLy9B0XYZbL0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=o3OqaSpoC2erMcIe37069yRcSEogFF7dxsd7zdl28G1TSkvskbRSmLykwUz96n2tM
	 GqYsnGEMUETt5jutheFU2Sgu43hCu9oCkAztSNuSIfOTcTftdbAajUI5auFlCze/6Z
	 inxBgs5iC90j9z1WimJEs4CGD9J0niAqOwNxvfaXzZ2HagOav8i8vo5gn+EWYsvncm
	 f7W1ZcyBUHdw4q10Z5I7hnXKqFin2wSLwmOUuNX+JS1j82CwsSomHx9iMoIwb2LAhT
	 f9s95PiIfmUv3Lo/QNRiKbiDOYGAQ4z66GJqUH4wOJOf76L5F9SQofwRGi5Cb1vt4p
	 HPGiFv2T52lPA==
Message-ID: <sashiko-outbox-200925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/23] dma-buf: Allow single exporter drivers to
 avoid the match_mapping function
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-9-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-9-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:52 +0000
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
> Introduce single_exporter_match into the dma_buf_ops so that single
> exporter drivers can simply set it using a static initializer to use the
> mapping type APIs. Provide a helper macro DMA_BUF_SIMPLE_SGT_EXP_MATCH()
> that generates the initializer for simple drivers that don't use P2P.
>=20
> More complex exporters, especially those with P2P, need to implement the
> match_mapping call back to extract things like their DMA struct device
> from the dma_buf in order to do the P2P calculations.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D9

