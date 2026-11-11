Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422437;
	b=OU0F2AwvTNP6XEtIjAyxgdMuRLGLS5uxiFPSm7wOCRdpoy1KVphk2F4msRvhbZUc9iBp
	 CqaSyI9dFCc8+C4gnwfzu1EAg77ZxwM7T+EnJFUAaGuns4UhEGhG9Fu/OcJr1Le6Xf8Wo
	 T2R7vDwmSlNq9GuyQNYvBRbQE0Jdmx1yQYcZQI/VN5ivNuBU3W2iUhHX3DqP0IM+llXpT
	 cdhCylAFFHNWmZzCao5y3UGEYSoU5v9Zq4AwojES6fysivSVo4iNO9pnVxRqMMm+reQsA
	 L22ORlTY+K+D54d9EsMhBsn4kIbtKNUsDdNTZiGqAW7zJBl1u0rVaQk9Kk4SuT1mdnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422437;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J+vAYwwq/7TtTHT3JKE67R2qU4p593sDAzoUsykHYk4=;
	b=mAgTcSIZQX1fCtgRo9Cz4F/zDIVBT5dJRYGgr+J3WUW5r3lc7msuP/kzGpcwhXv7Mp/U
	 BMtImarj8TaojtsSKFCjIKtQYfPstI3aLZjuLTQQhprsFq/nv0BgzpjGS5e++F1EpdaEP
	 mqI2U994rtdXjWKdtaDk3oCBDf6eapXipjpoBnJDWNBvQtQS6uBWE4uJKI/76ZzicKi2R
	 Q1ickkPDuHnHVH5Pd4hvtWOg8vJqEQtrE8Oc/KOeZeRkzcNICPbeeKH2qNMSLMCXkevx5
	 7xg2HrkdTMu2K0goIBq1Nu7Jzuw39u0VPw03ziJ9vow0/FN0go/dqo/Ji1dQ+0e2/Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J92q+Sks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0491606A33D
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J92q+Sks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707B91F00A05;
	Wed, 11 Nov 2026 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422437;
	bh=J+vAYwwq/7TtTHT3JKE67R2qU4p593sDAzoUsykHYk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J92q+Sks+7Tyt2gd2kJ8AgfhmVcnUqZwjnqNcTfW1ohrBvTlbpS3L3GYiFf9T9wTk
	 0nqqLeKOzbCgi6NA9Ck36dAV8rGxjn1RgQ0vePPEL6z1/Lxpu8OBylfAxDRPQ6Eqfs
	 BjAJ3a5iusSUZLG2RnohpHokRE8UcnXWU7XE2kmOgpNo0Bkc59DISP1qf+mr0ZL1jB
	 UHRCUjVGV1Z50ajK8Wp6sclmn+Z4Z4GNsYCR8jM3Jo2IxKKh6Po0WViI00n5tSEaGt
	 JAdnV/DBnHDUSZJ4k7qHfZ12KlAUG45QYB08nIFDAYMiKiAmurSH0dmq5OKAQq/69g
	 8ARqhn/P0l8vQ==
Message-ID: <sashiko-outbox-209478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-11-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-11-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:37 +0000
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
> Currently there is no way to check whether a dmabuf is bound on a TX
> queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
> of it.
>=20
> To help with that, add a helper to check whether a devmem dmabuf
> binding may still be in use on a given netdev, optionally filtered by
> the DMA device the dmabuf was mapped against.
>=20
> A binding can outlive the user's unbind: it can still be referenced by
> in-flight TX skbs, whose DMA mappings are only valid for the device the
> dmabuf was attached to. Reporting such a binding as gone would let a
> driver swap the DMA device out from under those skbs. Bindings stay in
> the bindings xarray until they are freed, so walk it and report every
> binding of the netdev that is still mapped. Bindings that were already
> unmapped are not reported.
>=20
> This API is necessary for the upcoming support of data direct in mlx5e.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D10

