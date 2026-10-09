Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5FC4E01ED
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552667; cv=none; b=S4TNDFdSRefSulq1vRPUSops7KzCPXb3GusBZ7z1aZX5ZkvRFl/odxbkUaYLTIep/wpSyB4ZH15nrPa2PqUrHC2LykvcZi8eaYUyMs0u3hQgnxJmBkU3N2g/HsRaywsz+VmcAHQWBnaGu7/BGjwDvoApeGwtXCTB7RIu64XNrl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552667; c=relaxed/simple;
	bh=A/Ur+RhMcE6m8KNpzl6AkzMJs8zbXDp4J6rCFoF0tyY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=nvv6ttokBxDK575L58Sm8GVSfdJ6dWcPBJar17Gjkj2+bzqMwQrNFUC83J5G+1GPXolI+7pKST2nI5SRR700TYgbGs4oX5Kch3tXASMJd2Ft0NZwqiOBGhgh6axXD5w/6OcPSQxWm5jwPtQi9Q/taZqIDMESzezYqZ4AuQtdQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPI4OahB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPI4OahB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D3D1F000FF;
	Fri,  9 Oct 2026 13:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552666;
	bh=A/Ur+RhMcE6m8KNpzl6AkzMJs8zbXDp4J6rCFoF0tyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JPI4OahBN2fYmO1cBC0fTlrodrkfZfTLwtn9rAK8gWLan1X/e0KnYhR7XfsSvSKuV
	 fySy++LmS40+hPTibNtQZXvV3uB2lBJ6l38aFIOWqY0H6N+WEtq9JymJc0ZFlhavMP
	 bc1zycBQdaAlPp6QXF4bY34R6AWb5XFsUaVVR5xRE3uA1c5sDTa0oEmJYr9U+mvqBZ
	 1J2TwCqaOJiUcaFY8jVSecR71nAxkOdn+zTDTxcTyb/dPmrYuCrobC/ERuRocd3SZV
	 nAdT5PetjC7yLvBMUB2eSfD1JqnuDV8zt0Kd4XD94if7eF8zGDbaX+7hBOqL5poFyg
	 C028l58XMC8wA==
Message-ID: <sashiko-outbox-165641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/10] net/mlx5e: Use the correct DMA dev when
 data_direct pdev enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008132815.654147-8-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:31:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> When the private flag is set, always return the data direct
> PCI device instead of the NIC PF PCI device in .ndo_queue_get_dma_dev.
>=20
> Rename netdev argument to netdev because there are too many confusing
> "dev"-based names in this function.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008132815.6541=
47-1-tariqt@nvidia.com?part=3D7

