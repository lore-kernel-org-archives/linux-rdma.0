Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED7B50B428;
	Tue, 13 Oct 2026 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908049; cv=none; b=FNKKC7ih36JsSNUKuwcDQNCErmt6M5BfGtA0nka3MNOVERKS6RvjPKypMw5JGjSpcG2pON95S0qGYJ+5bV7FGKs3xsQp464DcmIE4hmZCagZlcmkKRSzPCkQAmknxF5+kSm9PRu4zjb/Fp0ip3+PFO6U2XKk3MIK5P8+oC7khh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908049; c=relaxed/simple;
	bh=BGFgv5ezPQ438hvNwVGqqiJw9QZGaCdPAGBWGwT235U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DuEKhJ85MRrgT362lsVCPaqsskDn3iF4wAthmCtq/DUsDzhLwQai2x4N8etlnjWMISs+bXdXcOiDJ+aEzINaAiP23/kOTxjBc6Bgf4+lUJz6FyZQE9Tb0ORcMseeLO5sXmuJWaxSTldhpf6mf3+l97Gor01vFnqhqPSjY8deC0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0rkx26C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0rkx26C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7132A1F000FF;
	Tue, 13 Oct 2026 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791908048;
	bh=BGFgv5ezPQ438hvNwVGqqiJw9QZGaCdPAGBWGwT235U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A0rkx26COOi3et2UA5FmQNHyhlgWT7DrwMbS+1lJRTcUrPHPdLgIRtniZk0dw7Z8M
	 IaSoSxcktNODfIXr+smPInpaEknsQ2637Q1QSGkvfmuaspjh2JZplg3gYK1iFT4ig6
	 cmOpL5Su6FVJ8pICeBUKu8PWwZJJZznXtwDmAd7pvmD1yC9Q0YC2liieoTzrDwhS+9
	 ZbCFOhSKB9SptNzg7/PJxiI1n7OvTXwk39UX0Yj2Gd8KjEyqdwzZVTX+e0U+PBhFoq
	 5l1BuXpmSBwzLZ0x93cGp2xNbHKn/e1tfeXpBnRTcWW7CJn0Asp2YkTsXMCoVbQB4g
	 8nkb4CkH3vG9Q==
Message-ID: <sashiko-outbox-170100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API
 in vm_insert_page[s]
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:14:07 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The existing logic asserts that an mmap write lock is held, bizarrely, by
> asserting that an mmap_read_trylock() fails (which is not the same thing).
>=20
> Assert the mmap write lock here and switch to using the new VMA flags API
> while here.
>=20
> Note that the vma_start_write() is explicitly broken out from
> vm_flags_set() here in order to use vma_set_flags() safely.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D7

