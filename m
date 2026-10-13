Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F0F554089;
	Tue, 13 Oct 2026 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791925914; cv=none; b=YQWvcNKAG8cfOPb4EzkwEofLFD28bfxi1Hd/3CnX+J1fVu+9dhG1MBycULmT9MpUtJOHk0KZ+XzkzquZqGCUyrXdyLXHu3HUJnK+hpIty4UBY7TFXv5XqsZl9JSclFlbGu91F2SwjvzhLZSusWi98OrakXASAwqyOGJjQeBpaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791925914; c=relaxed/simple;
	bh=vk2PwYAQ7HD/BQ7odwL80VqhFBWIsnVlzhH0n7gw8xI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Tbz4XPVsdR4Q+9h2Pg15Pa808xHYcwNjEBPg/VFgjfbMZckmD1+fJyWNBOkjiSopj2O9veZU+4dQpr8C+RX+aSa6wR8FOHBO9zv4YhXey5xHJO9RS7u9T53gv5Ra3joFEpcDl9Ra5kG/MADbi79uml+odBigCwVTdXHkUIhv6Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXfIKEsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXfIKEsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDCF1F000FF;
	Tue, 13 Oct 2026 21:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925908;
	bh=vk2PwYAQ7HD/BQ7odwL80VqhFBWIsnVlzhH0n7gw8xI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OXfIKEsvokt8MxXGEm/5c4NWGeDD8Spam/tFENMGgANorUK+OnpPP8GUBHCGGGSgH
	 /L5Y+GfykX8NsXWgZxirYyjWlIGEsinZy/RT2DeQGHkGEVetqteAnF6HxFeY3xRHOD
	 VEsmgx2NgbAE/s7bo+xM3sYpRiWj7q40P8tyKEDXw2p65R+CZ1lkHxeAK2oXkfegMn
	 e+iYJjrOjdFRqAt/ui3jioP24S95oJqbSWE7xh2OpFzq+9I5F4o9v1TJEzhmnXmZzt
	 MFWJMpx/9gz9lCdlMsA4WwT4FcyOj8vd3b7Q9UCwGVKAsTmk9WuNhgRmauuDVq3Bxu
	 ksjt73VSGNa3A==
Message-ID: <sashiko-outbox-170517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 34/39] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-34-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-34-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 21:11:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
> so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
>=20
> This is precisely a test for a fixed or non-mm-managed mapping.
>=20
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
>=20
> vma_supports_mlock(), ksm_compatible() and should_skip_vma() explicitly
> check for non-mm-managed or fixed mappings, i.e. for !vma_is_mm_backed(),
> with hugetlb having already been excluded separately.
>=20
> So update those to check for mm-backed (and add comments for the retained
> droppable checks).
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D34

