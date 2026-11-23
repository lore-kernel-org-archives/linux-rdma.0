Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406978;
	b=J7ekgeN1y9VYyotIgpi955xa0TZG7WigfWu0HmQvmKjMzoBOs0Gw1Bcj38CmwReQXiDv
	 Lks1SLLcQUEd6iiLngjtgEpDIKFWd5jozPkpn/4zvrJt9u0wpTOrglCIYytlx0VLw55/4
	 lSwnw1B4q7BbEhm6kN39ncljA73c6GfovnHijru7uAc8PQIt0YcyiC7kZTzvpwY8XzKYh
	 KU4pFSWeFnW3mbpCDgkEpzTaDYq51Og/x/d1lLmsdsDouL65Qmr3xQxX6CZAzl5G5vRBz
	 dNAuUA12G4BPNY0L2OK7fqyTq7c8mHFKpesGWuX1tc1gX6tLAIv284ZslUvu2iEKWYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T6HXFlH6g6GOuCYHufAjNVuDUEc86NKGBCs2RnZtJ8U=;
	b=mA7EpVM4U42hQIa9oPQlIXiOnK283r+KcN5nfJ4PPFnFlqDbwdBPHjfxWP6b24v7PWHa
	 wF1/dTBXOBIXNX5OK+Oa0aS7XYsCzE3AFSCAfc0E236l7rGPeKX/tjDjH6zwIu/P8ErT5
	 17n4seUK8J/kFY+9UPzxrJwLmwUdi482Y5YYuxSx6NEYSUAljxMP7xkBhrajFljlZS/kS
	 6OUB3iEUF1KZbROj3oXzlu38KzJ06NNaZRlEIYqaEXfXXygP8l+iMVTAr2NOz0BmRhug6
	 heItjyMhSx5jP+dS9xzQogtjBBdINYZ/5memf/m+xvtBaEqKB0wqYZll6oZR0jArhBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tuxhuoln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874E2606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 04:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tuxhuoln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED41D1F000CA;
	Mon, 23 Nov 2026 04:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406978;
	bh=T6HXFlH6g6GOuCYHufAjNVuDUEc86NKGBCs2RnZtJ8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TuxhuolnexfyJG88bt6G+7KaScnbmCasAFHDDcGOZop/VC6uvahIWCOq/KGpPBOZ/
	 PuNa6leBFV72HZ0ei/9oZyQL8HepG+r0rElKbb0OXrXDEP3ZuFA4ZAa2EMqMCDom9D
	 31q7mVOINlqTk99Z3GninoaX5k0suQxPxMUa2QVsCz3PUBMr+oBQ2j7XhFQlFlN2m0
	 kpUGrap8AhWkr/2YVdN0KJMCZ6YZMfWttcbV0OmTT3BS7bSQyybaR8H0/00GlBr3bW
	 mBwjzLbmTw2WqFgpZOPUQrRiIBdirQq0925U5AZObCkGcvZbwr39CfLG6lfSn1dyay
	 IEmQsxPqWHKZA==
Message-ID: <sashiko-outbox-228650@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] infiniband: cxgb4: Add cleanup on failure path in
 c4iw_init_module()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wanhui Fu" <fuwh1120@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123040458.1880180-1-fuwh1120@163.com>
References: <20261123040458.1880180-1-fuwh1120@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:09:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add c4iw_cm_term() and debugfs_remove_recursive() if reg_workq is
> not allocated successfully to release memory.
>=20
> Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking =
warning")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123040458.1880=
180-1-fuwh1120@163.com?part=3D1
