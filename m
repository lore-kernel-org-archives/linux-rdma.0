Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001736;
	b=MQsf653RowmMsHCrnbqI1hG+Xhq8+E4iiWHvCmESYYO115uhEdQh2VsZ+rJ805fxLx4W
	 vX+gNJ/3G9hwO34y3XGOKeDdf0PhVqliEoJEpLB6BecMD01IQsK9+17fm9eCv6QzPKbNA
	 RR+V1DWMPv+BQZFuJkn2JSCd+gIfUG8tQwmOFn1RFF/7MIVZ7SXAiMyuI+4vH20pxv9T3
	 OLnqDk07mMT9T7hoTLPLLGJSRCGxtK8do/aaYCFoqIVY1qZf2vlERyYRk1rryENN2Ro0B
	 JzL47EchNJpFnU3b99WKmtRIf9821bHlqUHI54E2m0GEXGYGQv0u4yGu6wp3N8wxsyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001736;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5qGd4rcgQDpT/WcyvFPbTS/5MYaQsNoPi7Ar4mpQJ7Y=;
	b=nFI6Ldjt8EeOvfuHJ3N2v2Cu5003M7vZILM+Dp53x4AKUnKEg4RqwLUdUliOzlhDJsed
	 KJE+abdFPovw6lSGHX5FcuJgCeFmLfD6d4OZbjsLMPej2JOxyY6zgeNgvUPrsPQIyZltO
	 yt5rn5biRnIYrzVbPPL3iRT5lo1mWVvgyORajLzI8/T71LhuRdn1IlqysN8+90l3KAipy
	 +vod4TDyW9Ra/Trmxu2D419BOTZmSTC42S1vlwCYcRWtf5e5V7c/YrNataR3nScDzBOa5
	 3PNrF08AX16D0oA+nXRweGhRVY/ZOk1NXRHtrEnKn5sddGFtyru7fI7Jd5mK/9fwykA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C5RxnvUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10908606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C5RxnvUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9146C1F01825;
	Mon, 26 Oct 2026 08:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793001735;
	bh=5qGd4rcgQDpT/WcyvFPbTS/5MYaQsNoPi7Ar4mpQJ7Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C5RxnvUpZNERPxxXCSNJGX/qXCchgwgXb71IUBxqwQIgtF+MKybxbRuCY7fbvGBvw
	 7xeYTdwF43HQTBa/bYFcm0nKrN8p2yH/fD9xpVgan0xMSeucRZrBKOnGlhCST9aKSC
	 MXZWc+12PHr1cifzjKUE46tszkr+kY8JNqiEcer8NHIVCu5gtcrZ8+ef0TZMcJUTzb
	 ayNpEFdsuUgsdYMdvpFYARNnmEHFj28IMO2qdtU8cN1HnsoKnsW4m+PvMXG02afGEJ
	 wUkgYqTDyH8Jg04CJt0SytNd/dCx+t3x+wAyxCp17Oy4BQN2XMh1vxVk3/0AkzGLC6
	 c+iJLwR0wGa1w==
Message-ID: <sashiko-outbox-184669@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/26] drm: Check the SGT ops for drm_gem_map_dma_buf()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-10-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-10-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 08:02:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> When the next patch converts exporters to use SGT natively, the
> dma_buf->ops->map_dma_buf will become NULL. Additionally check
> sgt_exp_ops to see the new location.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D9

