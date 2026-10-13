Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FA3E5A32;
	Tue, 13 Oct 2026 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922413; cv=none; b=huL+cz+bziyhNXpFvjwm6AJWQGstehvYtqVdTgEV/B88rJre5/6B0HLsJSA6QPReHkUI43zO9FhHiC5IYqQtHUsOURxFvM8Jvn0GYRcnGAignBGT0CW84mkzWxr6woc/Yk9sC649XN0hFW3krG0ynxrZQi04XbiHJrnPKSDuAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922413; c=relaxed/simple;
	bh=o1UtWiq0Djo+zQyAVSKITV0ZCoSN+FXabkAiVFK6KWw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VzwWiuKwkze/kMptPBXlFkKFy6EE4/tBeE88wpRd5r1mjfORDqzL/VAyE/gJPq6k3NTZWCx1hrfePUd7ZWumULsjTX8IoxxPyp8pXtAeFtY2znvyz5ARrRVJ/tCTDOShAtyLekrjphMgpzAE+BHsIVWACnXUXh/or64wTltqckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNTiLSP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNTiLSP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39381F000FF;
	Tue, 13 Oct 2026 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791922412;
	bh=o1UtWiq0Djo+zQyAVSKITV0ZCoSN+FXabkAiVFK6KWw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mNTiLSP1F6VBzdXl/UtybMW8Num81BCgYs8umxO2WUgqnl/0fX9wEuN5E9+yLsJbL
	 2kRvkUSl4SFNRVwvpP+Q0Qye+JAKHhFBIka5y73GLp7WtpYUwAV96PuR7jQWgVumjy
	 W28jp1EAvQGmQqU6Dhw95nncxdpCRpvUJQqqCiZVpOJfqZEEwHiCEx+t/GVhZhoGX+
	 Wcy4o9re6vDvg60b7WsYQEg1Z8p6JT+PRB33r2FLIsw4WjXJceZyjkNJYPcOJIF6LW
	 8EGHrGaSJqS6esBi5gXf8mbxTyaKP/i39Ki4vjgnyup83neTWDivn/pQOJda3a70TC
	 R09xj9hksx5CQ==
Message-ID: <sashiko-outbox-170441@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 28/39] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-28-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-28-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:13:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>=20
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D28

