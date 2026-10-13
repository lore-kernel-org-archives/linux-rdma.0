Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9BA51A121;
	Tue, 13 Oct 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902963; cv=none; b=QN6aZ2ZprykvD2bFx1bpxM6PsXr5M2IuErQ5jjJgoLLbbsvm2WBKsvulWpFJt+KdnCw22VbhQ9Rja2f628IxhcO00F8hD+tzqf2te3ub1xXgTzcf5yx2I1AWpr/9V/NTETA5tHIYHvdoG6jiw6aNfSco7iXRZ1yKIovgdz11dRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902963; c=relaxed/simple;
	bh=B9r+UH/Jek/pvtTnOlWsQ8VfudHccOueisXs2n2OD5k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=b2kb2vqB6s3+9R/oTjwr6HObx5QcTKGxAU5K0CT9SmCGZgZdeho7716Q6a/yKTJEAUbj8lrtXM0mJ3P9pzU57jBAaSKf5hxngJ7N6I/wF2OrJhWx80DP9AMmPvHt5/nJPHuX8w3/Q7bOkOj+zMSU6+BplW/ZClOkWjMOC2Rw3ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXiscuek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXiscuek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257121F000FF;
	Tue, 13 Oct 2026 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902962;
	bh=B9r+UH/Jek/pvtTnOlWsQ8VfudHccOueisXs2n2OD5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXiscuekqYuwS5IBVM+WRh2gISO5IV+ODW/9wq73il+MMZYl/fss5H5bO8GqNr3xa
	 Y6PIWXjuVxr01BHyS4PpQpzmMINBg/mSar12ExkKAokYzFg0vNMV1ahGvYc++Yfb2y
	 p7dcHRVuftFP8JxmAOizu76fzE2q9kvg/4vOk389l2vUKLBv9IV/XMmj0A1U8jrHXX
	 mdaxXO0NyEKQomlqWVHJv2PPbFKDIzfsVTayD22fzX0eyQ69hp9y7rIUb4Of/BsLHe
	 eHL3eqfDmxLOStO/u7MZST4CrB8kIjQhUWImSy13MayUwsRWIvhlrvI/OoxViivr3P
	 o9y0zg9WQz2YQ==
Message-ID: <sashiko-outbox-169940@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 14/19] PCI/P2PDMA: Test the ACS P2P routing walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-14-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-14-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:49:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Routing depends on which ports share each path, not just individual ACS
> registers. Sibling functions without internal peer routes must use the ho=
st
> bridge even when redirect controls read as zero.
>=20
> Drive the walk over fabricated switch and multifunction topologies with
> fake configuration space. Cover directional controls, nested ports, TLP
> attributes, hardwired isolation, ARI, PF/VF paths, forwarding failures,
> translation blocking, host allowlisting and packed cache values. Keep
> external peers and self-DMA independent of sibling routing restrictions.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D14

