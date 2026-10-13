Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0212753C3C6;
	Tue, 13 Oct 2026 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791926751; cv=none; b=oQamEyDptAtWhpAQ1oTnyscfLVBca26MUGklANyOOf7TtCedz7wADRXGDFCHIqJcrAz4RO+wZKjIbS5mW8V5lUNvuLN32WOIBG+Cn9U4cFTfMs8Q2ylC0eFTTcFZ3qlA2oYLVB7/BMpWF5Jq83ifTa2BxfRCdN6fufGgu5jR8Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791926751; c=relaxed/simple;
	bh=Ak90i6SF7T/Y0wFmShH7yP3YyjbOoFwBSrlTbX3zCdo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d2pdmjZepVWOqbszcPGafsqNe7YO9FXomQDPqRPPUxiK1D7SHb9dCY/vEFW3y4sSdj9+K/1TYk0iFiX25yB1pAA1NbS5E98x7nDq8/RizHaCBKP2MFTM6jke6UlcL7Hy6iDXzjw7fk9XjhBTTYzBk1BltQdgDIE53EvAVx5pGks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HV1iv+FK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HV1iv+FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77321F000FF;
	Tue, 13 Oct 2026 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791926742;
	bh=Ak90i6SF7T/Y0wFmShH7yP3YyjbOoFwBSrlTbX3zCdo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HV1iv+FKkjuHR6nEWVt3Ig88a+MnrT823r9Zo/O3EzJFss8Pe1JooPBe/qh4IEZwy
	 ut59+/b8da6bCxRd95+P8wFZyN7ZIWVHKYiSVBacOs81P6/I3V9Y9E5Ofg6MpIc3CH
	 uJS0KPEtxGu+QAxlxJ8KWGhEdrBGpWoeRrtm1wxSqI+A63S5YFXSBrSZhXNNErsdUe
	 mnPKxHufqqEizCcOnnLqDWOaAb50gUHZ2bW7uabZYR1Gtib1QwsgZz/oZdzqWmCOGe
	 6AnC3Dtof1Phy66M2vI264gFZ/TG+16Q21EL3tADthit5nvwcdlLHh7XC0lWCx/fFM
	 ZS0OZmypTgJaQ==
Message-ID: <sashiko-outbox-170536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 35/39] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-35-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-35-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 21:25:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> mm-managed mappings may not set it.
>=20
> This is equivalent to testing for an mm-backed mapping, except for hugetl=
b.
>=20
> However, hugetlb folios are never placed on the LRU and
> lru_gen_look_around() is only called from LRU shrinkers on reclaim so this
> is fine.
>=20
> Using vma_is_mm_backed() rather than checking VMA_SPECIAL_FLAGS makes the
> check self-documenting and helps eliminate confusion around 'special
> flags'.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D35

