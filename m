Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E983B05B4;
	Thu,  1 Oct 2026 12:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856235; cv=none; b=eR/xJEQpei4LjQfpJK7S1bGVPNOT0KJaBUsmq+llm4nGnZFfb30r6kF4odlSAvAGQzB/Vw1atg/cRV0Q1f3VUBgICwPA68LvSZ4ijbMK5y8rwUppM84YCZoGcyvdLUsVZSU+Rw7ZWuCIGbVn0shEx2+RXjPP1T7/uQHP1kFgydE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856235; c=relaxed/simple;
	bh=BTOVgDCuYiHcmSugzZUL3bMU3P+G1dAmVFWk+BqkZa0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NS3p2xYe6B/s57qW4AG3y+7DbEA1hqPFlfRujgMFMA3DPO2hbtQ1WUMA2s704L6aeIxdHMQDLq4w2i0qvxbYaQLVXuPy+hnEJ4cTC4ByDplj9daT+43nYiyqRP+GydFnjHDnwEGBpLporpkZXHToFfWojCzmN/P+L+10YhAuo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOiF0p22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOiF0p22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DC61F00899;
	Thu,  1 Oct 2026 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856234;
	bh=BTOVgDCuYiHcmSugzZUL3bMU3P+G1dAmVFWk+BqkZa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IOiF0p22PmW/JGvLGE6ydcDSs7Yd2TwyGus9te3gzLUY7HhF10Aklmsus2La8ixuU
	 Ai2ucOiwSPNNBn14SW3qk3oTmjNdkh6AoNJGeWMBTUk8+CR1mYKMBxx8VnWK1novlx
	 VtivIYi9CgpNbflbMp8+K7end+1A6yzJ1fp8Lk5Dpj7Zt/b8aL6/0KWD8UrAPU1N1H
	 fvsp7Yr/uXJHlpVl0UUKdJojA+f+h9Yi5qXT4Lke5DF5P7e69DZ3JeLTYKJKa8oIfE
	 izzDSyUeo5++mUjN4EZ/Fnh6qA3rXqQ9PaOg/leQGwptpnGCRJnuaJkrsicG7sNcGe
	 97p7YcSRY3qGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional
 ACS controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-2-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-2-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:03:53 +0000
Message-Id: <20261001120353.C2DC61F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.
>=20
> Evaluate Request Redirect for client Requests and Completion Redirect for
> provider read Completions. Continue treating enabled Egress Control
> conservatively as a Request redirect.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D2

