Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911809;
	b=vT6Ye2FNm9NeqgTuK0Eg6rqoHGOAlgTQF0ogmTmQy2KvV4CXTEB+ODBhu+i/FqfSaSsT
	 HEqPfCL4bffq4aHDoUExvuMgxLchizr6Elb+lMQOj0MSIODd5FEAoXnt4XWVTM3nzUhd+
	 c+A0BM7FmQxNrr6fIy2MaKmThMv5IKE3ynIv+ZsXAxsYtYaME1dF2zIN1NKOL7iCd67yW
	 XW5ht2jHqatZAWRKX73DlhXRamY58e+k+FR4CmgaCs3yGVqpu4F8szYojdhVtup003hQ5
	 0dkhNFVX+EW4Se6I6OkxwXYKpgml994MQoE3hDwWnT5vrY0Tfn2iVox34ehMTxCXHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iBnuApGa0H/kamaREAuOazDIpUug8u3UAV10ktYG6V8=;
	b=YyX2+mm5ueTJKwWF+qTnG7nmtQZBvTZHYmLUXbeWXcEe/XbqXyfgMoQGHtRs9SYliCAS
	 sXUWlSG56czXPrD0D6kMYKisxqqKl5iIdzHuwPka8UKuxx4sWkbh7WXumBSVLcxU+orEN
	 mS3Ff1MwHPvnGFhvvHgRgQTQNLRb/dWmTQUihCzIO6xzLqMCAMpQMi/RA4kjMhzKnd2qc
	 8oO9VNeqDcZPiNPOO6j3XTvNovRm9gTdGBYZXlInQoOmxQFOzmg+M92A9JT0VkIUq0VhE
	 wYbOJzUpKkmd+0SB6QYUxKEodbDh4nnpilWzJwexpoCLSIr9qp3PEOiYkCaQXzcfMkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBa73N1o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936C6606A88E
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBa73N1o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7FD1F000C8;
	Tue, 17 Nov 2026 10:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911809;
	bh=iBnuApGa0H/kamaREAuOazDIpUug8u3UAV10ktYG6V8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aBa73N1oWf1XbP7PlyoQx6X62GS41hyVtEUM8UYG9toAiKKhkehsxPRIObSFVFeVG
	 SiOubSi2ldsoSPcekkRJMo/XXwDoS4d9MJKQ+2TVvwyW9sA7PRVVnoCNumsNPeA5Ze
	 vOyi4flJ7R5o/okbvZrIjcLIje6uRocNnEakbEP8xzbXsTHDI6UwtqgJ668EChXTwY
	 Rsgdq6Jks4/Mh/xi93i1nmiJ2lpm1+DGvTSwsKrSJhNaVRpeOA6m5d4bT/tQfzp0MY
	 8noiT494rpo3Te5y3z9cpDeqcG3Fh9/xbH0p/YuKPN3ep58H3gIh/d1WNow6Ywo+Af
	 Yd16IivqEAd3g==
Message-ID: <sashiko-outbox-218636@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 08/10] net/mlx5: LAG: replace fixed
 MLX5_MAX_PORTS arrays with dynamic allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-9-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> Converts two fixed-size arrays sized to MLX5_MAX_PORTS into
> dynamically allocated pointers:
>=20
> - lag_mpesw.pf_metadata in mpesw.c/mpesw.h, sized by ldev->max_fns
> - mdev array in mlx5_lag_query_cong_counters(), sized by ldev->ports
>=20
> The cong-counters array is sized by ldev->ports, which is fixed at ldev
> allocation, rather than by the LAG mode, so a mode change between the
> allocation and filling the array cannot overflow it. The query loop is
> bounded by the number of entries actually filled. A virt LAG is not
> aggregated and queries only the given device, as its members are not
> LAG ports.
>=20
> Thus, removes the hard dependency on MLX5_MAX_PORTS.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D8

