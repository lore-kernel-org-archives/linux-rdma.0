Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E53513560
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580563; cv=none; b=Db5YkbmN1GfYDNBheuAAdpk3BnW4lrXFQtv15JSLKXXMmxonixSGoEk/1jKqrcHEIn67i7ozFgfpbfoW5LzxUrq/WZ8M/I3xEnxtM0hO53isq/8IaqtEYvXpShaLzrWVn/Sib3hNrRTMQC14HvSkuk3TCRxgfu1D9P4Oin33wps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580563; c=relaxed/simple;
	bh=c8OlgZMb5/I00Lx6LsA0Ext+HyRr3JkHryciawci/Wk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xw1ogCNSBt8M7ERAj1vm7tstkriyKTpCZVSAERA/ZO5C3PR9xt8kQ2jlDoUBYrqDm5XcKQFC5fjQrN4piWcEMifpoQiPnPEddwnVHjbBBBgHOSrQTYGXlsmw5dozKXUKdxf+8jUNIivaWy0Wj5G7f96PezqIaudExk9vsAu5zLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=id73MxXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="id73MxXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832221F000FF;
	Wed, 16 Sep 2026 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789580533;
	bh=NQzzozmtkOtySSu1UoWri+JxjZ060ph7yg99my6zAyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=id73MxXidzy65nagI0e5aJQRnHj8RpdPCPv34oQZjny64rpnkrUiNw9P+r77JzTw/
	 NkCT72cqtwHBTKHemY/pm+74pPukhTOtG0y9kbMi6DZ0jn4KsEDMMgq5pyz26igkUs
	 SC1hA/weSv7gqETlyIejmP7UfSvTaPJ1bQF5wgpfZ88v/h0xBNTvB1i1WY2NFxkPdo
	 syAMseQW3JB0wW4PXVAOkOzb7hCwPD6qYNNNgopT5/N/HmQ3acozakcKCr3bJhNPEs
	 KelfYC7ahuc2i9Ml7CHdYZjQ2SxyIb0U5lRUpbPmcvvUWOYoE2/DJ1NKoEhUT4PebZ
	 MHatgjHEdZR1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeremy Bongio" <jbongio@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916173203.2555458-1-jbongio@google.com>
References: <20260916173203.2555458-1-jbongio@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 17:42:13 +0000
Message-Id: <20260916174213.832221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> During VM live migration or when registering large memory regions
> (e.g., guest memory >=3D 256 GB backed by 4 KiB pages), get_lvl2_pble()
> calculates total leaves exceeding ~131,072. The memory required for
> lvl2->leafmem.va exceeds 4 MiB (sizeof(*leaf) * total > 5.24 MiB).
>=20
> Because kzalloc() requires physically contiguous pages, requests larger
> than MAX_PAGE_ORDER (4 MiB on x86_64) fail and trigger a warning:
>=20
>   WARNING: CPU: 123 PID: 119906 at mm/page_alloc.c:5997 __alloc_frozen_pa=
ges_noprof+0x50c/0x1050
>   Call Trace:
>    <TASK>
>    alloc_frozen_pages_noprof+0xc0/0x240
>    ___kmalloc_large_node+0x3d/0xd0
>    __kmalloc_large_node_noprof+0x1b/0x90
>    __kmalloc_noprof+0x254/0x660
> [ ... ]
> virtually contiguous memory via vmalloc.
>=20
> Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
> Assisted-by: LLM
> Signed-off-by: Jeremy Bongio <jbongio@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916173203.2555=
458-1-jbongio@google.com?part=3D1

