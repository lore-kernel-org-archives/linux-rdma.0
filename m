Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810623;
	b=47Ohaa4pUmF5oU8HD9kFJ2MlRHtr2Zj57xWJSj9DjwwTTs5C56N3tSeLYbe7nkG77ztW
	 pZ9VUfk+5ryKM1EBdEmN8u3C51c2yuwR637qGy99xb+SIuy4YDX/nNE4VyyQ8fn7Ju0oq
	 hw35+ynxvAfxUhcLyH80fu7Om/okmWppL5LszztJKFNhUYDPyg9ZM3kWosTCX3so28tS1
	 f6gPby8PYOyL9xorkLU4vzeSiLtzHqw4ckEQF5wveLkbt3yL445WPty7Zv0+ayQfPJ5tp
	 H/4K2nQ+4BU2gIu9XYm7tWXE8/ERZQ39V28v3JGMDXp3yh2DLa7aC8OxmRIpsMjkF5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810623;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JSS1CkjRLQ+01pUt7bhPWWVkvG+1t1qhyZ6XfxPGKlY=;
	b=qInSrlAIIyAY+P8aRm7Vw6xXJVBmJIllRLKnfoXzUGDmK35ePCdWXQVVYoqvEAGtTOFA
	 mRaa4kEq+02dm+RD1iWZY/peWWpSTA+iIrZ0aPAgpU47TFM58ORVl3aq/xB7912dCLSl3
	 TbBqlKuWmuAe7ewFQGEN9fBRkCgLLeV2Xpg2zgYOoe8jzTNWSvJc0OsMLXlhPnvfpi0r1
	 KEIPGilUSjCUsgRMAxUG3HpNm86Ulw6KTPtMLUtkh+zpSEQX7KCACZac7u12welD1Swde
	 11Seln+87OJ66hB1eyvlx0eMx49/fUPL9HGSeeVxZ41hVSneWeRXdJyi+lo+BdpNGog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFmsUwxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB2606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFmsUwxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B361F000C1;
	Wed,  4 Nov 2026 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810623;
	bh=JSS1CkjRLQ+01pUt7bhPWWVkvG+1t1qhyZ6XfxPGKlY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cFmsUwxwU2V7xyIXWZtMpSZXe0P3I46E3MEkYblF185/oKYgrZ9HmArGScQlr9dpZ
	 sgUG7f+QhwkeyoXrYPnpsHACiZk7bLaBV2bcYj/gFilJD8e5sGjw5gmTJ2TWDNBHjr
	 a4yvDEWxEXuA+jOaC+h0z+Eb2igwlrIKvBtxdMT7deWMY2/xR8dBGIiOkgvR+LwB7M
	 xrHTT7iHCV/zeqjLmnfyyeaNZhzVqbv4lkH4ohL6o3HWho2fqFQRqthh7zlYCzGtXc
	 YxAi1XQHZJEuQhhQzYCPG003jbvNEkyDBhZeSe6DmG0UHBWRBWk2VIqeOr5Wof/wxk
	 QbmdOP4Cxhikw==
Message-ID: <sashiko-outbox-197657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 04/23] net/mlx5: Add macros for reading
 log-based caps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-5-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-5-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Add macros that can be used to exponentiate log based capabilities.
>=20
> When a capability can represent more than the used version (u32 , u64),
> value will be clamped to the largest representable power of two.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D4

