Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745303;
	b=N9RsdTb4NovWOlDzwwnGzMznUmp4A86OVgleCf4EKU037yGOToFtPd+i4cj1biwKUD1u
	 s/kFwpQyT+TVhZ5h7ficyM6J8AsfR8mHNlFvQDBq07FkHVVm4qrATr2A27BrfBcYi8I98
	 hDx38lQAjgVWLV++Khr7aybmEykSiqEf6RiPAYZUk/4zxVN1HMtbBh9Mxcvw9aDEXFdCa
	 6stnb92+E6QdU7CYzqMXwgBz0UvArjwRv+EMMr80eWqmTNxJuwSuJ6wF6NU4TmeYRh3B3
	 NSbZgj+wsE6m+QFxpky3UgeNc67jkTLlDAXCW8l9kCzIieuqUmxie6Ov/HG67xyYQsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745303;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nMxCuNsD4Xwa6jRI3SugOW4Mu2wa7yL33LPvp0i8Kds=;
	b=41X8X6+ZQo3AKoyhQ7ibCtQiLJdcYv1mmyCQU3s+KZCsDX1ZuXrMunRhEo20OdA61JSm
	 5sOG72lv+aHUaGgIf92MdaXpYjBFZD85AuryCBXehuYQu8WRTRhsTyrWidtNOCwd/uwXB
	 DIBGPAaHx9RtiltC5zqab1Skvovq9j2VsLHfK2jKAFXgEdPwCn+A6bdxmUXCBjm5aXrBw
	 163J8ArOPBxiX/xGZjzlr1G91ImHMcWJ0ScVSYhH1uvndYo4see+BtOtY3f9G9TOrSML4
	 HGop+WOml3AQajSD9I6vYBV2/iWyoNlD6HtBUxIZxKSM9l0091xX7H4MQ3BZ6hMoKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieX14UQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE8606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieX14UQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865F51F00919;
	Tue,  3 Nov 2026 22:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745302;
	bh=nMxCuNsD4Xwa6jRI3SugOW4Mu2wa7yL33LPvp0i8Kds=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ieX14UQVrm57+stWPKb/Tn146WAG2BXtNd70Nl0or26o2qXgB7kQcX6pKlN2Gc/Av
	 sFD6wurt6MnZM/2FAkEcoCK3oiuv6mYxjPQWFbr8V8FiZsCM7NiVgS3HnETDG8XZVJ
	 rDRFP4OXfTmeDdA+qQIqDKOoU6hPuwANY8n306kdpSneNNOW1+x4PKj7Vj/EMHBauC
	 JGHEQ3GipAr7neDpORe02NS+kLyHaMGsBFSa325uGf6m3MP1kqO7A/18/mHmVDEIJS
	 5/DwzfCcTohDimIWR+PUpfYi1BRHQGhDNEeJEwDJbK23DOASZ57x0pSsT3d/qMLav+
	 0T1cRDrEh+9Zg==
Message-ID: <sashiko-outbox-196135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 10/15] vfio/mlx5: Enable relaxed ordering
 on the live migration data mkey
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-11-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-11-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> As firmware guarantees that all device-issued data writes complete before
> posting of CQE, there is no need for strong ordering of memory accesses
> on the live migration data mkey.
> Enable relaxed ordering on the mkey via the mlx5_core RO setter.
>=20
> This allows better performance and supporting vfio live migration on HW
> that restricts memory registration with strict ordering.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D10

