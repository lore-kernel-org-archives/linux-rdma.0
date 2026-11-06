Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947441;
	b=0IBdvFqVnjEDRD5Z3lufacX6gJH1yo2T2E8B/iqX2ctcZqbV8ZwQ3lzkMQKUA3qR5YZd
	 4CbO2knj5AUhj7Cium/UAtnkimk3g49AIgXEm38cWr3Su/8JXI8aMn5IcCGrnryary7PJ
	 JeY1V0OhZ1GIE5Ce10+AF0iYAUp2g9EgrvpA+gt5tuMiOBnI581locNFJUhpBSovmyIiH
	 jFLeDINlzwPiU9lHfmUkonE4qq4t23RPbD2TDl7/gj8XdFe10djpRzneQFWDoUUNaHsN/
	 11p3Qdea+lYRSurCMeUC5fQLHfeX9Ly9m2tcjfU/YLxABwl5PWitjO8dy1clV9S0t9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947441;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4A9VkWWqhb3xMNWuUU9NG/ye+ygxqtU0jw8OUKRkmpo=;
	b=hhP4yp+pcirwLzk2KQkytM4eCkXx4syjs06lX+QrHf4FLyCJDVokkvnunrIx4uS5gfnB
	 x43MBFc+1HUjOGhXdnRf4yvD2oMl5Rt0ggu09vrZQhd2RsDA/O546p0v2AEQRLMZ4ASGB
	 khbAQ/OpdHn4Q6HnovnDPFynl7m56uwT9JPM1UZQQLGiVBvlLK2+0+xpnOqM6If2/6iv0
	 GZ3imTCEUUvZyp+ozWfuuwICb+iRJFgSKJIOOcDxDtEjUWSe3em7Cn/U19qiI54hHBEmM
	 ed4yJnxC79TKuPtEcSy0dyEq+q+DZw5nkKFCwQ7H589qMmV4OxjkVxTtPQH66MPNkEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOBQEa2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C3606A329
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOBQEa2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AF61F008A2;
	Fri,  6 Nov 2026 06:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947441;
	bh=4A9VkWWqhb3xMNWuUU9NG/ye+ygxqtU0jw8OUKRkmpo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=LOBQEa2WtuZfO7vhhi8I3/OZGosmvFR5oKRKJEcLKOE1+cU4IY1WcEXsg8Vc0Ur8k
	 Q5SxhVK6V0gaww+4bd/oLTBiF/NWtY+P2q4+FtiInlwEyWavJcH+P1ugejuEe4g4dQ
	 LSxESVcrP8Zye2wYH6Pdw1TU/DKJECg1JqMooqB6htEbUD08MuauCExZVeKmCMeQc3
	 +A8jf/O40bktRRc4iZ/QvGe2UnOAeCIAf2d3TgATgiVZHOH4gKGAvv79BjM0stfn9l
	 HNRzmXLoRifrMUZ+2ngtybTFnBoUOoZuuw7FVIMBEI7/4SeFMA5Gr0Hm/Ubs8HowX9
	 QsgQxVzjT45rQ==
Message-ID: <sashiko-outbox-200938@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/23] dma-buf: Add kunit tests for mapping type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-22-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-22-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:44:00 +0000
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
> Some basic coverage of common flows:
>  - Check dma_buf_match_mapping()'s rules. These choices effectively
>    become driver facing API and it would be a pain to change them later
>  - Test the dma_bug_sgt attachment flow to see that the new wrappers work
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D22

