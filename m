Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CEA5427FF;
	Tue, 13 Oct 2026 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922909; cv=none; b=cCyJWfhTnefuUD3dK1BQMWLdSaLjWtyYSKJXz/xLPHQV2Hm22PqjaeRxkhG+KA3FBEMdh2OZmWgG65oyxOV5vmlbW/WcJfb8U3vfAQFcPxmyjhEklJT4edvMyCWa+mWrlY2b0scjcEeoJtJzivrXdkwP2VY8Y3JUXRoJBRUqzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922909; c=relaxed/simple;
	bh=eA9VirkcFHLEx/i/r5oniinu7vAbSaMLW2lhOS1T6U4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eavhQkun7eabPbV6RoERGD9pAk2f8xj1QU1oQjEFUcdctgKnOF9mGKTiHea741mskHRwWc4OfCyplIYceWV2gCnfrFi/6aCFzKcEh4ggOUIyV+uuBoVVPmU8tLTdr3R1k9ZttxeNvwqbKEz8YX9OYIW9yQXoMqGrncZ1Lh3mO8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFdNt49G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFdNt49G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9537D1F000FF;
	Tue, 13 Oct 2026 20:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791922907;
	bh=BfGjPbQzAAmcVRFzQREf0xWg92scQMV5S8yw/1yzbGA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fFdNt49GVCBCQUwT6VB7SNUJDLa5vXBJBn6JIyh8nVQA7jMmU7sMGGESbLWY0Vb9f
	 JhrzpiZbPBKDjikdLeDm/RYOISkPaF9xgTG+2o9ZVvJw9d1MSWE7dk5YH8PCCcsGxG
	 oOqxxRGYeePAz+0stbkwdq09hAnzUFa1gFTxhFqsJvj2P3VlpkUVQARhlUUOW13Do1
	 qBDebDQ9Os+HiOyz5Zg+OxF8a47hrYStWFH+zJQCubxEHryNv36yVjw0xsTT6oovEJ
	 qEb7oAbPMcOiAErD6AClQh4V/PhR3u5y/PeOYu34YEMZaEn4oikzN7RxEIJm3PkQGm
	 SUZxr6LOCvLMg==
Message-ID: <sashiko-outbox-170448@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 29/39] mm: drop some redundant checks around hugetlb
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-29-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-29-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:21:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
>=20
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
>=20
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
>=20
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundan=
t.
>=20
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D29

