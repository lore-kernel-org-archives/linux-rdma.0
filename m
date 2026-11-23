Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394914;
	b=nRaaGcTJAPYvM8rMz5wgnOxir77d+/yNa5c7u5VzlliplpRVslWQopE7eAT/asiNQC70
	 MOPd/LYOvzLQxcHrkZ3YlGVV45bt7GOfoll6V4ksFT2SH9MQcypslVQmlqMP150xKq8mS
	 yaHOKJe6ikMpIHcPSSVTXLwG5qNKHiORWgTsCYSd/Lijbqia0NHdKrcWt7ovf2M99plzL
	 nfEOZbcRyeDa9tN2MxO069+8tY10oeSMtKSsl2+EMeRiIx4aUTUtU9mtlOXOm7SY4TJPI
	 KhbRV0C/TIguf7wNInbXytdcZ7Qkck2apwme+prTcHgj97EkwmLy+v/UJ8PEIu1qhOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394914;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tyfmao+rykOQD9lYUQxKSULazNgQpZtcRU7y8vK++lk=;
	b=Mmf7qpj0SWOXRW8+gXnbP9ge99KD55C7yTd7e9+ME8WxtXa2gzaTDSxcDFcOCGVGYKR0
	 nrI0mec8kmwBTh+R9PM9fzRwLvkcwky9KZ1bmvRllvuWESt9HZq+1zJaZOBkDYLFZ7X59
	 9jw7UdW0VqVYYa8m6FLbvT+cDMfvJ/RhOU2+33T+i3QWJ0mUNRKUb9MlK3p6ZOxPk4JQp
	 6aOLDOg9QA7lbpWgJHGmSINNDSUG9zkO4jb2AJt2XrUVD5bNerTImDNIIixupxg1AimZd
	 lJ7/JZ1YkFWfPJKrP231+/Jj+We59CXzzFZO/WJGTYS3lTrZxDKmYI5+kL3Ay95JcTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AHTaaLMB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6885606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AHTaaLMB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5833D1F000C6;
	Mon, 23 Nov 2026 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394913;
	bh=tyfmao+rykOQD9lYUQxKSULazNgQpZtcRU7y8vK++lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AHTaaLMBsmSLxbdmzO8zemRZ7apkvB35zokuTf/gMU3uu3CEtG7dpVq5MvmoRb63J
	 jtz/zIfzAQ+4CePiI0ZN3SlIZRwDPrxd3R39WlPvckkPcck5mMjvfqBr5yN65A9ZNM
	 VEMqvqOP5tskPHjyBQ0NX2ntiEBYjv9DHitxVE+8DpXZRvWOD/u3L5rciIpSkaCdp/
	 7Y6tmHlgHimcNT9BUzsmrlXp/8XpTTCfdZ2neuI5lFM/xkjUR7o2XI/cr91lDg8s8D
	 sgK4q7ccPURMBeIRPoAhylZhLy+v6sd/kAMeY+uShceRJZBPkl+HV5ZhpwF8u2U0Lt
	 FCebne703IfzA==
Message-ID: <sashiko-outbox-228490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mthca: Free the AV table index if kmalloc fails in
 create_ah
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suyuan Wang" <shyckless@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123-mthca-v1-1-506d3c3a7d4e@gmail.com>
References: <20261123-mthca-v1-1-506d3c3a7d4e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:48:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Suyuan Wang <stevewong@hust.edu.cn>
>=20
> When an address handle can be stored in HCA memory, mthca_create_ah()
> first takes an index from the AV table and then allocates a temporary
> AV buffer:
>=20
> 	index =3D mthca_alloc(&dev->av_table.alloc);
> 	...
> 	av =3D kmalloc_obj(*av, GFP_ATOMIC);
> 	if (!av)
> 		goto on_hca_fail;
>=20
> If the allocation fails, the code falls back to the PCI pool and
> ah->type stays MTHCA_AH_PCI_POOL. mthca_destroy_ah() then frees the
> pool entry but never the AV table index, so the index is lost for
> good. The allocation is GFP_ATOMIC, so it can fail under memory
> pressure, and repeated failures can exhaust the free on-HCA AV indices
> until no new on-HCA address handle can be created.
>=20
> Return the index to the allocator before falling back.
>=20
> Found with a static analysis tool and checked by hand.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
> Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-mthca-v1-1=
-506d3c3a7d4e@gmail.com?part=3D1
