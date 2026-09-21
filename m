Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177B48F83B
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000051; cv=none; b=TqerjHKoR/NJZsOz5ckqPQzy/PA5ponRPHaRHLB0TGh7ND8eCCMlFTdVIQBJh5lhtsrDlbToFB4++K7uPfsXvhMHlU7SnJHrobtfHgpL+5z9cq3oQFCli3fYj7PKH3NdPGhNjl6UdI8hWaZYM42Owl33VPsZh1ZzWhh5vfp+QMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000051; c=relaxed/simple;
	bh=hffFxb09NiVQu+2X5cg5Qay4avGgRc4H1kIZdCyReMY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DAPdrTwL1w7t0ylRIPt/sLRog8apcPcOf6j17eZDWT2/H8YpWX8E3I0gHdtLAQ1Scv3CJGNN6hQ1h/YlOlj7R6UxMisUV7n3cUNnjRXtUZEk0lH/jm5X2QOrksQ0biE5uhhsAItmjJxe4UjoQ0Wthga4P+RvFXDdRrNCDi54u98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q09J2Zd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q09J2Zd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6281F000FF;
	Mon, 21 Sep 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790000050;
	bh=F6/jesbuId8FnPehxdr28IVIQZ0Pk4HF28yM44r5l24=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q09J2Zd1AFG6+gzM91PPxACrSyBlPq1TNurLsej09WmR8dFyQ+ZfFW6x0Zjl0HAv7
	 ADZZobYUZ3KBWDOIZaXBxeLaRjTahY1MONZWPKEtevbj0siBv6hFK21qLBP+ylKrml
	 q9l7E7LXo++D6OgSuVwuG6nzLktFEeRPl9JO6lqDuZdRjS1QVMhv3zENEEhjHhZ6E1
	 3nF5QvuBQa7SX7FhAnSyOsb6iJO9hVQQnsCe1gIlzbiZyK22bOIzx4ybAdRX6SHzfj
	 16laReLhD90SLb/2tNnooHwGzM0zbMcyTmgZqxLjAbd3di28xjgqCLoHTHSYKPt4JK
	 6oRI4dOF29i3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Quanye Yang" <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>
References: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 14:14:09 +0000
Message-Id: <20260921141410.0B6281F000FF@smtp.kernel.org>
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
> The legacy recv completion path deferred reposting invalidate receives
> and instead posted two empty recv WQEs when handling RDMA-with-IMM
> responses marked with invalidation.  If an invalidate receive never
> arrived, each such response increased RQ occupancy by one until
> ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed with:
>=20
>   failed to drain recv queue: -12
>=20
> Repost one empty recv WQE for every receive completion, including legacy
> SEND_WITH_INV invalidates, and only while the path is still connected
> so CQ polling cannot race with ib_drain_qp().  Size IO connection RQs to
> 2 * queue_depth + 1 to match the posted recv count and leave the drain
> slot.
>=20
> Tested with a synthetic RTRS client flooding unpaired
> RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
> __ib_drain_rq() warnings.
>=20
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921-rtrs-fix-i=
b-drain-rq-v1-1-11b1637958ba@proton.me?part=3D1

