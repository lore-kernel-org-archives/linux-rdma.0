Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4089529414;
	Tue, 13 Oct 2026 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914942; cv=none; b=ji3Kubg9gUy+J0jYkMX4FOQ0I2p8d9AP5gUfpuJTA/rI2NYtoeWYiULn3JOvMQFZnTCTbHwhb01FmtZwRIMyYt7MCYspehGZQ6pr5j1luGVcAizjnyik/ZQN2VgGqSXLTqosZz/J3eX61t6HWSt3hqEZTDQKc87sgETyCHsE7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914942; c=relaxed/simple;
	bh=j3hOhUO59mMExzjcH9mU4/gx0DpGPd6xj/jUWkn/fuc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=R8I1hNPoJjbN/B0MYQa2XLdIhqcsEiwY7vtHGKqDY3SNyH4lMPSgOtymuwZQEf8lcELgImsd2jKs4Pd8KotsK4Xo9NqpZE47JjuKyRrAWYmZqa2wTJYTriGnQsKOehNwCCP4t1Ev/58mh5EfUa8Jae10Ybn5Tp04CQ9IkMep/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/pWmbjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/pWmbjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F071F1F000FF;
	Tue, 13 Oct 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791914939;
	bh=j3hOhUO59mMExzjcH9mU4/gx0DpGPd6xj/jUWkn/fuc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l/pWmbjGhN8TOLwxDbl0pBJTM8/bbC3XA1hiWOw1l4fwCMEh+7miJ9zPWOikwk/Cc
	 LE6qRXdh3tFdXEqdKf1CyjQBsZxaZV7nBt7usUqzunALX0LIfChg/QdwxHX4Nz4zHB
	 UWGvCD62UXsQXAE5r2s2ghrhUm5P3FS7w/aiTzF4+YSnc59z8FHRGP3eA9RpSyyPYo
	 //eqSW2roRfElMNv2W8UI9IHYHCTeWzWQluRpeJXtqmhxonQS1XuAl5CK+Mp7KIO7X
	 YuNndCuiupMFaTVxHcWuNJuBwWNWQw5tOZXCLS2a8+i2J9FhMvBmpixqSCOAYzdUK4
	 aDIt2DQv+HcCg==
Message-ID: <sashiko-outbox-170299@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/39] mm/vma: add and use
 vma_[flags]_is_fixed_mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-17-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-17-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 18:08:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> This determines whether a VMA cannot be expanded or merged because what
> they mapped was determined to be a set size at mmap time.
>=20
> This typically refers to mappings not managed by core mm, however
> VMA_DONTEXPAND_BIT
> is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> must explicitly test for this for now.
>=20
> We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not =
be
> set for VMA_PFNMAP_BIT's despite the one implying the other.
>=20
> Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
> mremap logic testing to see if mremap() can expand the VMA. The criteria
> for khugepaged and MADV_COLLAPSE eligibility in
> __thp_vma_allowable_orders() are precisely those for mergeability, so use
> vma_can_merge() there (with an expanded comment).
>=20
> This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
>=20
> Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> VMA_DONTEXPAND_BIT.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D17

