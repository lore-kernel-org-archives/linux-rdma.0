Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235655;
	b=iL/tozjerHrAlwE40sijyh7BaV4voaCuBNb2dpSGQAAPzWlQ9JT+bMUNECAhEQ6Y1dmQ
	 RrYN4nFtUV3Z3PKKgISP46ng5l0DW2vcama2wQ9Pk663KwCqJHiA9vusMPBkRwNG22AAj
	 oBO5sLfK77eHS5hDtoxAqamvsrg9ZxlTO68JW67AMJKYMXOFb65E50T+HYlifmLnvjW/g
	 YXQvR7Z981kEsS3zYjt08LUMw8L09ZRnTYig41HNHYupz8LQahbY27Qq2r7gQwojDcAHJ
	 XmrWf89iZ0ZZVgYNwNuoe9b4JiEe40ulVXHOMBtxOtVsb9y28AicecedzWhSI5qvDxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235655;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P89PTJbN9CTDGrYJnKATw/DfOxl4TfdaaMR8Y1Vsikk=;
	b=vbdoj8l9oz8BIXEiD2FAVOpWhiOm5TiJqhMhkHagc7HNGooubOVhK+j7aL5+PBQWVQmX
	 o9SmbZOh9Lf9D+/kKffxr0dABfpULWoYdq3IPbkCDyaPJ5nT7Jm+9I8jOzqvrPK+5e7Yp
	 EE4Gl+tP2fzQj2lFIJLtVuRO4SSIG2/r7fbycmNc0ce5muJkbF3zQZmucfke93DGNwIYh
	 p1pgvW6UCLE3KWfn7dcy/MG9jBsCXoghpmqKYDQCG1+b/pc2UUhlfPWtUWK20ljO7ApWa
	 5HO4HzLs905MIIRryaUQ0b8Z7tF2Nzvs0kVPWy0F/85zaMfB5gm5b0U4+WZFrNMHqdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnxueKVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A4D606A323
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnxueKVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D901F0089F;
	Mon,  9 Nov 2026 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235654;
	bh=P89PTJbN9CTDGrYJnKATw/DfOxl4TfdaaMR8Y1Vsikk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RnxueKVNRX1MYg58ua/N+p810VJybmUCQBauKlxrdzSMoTOQxlB9+PDk+PuRq6d02
	 5+dU0JR1GmOivbjpMzWbWPVL4xuHgNUsVXmtvdDHWkYY6VCRbgVMke1JPNNhwsYG8l
	 2S8WJukjEcyc3S7SlVOdKhMul22zblTk17uwMZ0rAgizc1Cyi/F93v+JiyZmY4q/YP
	 g57/jAoqdAvYneuiQdhGf12ZGOX5Y934RPdEP3Ltm+GxheXSybPuk6+vSlzphSw/PV
	 SS1IL+Pb+a0fQ6Lw5zQGRb72zmS+9Kvn4CKakVZJRKA//rwWWTEAxo4wbC4I7pBute
	 ddHZ5PNyVY7eA==
Message-ID: <sashiko-outbox-205127@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/2] RDMA/core: Don't warn on oversized bundle
 allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-devx-umem-mailbox-overflow-v1-2-4a63baab25dc@nvidia.com>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
 <20261109-devx-umem-mailbox-overflow-v1-2-4a63baab25dc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:47:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Uri Dar <udar@nvidia.com>
>=20
> _uverbs_alloc() serves requests that do not fit in the bundle's internal
> buffer from kvmalloc(), prepending a small list header. The requested
> size can be derived from userspace input, and since commit 7661809d493b
> ("mm: don't allow oversized kvmalloc() calls") kvmalloc() WARNs on any
> request above INT_MAX unless __GFP_NOWARN is given.
>=20
> mlx5 DEVX UMEM registration is one such caller: its CREATE_UMEM mailbox
> scales with the size of the user's UMEM, and a mailbox that passes the
> driver's INT_MAX check can still exceed INT_MAX once the header is
> added.
>=20
> As with memdup_user(), an allocation sized by userspace should fail
> quietly rather than warn. Pass __GFP_NOWARN so such requests fail with
> -ENOMEM.
>=20
> Fixes: 461bb2eee4e1 ("IB/uverbs: Add a simple allocator to uverbs_attr_bu=
ndle")
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-devx-umem-=
mailbox-overflow-v1-0-4a63baab25dc@nvidia.com?part=3D2

