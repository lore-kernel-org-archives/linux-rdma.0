Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEDD52F28B;
	Tue, 13 Oct 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913843; cv=none; b=nuhPonyWeMuJKI/PVW4e8GuACIG92uuWfmQkTfDhMuMqv1SF/OCd7FP552y3SkplFPeWe+buhuUAIqTdGqRgm3/DquW7s6I1t95YKLrp+JCQF+6yehrTomWYb0sJ7K4L0Vk/fTL34JMhV1m9e2JMdCBVrTVQG1wLUZ2Zc5h9KlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913843; c=relaxed/simple;
	bh=wRhKFjM+X7+htr9UcNVHN8TSNXj8aoBVlxl17byBZ9U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tJzbWcscT9zxsRUhOd8IkDHA0VjI8YohcBJpPH1a52OLDGnn6SQH2xXBlb3O6yOHFXz14qUlBmRpqeL85HOehxmm7nTl/wpzpC4Amk0mMfcy59eF5Qv5AyTyKb4ABLXhIllRadSa6tK0OKd0tdcG/SZv41YK8W28SizbU5+5kY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCBNXiQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCBNXiQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C56E1F000FF;
	Tue, 13 Oct 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791913842;
	bh=wRhKFjM+X7+htr9UcNVHN8TSNXj8aoBVlxl17byBZ9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BCBNXiQrCdVRyWzKFGcmujxQFiKXYx+B6VxtjZd/uHmJ9M5ggoetKb200Q1RXo5S1
	 UktgewNsj6IMvc48ysxsKSQZu2U9HWTVicw7pQ1M4+3adaKT72SILl5aXG+F62CVUm
	 aBAwMdxmTp/Yb6XRPMDYI4FkdVfHnUhkgtOcpvlYk7hAphTMeq7oEbtX8UsG+zLjsn
	 Zg4qdG0dUc1vCj4FHX7D7BtFMGzl2e7Vuedi/F8PQDnVAhgUqzKRGtXC8g5Ta2Ri64
	 wj2e02B8FoKMUm04MnQQABAitR63D/dgMDoQDAHsJjE6r4FxTjgo5AQxx9uNK5uwa9
	 nmwd4mRhoTuMw==
Message-ID: <sashiko-outbox-170273@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/39] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-15-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-15-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:50:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>=20
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>=20
> Otherwise they are instead owned by some other kernel component, usually a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>=20
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> [ ... ]
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D15

