Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7813B14C6
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482085; cv=none; b=r2hmNVLpALsnCAOyBmEQ4xgFddvfLUaL9Top6pG1Nk0dvz3QgpXIRs0BWkylGvEWF/t9mkkofvRteosc5hCerPQnHKo7bGx+Jm3EwoQ9A7966WXeo1NsmCKrShEv8EyYheyrxs0I+jAp3cTOwvriE59tOX3pkDvVv4ZBmLIzUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482085; c=relaxed/simple;
	bh=/vHjXeuqYk9eQRldDmvoOzKW08Fe3mDJKM5NRNbZznw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RJxvtPakhptOB9jg/W2dPdC45WQ06zuGZqfTirh08IXg+yniIx4wXLovn/BSFuxL3EZ9+zJc0ZlpRkPdWt2pkDjWadybA8MwM+zzkT07hlmVR42g+ADkRNn9BJEDzvufABTcP79T1t9yxUf6M3aCqH7aKiuIDE6AsvofbT1NPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxujOBpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxujOBpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C2F1F000FF;
	Tue, 15 Sep 2026 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482080;
	bh=/vHjXeuqYk9eQRldDmvoOzKW08Fe3mDJKM5NRNbZznw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oxujOBpbHwP0WA5pzRY890RCxlF16IwNiorV2+rvvmephjy7NXqjySIz6KmZlhpwP
	 JbCMFWibbwxqWJ5pCCyNt9tvFt7gZ+x7+VZigZRLPcOenUFfAadHa4dJTQs314l0oX
	 axni9q3int7majixcwxxHJV8NnLAKHv4PeRIUgpmc4xDq9G2ujeYke8XB3SQqchTJF
	 XLR5Z9bjPzSEpFLHjNRcg4NRIE0g+dXlccoTaP3gjKR4ouz2UBJ2XGbTR3NGktDO5R
	 NVSPqcW2hXd+cL9G/92yhDA2zjcP7cwixozn3KmyExO6duIyhkIfIpsV9BCiyZmmbc
	 TaRX/rvPUBtFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 05/15] RDMA/umem: Support an explicit DMA
 direction other than DMA_BIDIRECTIONAL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-6-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-6-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:21:20 +0000
Message-Id: <20260915142120.89C2F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add a dma_dir field to struct ib_umem to record the direction chosen at
> map time and reuse it at unmap. Thread an explicit dma_data_direction
> parameter through the internal pinning helpers so each caller can supply
> the direction that matches the device's actual access pattern.
>=20
> All existing callers still pass DMA_BIDIRECTIONAL, so this is a pure
> mechanism addition with no behavioural change.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D5

