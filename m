Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BF351D51B;
	Tue, 13 Oct 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902067; cv=none; b=PtAe5BEMdD6wNkhoRBiErbp5ElP5q5wndfVpHjlFd61VtzT/Qcp6v+XJDcz05PaGmrDhrAaRuPOiHtLgV5CiRfNtp3h0oCzyMv4F8Cb00nTcXlh5bJ3gbFFe2E4lltBNaydShlZR9tmjK1GSk/wFxfzgliCYi4LT1PF9oB5xECE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902067; c=relaxed/simple;
	bh=u119PPAU0AL9mcQT8xQMdGyKRq5c632EBNgYuxNHIP4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BdR1X5//S3fmj/Qpp8ZHKIeJN3XfQn53IpLb6Yju0GNBlrMhWvSexT3sZ/kKw5iZClOQPeht89JltVrvRWVxOmaYX7MSTOLFrZJ/GHCl7RSDog2O0mUnBB7jQsRveParBUZe65ohFsGFoe+WD/lJG9Xjrz4UhQZMqnHFw6L5u5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzJc+sbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzJc+sbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B81F000FF;
	Tue, 13 Oct 2026 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902065;
	bh=u119PPAU0AL9mcQT8xQMdGyKRq5c632EBNgYuxNHIP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BzJc+sbS512B2VYkUpkHlXpvVsWlOsZ27j3VX3JZEaWV+2+wQnwiA1E+ALbaebgJo
	 JEd/I4+eEJfaBYiLuRNBqS8dEnBmOVj/5ngy9q5lGMSN60c2tsUZXCoE3nvXtoxkva
	 iveNyZJm1OQQWXC+v1Qm+yDjAWy34zz/1VkTlGzERZZy92rcK4qdX2kqHRi7BU8Kln
	 +7qnwETdXEgtJ9AkRYHcZZaw3HyU3qs5z7gDtugqYaNd9cVRpH8HuAo2pxTpFiV9tb
	 xQfwIPVgKX7X1yMusD233wcyGgWQ2rrjtVvwPK+TdbJPiG+UYEm7qKtOUP0tameJyT
	 H8w2koH/SRQUQ==
Message-ID: <sashiko-outbox-169917@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 08/19] PCI/P2PDMA: Answer routing per TLP class
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-8-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-8-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:34:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> calc_map_type_and_dist() returns one mapping type per provider and client,
> valid only for strictly ordered Requests carrying an Untranslated address.
> Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
> do with their traffic.
>=20
> Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp=
()
> to ask about one. The topology walk and the ACS Control reads do not depe=
nd
> on the class, so decide all of them from the one walk and cache them
> together, four bits each. Every class still answers alike; the controls
> that tell them apart come next.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D8

