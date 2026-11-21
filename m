Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240730;
	b=SvqFdzAtRRwYp5L/gY20uy4nJ0jRrZrXys8wAlqa0IwrKIL0qEvuCyZ6NICFFghid4GL
	 +Icrf2+Ktjr2ztDfExcGMiewBBZs2xRFNBLApDrKxqQPudxiZi13UkFZx984ZyUa3DQsJ
	 VJ0ZzglZHFmTYctAsdwaZ2815BwT+3luEDciPRwzh9su7Hf5h3fPX3F/b3mqBzUZrYuMS
	 b3VaVJTjqmRr7KLuyhHO/RZI7FDrWiAFkTxqDkr1JPPYE7EJnOCQwXMysb59i5j4isdmu
	 le1+n+T+hnyM5c7t8HByE553074xpS9alLTpXewOgSunpIOvOIk3/+0I8WIgDGtszWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240730;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O/nriTbEAAgljY8FrUNoGSSOWBaQEPbyChVUrcMooJc=;
	b=jhGpIkjAgq1FKvFwOdV8tFbHuK2PRQLnqqRArK1AMLhKH7rPFgfdTuqfXwZ2g+VoMAN3
	 XnMGTpAz+wkMosbj+l+UziUA3o5KtxOQp4nwfSI5x0mXtux8LaqZ8bl+UY6TW8TzEuFh9
	 BmIawEwb5bfMau+xxUYy44d11lKp2elB99Yxg/Zzm1BF7vuIHlI6pyktjy7OylzB1sDC8
	 ZIynz6LxSX8mqH8IWlTT3MJaVKtJaKjsdKVJ7JOFApHGzjs79r38gHa2dSg8XeSdOCepi
	 bFyEQxPCo+Q2LbiOQauS0DoxEMTKJJhiR+BVRCTB0Jb2ao8trdlaldmWcqTzlCMxfmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDnP7LRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F6606A331
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 05:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDnP7LRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166491F000C4;
	Sat, 21 Nov 2026 05:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795240730;
	bh=O/nriTbEAAgljY8FrUNoGSSOWBaQEPbyChVUrcMooJc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RDnP7LRIDKGpA/hvELqB9opSfuvOKVFvVq/ymEjozizzBHyZa0iOwtylR6fgz2pR6
	 OMMQNmmjxNmCxzzjg9Uu6yvRKvslrkquu19XntO58/Yh+DOj7Er/h9s3PzyZv5Kx08
	 uTnuhH4GbMXVJ477X/ilBs91pzJo/mQ0zwjgZh7O64Tmt7ZbaoMHU9C7ORoOXSQLeY
	 fGyMepSD8tACV7LJqqASQlcR9l4n10JpNmjms39+jb+5u9QZkUP+0harP+q22Z/w7l
	 p/ZI77VWw9LpM6hVoUBHdvDFUbB34GQvgziM6rbSKZWr/63qF6tXQ98PJz4y2Maa/k
	 8dCNKokR3aTuw==
Message-ID: <sashiko-outbox-226693@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 00/24] DMA-buf mapping types
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 05:58:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 24-patch series:

- Patches 1-12 and 14-22: no issues found.
- Patch 13 ("udmabuf: Convert to the SGT mapping type"): 1 potential
  issue (1 High)
- Patch 23 ("dma-buf: Add dma_buf_mapping_map() returning a type-..."):
  1 potential issue (1 Low)
- Patch 24 ("dma-buf: Add kunit tests for mapping type selection"): 3
  potential issues (1 High, 2 Low)

Detailed reviews have been sent as separate replies to patches 13, 23,
and 24.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-dma_mappin=
g_type_v4-v3-0-c0183a409bdf@nvidia.com
