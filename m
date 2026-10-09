Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BF13C584F
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579837; cv=none; b=gFKzLyy1gZKFVfv2oOg5SnxXkSZxszFcQEJPZ1FlKSeqQ+iXzKJ6wj0kpqhFv+sO4HWdcDt6cPZQYaI5+3ocNh1tSYyaKmBYDHgpMpuzMo5owlwWaByNZXPf63OHzaSI1XMBHU9xEzuDnR8mx3f5dytzSNmZUHR5Qwj8zXEAH7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579837; c=relaxed/simple;
	bh=jlvWT6zclsKvcRmq1p8+Lx8/sBvH9KqMbadw5g0EuXA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=u3EicdEjr8yUhdJQlSMwg9Wj1+SbisbekbZMr/pW9GTQddqnh9tqO2cvsaQeb80+4WV35Bl63AahFl8eXcHMFWFPg1Su0ym2cxluaxyXfYJm0bQesY+3wvWD1N65cq90GBHxrudxbZ27tcpFLtP971PXPlNsuId4zob+NWQfgEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NeqHZQZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NeqHZQZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5519E1F000FF;
	Fri,  9 Oct 2026 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579836;
	bh=Mo4nF0ATan/SOiBlE4oHVy3vMEhRIw2ESPRseHUQrlo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NeqHZQZstlJVx8gIsKnSfmrsbZsZSe7z1iMpB2pxhwHh3U3qtchDolt54C8a7StNV
	 bo8hYTwrh2uBO2GiGT14R9j161Q266v96aoZcyvj6E6Xe0SgpNEQXaVN5AAKzB0bt+
	 x9WT7uLiQS5Fgwyvrn9nloYpyDRaZBCSpzCdNCOK7z546E8mxQ/p1adJYCpNMNVctm
	 YRrgrbVSpKnwjnmGHWNTGzvylrTx0wThjo9zrE6FwJRLHhMp9k/n+jObi50102L+ee
	 RjH7tbp007T1YxwLLK0+oajERXLU37D3ExfBw58ZV13ZQKmlMbdrSUE2/cY4QtBjZc
	 CywMvRPa7I5tQ==
Message-ID: <sashiko-outbox-166068@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 03/10] net/mlx5e: check for failure when
 pulling the Ethernet header after XDP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-3-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-3-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:03:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When an XDP program leaves less than ETH_HLEN in the linear part of a
> multi-buffer packet, mlx5e_skb_from_cqe_mpwrq_nonlinear() pulls the rest
> of the Ethernet header in from the frags with __pskb_pull_tail() and
> ignores the return value.  If that pull fails, eth_type_trans() later
> finds less than ETH_HLEN in the head and BUG()s in __skb_pull().
>=20
> Use pskb_may_pull() instead and drop the packet if it fails.  Pulling
> min(ETH_HLEN, skb->len) keeps today's behaviour for a frame shorter
> than an Ethernet header.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D3

