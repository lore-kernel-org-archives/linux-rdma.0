Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008582;
	b=QgXuhMC/5tjDwENMLzUez+w7Z/Dumo/HKeDdcNjX33iJ2ehx5gGj8AIqZrngLlp/AvwT
	 wtDv8aJCPEkkQbr7CE+h6QgHvtu+6G/KOe8o8Tt6bojtz1m+RUr08HT52inpbhTfLQWLw
	 QW8y/VqZh990k4bKLl59DVLJ8iQmMO7yGE4bBvWS0IP0sbHJzdpiVhDgph6pRl3Zp9tsA
	 z9Zvp5j4admsijqoJ6o5O+1iZWLLRyehwf61cqC36Ob/qE64mzySK57kVEORLxvruqHB/
	 015wZUwYhEH4SPmNz16J5iwwRLFg1CcozlX5aAEwsH+MBisR/87OXZlJqslJ2GRECaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WJoeQD9WFGjgxXSbKJERHhc6lEhoYBM22635TGtFMz4=;
	b=DKw87XoKKx4eRtgDzQerXGlucXLIkXHwp8c+2iyzX7/EcCdDXgVW0BvM5LGZnt72vXML
	 meFw374IVgCKe+fFk40sAj/icZXfJN6QkefgvaOUO1nZ4ymTayPy0r8bljvzsA3du5dij
	 ErCbKbpYD3GpUTDGlkJX32q2FmDN6zpn+F1aLgZO/eRn3KNqTUm6HZCj/Dof/55eiCDsQ
	 JAckMkVcxMSGjr6q0mS9Uh6wA24oUgPh3deS0CzgHvtg7951iGgjJc2VDv5aAMAHDgqvU
	 LUaO/EifViahud71+Af7X1hPdQ8SzGCZUQlBwJPi8Tf0xRa/ZiAK0Ou46kQc9NqM4iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JoeVJhsC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F2606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JoeVJhsC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AF91F01825;
	Mon, 26 Oct 2026 09:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008582;
	bh=WJoeQD9WFGjgxXSbKJERHhc6lEhoYBM22635TGtFMz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JoeVJhsCjkwCZ1mz199aSgZ2uwnOIVQAgeT11RB5BQrdEhvrumiPifsh6B8DPvN70
	 5tqbfDKTrgS/fcaKihwMudofjQ8IcbVm6Gu0R0N7HPmuJo/Y7lE1/IeyWxh4FeVxHd
	 r/gqovbCuIkmnc41tcw/F+BnCp0TJqMKDSQJdD9zPeSG3XcVdTrX/lVTkcBTrVmg21
	 hMYjkkdWySFtYL+jTI+7ptubMvis4QJ3s5lVi0ZD9zDOht5/OL22WXfItmeKHBhJko
	 ZZ/yUbgNLQXB5SkDF7cLFPSUjoaktRd8CEZa6jBmMXznu2CM+Hp7pguiaYmZKJwFSH
	 U0p9nxVk8NkDg==
Message-ID: <sashiko-outbox-184853@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/26] treewide: Rename
 dma_buf_unmap_attachment(_unlocked) to dma_buf_sgt_*
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-23-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-23-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:56:21 +0000
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
> This unmap function only works with SGT importers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D22

