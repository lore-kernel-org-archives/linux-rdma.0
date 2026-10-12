Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B4737A498;
	Mon, 12 Oct 2026 13:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811408; cv=none; b=XVq/uJsvgv+cDU7JJeYk92YoRxNAWhfhSPDYvWvihiqfhNZpK4gu39tGLLo8u0oIOkzSgSEXD58zpHMCdBBPnq6faum3GdCXcGIGpgEjOFKqGwHqm2tugH5JrffZpA1qlGu0HTyd1Gk8V1ZatxWPBvwsNkRCHVa3yPxvKgofdWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811408; c=relaxed/simple;
	bh=RAf0PxXprLYYnwzidh4/H5bSyLy9i7/l1qep+L8tsxY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KKI+ksrQRQYY6GPOfrcbRf0ipO21s/A8FzbNT3j3AwBLu6IHfYV9/ndGCNGcH8n8aE+DzSR//u9FRJw1cTEwdyqhy5VEm3ZPW0ExUFHEj8rWRtRXfIMTFwBN+Ocd3jlE9CevJ8e0MZxTtMLu7AFKF0PKWxM9rGBG0Fono6KKluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DntkaKee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DntkaKee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C71F0089B;
	Mon, 12 Oct 2026 13:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811407;
	bh=RAf0PxXprLYYnwzidh4/H5bSyLy9i7/l1qep+L8tsxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DntkaKeeUOIOwed2ECaW0od+jrp9eoPnMkY0GOAtKticLE9TRPiqHfTuFYqmaG2yb
	 EfjDZvMBrDm68TpuLJqyU4UZWR65i70tnOQFEIX4e0qkzZK2LM9o/lITBzmxN3LB2B
	 UytKVm3oDHND7qzxwVlHa03M6yiV7XljVOdEkgU9yI3w0dl16wI2AroyBABLEdkRbH
	 Fbj3Rh6FmJ2XNeC2lQLOYcXUPalXhVOqnR0RdbJOh4zR6BhuoEIVCCt11oeqoPtGBS
	 h2f7ETe8Rg5jGbmDPKdkJZwDa1ZSPoZxb831r9FsjD1euaruXENKTZ0mQ8p/EgBDnq
	 EggOQhSgLHwbQ==
Message-ID: <sashiko-outbox-168171@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 13/18] PCI/P2PDMA: Test the ACS P2P routing walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-13-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-13-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:23:26 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() decides which ports along a path carry the
> routing controls, and holds every class's answer in one cache entry.
> Neither depends on a single register, so a table of them cannot reach the
> walk itself.
>=20
> Drive the walk over a fabricated fabric of two devices below a switch,
> with fake config space supplying the ACS Control registers. Cover the
> ports below the divergence, the three cases where two classes of one path
> disagree, and the packed cache, which the fabric has no provider state to
> exercise indirectly.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D13

