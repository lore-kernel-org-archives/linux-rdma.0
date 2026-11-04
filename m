Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810635;
	b=Fnm3unzzBSUJVDW9WvHHPp0q/wiR4adJN2uvlvYjrWA4/khjOTcnkoF75v+OK/XaKbSO
	 eHO6R7bPED+ndYOgmvtidZPNRyVPeuoAjc1E7rfblYJ/kVkaHlwI3hbDsnUQLCF6AQO5p
	 IhgdK3layHY8MbwVc1xvvMWwRVG4SrRBbGdXoDoNkCunONB/Q6cnpT6Mzuf1yzFgPi1/9
	 NQJUuf26buh6wq77GW4CcCG20lT40IlaB9bVH7p9wrfEyMjXMKCO49SEdLTh+116Y/mLS
	 hitxE9WF+gvuQReB8YoFNr5RARha1CHsO9yqbPtlIREQGOenXuKJPPQkD9mfaOvLezQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810635;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1NZHiWfD12G3l/17QCq73OPOiQD+dwW8yyM7hootoCU=;
	b=n+whzFVId2GWa9PrfSAtIGLGs2yWTzmGa1s+Ovds8jp7dB/HG/21KQC/8ohBzrcAZTQ6
	 /ACJX4cR4h3pNgIllzG02SIt6HZ/UKcEyDIddKDS+VAwVIOdq2F5JOKlUdZL0WSLTxHMR
	 iXNfYcpIqeneG5nIHojWcrz6I4aEIIs5jiMy+5c5kV3QEPmbns19kfnbwutATMxWHOU7Z
	 MlYrfAyLsXr8p0CpEqFhf5wUOalGUi+Do6DnnAGdaUY1UaHYqw2fH9mR3RPjtc1y5i7+Q
	 UL4tUXeVPEk/vEfthfMz9XvTG6VD8mRNJjuVTdlVUUDRQ/fOwkKOQBFe8jy+C1noxLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3J38jfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C995F606D812
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3J38jfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1641F00919;
	Wed,  4 Nov 2026 16:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810634;
	bh=1NZHiWfD12G3l/17QCq73OPOiQD+dwW8yyM7hootoCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h3J38jfQq+psSLjD8x+jTpZQEFpoGt/NfcbLSOjEf7yKiW3m2SmxcoNfUe8WCzEb6
	 ZTCcZqWii+NXblNd/k0aQ4FWSJV1v11v3CmVUBALt3pydJpnorwoekmM4VCj1jV5fw
	 AoYmuJy4V6DB829pyV1fINMFYRDLE5pNCUje9LkBp/wf0zc1jIbSxKm0ZGbdPwKVzC
	 DD/gazQUMIY0SVjqWweGOf3jwU6dd3ShAZCsefAvIiUB2hbMRBn3cCnKPrlf4mUUYl
	 zSht6uw8rx5+mhhuWvdOkpuCeg3B+nxxBREi1jDXTosgsZr0aftgcAVHW1wJxPkwtG
	 qYqOF7gfJZAsg==
Message-ID: <sashiko-outbox-197675@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 22/23] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-23-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-23-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:53 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D22

