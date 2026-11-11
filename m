Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794362218;
	b=RI7Yse/viaY7BJ2vz9clGV+gqZD67P3xJ1ABBnhD9/EUN6foiBUc6mVkrGMSc10mv7TS
	 LPQMNIJVCv4wGIJb9Gf8gx3pEN5bFdoeC4XLzWePsjjS20BVHLU022yDBGw+yYFbvzUfq
	 zHx7iu8RJQCXhXQ68vsrHgebbQta+XFK4OYUWSKmXPgLc2sSxjpiBpOylLzDaRtEyzZgr
	 uIE7E8ZAxVA0bgw6LjAvy2ZpTwZp3jWQndbnKueYZ+o8o6m5jqs/N6HQu+G/y4ZqCR+4D
	 hvj9S/iZp7l2FQg3bRu+CtC/lPp05zfCS7byWChVjEEwkk8breLylOEuEX+2hfkQ8Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794362218;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kBVnXGgofrfD9Ng5zdgr2mgsyop9NRO7iiPjrUxfIpM=;
	b=3nBjfwiWSj4poRRwhAEoRDsXSjOMPrSH83Zr2WWi4dmu8hOsRGMvb+SA+nkT5xsbDPVT
	 WobiMTf+kXQTLVcJ1ov8R1PJ895roJY6pbGZ/ngLx8FNUoXLXFDGkhtrVL10Y1GxKmVcJ
	 rFT+tVndD3Nc185EizFsYnXmiDaQUHtpmlHf5RyjBvTgBdx476EYU/ajluIpGB5BmEf6P
	 ZN4cUjWvBHxVBe5kR6XxHUMr8VMeHB/n0PczqIceiQP37eXD2FQzsA0qHq85yGmXWmXx8
	 xkCJFE6EdsfFoD6p3R/LIM5VBhp/v6+fG2nAx0bWy5f5THgka0ZOih0bLFMl1XijstA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AvFZvug9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAC1606A320
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AvFZvug9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC94A1F0089F;
	Wed, 11 Nov 2026 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794362218;
	bh=kBVnXGgofrfD9Ng5zdgr2mgsyop9NRO7iiPjrUxfIpM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AvFZvug9iL+Z3Q92S8jt6nM7C/K4SlsrDKQUN+7o8Ggrv5h1IVIN0h8OHSOO5f3/k
	 FyY0xmUooYKdD9At7B0Ays8rbxjRp42NYuvRpsj89pbx1w2LmtdVXCspnJJtsZ31Lj
	 gdq5qXVJHrzztephRwOTW2AYLvXX0uf2g3zmMALHf0aRTO2obBcaFMi1jlbspaPcig
	 9ksHscHE3nJg/wuUmhCp8LtU+AqkIjqPXjsMuUvvDCKOp6vQuqaAEFs5gSRrmJg8rI
	 LHV40TCLM1NO8dSDo0QNQJPvVkwZDHpk1/ATqpAIeyoxAnMIv4LE6xKTfKT62cfSml
	 zD0IZjJ7jeU0g==
Message-ID: <sashiko-outbox-208059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/srp: Reserve send queue and CQ space for
 ib_drain_qp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Praneeth Balasubramanian" <praneethb2002@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110222421.205573-1-praneeth@ucsb.edu>
References: <20261110222421.205573-1-praneeth@ucsb.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 01:56:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
> ib_drain_sq() requires the caller to "ensure there is room in the CQ and
> SQ for the drain work request and completion".
>=20
> SRP reserves that room on the receive side, where the queue and CQ have
> queue_size + 1 entries. Commit 9294000d6d89 ("IB/srp: Drain the send
> queue before destroying a QP") switched from ib_drain_rq() to
> ib_drain_qp() but did not grow the send side. The send queue and send
> CQ hold exactly m * queue_size entries, which is the most work requests
> SRP can have outstanding. If the channel is torn down while the send
> queue is full, for example during error handling after a target stops
> responding, posting the drain work request can fail with "failed to
> drain send queue", or its completion can find the CQ full. The QP is
> then destroyed without the guarantee that ib_drain_qp() is meant to
> provide.
>=20
> Add one entry to the send queue and the send CQ, as nvme-rdma and iser
> already do.
>=20
> The missing reservation was found with an LLM-based tool that checks
> callers against the rules stated in kernel comments.
>=20
> Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP=
")
> Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110222421.2055=
73-1-praneeth@ucsb.edu?part=3D1

