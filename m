Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745305;
	b=n9me2PuuzI1wUkVPMcd2ZfYDBNmjbFeJWqi39s9B7wDPzFnOhTubT4eqh347/qHslKLR
	 YHBu1XCcsQeJZivomTeB8SLjvhoPeahxR20xky0nqAZcuf5YHv6oWwSV0015rT4kpOyi4
	 EYTF0sv5sfOCpcrlzL3t/t0/uc6BDbwzQ0Yg7Sk0GCGp74uy7HHUHxLt5QQ800Bx7C1pv
	 2W1yJ841UAt2xCMMgRQRAcvqEangbpDItD1EW166CiuDcVD8ydjlcMLyw7wrFmLIqnrgc
	 WjcDbLDSimkZBchlrNtZ+M1o4VzctX4RotYYS1UJmVm1CxIhWrpylJN5ergUf9yUYvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745305;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F2BBnlwDwcHtInTKfplpnXw2yBGEHaha01Kg5t2hNRQ=;
	b=OOsPY0pHgsF6rQGU4XgUIlrtZdvDKa2lzgHqKJ+FbvXry30wjA+hAaT6GoBBb9Eva67G
	 fItUcdQkk1LQa2wOa+Hi9eQIR8RM22FGftiRJemVGWJFXjQEIEoenL1Y1cQbPFVUs58E+
	 mCKp0vSOjixn0RgDE+zUW0gzgVnd5WWdBwZXrPucxu4VNWTe7MCP9iGBXlGz5aLDXuHD8
	 0rz7B1pY6dGm+I8cDr6KIAs1mh1bZZ0uVJH8yZe7ccYBkdPiVFAotOfojgNZnQ6DDHUys
	 jjERsuQsBaD1Vhlo5wRmO3K31zW0NI2BXvNzJRPlqkRkXPyvfthjm38BxCse4B44f/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AcSV2a9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3579606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AcSV2a9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965671F000C1;
	Tue,  3 Nov 2026 22:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745304;
	bh=F2BBnlwDwcHtInTKfplpnXw2yBGEHaha01Kg5t2hNRQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=AcSV2a9t4r+Cxhq2caWDE1NyUifi8EWYVZ599uvvRIom+/TBIqf9Q3739qp6pgg4M
	 H+HiF0K9aHZvLOJZVLAFSONJIgT3I6lkZBTO/Gx9BXveyF7wVTpPMga+BZaZ7FnLUo
	 opgldr9AF9zuBp7OyuKBsAswZ7TeL4wqDF01ycPAvQSXX59UGCO7s0Pzr7IxsF6JML
	 DCW2UAnzrLBk84WClz8HSZNBqKStKf4y2GWpcs6XUNh1CgzLcK1dOvszwstGvODmRw
	 aV+ro87WCkDAc8PpoOpfSyV2+x+wHaAZ9mIF3/xmCfDDYYEH6goxKyLat+Giy0gv6g
	 Uf2+S/AJJjRnw==
Message-ID: <sashiko-outbox-196138@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 13/15] RDMA/uverbs: Add new Unordered MR
 access flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-14-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-14-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add a new Unordered access flag for MR registrations.
> This access flag allows additional relaxing of the order of memory
> accesses to the memory region.
> Using this access flag allows for concurrent reads and writes of this MR
> to be reordered.
>=20
> This access flag is part of the optional access flags range, drivers
> shouldn't fail registration for any value in this range and are expected
> to treat them as best-effort.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D13

