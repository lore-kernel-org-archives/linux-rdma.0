Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793947439;
	b=rkgroqI6a+zaalK5IUTin5oWwct9O4lOH4yqKd/hYxWlWn+Fq6vvY14ZJgk5xRoPnZkO
	 3rjf3tVdjcNqRyXADGPeYCkKa/re8W0moqtyfFeC5vEcUstpMoCVd2c7L9m7Av9tqTeC8
	 nkGquTLACqAqiEpv6n/D+qFRXrAphqnevWa4FPakrG66YluyRno3Z4I6biHEgvQL09A6L
	 h8nv1NG3otzfzNhNW7+W66BGsqF/E8ztlYRdlLm8l6rYkbspx3rjQdTkUHG/snbuLSSjP
	 2SLkbrQ8zFaJmg06xufOkL50irZkOH6t/q5S39LB8PttUFCTS9OffzMN4D4R6QQQ9ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793947439;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D4ugQEKnF12QYh52zkVDXbfgfN9kngeY/NfLuP+ajVg=;
	b=Mm/uPXh3nOYKDoWArL0Fd2kXePPCEsO4ZVxhMH4ZLOJfXbPruCuNKAvnK6weNKj0BCi2
	 J5zOG9rxauxuuNYaAnzqRLnvpe1yUh4QiCTxquHqwhpDPvlg79BSvn8gRuT32T8/Ori4z
	 EKcmnRIccX9Uw5sX9dYbdde9Tw5OFuUEnWuG05ufQpmKhMuuBUobPhwuvKEb6YXsyfnzx
	 4HXCLbZjehYAvoBltPbYTrS206z39RVmKh7/JPZzmc/ufb71BbbNbAx1ueEuy5Whj4iAk
	 nYVZZjT3qhZ16pSy9/k2fXWtd27yyuPXwnIU5dR6hk3W5fbZf7Y4JF6HZe19kjNAJqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ek2rJz04;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377B2606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ek2rJz04
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53A71F0089F;
	Fri,  6 Nov 2026 06:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793947439;
	bh=D4ugQEKnF12QYh52zkVDXbfgfN9kngeY/NfLuP+ajVg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ek2rJz0422dRG8TLjSZUOk53adxKmTUPYrXBosULDiNS2T/S3cidS9ZItwfoDpPup
	 CdUHAZjyttw3eRWwtbOCRVgtzB9djS29hAcmJ3MYSGIR1RoiEu/L/oZVHfmYhaxFEQ
	 Y/DHyu9UKDax+IAUY7i2J3fD8QIzbmz06YLCBrjvr/vYYTBa6wDFIhYMz4Pd+8uVDQ
	 Aqq7vavqndTbMGA87GBRTxO1K/KGCKvxRo6brhM783o1hBjA+CqXN32RDy8LYZqm1P
	 eNM7ELsMua3J8u+Ei1Fcw4ANpKw/e2FB9Lq0/Z3qo7VXxPpIwAny3fOu8mlK7pMf9l
	 /ZKGNZFvj3gEQ==
Message-ID: <sashiko-outbox-200935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/23] iio: buffer: convert to use the SGT mapping
 type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-dma_mapping_type_v4-v2-19-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-19-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 06:43:58 +0000
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
g_type_v4-v2-0-78b8dc9ae80a@nvidia.com?part=3D19

