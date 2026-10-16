Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD73812DB
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183309; cv=none; b=j7B/zZO4u7dZIUdEiG9nTvBxSBilwZoVXof7RJs3eRFjeKZDv4NsuAKrkpJK2TnKhMuA5yBn2po/YexL7QLVB485qUuIIGknJlaoB2c6cPKoPcYo5usqLsOuRgwIMdGsZfOYD3X18qtLLFSXMDlndWCTbn2PC4K0EYNhzjCGlL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183309; c=relaxed/simple;
	bh=O0Up4GuO/x1sN+lXfPV1Kw2JZ6vMLHlj5yDm2f5jW+E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BQzAEBMagt7qEUU4Rd6Icy/par+DzsR4s4Ct82z4+ckRUiFgXfq/KHUMBgH7ZpSUjEzChcW3OT7WGB80TjHHxKlRAMh59N+7/ByuYbCsJ3s/+wrUoEVfVGEagA1qpoMaGJYwOisF6XQ+6PEDJp5T8QQnaGyjAY3294363C816Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOYmvVJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOYmvVJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF68C1F000C4;
	Fri, 16 Oct 2026 20:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183308;
	bh=O0Up4GuO/x1sN+lXfPV1Kw2JZ6vMLHlj5yDm2f5jW+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UOYmvVJmve9X00Lo/edAgXx8jdviVyknFSAu9RzJz1Kuyjs4SDicbG0N2B5/MaC0Y
	 bNAIvsm6jgqet7c7qfhpQ3dqo3OnFf/RDkLIZJXjjwUdcgmPylZ6UAm0VLaHDSYNm8
	 sZylhzulmGF9fZVYRv+DOLvsz6uYHYlhDMLVnzzgDtTGeU1vwQNWJQno+/T1mzCAre
	 i3WnX0QFbb6fmSziQIcrOgw1YbNZeOfPav0pJhkVB9fTpNClUtMiMKglffT2m6pJq+
	 4OKHkeSKxjZuhzDhp7a/5CNoidJQEIqhb5lfXU2iOJOUWIp2CbitO7cNwNnzhYfOcL
	 hRkV9DWpuAt2Q==
Message-ID: <sashiko-outbox-174920@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 6/6] RDMA/irdma: Support UMEM attribute for
 SRQ creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261016202909.1289496-7-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
 <20261016202909.1289496-7-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 20:41:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> Support the standard 1-step queue buffer creation for SRQ by
> `UVERBS_ATTR_CREATE_SRQ_BUF_UMEM` via `ib_umem_get_attr()`.
>=20
> Set up hardware pble directly from the pinned SRQ umem via
> `irdma_setup_q_pbl_from_umem()`.
>=20
> Proper umem and pble cleanup, and error unwind are added into existing
> `irdma_srq_free_rsrc()` upon SRQ destruction.
>=20
> We maintain backward compatibility for the legacy 2-step registration if
> the UMEM attribute is not provided.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016202909.1289=
496-1-dhu@x6u.co?part=3D6

