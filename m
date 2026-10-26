Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008899;
	b=b/7/xYDcMZ1LYTrW0ViiXnfE3aLmfIct7rNM3kkYvi5CrPOreHnvTHit5SH5TENXMQMF
	 V/wSYnYjzkAzHFe/s3aauyKQEhMhZyFF1OLYj674bqTAM9X89tn8Is9BP0wE5+UOat+7/
	 hb0RN+ayi+nMSXP8F+DVnPFJydsaTUq4huzOWrGcC8XWeENa+f2SwLJjMZgKFr5vzsgq5
	 X9i/QGj0QJWqEUjGWGYctmulXoYnlfG1b71b6w+YwZmQ6spxLx+JOWTWFoGqq0VVorbID
	 G35UCutCOu01UQ+jcckLMwmHIuBuXY5RKE/TT3dC834lzt89mZqeYrx+o1acfMrlLSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008899;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uA6rRymyPdqdTyxfa/XHkg+BgBXpk3WqgbuHxMunPHE=;
	b=d/UYmapxuaaACTHS+kz7+WMKe8n4OeE1bOdZykv7dljawNjd/LtYbl1xyutrdGHwlwd+
	 /H36lZFOi6egakCul7SL80J7akwDiMhlYTl5lxxcQxtpRGC47JV2NtuMvd8d67LA8w9Bd
	 Zw2lzxCbBQLCOC45IQlxivXfKB5qieTUlJ5vtSs+gUF4ENDKfhHZl4zNKfAOGOMVKDNyd
	 bn5Rda49q+OexCNEHUUaHCeXR0koNb90b4EKIKOyxsH7XEIsjveCWrM+JqSJ2v/24G/s2
	 s2QT9wbJTX5KACQdSoTkCK00zh0FCPz1ZCblYjPJETzR7YlhU4tvJLZCQit97Zv2QHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NdReMPVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92707606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NdReMPVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0011F1F01828;
	Mon, 26 Oct 2026 10:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008899;
	bh=uA6rRymyPdqdTyxfa/XHkg+BgBXpk3WqgbuHxMunPHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NdReMPVALK8UQTw/1oXlkWXlEAfbjthtMq+Jg08zpmSSisnHbSGsrIYhcutgH2I/Q
	 VhGjQZ//fel9Kfs2TknHDKRnbPaBpPgK1d+DFRdKQq//SU1S5/gTXNhiN/Ki1RrWba
	 cckw5udzvimktwWIGfUkY1Uv/hT8v3soGnPVVvh4JlZVotlgGAqhbH8yopbeMfe5aP
	 Nov1YjD+6cfDaYtvMkBH+xTIhAQVt7Bff8VKg0AU6ocuw9GtCCSgpWXstY1ttrBkYX
	 mBRCai0IkIYQ1Aq0G5VPfGC0E1VDltYDb10MGC6DZQBFatRCd4qmNG0kH4jqGu0L1Z
	 aKhD3QPe6MHPw==
Message-ID: <sashiko-outbox-184867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-24-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:01:38 +0000
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
> This attach function always creates a SGT mapping type importer.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D23

