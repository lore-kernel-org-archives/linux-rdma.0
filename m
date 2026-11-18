Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022034;
	b=kuuUs/ovdoJhh+TGQrvd8LSaCUYDdDyoDsYR0dkISR/AJiKJPm6OIeJbYZXSxzkNfCM3
	 X8UsjJ2tW68mrfnW25kkRJIYk9SuoWXkD9jRvJ8iMp84VXeYizAlG5Gln4xCMnukatvzk
	 fRG2Dd6hGP7P25Yv8rJlvxBvmLL+t/Pwqx64bCbXISHwNiUyqTifaDOUK04xQ4Su7fiY7
	 iarrRLvc6g6AIFwtvBaRu1eaAlDZrCvBKXLfTgRvfXEquzYxjP+n985cWMtILXTQlFwe8
	 7C6CtNEcqHZfSgsQ1Oe74QNv88VasTG6zQvjEFzW8eCyDVWPHLo+Ux9MJdkkD7z7zTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022034;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Mj4LE4iseRi79AplVj2z2bhiUzv8/BARCad6M7TDFj4=;
	b=M2XGJQ8cgOpZ/zF0goinU8vKH8auy0VSVn5hTtwpBF68u0/wFGLIOolYx+M1ddXUxIG6
	 FbHjjd9e+qboYwGF4C3nNXpTWLygxrbI+fMXsQaL+lbBGJyQZG6Hu/8o3xIGlVPirW/eA
	 JV1MFzTne7ZSot0r+5cDnVKHWM9SN35qIV0AvcGedoTEbFL7WYgRRg24QOmfh5svFQ+pe
	 awO+7YftiUMPe1OxHkjhbTjGlNlJdoX+cnHxxmiILDv2cQv8TWxumdgZIS8zIFvOuv3iN
	 jIshercofZYY7AGBTxxQHKUvRahMJJK9Uz1Rm6WRpISufDa1oNsSTiokmqd1LCiworw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2Y5xVwM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA674606A32F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2Y5xVwM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1261F000C6;
	Wed, 18 Nov 2026 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022034;
	bh=Mj4LE4iseRi79AplVj2z2bhiUzv8/BARCad6M7TDFj4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q2Y5xVwMMLaxmSgTlqXrPgFIymqpFBTyLH6ftFBi/OlbVNxpzB5rMh8cAzP/D3dQV
	 g5qxhIdc1j69hwYxI4LMp1Olr+ZLJojWhb7ti3/9itg0dcjwftYPUemrmQup15Jpt0
	 9sCimLBuWjSjUwydMzgH9M4LUO+Dp0H8hU2r5YOYyu4Ep8tz87MetayRTUXkb6nNBb
	 riIITegFyJL75WVq6pP9IaUnkynSDUbCNF2y0KpD9CFioxbppVQHW214vjVg9kQq50
	 MbbK01fYa+cfid3VBKH9hSTpYYrbwWDrqM/eXYocM0jyRWIAtfpHHSaTEoPqTavgNd
	 AmH78vdGmcJPg==
Message-ID: <sashiko-outbox-221622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-22-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:54 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D21

