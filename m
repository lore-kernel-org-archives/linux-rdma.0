Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947431;
	b=d1MoiLwzbMWT2NGNyKXapV3C/0ojHe+Jqslb8uPNqOrm4qegJLABSm865M1FxQOd+93X
	 H1y3bZcGgnUtZxElldfSnX490m+I8zYvP2rHuDDtF6aPFQlZxTGGOyShjqZBg6/Vgk/R+
	 bXR+thUTOYvsPPQtcbjWOcVflfGBOIC1Bw5NP9SIqwo3CoOD1nEMYaaaNCRv9sTarzfSZ
	 zOtRZhyrHpQ7uDlkNK9g5i6M/BujpkqU9Hga0QJ83RZcMcK0FcWcKoYKBXxQ9qxXuhk0L
	 2KEs0/B1/trkMyWPkhUn2Y1HCbnERSFFvkswnQvnveBAkWV0Tnnk9UY0kaats0I38fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G/CyD1yAQPuGKC8ZnbjbLsPRjvIOVy86mHA5xwDoTms=;
	b=ME4o87IjZiJoWY+m8lGJM0PbGB9JDWQhR6aLALXQv+8b/oElsOVkaeRJv4EBSrZqI3Pf
	 9icu1NmATOqVl8i34jrx/0VkqeNHbxxqhQwJWFlRdjSvNARjpCCWCSTG09HqrB0eP2f4q
	 qy8L91IEM1MnB+ZhxnxEu+dXbJPG4WdIm5kqAI6fyJQ/V7+kP/K5zxzTU3j+Pby9mhwKq
	 cAFtcfPOW2InYUXxaubBOVEIMZHSumJgZnO5kG58Q8obmi0dnEbmdTnMClPxmkkdDY750
	 Ds2jvByef4ce9e7pddPLW4Mv/QaN9WbpP9/D2QqVQ4FhYz8Qr+xgMLudgWo2KcZyHiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWyK6Mzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9A606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWyK6Mzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7661F0089F;
	Fri,  6 Nov 2026 06:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947430;
	bh=G/CyD1yAQPuGKC8ZnbjbLsPRjvIOVy86mHA5xwDoTms=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EWyK6MzbdmLJM2TDW77KIUy5KdaHt3K41HkdKqa5mblMeA7vtDJJ1JlLzXUWk21ig
	 RP7QYW6hVwBBazqyqPAtYHKZmzmzuTc7Op03a4Tjvsrk3UFv998bvKJgjwvBg3M5SM
	 RSAcQJqPHd4VohXetkQw7Ezz2g5Y1Nz5Iw7o4QB81c3ajs3JFd4D4G7UYjrVJMrIf1
	 SfMgZq4Z3nS7W8A35Ht/XiHT5AhorkDhT2KphiR1YmrLgSAVgdOzdH+Y+i9s9eqbj2
	 8VnWbSPc1Kdi+JX4qbHTK22p3WyIQDpfmtVRU5KB9tstnQRW/chNY5lv2ifs7lhAa7
	 gDGWCSoaWtriA==
Message-ID: <sashiko-outbox-200922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/23] dma-buf: Let the exporter select mapping type
 at pin/map
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The match set negotiated at attach determines which types an attachment
> could possibly be served with. Which one should actually be served
> depends on where the buffer is and other attachments when an importer
> first pins or maps. So far the first entry was used unconditionally,
> even if it cannot be served to some importers.
>=20
> Add dma_buf_ops.select_mapping() under dma_resv from both pin and map
> paths before the type's map callback to let the exporter choose which to
> serve based on the current placement and list of attachments.
>=20
> The choice is recorded in attach->selected and does not call
> select_mapping again across any number of unmaps and remaps, until
> dma_buf_invalidate_mappings() has been delivered to the attachment.
>=20
> This prevents importer remap from bouncing a buffer between placements
> - the type cannot change without the exporter explicitly invalidating
> first. In other words attachments that are never invalidated keep the
> initially selected type for the life of the attachment.
>=20
> A failed select or map establishes nothing and leaves the choice open.
>=20
> Importers never select. The importer's list order is a preference the
> exporter may weigh or ignore, and an importer must accept any type it
> listed.
>=20
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D6

