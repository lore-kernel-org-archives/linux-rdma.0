Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794285930;
	b=GKh3kdrEgFUklKLqB76kR5NEgaZWlolsPC4tKU5ujv+qVFEGDvJFzBRZVPWNKWBs4lt7
	 8CErERYHDSNTKcsd/eyl2PyfFlJibKAs0U+C4G+vdDY/erRXIaagRzOIq2+yrQD2lM4T8
	 hgThnplqBGp1zA7BQ05gDRjaCLTU58w5ExZ5ckiBGX+HbzBZNrxQ7RUWtRXQmqr11proX
	 cplfNAehyiX446nHdygCYQ1hQQnATh0u0YTN1AzG9LWfg2/w08nbHO+UF0B3DhNpAI37+
	 zKqR1RKDwFB7cFcu9HmFK+BvMKaJwX3li0gGO1jyghZCF0sy1K75D1Sob/v4xLot8ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794285930;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LrGCGEicC6KRFC/CKzDSBrOF6d/O5J49VVefSSWd1go=;
	b=tDjAD25sOjM2zBaQW3705lFeBHbyDdJbLLuPrODbLVX7ws42o+6WIm9lsaznT4hLuOe9
	 AYMgCehXfEV0/gX1/P4/COH3c8MWF2tE92631/UivkMRTS2jsvQLtIHjkUdU3ssmZxCPy
	 8JM+DPveoHhURn+N2x60JnL+xSSSZVhCjtMXwMtAfz+2bCdCh8NH4iliUVyBly6+o4J+y
	 Muqj2f6ILFhv8ea95pxVhL43KaIu5XULIMgdcgEvviBVh3AXQKfRPUp9ta2wAnK44VkhJ
	 zpKxUuPTVc5K126sXSTuZ9tVQgboeNeYxods31ZA0sBAer4pUaEIAC+w9i53mBqU7aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3Q6P1dv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C99B60A260E
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3Q6P1dv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78751F008AB;
	Tue, 10 Nov 2026 04:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794285930;
	bh=LrGCGEicC6KRFC/CKzDSBrOF6d/O5J49VVefSSWd1go=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o3Q6P1dvRQoSCnvtaqd39JqToM5I3uH11BmYhnjM+SRDsXXlbHrTOGErooEz4mWCT
	 bWcZlK80jpOoGksqvC8YsfF0rimfTmnRbzuVJpqmN54/3UNFXYDE2wSbt0GXqxIvHw
	 eG5esROXLarb7GPXjWShaypRWpCUMMlEpgNGmOBKGlaXUfU/9gXilsot37qqIBBPrA
	 Nf8q75eDcriMUGj6iGjEzjBOcMcf8wRm3lIqUORNgQ/avDRjnMxIgVYal7f5Y6R8pQ
	 M9QeSuNyJkV9SRhzXOOSnU04N9Kc6IYLuxn2RWU2N4aeX0pAwsgL+RRLuveBaBx69s
	 VUyOblVW7m5Dg==
Message-ID: <sashiko-outbox-206235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 05/13] RDMA/core: extended address handle
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-5-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-5-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:45:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> An unconnected transport over UET resolves a peer by both its network
> address and its queue pair number. The write() create-AH command has no
> room for additional attributes. Add rdma_ah_attr_ex to carry new
> attributes, reach it through rdma_ah_init_attr, and add an ioctl method
> that supports it.
>=20
> rdma_create_user_ah() now takes the init attributes rather than the
> address alone, so callers pass the wider set.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D5

