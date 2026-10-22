Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703538;
	b=c2Zs66bO8sSogIc3DdPbwBb4FsAsoHWfWjclxEpx+a/bq5lkqaZlOXEpgTd2McjcSPbC
	 NxzksnPKO6A4hq0tphx6fBOEIU3g20AVdR+GuOU4ihyjH23z7zQaIH4GGU2ekyc/MhjNS
	 HFhALe4npxoAoy3u5+a6rhSjuxcRbqRhAxpE6LSKKDzJaiI4acpqPpf9gbH8stBR3DD9C
	 4PGyXZRQDhwFKPqe/z34rZESt6u8D9fakxag+yrqOHLIELLLpLJzR9mZ3WBZOdDQZ4wuw
	 T6j4mw5hRUOyAp8N05cTbBHBLTFaz3w3MYDpgGTQaHc2r2V0kWn1xZXgXUFgMXjcq6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703538;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MnfXK6LeaXMLLUU7Kx91P2Twt2I7jTviLhyszbHmBRM=;
	b=BNsab8ElYRB9aEAHa1EUaZoD0k1vhLM4ZlPWDaPKTrEcdHJp1hO/xSxks9yXIjLmIzS6
	 6IC8NyL250mpOvk1pYIMPQGrVINz/r7E62dVax/UTo+5bQsbFhNgOn8BoOqu3zA6EwjUD
	 z/k2OTL6E8hrINr4/x21ncX2JhH9nrWCf4J7upnreRtBRiYDiVrCEjO5VfGgXsmH4KoZP
	 wAm2TZD1Qi5P6BmG2cOkxwsxecb1mDAWR4SD/IpITl5kVntJPZURGA3mtURbRj/IHz8v/
	 4819W/X+0ImIlScQtV0JK/cVYJVbrQUP1cUscDCUZ16rn96w+K7FTHVZRm+PibWeXsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvV5dWOy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA73606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvV5dWOy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B2D1F01825;
	Thu, 22 Oct 2026 21:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792703538;
	bh=MnfXK6LeaXMLLUU7Kx91P2Twt2I7jTviLhyszbHmBRM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DvV5dWOywmnQ/i8edHvJ0q9TH/J/SRne5Mn9qlloasXdoA8GXznEhL8lOQR5vqQmr
	 uIm7dMlDM3aYfusd484Q++VJW/gqOtU4x3Z4hLyYjmhrDLOwf1u/aMZczcnwDFCGuN
	 x6o3cbWtm6GdlyRb6Lcpqr7zY0zAtnMWs7mDr2fLeGHOwmTzAsQakm8OpIQusbvjRk
	 m8asUV0PGrzWCrACtxSOQDN/f+QG29Cxay//x3jZeQ604O5uxpqI41J3C7y6u4F5nV
	 Xsf3U59dL5l63dLdhTlcN+mxTd7b7xM5aNdurvoPPVrOeXA/YWnRWMercRl+KQ+h1P
	 FdNkuvMneTNnw==
Message-ID: <sashiko-outbox-182047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/2] RDMA/irdma: Fix paged PBLE and virtual
 AEQ for PAGE_SIZE > 4K
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261022210650.1182000-3-jmoroni@google.com>
References: <20261022210650.1182000-1-jmoroni@google.com>
 <20261022210650.1182000-3-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 21:12:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> HMC page descriptors and the virtual AEQ PBL always assume 4K
> HW pages, but irdma_map_vm_page_list() returns one DMA address
> per PAGE_SIZE page and irdma_pble_get_paged_mem() sizes the chunk
> as PAGE_SIZE * pg_cnt.
>=20
> This breaks when PAGE_SIZE is greater than 4K. For example, with
> a 64K PAGE_SIZE, the second HW page points to vaddr+64K whereas
> the driver assumes it to be at vaddr+4096, etc.
>=20
> It also ends up using an incorrect chunk size which causes each
> paged chunk to claim 16x more PBL entries than what actually exist.
>=20
> Fix these issues by taking into account the potential difference
> between the HW page size (4K) and the system PAGE_SIZE during
> allocation and mapping (so on a 64K kernel, each page ends up
> populating 16 PDs, etc.).
>=20
> Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definit=
ions")
> Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
> Tested-by: Leah Li <leahlijuan@google.com>
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022210650.1182=
000-1-jmoroni@google.com?part=3D2

