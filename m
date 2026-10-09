Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5FE377AB4
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579842; cv=none; b=j0aH6e7g0YWnAQJsby7RjeIPQI6OGv3rEz5hbxCq/d60T+8S5zuDwNqhFCI5uDi8PLEeglGRJDsFvqHDs7r8FoQj1FIaK/NfrmYcfokIGk98JVIedRht18R/l5xpRZFPv6qzay/mqnfsTSnI2WY4RqShQ7CFKj2o7T7hEhlPSPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579842; c=relaxed/simple;
	bh=aQ8AZnRffkG8coogWQaD0KqkFerg17Rh3l4wAwLfMkA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LGoxzUFQOWlGoqhcrGEg6vGUnnsoVUjq+yzZfs/j8Qy/H0BpXCHaq6bNFmquN7dQYy1MxXQbN5Oc3G0IVAeHKgx5dPJGrle3aBTrxHNUYrEIVAC8L5u/uFfOeb8BkhJJb7TvXmeuJcvo1uhfyTVexTzG9u9SB/ZKCkUrsIdhNeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuWekzjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuWekzjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B91F00893;
	Fri,  9 Oct 2026 21:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579840;
	bh=qqgeUYi4ymJUKtqneVIXrdLGfAJW72MYSp85bsFbDeY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UuWekzjWmZZefRrzdmMbZfGNWt3GYNcfVBsOgIOWwgqnQjx6gDWDW+ylFBDr4Xgd5
	 f3kCj2wDbv/u8u0lvtALWitRL9ghhWKr7qCWZsjC8rxjfcXHqxzsbmPaSCcSIsAq3z
	 J0m+luAhFDUq28tYPt7Rd8zz/8VzYrbo4tlRZ9ivf5XHpsfVnTSQmirTsDoTHBiQ97
	 OLEECFPBEkbD8vo6B2sHPZh5dYUKHIB6nJ88oo8lb+oH92MXaDldiM/SI1VoVFJ2hB
	 GLxe3/KIkyxOhxET7HIiOBwU+7RP/IKhWpuRSxJV1UtwZzd+Uj32Vl2tIvhzDUteVT
	 I9yxhv1YucdtQ==
Message-ID: <sashiko-outbox-166073@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 02/10] net: ftmac100: check for failure when
 pulling in the RX header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-2-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-2-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:04:00 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> ftmac100_rx_packet() uses __pskb_pull_tail() to pull either the
> Ethernet header or, for small frames, the whole frame into the skb
> head, and ignores the return value.  If that pull ever failed,
> eth_type_trans() would find less than ETH_HLEN in the head and BUG()
> in __skb_pull().
>=20
> It doesn't fail today because the skb is freshly allocated, isn't
> shared and has room in the head, but that's only true because of how
> this driver allocates.  Use pskb_may_pull() for the header and
> __skb_linearize() for small frames, which is what the two pulls are
> doing, and drop the frame if either fails.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D2

