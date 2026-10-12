Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A788376481;
	Mon, 12 Oct 2026 13:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811252; cv=none; b=C/lxx2UgfT3VYdOUHWI8aUjb1mthXnyjen4DdoOY/+0mpU5R1jB9e3AHVJYTYYcOPCnMliyxSu+tRurqx3R6nNdknvsGiKZ3HQBVndt+FW/iNupvTsKoJSgm/DX21VWJU9p4r48jUcLzpac6rSVyRUFd4kr9bpngKxSAH6r/uZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811252; c=relaxed/simple;
	bh=RWwBHXqGspnBAtAriCAV4NJ3pZG9GwGLLo60JD5LsXU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KXbJIH4UURmszCcy4mkMsLXcnhMqOplO7dyWs9oOlupignsbkJzxFRy5JpgodG3CkquWBgr3BIISbxdeXIYNh5MNLJQdsCCz/4UzEkeJpenbbqrtZU8/MYKSQ/Z5zCpvx2dVd3MY5Wdxe0duGiNxST7ntjxDJIbDoD1DkSFfjlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkD5+6Wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkD5+6Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71D11F0089B;
	Mon, 12 Oct 2026 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811251;
	bh=RWwBHXqGspnBAtAriCAV4NJ3pZG9GwGLLo60JD5LsXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EkD5+6WgGEI7KWqniEn2viIdUCjXQnVob/YDhHW/l0G7efMz7WyPEKWA6otnrHSAe
	 weDtr0kLZuZk19j2Vl1qx/aUv2QSyZXL/lX7aI1BSS6J5WeGFTmm/2qzn9Jfq9KmVQ
	 FgYQEkoE7D0Zm1+5XdxAYCJlyrZY7FrWhmf4JTk96NaOSxZSxuLsPFAmigyOw+DjZx
	 lz+jMMYqUHFQOl4EpNDeEEDJSNRangaiFlp+JAkutJ9HK7Ohx3TpHtNqB0M6ayXBEq
	 tYzqvuyjnrFU5fvvT+oM17GX5nZex/e4p3BKXZcD6C4e8VUtCZmOki8NWxx/0evEjY
	 Yf0lRpJjLin9A==
Message-ID: <sashiko-outbox-168169@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 14/18] PCI: Add KUnit coverage for ACS isolation
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, media-ci@linuxtv.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-14-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-14-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:20:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Direct Translated P2P does not weaken IOMMU isolation because a Translated
> Request carries an address supplied by the IOMMU. Config-space read
> failures, however, leave ACS state unknown and must not report isolation.
>=20
> Exercise both cases with fake config-space operations. Also cover missing
> and unrequested controls and a missing ACS capability.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D14

