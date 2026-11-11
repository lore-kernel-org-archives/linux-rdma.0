Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404819;
	b=yEgwDIb2TNU4h9TwGy1ye9aJviywMgtL4P1SVufQ0DULLvRI0O0nSfHxxK0Anu0E8rlU
	 OGdV3l1a6hB/CjuuqsLRnj9nfvi0thcm6fHSiUL/lG9HVP3qLk8JPQwkAT2GKdWpypV3l
	 +0c3LJTsY90Yo6tslb5TV8SORjuWyHqZYklgEP0oB6cVZezYk31UIbBWZM8/gXRccwx5W
	 bGNhWZ36eoIR+SVdog7GAdMxk21XB3XSocVlkpHmc+uUjDoRWwpEulHyfxx5WFEP/PwU8
	 61wytMyQ+MibijMzr52sVCozWAJ4ozA9/ww430qCrEBLam7eMYNWSR6101VzwqPhB2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404819;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/TjMoVCQnU+rwVUAt1wJYbW+ozDQ3kTx7mCKjia9rO0=;
	b=HWgG2pHl6dn5O3sPyC/6WE1HFSYMhbHQA9O4uPNEbcLDntZrk1CzKKNAfJmlDjB6C7Ep
	 LAEX59y2fxH/erqc4Nd5KfuYbetEh1sQyDksfZ+s1hlnJmzKXE1dcjAuiEkiLDQbmeo0l
	 kAdcUY5ifQyCc5psF8Zg1CDdJPZHA797Osz2ZHFpskj2K2+vntDjgzL3i7egHRSzpKRX8
	 3lQE2i/uUnsUPZXE4jiDP3515feDTEPKUMCryMnqGYTKQeChWgEkztdoOYX+FlBcbgLFY
	 jwQ44gPUAXeFqzlpHAUQW8eSBObGvJcZvBt1blkdgYN9kv9lhUblc4qeUk71KRwwZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xn86ivn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A2E606A89A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xn86ivn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052861F00A06;
	Wed, 11 Nov 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404819;
	bh=/TjMoVCQnU+rwVUAt1wJYbW+ozDQ3kTx7mCKjia9rO0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xn86ivn90+FkL/KoMsQ0FhszbLPunTPKB00jKJ4Zt3nmpSRdP8KtsfWsuL0OWZIPK
	 vyoaLYlWmjKyPYYH7CxY2xEBVciTT6GJpNSbtTE1mlCskkBlcIu2AsGJ1Aef03m1fe
	 MQCygKKApAutS0PU1qSB18jHzB+R3FgT4vzfXKJ3ntMThZRvG5HZ9H8vOFc7PibdSb
	 Cdgm7Tl4T1cg6tMsC8ETB67mgvOkV9WOtCRI7KvfFnvgnWXF/TRH6PDE1/oYBFWYX0
	 uSRq0dfMTi4G921MT+bQCfLMtM+w/en2aG50w8JenlJc//wi3OupxV21br/+NJepc7
	 ZFw3Fn2tkw7gA==
Message-ID: <sashiko-outbox-209108@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 23/24] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-24-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-24-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Userspace must know when a device is in adversarial mode, and an
> unaware rdma-core must not get a context on such a device, as it
> doesn't harden itself against the NIC.
>=20
> Report the mode with IB_UVERBS_CORE_SUPPORT_ADVERSARIAL in the
> core_support of GET_CONTEXT and QUERY_CONTEXT. Add an optional
> UVERBS_ATTR_GET_CONTEXT_FLAGS input, where userspace declares
> UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED. In adversarial
> mode, GET_CONTEXT without that flag fails with -EPERM, and so does the
> legacy write() GET_CONTEXT, which has no way to pass it.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D23

