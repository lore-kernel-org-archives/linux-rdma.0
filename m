Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C762E558203;
	Tue, 13 Oct 2026 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924617; cv=none; b=X83XDiZGg6rAotvcYMsQu4dPOIWAGUx0Yj6nuEa80riaPleF4snJ0ZAfW4/ze/G7FkDz8jRcebZGkcoLG9pyBjx+zATQm4j6QulmP2cv4DEoJ/ZpMFRi7uqNvTXIuqvbfXlzjjIRnFAHHSyTAximrRSKCL1w/Z6V4ryKj1I1YrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924617; c=relaxed/simple;
	bh=46iadmMBynpiFNDGNr9uRc/wisQwT12baHH7CdskpOM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=J/JizWhn/9djBIIRps7jk432X1a29gBGoYabGLMujfYc1MeWu98GneUixxLbZmL17+dlxXy0lxMAr7Z3TUhheN/XVHZLNn3noPfpV/v3V1JAKFwcQU00q9pah+Oh4YuA3SuFMFC1peLUcehdQz530pE5ez0XD+5ps3hsvSUpw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiJDthA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiJDthA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4401F00893;
	Tue, 13 Oct 2026 20:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791924615;
	bh=46iadmMBynpiFNDGNr9uRc/wisQwT12baHH7CdskpOM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LiJDthA+DXIyYaMSx6pLGAdi3n5sZbMF28klJpoQ7V4wVRM6L6hmNUOieDpxsk+XK
	 5hRrVk/PzT6kyWE5TXa3GTxL4OPpJN1iEqcW+CMPMyscveFPyLhdePQkZPOWloYV4S
	 39HkLzGomSd+ERd+BrEDFY6+yp+Fl/li5EHB7CWp5Zi8G9FIc4MAbmc4QvgxmBC5tW
	 MXqBwPJiA8789Fx6YkMcbdJL2szZhAsTIdyjgH0Hn0xOJeW/5EzMquSXP4oD0BMT9U
	 6xCsDJUKi9v/gaiN6mYyQZCA/EtKWwgHph3ZQcY8krEr7H8jiVjNV/kewDtTuk/XlJ
	 u+p3mMCzb/zoA==
Message-ID: <sashiko-outbox-170488@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 32/39] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-32-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-32-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:50:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
> when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> The droppable check is kept explicit, as userfaultfd cannot function
> correctly with droppable mappings.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that mm-managed mappings may not set
> VMA_IO_BIT so the check is now redundant.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D32

