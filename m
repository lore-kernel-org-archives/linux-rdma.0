Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703601;
	b=3HQuO4qMsO4nkm8MwcdOLckCiF1Sujv71A9aHKUysOyITHs1l/7/U+9bYHAXQhUdBolm
	 KQp8A+Dusg8AKzsyKcQaRMruytqxM6QOf3V4NDwHt+02tT9pKXLPcV/sTimQ0yA48whIR
	 y7eusmfRhrJ7re6xxUQPNGHyqvAvuDllhHxw2ytOOjpYCvjHpyl7q6zivG8R/1T8blNjj
	 CkBEC3P6qwN85FJife1kDXBpRzha9uR5B8yJ5n1Ur5pZY3qNuviogJUzHV/S+RZqU9oEK
	 3GJbRvgl0BjYI8vhaN30PNObEN5+/aANzj5mAsZeUw2ollMMRULWqAGL/1sEqC1ivSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WOLtZNaDZF06RPF7OQ9KrZyRG+0ns/rcsG60aj3xjF4=;
	b=d2I3kEb8jpesFbJLXPUPG+6vdtF3qj2wsnKPRdFugV3UAFcv/Ulx5sKTXAUSyyOrppZX
	 m6b+JbN4qpJJqyHlUL8KvJzwfxu/fl7WnMPjwijKrqAxzyJDq10R/6FNaxMI7Y7Oyyk9y
	 M/xDIRg8Ol+MFYOzH21zzzdUJEsX/SJDeOB05W9sgZce+NHqYg1tGDBSKizghiCATQbHf
	 NYnT7Za64alAe5tW73V2PyWXv+Ys5Dx01xioq9lLc2sbxck/HZkHFrL4B4I6eYlev9Jlh
	 Yxse2SVKq6OPpmGie/iO97JTO6urtfdJL2FsSbYGPEIPFSkzpDJ1D9r8SXE0b9dltgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M92+5qdg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549E3606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M92+5qdg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9751F01825;
	Thu, 22 Oct 2026 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792703600;
	bh=WOLtZNaDZF06RPF7OQ9KrZyRG+0ns/rcsG60aj3xjF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M92+5qdguJMbPBhPEnHzE/0wNpnLwNtpgBYKZTxdho0w0DFVf9csOopAaIRH92WYb
	 xyIEmekAE082C8QMsweHmMZAbXgSkqzJaObcFwjQGzqi2sYyOTedvShoewYO8ohKw9
	 3xEnpQ8Lg6coQBo+3eH/ftv2C1FH+xR/fhO4qBHljr9fKIJ2Vl34MSvnWpcCcrHt0o
	 eAGGBWTmq3zzjKsuC+OxCQTNcsmAyQSrNWRDJmlVgSTkvcRW/HtKPU3yVYB5jQSyeq
	 pC1KaqlEwX1VdRX8KvqROuMJDvRbJRMWQ0eLure0XnCnQnhNTs+Vd+03j5fEgKYCEY
	 yLO7dwaFT2JMw==
Message-ID: <sashiko-outbox-182050@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Fix FRWR logic for PAGE_SIZE
 > 4K
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261022210650.1182000-2-jmoroni@google.com>
References: <20261022210650.1182000-1-jmoroni@google.com>
 <20261022210650.1182000-2-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 21:13:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The HW only supports 1G, 2M, and 4K page sizes, but some ULPs
> pass PAGE_SIZE to ib_map_mr_sg(), and PAGE_SIZE can be some
> multiple of 4K (64K arm kernels, etc.). The HW can still support
> these scenarios, but we must force it to use 4K pages. The
> max_fast_reg_page_list_len and page_cnt during MR allocation
> must also be scaled to accommodate for the additional PBLEs
> that will be used when ib_sg_to_pages() ends up producing
> more pages than what would have otherwise been required with
> the original page size. It is worth noting that this change
> avoids this over-allocation/cracking in the off chance that
> a 1G or 2M PAGE_SIZE is ever used; it's only applicable when
> PAGE_SIZE is some power of 2 multiple of 4K that is not
> currently supported by HW.
>=20
> This was discovered by encountering SMMU faults when running
> kernel NFS/RDMA on a 64K kernel, which was due to the page
> list holding PAGE_SIZE entries while the WQE was indicating
> 4K, so HW was translating every access after the first 4K
> incorrectly.
>=20
> Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
> Tested-by: Leah Li <leahlijuan@google.com>
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022210650.1182=
000-1-jmoroni@google.com?part=3D1

