Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCB34B1B0;
	Tue, 13 Oct 2026 21:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791927213; cv=none; b=txpztp2Sr96XHKIUdarSrNO00gYBBuJak0cYXqFZY86xF1gzIRHunuT27jYeynS3GhCgHGPTnS9g+nWA49iRxxfX227EHkXa85uwiewJUkW9zc7vt7f2o2VujI8/i+Hb3JjStiEQ+96tBwFSO3I1VqRyTslWgzZEtROxLm0kF6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791927213; c=relaxed/simple;
	bh=d1tn6YE+HB6E0bzOKUd/l2KYHJnRq/uV9YyCMtzcOAY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=a+S0Cctn62YdX27KT1WcQs5s9j2+kz64uUB1aB1eB6gQAHxBn6VO4FwF77AClfpGSg731YJLtKaHANLl5dAM8ckHCQYzxHJuyOe9J/PYKSrIhRJI/4ITulvZY3u0VOp2V2hipnaDIom/ecjWOXQGX0YWVQse1S5nRd6p/ec91L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A02HfTIZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A02HfTIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA771F000FF;
	Tue, 13 Oct 2026 21:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791927212;
	bh=d1tn6YE+HB6E0bzOKUd/l2KYHJnRq/uV9YyCMtzcOAY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A02HfTIZ/V54vscTc8GYzzlznAR/odqt9vrqnBykeDxf/E8Vs3zHfqhiB8ZZpp2sp
	 nlDgI1w0vHwcdx5RF+Js0u7kPbMqJ1xlNlWBHPhdBVOO6NDyIQFVGWxpe7USutTm3l
	 7uMGbQMrBBnN8+dnajs48553hP4/0HAlVME1kbQQrMKvgym1D24ArhB0dwPjgP0KPx
	 x52l9nkIvYOo4fwtPYONCWEPJxNnKPzFjccbuifmojfU+JBFogO3afChuJpNPY2FZN
	 bo83YyLOEJlKc8A5tzqDSc5Pd/xPfKHp17qkVp3pteP15UA7poNL0Ep+OLUesVp/1A
	 BdYalTcBAn20Q==
Message-ID: <sashiko-outbox-170544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 36/39] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-36-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-36-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 21:33:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Now we have the expressive vma_is_mm_backed() predicate, use it to
> determine whether to proceed with migration. This drops the VMA_IO_BIT
> test, which is safe as mm-managed mappings may not set it.
>=20
> hugetlb mappings are mm-backed but remain explicitly excluded, as the
> migrate_vma page walk has no hugetlb support.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D36

