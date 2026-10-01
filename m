Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E54D30569F;
	Thu,  1 Oct 2026 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856329; cv=none; b=J5Y7iuiBiZmguNTpJDTNQ3Auu8TfGS9YOWypUzYLniwWC6q88VO7dX1fKPf3/d8vGDs1tmnVJiz+i+x0XB8WE5Uksow3nVbTw5phIIW/5nV4IrbWP7S2y3dsfku+tRfjC7TULiq4wmrU6PYYeA+x9U9D4kwGCjortCs1brUPlwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856329; c=relaxed/simple;
	bh=vXyYZ47Shvz1+FFMohijPoX/VcThcKjXql21tUaN4Q4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vGBrl7/2sJQVCK/P6woS+GoR3GbJPQ0nrMzZ0reGbFayQPdM2ZkYn9IPjtp2sNfT1Fjz14EcSQ13mwbYZH4/JqJ1or0S3G8ziBXsNvsmXC73VYNrXchszMsf73aA+OTarhtSCygZdjN98M3WC65w94Q1xQmDzahmzrqcLAdW1sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aq+by9ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aq+by9ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF8F1F000FF;
	Thu,  1 Oct 2026 12:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856323;
	bh=vXyYZ47Shvz1+FFMohijPoX/VcThcKjXql21tUaN4Q4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aq+by9bask+EcWUnL6vXApSXHmXzWPA2ZxRlo5IR46oIfVHXSHNi4+kwf3ouAWDxG
	 Ux+XfdRIwlqEucpdVujdTdWcO3uWO1n/wsDwdx4Gk0olVFVua9f7eEY982Cjfo8kEt
	 VJXS2bOBcA0hU2jDvoo7M2oA35xMQQ/QmkIkCSL84BNDiWZEz4yTjXuH6cOw8Ep/t/
	 9wQycpnzpTYjtZjy/Cl78L5DK2nQwZ3MdOY8UqWOccLjdz5XPSv5hFAO5rPBkxHKPc
	 ftfEXtQub0ISESXe71atKOCzIMQUc/Wkg+HwgqV6JPqKOQbmfgbAi5HOGQfWRWzac2
	 WhzGgkSOjIObw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 03/18] PCI: Reject unreadable ACS controls in
 isolation checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-3-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-3-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:05:22 +0000
Message-Id: <20261001120523.4CF8F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls.
>=20
> Return false when either ACS capability or control state cannot be read.
> An unknown state cannot prove isolation.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D3

