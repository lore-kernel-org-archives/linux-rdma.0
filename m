Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010660;
	b=Necax5p9t6TtL6oSupF+bEezEEGhF7sTyJ6sRv8iuF1FLhEC8nACyj0W6QiUiXtoUuPn
	 PI+jxpiYYAq1NDMtHlME8x539/G9eyMqD/OsXZEptFqJuwMsKtLubR1rY6W1BlE0Bg9UJ
	 0TROgs6VbUY4qn5BZtJdBWHEycFVE5+KfEsaXJGXdQErZYW2dLvtI4VRqx5k2mZoSaHaq
	 aNZIqTeq5Ny/DkpYSLkiTSuqWsW95Iv0bX4E7aim2orev5wiNGwDnASnXonEffKxCj1aa
	 JN8abvOwKtngyWvsef5q0PFKisLr1s/Dqp0w7k1jRepTbpZkjCdXbvsSWc2fj0wWRXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010660;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=shXRrZZ+z8RmoRjV2T58bybCfyc9jEyGGkHMRa3H6Y0=;
	b=xDHsqBC81/POQpoLHUmxm/NKsQuqSnmy39vWBBgFCP3IDxzSThIdv/LZuIMUzr9eOo0Z
	 8h1NpTQya4Ue7CjwT5T7ybcmpXvn+1msxCu/PJP+W/FOOMTfbe4Nwxhc5e1jKwqtiFl1W
	 Q3iDf4g2i5yZ2kL41aaBmyBdXRYVAZmG2gb8zvHvimpID9vof4KGnqzZEfJgBm5sYZhaQ
	 9hpc41/jLu4NkN/+pQ7DP8OqiaUxm/ip70ykc1NZPc98PGJkXkH0PPGqa/ruAMP1Aqg/2
	 v87oNR/JgSrU2XeFWsC4u9euHs4JNVCbzQKiW32u8uBiIVo2v3kiLkNz2zewMS18kLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeLJGya1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D8606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeLJGya1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658791F000C5;
	Wed, 18 Nov 2026 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010660;
	bh=shXRrZZ+z8RmoRjV2T58bybCfyc9jEyGGkHMRa3H6Y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YeLJGya13w5jvZSk4tryT/3FPaYGHoZ63MwnDndcsRiSw0JwUV7fVOoeLfh6SyhEP
	 DXhlv1SGi5V7YL5XaJasYIUb56Mby3e0odO8v/polFyXdYYsUBUD6hZTJEWmb/Pteg
	 fAIjL9173rdOxZ2+3X21Tt1olXImd1AXsADxuHH6j9278IWfqWtrHg6AX2xsNTEzo1
	 31QE7ACPCPKPkVUicb9kfzrYlOQKybcjni+t0m5xsIKfPom5fx/DlICRjRBqpgpIze
	 757984kVuTFAuJXqsFVmxVHDSsl3pPvKHu5aUucf8C4Rs+M3Hco/dgaSB1kh8SSwD8
	 pAMs71BfAFrzQ==
Message-ID: <sashiko-outbox-221139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 10/11] RDMA/mlx5: Resolve the bfreg UAR-index
 core device from the ucontext
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-10-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-10-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Akiva Goldberger <agoldberger@nvidia.com>
>=20
> bfregn_to_uar_index() and its get_uars_per_sys_page() helper took an
> mlx5_ib_dev only to reach dev->mdev. A bfreg is allocated on the owning
> ucontext's core device, so take a struct mlx5_core_dev and have the QP and
> DEVX callers resolve it from the ucontext via uctx_to_mdev().
>=20
> No functional change.
>=20
> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D10

