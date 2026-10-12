Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3156C2D8376;
	Mon, 12 Oct 2026 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810913; cv=none; b=EUqCOw0vIX9TxErgUQE7s6DhGURVS2vKajQuMKazQ6pMGcSxJ5n9lKfij9azzYdiMkSxYQ9+MKR4iNm5GAajrwEuoxniDzuDQnXFPwrnJS3rw9B0q4zpYK9tGHh0V3CEYmWK2lFyIjIfoc8oka5UhKmBo6eqmHe8Zp+UFQcpfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810913; c=relaxed/simple;
	bh=U7ucs8S4wKunMBhwOvKDYdJ+x3N4ILKHnxrNI+JLyWI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZjcKnB3n+VhLjD5gJJwFxoeC84zLSXK5NPt87uZMfQjRzSxNjkH7NBBNC8AwfD5GpqDQcmhRr6y/aI6sN3OULFtdP5tO3xi1D+Wp+ZNdDeW8NCjxUtVdtPnWennO/Bngdgs/xlbMCcWIhxDHzh6RHk2ErbBWbwlGRweSaaIamUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9MFBouP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9MFBouP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8291F0089B;
	Mon, 12 Oct 2026 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810912;
	bh=U7ucs8S4wKunMBhwOvKDYdJ+x3N4ILKHnxrNI+JLyWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e9MFBouPaNhfw7CYmVJjNzZveFqbGj/R5pndA23KmefsyO9F48klVM7JBeXGrtPEg
	 UcpBgqVSklzOZf+J8rLrg/t2R5DbgTNCKlMU0/BgWKSnxnB+SFgNU4fZDZftaifPea
	 UF59IW61D9p+I50Sy33Jqhvr3af0nS0jijDKtueKfnlZUXxN2yEEwbtiMojr1Eq9YF
	 xss0pljfyZBO0PYYZMXCVMzrir5iAekNa3yVq5KxYNZdw/rX140SMGO1z5qmEmr3M6
	 mMqeKnLH7RNxrZHX6Uag7OUrvkGoa2yIrHlumzlriCuUsn2IBnpzL54KyZkCPXejzA
	 flANHbb67ENoA==
Message-ID: <sashiko-outbox-168151@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 06/18] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-6-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-6-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:15:11 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D6

