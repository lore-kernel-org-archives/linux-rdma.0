Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81025208A3
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069631; cv=none; b=rbj39UM2UCTXWKgFTDLiKs2blgeLAykZpyBgv6GRg5lXbi5vAw09w3viQOkvL54py/1yaIjaBFpc/ccj5ucmjQK+qcgMg9XRP5ri8zCuMc5pMwFn6vZp3GtPVl4stBPviq2ZCsQhBBL6bTRlRoKG3ZSjw2iHpEApaOMSs5yqzy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069631; c=relaxed/simple;
	bh=3bYwUvdH50Hdc6k0QrksYSBXndZy7VtYBP1Uc7MUVMI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=tvkqDhLvgNogV4bxaf1QToSO+J1HYsBFPIkNnZ13VNmBYAyfgQ8b3sCmMUeTW9WlNfhruTTGRijOEm3bUT54n+gq5iQVnLZoVIyFG1uz1hVgR+nw5BLIyTqCkdxqeOJYd0noG0gcIHYzf6W8uAkDPbEzWJdxIDciUGE4HU93ryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zyy9xdPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zyy9xdPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECB91F000C4;
	Thu, 15 Oct 2026 13:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792069630;
	bh=3bYwUvdH50Hdc6k0QrksYSBXndZy7VtYBP1Uc7MUVMI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Zyy9xdPW2GN1icCn3DiCX/5aGd/VWuotq2UbZZXWUKGowc8bX9fz/FViTY+5vF8dK
	 l6+n/toghdBEfW+Q//XO57KxxfSJK0NlhAt23OpOPkjvWuS9I7Md21REiP/L0z2rf3
	 v0fHAGlArelUH0r4OnrOfetR2Bh6zE52a+/9DaJ1Q7t9KuNwRBUAkxJLZOfV2NrD8k
	 DcANjBeVllG936FlBeJg5KAgKqKC2RXPN2QfT6L82yuAKjc1jlhUAxipzabNR1UvMF
	 su7Bd+ZVsdTTu+1rFG5kK3z5+M/TocQyU7Vt/pAP8RJC1XI9zAfKWMhoK7/8QK2MUd
	 8ZybDVMqyM4HA==
Message-ID: <sashiko-outbox-172897@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 3/3] RDMA/rtrs: Post client read requests inline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrei-Alexandru Bleortu" <me@andrei-z.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261015125118.2966247-4-me@andrei-z.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-4-me@andrei-z.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 13:07:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The RTRS client sends a read request as an RDMA Write with Immediate of
> a small message: the user message, the RTRS header and one memory
> descriptor, about 60 bytes for RNBD. The message is posted by reference
> and the QP asks for no inline data, so the HCA has to DMA-read it from
> host memory before sending. That read is on the latency path of every
> read.
>=20
> Let rtrs_cq_qp_create() take the amount of inline data to ask for.
> The client asks for RTRS_CLT_MAX_INLINE_DATA, enough for a read
> request with one descriptor and up to 64 bytes of user message, and
> the server asks for none. If the device refuses, the QP is created
> without inline data. The client posts a read request with
> IB_SEND_INLINE when it fits in the inline size the device granted.
> Write requests, whose message travels behind the data in the same
> WR, are not changed.
>=20
> Providers copy inline data from sg_list[].addr as a kernel virtual
> address, so the inline path puts req->iu->buf in the on-stack SGE.
>=20
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015125118.2966=
247-1-me@andrei-z.com?part=3D3

