Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B652F538D8A;
	Tue, 13 Oct 2026 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791918204; cv=none; b=iGtphNpt1NMYTfQ0/xQpfBradGwBK7m0OrTB9FCUHJqu+MvqbijwH8dhez5e3L981lhMfE2bglZS9KkzZhtksAlj5CFY65hDhyMpiomsTiPrVDQuVI1J2TzK4Z62WWbuMa8IhAbBNjK/7k7DVYADPaLUInSD8KM8qePyqtDp9sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791918204; c=relaxed/simple;
	bh=JGnkDISweB9IJ9+yK+MaOUwNPvCbnulvRpB1EcLWzV8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ph1sty2sl3LQtCkIAWSXail5HisZg9urp/VRuD/abIfUZ3J/hcjAmgXkrKTrUt3CTxsbBUM9JEm/9xoQZqUUfDLrFYK1lVJMd6dIbRJNYFceVMX1w0/SytF0hvrEvV/7Rapw4fvIECH6GgXPzc0kMcMxOkp3gDj175CP3/kN/0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbvfikM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbvfikM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF22A1F000FF;
	Tue, 13 Oct 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791918203;
	bh=JGnkDISweB9IJ9+yK+MaOUwNPvCbnulvRpB1EcLWzV8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nbvfikM+JXn1wOfqmjpNiVVitHO9KsbicXRxp4JzJ9JzOCQug+5idPSu0mONKebMr
	 AZOPF0cMElLP92wN/2wJ9V6KsjDpj6srYhlQWYdN2Y9RShaNc5xp5p6EBcrWznllCi
	 9oSb3I3zSlvG1zLMKWWx/qjO1T7WQsrRqE/jYIFzH2jt+nRvqA27GBZzFc/rGo5BbD
	 uSifipd+PVYCN/PZCOO/c8MEtDKG7ONZ9V7Gi7a6EOjrkzq6Rb92pc/FPB7yNt3Kvj
	 TAc3ooJpq+lqCp/JWF8AQZjdIhGeUVHTZ0Lup5IcGaVkUepaHF6tcnIf+4ljb+Pf1Q
	 9uhYZ4kYzCHnQ==
Message-ID: <sashiko-outbox-170373@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/39] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-21-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-21-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 19:03:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>=20
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>=20
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>=20
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>=20
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>=20
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D21

