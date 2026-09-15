Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0513B27EA
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482061; cv=none; b=aLkeKS52Q7LTxXuzHEUes1F6PWmPapcWlzh39yjTgcX6YjFLMDGuYa5XCUXLMORMA8/FYHUEsp+Cx9OgDHVzJ1HqmqrehqPk0ltqsuynslXkhDPomNZMl5s2SRwRiXKB/WXHWrA3MsLLf/jQNMnIlOzoqIqHaWzUr54XvFsqsxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482061; c=relaxed/simple;
	bh=2wlYafuHPXsv9/y+Pm4Kxk9TmQTlfmjbUfp00H/1zJ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GcIsDfQwo2nA+ESanlb7nBQYP7d2Lc3y/fy7PLfV3/Ji/FU6CLmznFEsQJtt06/3xM7H7TGr2XcZp967Ok7tBQnFutU5OTzj44ibSDkKR4dE5FxqP6nljfbwbLCi9gUnx7pTJCOj8lgXLv9B3Zy0xrfsj84QqrLiYJBDbEOFMhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBQ8L7jl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBQ8L7jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041151F0089C;
	Tue, 15 Sep 2026 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482059;
	bh=2wlYafuHPXsv9/y+Pm4Kxk9TmQTlfmjbUfp00H/1zJ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LBQ8L7jltXEWf3cQG59fxKxyZvGcoiWJ8oBAQ5VKncKRkX1kR5zAbs2O9qP+71BE/
	 qHW++qfD+zRaEc1YC4rt2ZQdVJVO07KEIGF3fDlvHZm+f9pYML0PcwDjoZR5YN+MYJ
	 AWKbrfNGPXz5GBtxnaUdsYWtdJu0C9is0YZpdap/AyZUhlsDER3Zybta2xx33pwtQr
	 hWlc39kQdh3nsVfOvbuejoSAY+7Qopf5xl/yjsGra9My1a9vNaofVLkECquMBBgqRm
	 ConOoyASTC9yrGWw8422v+aHVB6X++ldOKS+lfkkDNqp9Huk7PW7mnNbimRrupUDCc
	 fUB+RLkKImDlA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 02/15] RDMA/hns: Pin CQ buffer writable to
 match device DMA write access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-3-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:20:58 +0000
Message-Id: <20260915142059.041151F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> alloc_cq_buf() leaves user_access zero-initialized, but the device
> writes CQEs into the CQ buffer. Set IB_ACCESS_LOCAL_WRITE so the buffer
> is pinned writable, matching the device's write access.
>=20
> Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D2

