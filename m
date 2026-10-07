Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE8F3806B5
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791417395; cv=none; b=hk/M2Q6cm0UgWlptsxvFPUlZHrLi9PEpwq1w7FM7EZWVt3NqdeYU4bT3kXKcAa6HsOkA9sHLwJY43EBRD4BKAloGlzzonwq+ArbtpGKW/9aaqwZKT4vtcZeKQrERh7HfxRGIr7d0PPRMHRAsbC7X9THD4Rgf6sFBsli5Bkrpcnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791417395; c=relaxed/simple;
	bh=ZPtgTDaybpPl4eQSKFVzVUpa433crnIFlmHKeyaR4vk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ww3QpRFWqvLYgcRUWgBfNSygcv4Pb7/o9YXG0ZKlEegiFR9ZsLU6fvJjalgFG5+M0ZzxGl4tMSZ8buGhiJtpbeADrRzAc/e/ThtD2bj9B1uIyoNRV9TYxFb/mYzUPRjPKZxqe5T11AZbwTIcpBB/YDa/B7Qq79bPz0j+r1NbgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTodjnUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTodjnUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174F1F000FF;
	Wed,  7 Oct 2026 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791417393;
	bh=ZPtgTDaybpPl4eQSKFVzVUpa433crnIFlmHKeyaR4vk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTodjnUIwvIuXwYRjeXoSvCnfw3Mi/NT4TlP02Tga06/wD3Um/mg8srNeUla+jxHw
	 1KqIE5XT2/LbqigiAb3Ji9u3qOh9kQojxUwzAUVjnuvCtjkoD4iATLWPK5BeBJ07wi
	 6efVJfMsL5sHkw+sHBFZPlS77g6m1V649XJYdEBmkijttR++GlQwaajiblx95p9OyZ
	 jYC1jD03F+CW4PouGolVCbJzEIQfpwC/6j+NKFDkG+SV1LWArATbgxjw8JjY2Ao+QX
	 hqlxLfEWrSDUhFA1qktFJ6ctqCnmQUiGDTLi7pz1DmwmXVfRhJ5cJ3W+/zw5jDgqmP
	 Bmvj6AvKvfguQ==
Message-ID: <sashiko-outbox-163443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma] RDMA/mlx5: Cancel deferred page-fault EQ work
 before teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Prathamesh Deshpande" <prathameshdeshpande7@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
References: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 23:56:33 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Page-fault EQ work can remain queued after the notifier is disabled.
> Destroying the EQ before cancelling that work can let the worker access
> freed EQ memory.
>=20
> Cancel the deferred work before destroying the EQ.
>=20
> Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to =
RDMA")
> Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007234216.2765=
-1-prathameshdeshpande7@gmail.com?part=3D1

