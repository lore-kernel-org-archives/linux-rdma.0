Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E23ACF02
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482078; cv=none; b=f9PfZoriDnN8lkEqSvL45mttfdZZkgg2aR1U9yDtfaO4tahKbey5C8rBuN8Tj+068v2A+lC2dJdEQdeDFzI5VOE8hDmZRNscF+aKqy4WIhY3qeVQPd56wixhxs6IVsJVeA2mzcacCtPJFK9f3IbnNQ4f75seVzVWsr1epZ3x8EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482078; c=relaxed/simple;
	bh=CGZXf+ezawkbzBhZf62i35yC2z5YYsSho71unKKl0Q8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bo7HSY7V7te51GKsbrKP1NVp63+AXWcKXcPcpisTKX2J7cGhrcTM64O4IhEmVG0ZTshxupLtgBgntYYsGyQpJvyZPa1ppMskJC7ZhhaorFg26nY1seDCzNRXgYsZDx6OZG2GGD07AkTicvOZSYXOD9VsMujMaq1Rzp791S1loNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmlUPE+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmlUPE+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75071F000FF;
	Tue, 15 Sep 2026 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482074;
	bh=CGZXf+ezawkbzBhZf62i35yC2z5YYsSho71unKKl0Q8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jmlUPE+P0dqwWNWdl0D/5nl1wlhYWD47PGhw7SDeV2o8a67ha0r1KdxNJL54zcyZJ
	 kIF59c9zRlypd0r53qo1qF9+Wzdpxl1HscJlfjb+zwQ1lVBOt9gVDMLTbOTXaK1gaS
	 9Z+mi2++DHSaRfZA2PJ6LGxI8L5hnlcNdN+KvfMww6YIXYG8Yv/7lcEBdVtiu0jP8J
	 FTxpo5wt3qJEt11XaOlJMMTvoUaSSfSDz1uE4dPS5AGZEnKJY7RWrNNnWaqKk+KnrV
	 H83HwIjoXHUT16RmA4BNmhezwzXg+DwP2q63I+vlilrTyz4zieyNalZk3ZXVAoJhDX
	 N0PSEWdoHE97A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 04/15] RDMA/umem: Reuse
 ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-5-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-5-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:21:14 +0000
Message-Id: <20260915142114.B75071F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Several drivers pin their CQ ring buffer via ib_umem_get_va() rather
> than the CQ-specific helper. Switch them to ib_umem_get_cq_buf_or_va()
> so the subsequent DMA_FROM_DEVICE change covers all CQ paths at once.
>=20
> For shared helpers used by both CQ and non-CQ callers (qedr, mana,
> erdma, hns) a new is_cq parameter selects the appropriate pinning
> function; non-CQ callers pass false.
>=20
> vmw_pvrdma's CQ is excluded: it embeds a ring-state header that the
> driver CPU-writes after polling, making it genuinely bidirectional.
>=20
> This is a pure refactor with no functional change.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D4

