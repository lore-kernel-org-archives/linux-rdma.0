Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902054;
	b=vYOD+EmxK73BB1ae0AHBzgqlFKPIWcqQls7K42/aSbky/Ud2KHWV2EwSASxpAqxmOs89
	 HpDLCNesUQ1nbSMF7qzP7USbArSqhS991FU5TOAV7h3BxKHCbPKudvwuJpk9JeD6EuIgf
	 UBByGk6mjcy8Hi1WP3YIQ94XsJ8OTib/nnZNZIG+0rrKKY392TJfn+xYDuvAbGsnoTdYa
	 MwRTTrc0s2HHflaD9dL57vSqkNMeDAXMx5C0PknONg2G6XooiiFuMlAXiNK/uNQf0ryzN
	 1cZguyuXLPVx4H3Ro5YsIvLzBQyA0yO5N1PfM7u9HgDsZj2B+N3JyC/qiRJhmvL0+Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902054;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v6LvlFBHDv5/rkwjBNkmXdsdPGwAH5940RNr6FJH4kQ=;
	b=DuUGx7rVrCLhjnnEk4s0W11oxA2pe0iiLRDgLiQ4d4ZwisdU72zUbAj7uoFkEncXGgVe
	 sFAvVUdP7iPH+TTNnDt4vAur8beEtT1YGyeoPOD4QO1sBgWtJlUmUMVm/a2kOgARGjDGh
	 JoFiCNS7ukaODPWDuwGucbBN1GvNmH1pHn2M55x/dlTlNLi7mMx61FwzUSrSqB3+hDm7H
	 P7OueQRQLx4mwlVuTxl/eknJoBJnZdWpaDzLPpAT9iN7LsvMXbQ+gew9FMs9X9vfFVrT3
	 2VbsakdbCKkBsfX9Svq2ibb5wCiBGtHJaMTLkA7E033Xer/4FAQylyo+gE+NQmY5/8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bn1+1LHM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4400D606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bn1+1LHM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE561F000C1;
	Thu,  5 Nov 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902054;
	bh=v6LvlFBHDv5/rkwjBNkmXdsdPGwAH5940RNr6FJH4kQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bn1+1LHM4jAWAMgVBWfnddA7uxcQrgYbgN9R53K+NyQBJswExd+NSZGCgNPqLM7ak
	 V3VQUCVlmRzDFL6E4hrWWY+Pd8sEykSmAVEzy6LLZ4FsbJzk4l6TfjfQ5eYrcx3Cvm
	 rMEIncsIVlj2ZtT0nLtX7FJVuSyak/9D+hW04VwuTiU9njcCU1Ner4ozjGIDL8xvLm
	 t7AjO/UlB6Ap2wuZZWEqlreRwcsfIx9j0zRLmOnfo14BrNRn2g7CN7VRr6ZNmi+vd+
	 RL3Bavu9OZE6cndVo8PbbePKaryMPTup30jIBvNaEhkRn/i2pnT2WtHtVOcZKilgP6
	 r2s1UwVALtWAA==
Message-ID: <sashiko-outbox-199692@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 3/9] net/mana: Extend GDMA encoding for new
 RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-4-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:07:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D3

