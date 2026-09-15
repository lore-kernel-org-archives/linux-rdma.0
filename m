Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EE83A9018
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482124; cv=none; b=CC7MHASgvmByygpnfQ85N/Zr2wL0i/+iDsEDy8guFmq5jA1Q8Ew3sg/UR9wchtO+ZsK280A2rnSYkzue8NVdEDvkED1H69iX6QvOYTSn8GJu4SXUxtWMok03/5bIIt+c1Ald+upzpJnWIkIyV984S5yWd38+3ATDIBBo9jl9NBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482124; c=relaxed/simple;
	bh=Ag9NbkRWMRNgz10qH8JmgSZJ097vChSoswN46RYoaGk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oarUhb5NmXo8pcz1oGXOm2bdyAkBZdlt+wUnU8veNvY4jXf14VHozfAvdB2npTifegbJr31RZefVES42JGKs1UAdFCFPBahs8RPe7TdgX7ZeKcLBXN+3ywZ2PaWp/LLLYpNCnWcDDE8OQk2ccf+//0OK8w7L+jE6ZnVOteQBiyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikjtjWlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikjtjWlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859A91F000FF;
	Tue, 15 Sep 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482122;
	bh=Ag9NbkRWMRNgz10qH8JmgSZJ097vChSoswN46RYoaGk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ikjtjWlFBgTjbTp/Onnwlx/Ujcl3chiQu1EKf8x9OprsjmB70HNLCaI9awQL7q++z
	 zieaNy6s9hf1xcS6QYGQehiZbWRQ758gvgX5aZh2T1LcqS6rogYeW2ln58b7MBmrTG
	 pVnvlEcMkUIBNxBAlWDG557366wJMUVwXFiGJrd1vOZQGYI8IjsCw+XWmbvY/2nxYK
	 O2oXim+tinHikaW4kXbwEomEhReUuOa7C6/djd9JucAKmG6nSweukpM77ehYPOQBUz
	 8XftWOf4htKALsgy7I5+n47+DGl+HFLxPCH23fydNUpMBJdc9XCdyEqQT8Xb7SRUGo
	 /ppoGrG3A0tXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 01/15] RDMA/erdma: Pin CQ buffer writable
 to match device DMA write access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-2-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:22:02 +0000
Message-Id: <20260915142202.859A91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> erdma_init_user_cq() pins the CQ ring with access=3D0, but the device
> writes CQEs into it. Pass IB_ACCESS_LOCAL_WRITE so the buffer is pinned
> writable and marked dirty on unpin.
>=20
> Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D1

