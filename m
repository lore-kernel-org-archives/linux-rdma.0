Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827259;
	b=ADLxRuxOU4rItB1qps9Pl3Yd8meCHnrtXOKjmBoSYFU85a1/P7zK2b2O6g8Vos3AM1SL
	 OQjlKa4x7y0ewCjIKaOD5AQ5ksBvj9eUAr9fnOpQGhFzPCyZYAbXZPoNtoetXgWw3O0V7
	 GGmqexNriyKyPgMD0foIwsQW6mdLkj67S/FoXenjndLGbVQvWnY6LTvlfftOJap3oj6UW
	 HDMD43YRNmAPv+kD5Nf97KFBJSkwcAbdzi7p9jn5beroJpA1XyOlANKbzIWENyRt7UZ5L
	 LH28l6Ya7jk5/tiJ9UDTFcFINL7D5Y41dPwyeP94bFcoY+VkABaNk1JBNL076LUQf/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827259;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kwitrNdFbfhNJpXMZdl5Rp26lGP2UXlq6YGLbdGceV0=;
	b=WgvAjeByv1C8QZDB0gc0HQ8jvg8aZ66vhNdyqvKAnUDq/3/wF+wjmH2r6ytlauKmxWPq
	 Ok6Ydjq8aJ1o8IwjwetjmXtRypgfyMejNk9+M5zJ/FCjzvBYl9Ntc4C5QbPsIC8ll9yYy
	 CE8iPNY1G+cyHz6ycs55GWY84Ek+oub5pFszYP0e1b3rC3OQgD2YcHz0YZ6zmPtFdX3tF
	 1YS+XCT0bZdtAdfCp55H0d0uZAexsmeG89hiMTO1lZrx+jBbPNEBS1jr3kFcaCG8PNZxR
	 yQwQf34il7AyBpoHpe7XvGtm6wpQUrBjYRmzBcSuvK7SYvSGVQxRdjxABciw06W1Iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7OFhBHl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1BC606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7OFhBHl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8821F01825;
	Sat, 24 Oct 2026 07:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827258;
	bh=kwitrNdFbfhNJpXMZdl5Rp26lGP2UXlq6YGLbdGceV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d7OFhBHln6xH7w0/uDoXrcx9qFvfeDPDkObgVPDnwnetM2U/cU4bcgR44WTQqSbGm
	 irr2I6q93+CqEpyzu7gGh9DVJW0q7ucMiFKl1uyEgQC3hOhx6ifJzI+NIr7en7bY2t
	 ffVqWX7LKM5xFhd0Ny2Xpg3MD+XaFj5UvQe0aWFLngjszdgv3AmfPCeSyD5ruM92lG
	 OM7Ty1twkiA0I6SVV79+YZQ2pxDQKaXCJhsVR+RIqYCcABSSTYxlB/DpOysLtANzwG
	 +qtNvPjtTvC16Ck8yF5JSpOBJF2Ft/I3y1VY0sYP9L/z4MXpgQQnfKvz6QSdhsXaMd
	 Bdw7eTIpbPMGQ==
Message-ID: <sashiko-outbox-183586@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] RDMA/zrdma: Add build infrastructure and module
 skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-2-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-2-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:34:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add MAINTAINERS entry, Kconfig, and Makefile entries for the ZTE DingHai
> RDMA driver. Include a minimal module skeleton with auxiliary driver
> registration structure to ensure the build system works and the module
> can be loaded.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D1

