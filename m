Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336021;
	b=NZunOQJS4rUe1oZbynSaj4xh2r495Pnho0zm3dWPq4Y1k3NvUsPdeTRPIbb00T5SFfmE
	 C9gW/+ez72kOp8NV2GFbttHnvTSVi/WrClOV8NEslfY6hba9tbcsq/oQVHFUuER+WbVDW
	 OGlGtiHs+GAaeMrZHFb6sYFHPQWS2lDPYoPUpsHSbZ+mqFIWzzLYu3Jltu5th2CHdel+9
	 hxYya9gcE8PkqwowcjO5sxbTix6osO/uFO2pQPsZtNy2B+z8P8fH32u7uiJq7cgOvZ3ue
	 M4nPKWobJGxR9Rk91LCuh1uBss+83nkFUAzKqu1cG6FZhNguxRMoO99cBwBJxd8CV7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qbFY40ZIU5ljloYAgocEITu+A73OeaMYlpkoDO0pJ64=;
	b=RttP2DoZ1OGdn3ED5ClX3jOoUZvKl0IhjblJLX2HP5DCNK91oUEb5vPEG3yKOifB4VLn
	 zm+tc/NTEEkCLwMnzyDTru0l9Ka4pF6klySaXh/RP+nNgRJJMdT5n+xIIsOtGxX8+10BF
	 9Dju8jRA7U/u07l/QR54v0F+qqrhbJoZmeVJDLnPyXMeiWkZ2F4gUo8U6bAaSc9bbWXRH
	 S+eRYIV0VtGdw6tBD0/KKF+U+WRYQnn8gR/VOGX8Ow/wSV7PmULMdR823fp1Qljr61Kt6
	 mbPOOF/JWJK6ftSjebPJeClmV+9c1QJnHW8CU2st0jfJ/9rlAdY2ONLNvZRbV7YAmzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4E7FOKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE127606A329
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4E7FOKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833071F000C1;
	Fri, 30 Oct 2026 04:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336020;
	bh=qbFY40ZIU5ljloYAgocEITu+A73OeaMYlpkoDO0pJ64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4E7FOKDrO//Rv+ASVkT+8XzbYeAsopc2SGe1pWu6+jgMQJUGuzitq4UinOzugteL
	 kyDkFy8c2Y7xhGW2N/xZ2aNdAsmsLUjuGqkTHz6nfRVkKa5r2ZvUjuA0gCynnZmYcB
	 2tVqO0tydAXiEyhAw/7YMsEg0rsBAB5+1iRkmG92gfWCKd3btM71DshTDGkdh0c3q/
	 7j6u3hNFHZHnsn6U+u/2BNlEZkkbLDWVwXBEROwxeR52+/DRy0vwia7urIIad1lKZH
	 kXrmL5l2nfUhkrHrx/o0YZef7LkY2UTpbLXLdOZx7/J0O1vtHXVqB+hBwZdJIhikmo
	 3MnzzMtzvwXKg==
Message-ID: <sashiko-outbox-190335@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/3] net/mlx5: add frag buf pools
 create/destroy paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428052920.219201-3-tariqt@nvidia.com>
References: <20260428052920.219201-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Nimrod Oren <noren@nvidia.com>
>=20
> Introduce mlx5 DMA pool and pool-page data structures, and add the
> creation and teardown paths.
>=20
> Each NUMA node owns a set of mlx5_dma_pool instances, each one with a
> different block size. The sizes are defined as all powers of two
> starting from MLX5_ADAPTER_PAGE_SHIFT and up to PAGE_SHIFT. Since
> mlx5_frag_bufs are used to back objects whose sizes are encoded relative
> to MLX5_ADAPTER_PAGE_SHIFT, a smaller block_shift value cannot be used.
> Requests larger than PAGE_SIZE continue to be handled as page-sized
> fragments, as in the existing frag-buf allocation model.
>=20
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428052920.2192=
01-1-tariqt@nvidia.com?part=3D2

