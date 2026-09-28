Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E814B4DA9B4
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616745; cv=none; b=h58O0TvqmDUgosJvnctRu9ttmX8a95eNV3txKvVmfPXUqPs9L51RX1sS/3XiF2MtqaVN4hEhvUGLWvwjtpxg2YbVMYThvtewdCkxC2ZlAg4VrP7/7TTasJbxX5U5afRBzAsvWH8QPX/+dtlB/fRvFguIxiOB7x4uz/VDvfdJFHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616745; c=relaxed/simple;
	bh=jiTEKLFc39oQ2yhvKWF9Dt00ugbT02QGjPCmMdiUFBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WRbZMHbkDJuoLkdDw0qGWn+qqHvf2ezEoMioboIDu6f5xMFLnj+1XKZ2H7vli0cYUS3YzqG4N92fT5rcHetSQCC2utwbZNJVZUT/tn2HQtcA9GP1njQfNKcG9J2UcBEha/S9iVSY7E6WBPCLe7tf4znHQqKompH8IVv8VbsfWsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CT4j9JvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CT4j9JvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CA61F00893;
	Mon, 28 Sep 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616743;
	bh=jiTEKLFc39oQ2yhvKWF9Dt00ugbT02QGjPCmMdiUFBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CT4j9JvXokOBkqgKD9+snjrtkXF31hLOfVgI78rqoTNYNQe3MHApyN6mZLowsgmwq
	 tobvbZbTQMul1h/ztZluIUUv+D/kcJkYvtt8dPf6pTisNkJk04wSh8G2lhOicN/npm
	 xjy7YyDO+iCZjJj+llVtRCiM4AKcSGXuSjJAbWHNulWtO9ABGZmv4iSA65hMdS9gDn
	 GGd1onlzWXxjYOMJZdhHvierAOB17PqfrbESa1Wa6mh3jnyNgi7CVt4yRhKSvsINjk
	 IBg7QwwDHwGvgiffY8ZU3ASTv586V3FGYg+U5rmETY/KqyD4BNZoKrOzMW2xcXyheq
	 DMN5iRL2QlZ9A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] RDMA/rxe: Invalidate MWs on QP destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928171756.3254016-4-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20260928171756.3254016-4-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:32:23 +0000
Message-Id: <20260928173223.65CA61F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A type-2 MW holds a reference to the QP that bound it. If the QP is
> destroyed while an MW is still bound, the MW keeps the QP alive and the
> responder can retain a stale QP association.
>=20
> Scanning the global MW pool to find these MWs is unsafe: pool entries are
> struct rxe_pool_elem pointers, and concurrent deallocation can invalidate
> the object being visited. It is also unnecessary because only MWs bound to
> the QP being destroyed are relevant.
>=20
> Track type-2 MWs on a per-QP list. Clear qp->valid and stop the send task
> before invalidating the list so a late bind cannot attach a new MW after
> invalidation. Yield between MWs to avoid spending a long time in a
> non-preemptible loop when a QP has many bound MWs.
>=20
> Fixes: 32a577b4c3a9 ("RDMA/rxe: Add support for bind MW work requests")
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928171756.3254=
016-1-cccccccccccc777777@gmail.com?part=3D3

