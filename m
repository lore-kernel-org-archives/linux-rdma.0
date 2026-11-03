Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745304;
	b=vAJbiaNb/X/TiyYvo/pwQ3V7Jtn+YE1KHRR7IlBSsDU9BGg/XKUccRIftU4XovoGpJZK
	 iEq0nhTffQb1eqKIbyQhcEFZ2SOgh+UbilhzaKA1S4+rE4IqlOKz759fB/kyWbyxnG8vY
	 qntargwFwWyszyj/yZT7LUGA3qQ290yBLzr7sBvaQFFfTv6kMRu2nfRfKDhU3+lxUAL8S
	 qERQ7a+GQ7XacPwUFHMmJ4DIYT1guEin76ttWvZFsYmYuElRr/vqyPZzLj6ZY4D4gp7U4
	 MXj3CEX3ofaihQss89aZw3I7/AUJyKx3TlI/uP83XJkqBBi7IXf+HWu99/wM9vOMzwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745304;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5Azq7Lycc1U9gm0StXIJm64sszExgnDEd9Y7QyGS7jA=;
	b=qscehMWtPZcovVjwh9UAVD5ctLxBMf7RAJoxSHtf4AS7P6Zy7S2SHK95LqAE6XhTp9kO
	 hXy3gRQzo+OR3obZZv1fOeUl4KurBuPYQDF4+re+cF4Fidwm+PQNWLnrORQdQXsoFEwir
	 ZE1dFysngnHAmeopN1gZnAOu3k30mUsxZeEs6vLVIjGxtWeebluFHJT73oAH9e8/1mwm8
	 5nqo29kRag3tbXf4IUdENMljQGufGY6XlkLN5my3u2grVilRnx/yUtI6Wz0nPCaQPUb0p
	 IMy9RHFBh/sS0xUKgWUix8oLBNIIrLoCBhYU5pj+drhVV3cUNK8jQ0zkhOVTNwlFtfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmPS6qig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E154606A328
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmPS6qig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48991F00919;
	Tue,  3 Nov 2026 22:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745304;
	bh=5Azq7Lycc1U9gm0StXIJm64sszExgnDEd9Y7QyGS7jA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BmPS6qig1jjEdUwASaoyBup05GKUPOfPQwj8sxczHBMbj+pS647nW6oEyK2xjK3s1
	 ymS+SB9YnubT/TorViiOicdaHBopo0tBGrgS5FiPAjmqM9tRBq3wEJeQ6tmkhgrtnA
	 Np/7YL/diL2Bym7lzH6QPOD1blFuZyPFfC74Om4JaiQVbyhwJGGYLz62i/+bkvBnh9
	 UjIY4Ns1RRNaZHqh4qX3DhqF4HrFoTTvoZKq1qJvvbCnPjMO3Ldv+XdV/T686arbnf
	 hqL8x+JZVvYGEDrEXo2B4ShUZ2r+whw33sNsPmxJn1nngSoMW2hT50BSTudRhfalbV
	 6yJh7UDpsR7Qw==
Message-ID: <sashiko-outbox-196137@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 12/15] RDMA/mlx5: Converge UMR access-flag
 cap checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-13-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-13-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Move the UMR cap check from both MR registration and UMR paths to a
> single helper checking the access flags non-modifiable by UMR.
>=20
> No behavior change for the current flag set.
> Converge to prevent code duplication when adding support to new access
> flags that are not modifiable by UMR, like the new Unordered access flag
> added in following patches.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D12

