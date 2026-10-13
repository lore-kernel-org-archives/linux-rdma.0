Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EA45476D8;
	Tue, 13 Oct 2026 22:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929650; cv=none; b=tXLnKCf8WQi7vJbL46QG189j6pum3leqeTjKJ7LPYb2Ts8gf3etDmd8baYpnD7LNpjk/NexznlG4ID7JzeXcCNGZu3260s0XhB/zXy81fjdwrUNbZSveAS5Rkkd+JzO8IaT5Y21EkkfvuRpXIOTuOMWOzbVHTs8Oldl0lVO7olQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929650; c=relaxed/simple;
	bh=3WIdtLgclVaK30MySg7pBCiuy8t/rYZzOGp8vyC6W08=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fkjLmcbSO1ICKEKf1+11fy+q0r+T9yg9OnkMGS6ln+6Drd9pkIZ1d7slrp5Jk9r3tuBxyr2I3eDXevNaAaB38QrdcQY6IXHH74AbKc7NeSLVwNY8fTfmfCsHda+UTKbDKpFkkNSu3QAkXkaCq6U5mlTlz7jBBhHKXuDjVTbpZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JibyuJMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JibyuJMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BF1F00898;
	Tue, 13 Oct 2026 22:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791929649;
	bh=3WIdtLgclVaK30MySg7pBCiuy8t/rYZzOGp8vyC6W08=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JibyuJMGb8U14pqi7xirdrc55v4AmelO89eC1DEsPdrfGXenLfFsrhjxmXv61rsdI
	 aq/1eix9bUtqL2KcEndWeMmgPybARghWfSiP11QUOTxZ0+wDiO9PuA+R9tE5mV0qXq
	 JM/0Kf1keS1X6Y1v0XkdbL83UfqltieMYAaWqhOdCrWAreFcSP5hzqdFBRqn9V8eP9
	 1caNZ1f699n/kkPg8ljz/Lza9U92dHtj9dPNGhajqrh5n/t7plOPoGej5pbnYsHlv2
	 298DTXswULnesTpJiDhWReZMgTgJrx2pyik4qauUO0t7ZiD5HquZFrOJ6WqrQFdr+S
	 NfNLWh4BQRtCQ==
Message-ID: <sashiko-outbox-170566@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 39/39] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-39-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-39-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 22:14:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
> but with a DAX carve-out.
>=20
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>=20
> Therefore test for !vma_is_mm_managed() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that
> mm-managed mappings may not set VMA_IO_BIT.
>=20
> This also eliminates another overloaded use of 'special' within mm.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D39

