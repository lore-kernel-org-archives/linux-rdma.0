Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B1C48C3FA;
	Tue, 13 Oct 2026 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921260; cv=none; b=fAaMsVJGsK8HIctS0zAq8NQNWHgbxbwlOWjZtHiMn4AOXCHuu57OUHNLYZtjks9fNhlKqo/fvIBYgeOP9xbxrJFPU8tOcm15XvPeMS0hWa7GqswlIyOutXzIhp638dcoiRFdtpFfbOo7g93TgCTnnreQfdC0lLj7X0IDYd3HtL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921260; c=relaxed/simple;
	bh=Cbj8NzlF+5kjRQBTI+TSH8CrJMO6RrXxcAfJbaCmfoA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BCd9+gy+JbXdhsJmEt5SDqmHHAFcROIkuH+skTvf03APeryirO9LGkhe4KWUQlO6DzO19KZHzCGJ11sj83qgltvh0vWzswj9dfPeg8SK5f8Zv+GihxvBUuuGFljqxJTHLJPSFSKpKKH4QMz1/XeG1r7vokNJJ/Rz+alNlhweiDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaI7POjc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaI7POjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25511F000FF;
	Tue, 13 Oct 2026 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791921257;
	bh=Cbj8NzlF+5kjRQBTI+TSH8CrJMO6RrXxcAfJbaCmfoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aaI7POjclTNGJ12FAZEVQxYHh/N/iZoDRas3G3OBUCUzSvXeqZAoTPijQvHPRLAwL
	 3+w8VgfhGlBB2JyViFpILFDk8hlGkMyWolIRsEgdHAx0xmVmDNRnbBTDM0tnPj58nA
	 9CMTWOCTTu9+9dAcShi8OdoajbIE3vXvVxuPqqUpO+82Ke7v4JrZppH7PU4YSZ6YaP
	 6Y7pVZCLKKYvxNAfM1SGj3NgfNXAJk75tYWASJEDCqF06Zh1HCacyKIN5gQdDd2dT7
	 h8WF1L9bGRQcRAPCu/YI24rcIXYFXIlJyOU95ngE5bw8Jm7+1Ekb1H+Gr08Iof/6Cp
	 z8HG+lIllysew==
Message-ID: <sashiko-outbox-170431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 25/39] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-25-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-25-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 19:54:16 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>=20
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as not being mm-managed. The check WARNs and
> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> without a kernel mapping.
>=20
> Here VMA_PFNMAP_BIT, VMA_MIXEDMAP are tested individually rather than usi=
ng
> vma_flags_is_mm_managed().
>=20
> This is because vma_flags_is_mm_managed() still checks for VMA_IO_BIT.
>=20
> The very next commit in this series removes this, and the check is then
> converted to use vma_flags_is_mm_managed().
>=20
> No functional change intended for in-tree code.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D25

