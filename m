Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404814;
	b=qZrNNou16hnQWh9tMXfFSi/C6qxnIfSOu2lUDYaudglvbTwYmuL5uHz/wFd52IHvAI4P
	 B6+oBmLaZpuNcq/wHpiqsrO6Bj5FyYICOkvrZOvvtqL9B3sTVJoHG+VljaEVfixVxmT/F
	 fqMbLmsRBr+1H1iXpDoGrOUdAT6XUTKb1znxS9QOhRf6pt6LRvGvshOus/0Y5AiGxitKE
	 nOMsz4ngFDO2KAXJKsCc0e0nhoUCo7eE9sTSD6LEPZUErSzGjLS/bPSgBPbJ6Q6zZMMo7
	 DW9YiheyeT1PtdWcUubHeUss4StOo19bxVJhAVr5xUYacbSME3SWRs74jrCmEPonF8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404814;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KQw2ix9pJunJCZ4A5y2qpv7q7pBzF7Y46NufGbUSvLo=;
	b=OfyYuHsFzPMp9msyjMBC2tKCzN7HiML2CX5GV6FVUXldFlIjz5YIaOgKuZ0Hxub0/Emb
	 WwqUlnd/53YCGUFqalcT05KxXRYezIKrzt4K+rVIcpz0LiHUyu2yVZZ48JiGK6sKwVoca
	 qepS0YNLcRiFcIHKmVQe2ayYxXypAmR9xQAoDQfz2b782k5iPokrIPnJX+98R2NmrhUHM
	 HMs8AEuL+oj/0iJL4Lh/cyE9RGGJLu34QqjwhaWiUvMP9YtaKRWD+h654QIfmHRs/8x6h
	 ZODfHYPyXoVVuIDfJ05tqeWCOVcF6xXXbvUOO9M171ymvb/NSix/EBTD6Oln5WOORjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ClE/M8FE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EB9606A886
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClE/M8FE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8714A1F00A06;
	Wed, 11 Nov 2026 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404814;
	bh=KQw2ix9pJunJCZ4A5y2qpv7q7pBzF7Y46NufGbUSvLo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ClE/M8FE2DbKZIPFbDH5xKp8aWLvZYVBwOp6fmS/aM6PTwvBy40poMQgCEStbL1p+
	 48w7VIj905sW8wisq5pA9Fc8g39X/otG7Hw+/F2MaAqj7a7yXQnCVhDqr0jqBaWip4
	 P47vwKMEPcZfnGCCaXGRM1XGSEsjejbX/qKy4ioKbJ0IoYYTWca/KRP4dwgKUwJ8df
	 Uk74ug/WvisEmNl+8BXOAP0LZs/xncP9h2FEIlgnEXGo5AVtC+LzVS/x7IzT54aCfu
	 FRecrnxI7s97ti0iYYTns4sNRZLpMHyG3qrSQagTsFtCWn25WiYSfk12IuLgkaDygH
	 vMjrudyjHbYuw==
Message-ID: <sashiko-outbox-209101@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 16/24] RDMA/core: Set the CQ comp_handler
 after its poll context is set up
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-17-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-17-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> __ib_alloc_cq() sets comp_handler before it initializes the poll context
> the handler schedules, and for the workqueue contexts it arms the CQ
> before setting comp_wq. The CQ is reachable from the completion
> interrupt once ops.create_cq() returns, so a completion event raised in
> that window would schedule an uninitialized irq_poll or work, or queue
> work on a NULL workqueue. A conforming device raises no event for a new,
> empty CQ, but nothing in the core relies on that.
>=20
> Initialize the poll context first, then set comp_handler, and arm the CQ
> only after that.
>=20
> Fixes: 14d3a3b2498e ("IB: add a proper completion queue abstraction")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D16

