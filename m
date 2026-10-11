Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F22DF128;
	Sun, 11 Oct 2026 10:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716181; cv=none; b=gIDHUVLB5qzDK5l5nw7yU0clzFBJ94y1Me+6YxNFt9aXIKK7c1n7bMp86VbbNP3oFg9CsyrSNVccn1pHKFQWNVVzf6zTh0lg3D3qwWXimgzaw7qJpK3Rc5F/8DYYMrv/hWUs0efQj5yBc34Xav36bn2meyz2WAQL2Lg3UFsH694=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716181; c=relaxed/simple;
	bh=QGfOBWAHuNFrOrL4sfa37BtmNCagiA9s4P0z4ZsIVlM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HFyrwEsXmuA3rikKysTyjqe2dorqekqFurcHeW7A+5RIN1KUu84yGTp9MhzB+9LZ7eFT4cKvudj/fO5sPEI3rSHd0FTLS6ptyZvLU/O5oO+eeU3fGXL+8p9pn7mAdbdqS1Q98VZ/rEq/OZiYbm8YQ3wL9z9HGWnUxzB2jlGObxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GURE+rtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GURE+rtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE951F0089B;
	Sun, 11 Oct 2026 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791716180;
	bh=eM083vjHBG+2qw7HwqBHxB7l47W044uolM7wbU1Ibto=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GURE+rtjfWuOaKxO6tkOMDPA23/9kWAoNDa94KIRUCNiS89XZcgtSjO/CGobEY1Yf
	 PzLSxm5NIt0nvq3kgXnhZdazm5Y7eEm49l/nNPTsnCrCJ+BEnH96r80NCZavt2XVMI
	 WB0X5M6PTdbS4A8yBPdKmssn7UyDJsuLVoCNdQLZVq0+TKSKit1yh56dh3sGWNOuON
	 WI0dM+PQL11rJqQohm33nBlNB1iEvQJo0OkIlAvtQLD+ATmOpWA4iEQDck/21pPa0B
	 EYL98aS0dyo1SyTOf84ZofGy4U20vMKY0Ds9Qh3HaIEV5d/+58ZksoKu8/ar0HbWyI
	 xZU4z5TitdnfA==
From: Leon Romanovsky <leon@kernel.org>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>, 
 Quanye Yang <quanyeyang@proton.me>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
In-Reply-To: <20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me>
References: <20261005-rtrs-fix-ib-drain-rq-v2-1-35535a3ed115@proton.me>
Subject: Re: [PATCH v2] RDMA/rtrs-clt: Fix recv repost to satisfy
 ib_drain_rq
Message-Id: <179171617735.3010278.9064098376724483843.b4-ty@kernel.org>
Date: Sun, 11 Oct 2026 06:56:17 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 05 Oct 2026 02:01:15 -0700, Quanye Yang wrote:
> On disconnect the client error recovery path calls ib_drain_qp(), which
> requires one free RQ slot and that no recv WQEs are posted while the
> queue is being drained.
> 
> When the server is loaded with always_invalidate=N, the path does not
> advertise RTRS_MSG_NEW_RKEY_F.  A client-requested invalidation is then
> a standalone SEND_WITH_INV.  The recv completion path did not repost
> that WQE; it posted two empty recv WQEs later, when the RDMA-with-IMM
> response carried RTRS_IO_RSP_W_INV_IMM.  If the invalidate receive
> never arrived, each such response increased RQ occupancy by one until
> ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed
> with:
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
      https://git.kernel.org/rdma/rdma/c/3255d6b8349157

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

