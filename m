Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947440;
	b=KQc8JRCZAlrvbvWMKqFXVy3zcm+PggLx1rbueSQXSe1sgpucOPA1IWdPOOnCKJVThJFK
	 5JX8g1N0gSO/oC0mNKVOl65XcO5ItSHQbFmMFRmwFRyR4ZXLQE1P5f7TuO5Zw0sJXNnEo
	 aGDAzHcPNdbd8OsFks9Y/ChpRNDpKoj569a0irkIirZuRQP69k7QKqje5JaAJaviz3SHC
	 hyRcTYIqXKBccOjcyE0C7tm8ls7ty3IyQ7gJ4TYMuvz9GAYsH/ykipuGDXE/hGX3ViknT
	 jHe7wohwUfR41Ab81emO+z0drLnjdoO7wGqJpSwLYeE6Rb//B0LpxD2o2CoNPp3naIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947440;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=88RylHGXXgAlMWmIBk7kRx4R9wQJgp/Tung5QQOut0k=;
	b=4rWRLwRTPyoIyR43VA1rcko+/C3ycslLhpCPOw/Dkavbv3T/X7AJ27iX/dJWrRJjPzNE
	 EnPqKbVG4fdfXOavdowqznJW8p0e9SFboIyBLhoYuINqZzUFwZLxj9vAbIhuRbfAMxAN+
	 BUKVnrcvEseqStVvpOo10f2+HK+lbdus/P/sC4MrbHMxNTPMNEMag01PmkmG/cxJCFeUV
	 s2+7j8V60KLy0b8MsRqDcRImeYO76Sh04Ky7m+SDKmpBivOVmE/b3XKAWpznDKmMvfAUj
	 nXC4x7HbbY+Pe9+6fRQjK9Op+V87aFrWIpwE4GqKBvES+1wEFlMpnexGYmOOGj9Zt+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqG8fjwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A1E606A32E
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IqG8fjwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855B41F008A1;
	Fri,  6 Nov 2026 06:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947439;
	bh=88RylHGXXgAlMWmIBk7kRx4R9wQJgp/Tung5QQOut0k=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IqG8fjwadO/2f9kKfHCQzO2ce7iwBjDGSvA+RTQfKDD3Hwzntw/qSZ0X8xI7YV1hL
	 EbYpZ2AS+GwGan2jf9oJ1XMp2tXvo+Cc4kTs6T0uz6U7cnrwA/JIHcpAD6r4NzNW81
	 LGhgfFLpLw1O2zsE0CpJIsj4SBNrwpnvVCmlQwZ3KxjdyWImVMd+ZhkjGZrxZ34/qV
	 v8m7/iFc8E0ZgsIUPFdu8/HhHoxD9OSZCem0IdR2AvdIpAdRGNOXICDIOuW82EeUkX
	 Ze6S/EENlSaGYMsma8PdV9SnxKJd1heZUSflMruA+OwT8W5v0Nzq6QADFNoxxMZw+b
	 lkn0VYL8Z0CgA==
Message-ID: <sashiko-outbox-200936@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/23] functionfs: convert to use the SGT mapping
 type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-20-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-20-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:59 +0000
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
> These importer helper functions should call dma_buf_sgt_dma_device() as
> they are always working with SGTs.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-dma_mappin=
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D20

