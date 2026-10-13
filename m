Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F093EE1EE;
	Tue, 13 Oct 2026 20:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921766; cv=none; b=OPLBmUdhc+k/E52Dl9Wh8Ei4i6VsXJwSAJ6dX6ygWrchTZqh5CDNTmbOqmupsa4s3x5pDoHMKJEVWNjE9Do80TiYKZ2WsQLRP3t8NAhA7LeJOYYgZutP90jZTkilBNEfWHyzgJPkl15r1MurAiKiB10KEMgSkhJUsN/RALms7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921766; c=relaxed/simple;
	bh=emp8oVrzYxpkBsUuL7bkUdle15UfPuZOJA6GwoMxq5s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ot+u2hUgfa6ftoI9/dTgvErXwVEkj2Cg8e+LjHgcdjwx5XSJONTAEscOEtAq8ar9nknsvb2BrdwcLUeTZ9ONudJmdtTXiXLXlFm7orFnZV6dRfIk61R54lLp7/ySmheJd/2pH674YqCj9BS2fUaPOD4LW1jtCVQkHr/kCobqf64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz1/VyHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz1/VyHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE06E1F000FF;
	Tue, 13 Oct 2026 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791921764;
	bh=emp8oVrzYxpkBsUuL7bkUdle15UfPuZOJA6GwoMxq5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bz1/VyHi8aPiEpYzbtlOLw9LQ9X3/j1sK2COJdgZ7OCDRwtTzRFl04LkWY0Zr3d1F
	 BgG2mucKtcYlfGHHaf5J0ofpS5SUXG/rzHKTyb0hcCDAOPBUm1V0TJGOmKGEulMCN1
	 uRqfg7tpCGiy80a2UQTfZ30iXcjvwTggpMYy2vhxVaVI/HUsdLR8VcYbzj0rL/7s1g
	 wrXet7ntoRh/Zz9+Ck6og0rAjVlF/S+2HrOwxoHHE1uLp8vj9IlxqIYyS1QkZkmrRH
	 KVuO/+fTqL7zgQpofFsT2XgGGvgJEoFvgx+8pvDSo8c2dgY3ix2T2PG/A9drXYv77G
	 MIOJUNoNr0CfA==
Message-ID: <sashiko-outbox-170437@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 26/39] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-26-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-26-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:02:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> We have now made it such that every driver which sets VMA_IO_BIT marks it
> as not mm-managed.
>=20
> However, vma_flags_is_mm_managed() still checks for VMA_IO_BIT and, if
> set, treats the mapping as not mm-managed. This was previously required to
> handle drivers which set VMA_IO_BIT but none of the other flags which
> identify a mapping as not mm-managed.
>=20
> We have now established that a driver which sets VMA_IO_BIT must also set
> one of those flags, so the VMA_IO_BIT check is redundant.
>=20
> So remove the VMA_IO_BIT check in vma_flags_is_mm_managed() and update
> mmap_validate_vma_flags() to use vma_flags_is_mm_managed() rather than
> open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.
>=20
> [ ... ]
> assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
> now suffices.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D26

