Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A034E48C8CB
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791208406; cv=none; b=hv5L7jPTEYv2tHV4KYrP4mMd6YEdYet+vBf/LXwdChfOVlYwESzqE5lWBTj/FNTocLpF6dwwh+YqssLrnsOqxiJNyJQs6Obg1YKvL94RNz4mz+uLBKQr6F1XAiA93VpmcOd60tU+U91hQPikCjd8NCykmHGVs41Cttq5LQ+s+kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791208406; c=relaxed/simple;
	bh=AGpHDF6tpWUnN6vaStbnnj1Tw2ZgYdInt7P0SKmmPyY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U/sAjqobSiYSPV0pQ1Xs7O3Nut6xq4vaQ5PPQqG5BMX8DkEUnFGtPJTME5Tjpu+M7UxptsU154kl0294S2C7cz/YoDXR+yXOE+Tq/vP1if7hUHginiq4OIM9AxHCMqmuv5onnmQ+R8WUbdivqGCfbBqv5w3NI/can0ruH2PlkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbC9+FOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbC9+FOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CE81F000FF;
	Mon,  5 Oct 2026 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791208404;
	bh=AGpHDF6tpWUnN6vaStbnnj1Tw2ZgYdInt7P0SKmmPyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbC9+FOq4sTZPE30DkRjClJgoIj1ccpcyOujxKYGEJXvAblkZZlR2FARF3g67mo1K
	 JE2+gnpfvI8cf2Ry11UbmuJJ9Et5SIJMTyuvCuZjLcDZe/N0dA/rwuaGvuzaLcyKeP
	 T8vRLg30ISmv4FMbhMMu8LaQsuuvguXTNKHUbQRQWclLpGGiOC4WvWSwrBShada/L8
	 prUwz9aNcTVxsKcB0KKIpmjLru3YOCwh1wi9WRKnWymKXADicGNLxFCWrclD8ReHvl
	 DWbxAbGndsA+KUniS86D6s/h3t0BDk1U/b5UbWs9DDlY07eJuhK62B0P14HYTi8/PB
	 Oa4yTBZNH2fKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/mlx5: allocate dma pool structs on the pool's NUMA
 node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Seongjun Hong" <hsj0512@snu.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
References: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 13:53:23 +0000
Message-Id: <20261005135324.45CE81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, whiile the DMA pages they describe are allocated on
> the pool's node.
>=20
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
>=20
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005-net-mlx5-n=
uma-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr?part=3D1

