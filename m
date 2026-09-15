Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB053C1D61
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482779; cv=none; b=YU+X/DbKEu4oz5FaUOl2zVjylRTA6/7HN/avh1EODqIY7d/xoIzeZrqu8F4WHH62k0NLdlgIPIf60OVyJcbBFRgj65UpdejNxsHt2buCkiwz1FKQvUhhKeAg5ipHblJcrKltzJfvguLmoUBItB1P+hpLe5blFqqPOwc3GnCNUjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482779; c=relaxed/simple;
	bh=6PXjWPj1A419UFth/yB6GN9TRsBlM+XXW8GjSh9vqkM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CXbr15/xWglAdb+p6+glbMbMYM0ZMahIOeMsQwdFzOFtLzJhk1fltprC1+kChI3U9/GG4mTZU9bFSxwivevoXO/Wxu/I7srHXSnyic4CEur9Fw7QiyIwshumvDZUesC8wbTYKcGOIkQh+nc83bUBM1p+jBHn2HZdTX1kmnUKcH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwWt2eTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwWt2eTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E941F000FF;
	Tue, 15 Sep 2026 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482777;
	bh=6PXjWPj1A419UFth/yB6GN9TRsBlM+XXW8GjSh9vqkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HwWt2eTD7/dFFedswua8sz8xMJsryLw+fzWOfpi3cpiBujsZCClOSozUtkIYB73fk
	 7PQ9iqERd0KfxV1RvlDfCjakos8mpoyYCjjWDpudevrmtoRgU/ILKGph0wIaeZJjYv
	 Kv77ziVTJuya0hydalJE3Zs7OhNubq5a9TtVM9oX4qP7Eqkv8fW6AFQoJP5ZBM2z7c
	 5FfEB65UV5oV76X6kDAJXBVpPzDAT8T9hg6BOIPpflDdaBHkYs7n/UUe0i01Hl2Fuw
	 Vy+DVn1V97oeGC/rD8Op6YjR0jYDPCuZdN5QPdUWcLapq1mUllcx7JxZw0zgx3E2D2
	 LotPCHqsWC/9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 12/15] RDMA/mlx5: Set RQ event handler for
 raw-packet QP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-13-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-13-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:32:57 +0000
Message-Id: <20260915143257.B3E941F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> create_raw_packet_qp() creates a separate firmware RQ object but never
> assigned rq->base.mqp.event. Any firmware event on this resource (e.g.
> WQ_CATAS_ERROR, WQ_ACCESS_ERROR) calls through a NULL pointer.
>=20
> Set the event pointer before the RQ is inserted into the resource table.
>=20
> Fixes: 0fb2ed66a14c ("IB/mlx5: Add create and destroy functionality for R=
aw Packet QP")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D12

