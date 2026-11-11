Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404816;
	b=UEX1sjFBtUBRHixzpQkGIjUkLdD56sxhCmi9esHKdiMq4eSECCmreqteDe9ch8MMndfJ
	 VmfjtK60L+WD6gMylA7bmGA7L1ZFKz0ZwsiIHOBREoB11kw9ag5aiz2AimrUF/wB6n6hF
	 6SHG24hY+H9Jg07e76ihtkIblpd1Q9uSqtz1huhNKPzGq9/SrZ5pZsY+d1VPvIpLW2KjV
	 H3Y1p5+zTJqYc/tIzoGCfRcJmJZu8O1h9EOYpECAX5nYsd8zDYQiSjI7SxN0YCkWSmOKD
	 B2dUQQBch45DqEfvcQRpT7JPDmAiQygoUNttRfSeoPExMEnNvzaMmJDv/9uPhSrdPDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vBv3R858PDOa2tqZbginm3edBjXsj4Mb5YNBg9ejGkM=;
	b=3bDkYB/WJDgGPrUA2V52ep2XBwu97OPjABAl2QragpmDHnBL05k2rKKMzlvZWMs8nULo
	 3EGTxeB/ardCjig6PdNiSwcwAFWK2Cnn16NdqAEuPYlr3T5+W9Rz4Fzin2sY45Z/XPU0h
	 jqEB9llrOX7y6J34kXPf3Mv7UN6aS1I/h3Cx5YQ5Lr8/BpngxWcFa4zMv0zSUruJWFNie
	 pZ4J7LdOijnDRA9fZtuoIU3WLu+S1dJ0KnxgVRaTGBRWEWe7onwiqKxBNHsNMBJJPNx0B
	 5eHq5vLTqAXn8+zdf2OJkj1k4cXtVzqwCxiPtlw+f3rVEifOxJAuHY5CBLe3tybrfUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeSEufGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F7606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeSEufGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780EC1F00A06;
	Wed, 11 Nov 2026 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404816;
	bh=vBv3R858PDOa2tqZbginm3edBjXsj4Mb5YNBg9ejGkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CeSEufGYyfIAcfDOFVsSvh0lMl2Cy76GOw5l7kOLAfpIcw4GjZjrKbd1uxiHPOpR9
	 am2ASf645/Fk3Rejp/fUe3Y7tahWib3dD8kW5F8CgjWtApSowGeqgPo6jrLHZBYQeQ
	 D7x0WXRnHUsAaD0andD2BQYEgLydOD+2Z4zFxl7jBXVLYzdpBVd6KRVusCjqMN4BCX
	 3snv2XIl3r01SHoUHTlvbSHYRkQI/T43gVpgGku0qKZ81kL4h4ZIiGJBrAss+AUzfS
	 AYxhd+elsB8j6RcFmHMUMk0pqnyR9AzLgvlzDlfdM0O8le9YwcpGhlYJMtWAG5rJlH
	 I3kx+3yWNToAA==
Message-ID: <sashiko-outbox-209104@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 19/24] RDMA/mlx5: Validate firmware RQ/SQ
 state before sqrq_trans[] lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-20-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-20-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] RDMA/mlx5: missing Fixes trailer for sqrq_state_to_qp_state()
  bounds check
--

commit 8e8f815c736eddc60d07600341bb9a6f00977b7c
Author: Yishai Hadas <yishaih@nvidia.com>

> RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
>
> sqrq_state_to_qp_state() indexes the 5x5 sqrq_trans[] table with the RQ
> and SQ states returned by QUERY_RQ and QUERY_SQ. The state fields are 4
> bits wide, so an untrusted NIC can return a state above 4 and the lookup
> reads past the table.
>
> Reject out of range states with -EIO before the lookup.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

[Severity: Low]
Since this fixes an out-of-bounds read in sqrq_state_to_qp_state(), should =
it
include:

  Fixes: 6d2f89df04b7 ("IB/mlx5: Add Raw Packet QP query functionality")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D19
