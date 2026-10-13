Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270FD5505C2;
	Tue, 13 Oct 2026 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924165; cv=none; b=eLx7KIeAfhBxu4aaMuxyYSetsbgmTsYsFCbOBvPd1VrW1tAv9g1YKJEfKHgtaKbgWSog0DHTYSAZC6d90FPLGxXu6iDnsvDDNpxE5Jy1iH0Z7BJAGvaiqtAt4hLmqScVUEPn5apeTb0GkYXZVUtAzslqNDu+gsN/xk6FJihotVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924165; c=relaxed/simple;
	bh=FdGHR8ErbiEOINE6M6o1dmXEFsXIKVwWDks+iAHQu40=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XdF8wTrz+u7tMtTHS7PQXYVLSpjiOzAWevWmeEYkmzSpCR2lJ5XEIJVzb/XDvsCXUiJLyO44yytAUt0BI+YAyVH8pkfwnZNc8Zl2ZFFPJkwrdQFNkWt0hKS5jawQGe7ASTwUgWGODNmNVSsCgf9SqhqmdXq+m14V4B0lW59TAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0WNNCzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0WNNCzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9CA1F000FF;
	Tue, 13 Oct 2026 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791924163;
	bh=FdGHR8ErbiEOINE6M6o1dmXEFsXIKVwWDks+iAHQu40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O0WNNCzsBLimk1XmmRIFQpDcW9UMZhafGQ+Zw64av0VYJ3QaMddTnLvPNl+TKNQF8
	 06BNg92Hn0qc7fHJi/bMVFcfls1trcCQE7PyfFoPJ+SSIMU/VkjNo9UEQq4zl0Rs3A
	 Ikjw91wVwTxSddvYG6o5OZQGZbtUZ39QqQN4SBjBU+UIKmQ2uJ14n6RX6daY4cg+3k
	 ZAFu3f4qKJCNQ/RkA187WRMRq53eOKDOhZs5tsYQHRAxYdaRsK6TVo7B7nkbgsg9Jm
	 6JACrrlijH07rauWG/FXPkWSd9G9+rp1YGPla/bHRl3WvLszf2YtCNfhGA6pCQ5Amx
	 08HkzQ9XJskRA==
Message-ID: <sashiko-outbox-170481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 31/39] mm/madvise: update is_valid_guard_vma() to use
 vma_is_mm_backed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-31-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-31-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:42:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> We currently disallow the installation of lightweight guard regions in VM=
As
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
>=20
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
>=20
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
> is set, this check collapses to being the equivalent of
> !vma_is_mm_backed(), excluding hugetlb mappings in which guard markers
> cannot be installed.
>=20
> Update is_valid_guard_vma() to reflect this.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D31

