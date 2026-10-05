Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF4C418A5E
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191436; cv=none; b=qPRuX0KycDOKNDCIDvb908WlyTl/Q/1Gy7wBTDLZxzm2q/xYGMa9fkCW2R9/peR4iGU3gSHiytZ2wzC6APrmkjhBtYCdwJBfGn7TDQGtAld5YdyzDn8EJCQvnZ88fRwxULPC6K2HJjCjbSuGL+lILZGDsw4g3x8GcyWKWeP4mHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191436; c=relaxed/simple;
	bh=IgVcEOSCTESsMeEd/DUwt3qbz4BaWAzpFH4IwGdU9PI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OzX9Y/+c21UthR9QdMUQ3gGsyQDXjdNwwfpN69N4XY6/PvtAF7WmnIXmeQTGRJ7FVjOms2LPeQFaR2lS7/yXlS5NYSmi9RgNHrD+Or/xNCV0TZWREApDGyUQogRF9O7NHKqWoBhZl8LhljYUYscTZj+A3op0CrwfufNf11AKvaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nB8sBl+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nB8sBl+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B41F000FF;
	Mon,  5 Oct 2026 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791191435;
	bh=5zs9CIn24Q/YlWlIKSXCsuHq1dBk8tYMbGAEufkzf84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nB8sBl+64PrsmvBFrhRqPo3T4Y/f0AyYtEr1GpbpFiWCaUMFFGmqWBHh7zEFtz03N
	 jhSFqZlmr7YkwZeHo/bITepk4zFKn4YN3UveWyhvQgqUGZq60VVq2LOnUUKgJc7100
	 Ef1Nz0W+cel2H8KISxsLc4WfyA4hmwvgG2RhZYNuPCIBRAHiMhJVjL/cLMNlRs5RiT
	 9oujJePxYYTJ3u7mZKEhYaWrdu4d/0+gDeuIxyO+lSqVULZOM6zn7learbLWg8JQr3
	 7Ip+2Bq13PB7xDx9OFZWNZcj+wAnaEu41dW0+Fxu0+jsl6jy+uj/QuZW+3XBmY8P7N
	 Ln8R8ldmlduow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rtrs-clt: Fix recv repost to satisfy
 ib_drain_rq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Quanye Yang" <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me>
References: <20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 09:10:34 +0000
Message-Id: <20261005091034.E25B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Quanye Yang <quanyeyang@proton.me>
>=20
> On disconnect the client error recovery path calls ib_drain_qp(), which
> requires one free RQ slot and that no recv WQEs are posted while the
> queue is being drained.
>=20
> When the server is loaded with always_invalidate=3DN, the path does not
> advertise RTRS_MSG_NEW_RKEY_F.  A client-requested invalidation is then
> a standalone SEND_WITH_INV.  The recv completion path did not repost
> that WQE; it posted two empty recv WQEs later, when the RDMA-with-IMM
> response carried RTRS_IO_RSP_W_INV_IMM.  If the invalidate receive
> never arrived, each such response increased RQ occupancy by one until
> ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed
> with:
>=20
>   failed to drain recv queue: -12
>=20
> Repost one empty recv WQE for every receive completion, including
> SEND_WITH_INV completions on the always_invalidate=3DN path, and only
> while the path is still connected so CQ polling cannot race with
> ib_drain_qp().  Size IO connection RQs to 2 * queue_depth + 1 to match
> the posted recv count and leave the drain slot.
>=20
> Tested with a synthetic RTRS client flooding unpaired
> RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
> __ib_drain_rq() warnings.
>=20
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005-rtrs-fix-i=
b-drain-rq-v2-1-35535a3ed115@proton.me?part=3D1

