Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8570B511E99;
	Tue, 13 Oct 2026 21:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791925290; cv=none; b=Mbo5I8w20XIUICh/5xlay94odRaJkOusO8q33ua22RW1CsUZy1g9iYPgjDWio4YXUummkw2virNqiAJ62XuK7YtlM21qlt2dj19nJguxUxkvvnwj9TGMnIGJDfnuYMD+XdbgNycgeYUur+fArnpKBKZpEng8S6c72rG6hEOIsEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791925290; c=relaxed/simple;
	bh=sZBpQpUadceoBMH/ZvndmIicfOcoKzSaD702QVr/ELg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gAUOOxXzDszn4FFauV/Vq/rA0hwtvsa63BhnK91zylhBonWeKqK+TM5k89rKBKYFQhMU7Jow478Q86B+v1ydfs1HvHCKrrwXKWcu/yj8SJDgJi3VWwHJfayM5ioRJhP/C5AeB6pYLyLTgryMezKqheaiEYm/L9Jr1PWnZRDD8k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5iyKOEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5iyKOEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3AC1F000FF;
	Tue, 13 Oct 2026 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925289;
	bh=sZBpQpUadceoBMH/ZvndmIicfOcoKzSaD702QVr/ELg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I5iyKOEGDVO1a6Vo0mVKxSPizNMG81SiH8SYBx0pmjMVzO3El1dqQAabweqHcyfZB
	 hl3uPuOGx5XVdBOsABwAn+r9u1ypBHUh2lepFtUKppIg6taJmaT96teJRo70st8I3t
	 h9G1L6EaCJ5DrXL9BscLwdljlCJ/O7s3B1uVodPrvWKPzll397ce5v9ACJgfOCYg69
	 /PGAzIHJEbA8fQ4VQjgbvR/5Oj1EWdQnYpaZkfKge2NDFxfwa1Wz+Fj1rqwolYgX7/
	 aNCqAnOlDYctuOP33BKm7QjQeGNj/WUdknx4AeZVUaMVxOevxx2MwX1cIe9vZsriee
	 oXsXoigbrc80Q==
Message-ID: <sashiko-outbox-170502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 33/39] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-33-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-33-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 21:01:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
> and VMA_IO_BIT.
>=20
> Now the invariant is established that mm-managed mappings may not set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
>=20
> The rest is equivalent to testing for a fixed or non-mm-managed mapping,
> i.e. a mapping which is not mm-backed, or hugetlb, which is specifically
> excluded.
>=20
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
>=20
> Express the same thing using the predicates - only mm-backed mappings may
> have their copy-on-fork behaviour changed, retaining the eternal exception
> to all rules, hugetlb.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D33

