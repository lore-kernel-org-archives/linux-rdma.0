Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D94A0156;
	Thu,  1 Oct 2026 12:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856078; cv=none; b=l1P+Zuw9naix4+q4JPfcT2ZT0WezxHLUWxk9nCNgPVScFy2F4jZa8sag68QowfUkzxznYOSz3CQXJGD3ZhC1CfwGs0adqOEP6EhbjCgQwu/FT9jknhcH4UA49pZhCOeQhBqaz5FPCDOgCsvRVVJLfzfWJDx/voEnn7kz8+zriuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856078; c=relaxed/simple;
	bh=C4J0R9HBIZKYjc5evTkydqc/3Ah1h/+1eQj/E3deQyU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qif1YwqkEANklX/hcbm00wZlaeFVltVzI9kku1e5vJ0rl2XCbfaqW7Fyvf+yB9Gu8wLmhEWnqi8Ft8PoXVeRDhJ2TOHjrTVw96EpDwDSLLTO1TlWPdsxD5/LfySDzs12yKfxgnnOfeD264eUWJFDbQOzjGciJAqfo/TCkLSCXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSyIQHM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSyIQHM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7738B1F00899;
	Thu,  1 Oct 2026 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856073;
	bh=C4J0R9HBIZKYjc5evTkydqc/3Ah1h/+1eQj/E3deQyU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BSyIQHM1LvBRo3wXtUsF56Yhx1m0Qt/C2Qynf2u0ivFBLoRjNAXYzPKqkO9LRMjLd
	 rjEnjY6UsU4zACGv6z2G3v2ttF/fjsxM8aKcArTgoRrQFBHu8hiyvD1YvaH2Y81Vli
	 Rw8yQJNgmQpyjBH8AehpKWs0zW6Izgcy9LwvcPpg3CrvgLORMa9tOYsekDi+cAMsDH
	 Fg4UTkOKc8P7eBd/k4WvbGzuYlesUCpmI9uYkn0/JtqcHPLmznhecOqjgQMRhiW8By
	 L0WEcdfIph+03Ks5ojsekOpIs+K/p8mRzwnWv7WHEcEHYk4FMbpWnfAPZgXeRhRJN6
	 5JLIQfjNyqJGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/18] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-6-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-6-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:01:13 +0000
Message-Id: <20261001120113.7738B1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() reads each divergence port's ACS Control register
> and folds the result into running counters as it goes. Any routing proper=
ty
> that depends on the kind of TLP being routed would have to be threaded
> through that code, so there is nowhere to put one without reading the
> registers again for each kind.
>=20
> Collect the two ports' ACS Control values into struct pci_p2pdma_acs_path
> first, then decide from it. pci_p2pdma_route() applies the same rule as
> before: a path routes directly only when both directions do.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D6

