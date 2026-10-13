Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE11251FCCC;
	Tue, 13 Oct 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906697; cv=none; b=uQpNousDunk8jC429zhOKmUHV0I1qONY8GNoFa8LHPOGGY33e2T7lQ/3kZHhn5pQ4yAJV8OvdJ+GBY8iYaGUKasloKyuFhaSfZJWjpVyDqBUy6Kr7EHAFEbUUWnHCVpq4V7GXoMefh+/77WAKkwwt9P1EDbiDUaXF8TulDwDlE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906697; c=relaxed/simple;
	bh=CL8Bt3y+26GnTa3Hx7rUpCw4fnixt3BZgzL157rkuBs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TeK/3WM+6GAW9iwc6lIONgcey4tvomrY3qB69+q8ZAJgcAWnaoTKjCXhZUBA240bxtdvAIZ23cZylo6G+MWg6ShglDmlsZs1cYWayG9b3xxUuy+sLZ0Z/OgVMZ5hGfVDJiezD9bZHHu0e5ZZwfNXBgzld4wk9KKG6kljohMS31M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvlE5KUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvlE5KUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6711F000FF;
	Tue, 13 Oct 2026 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791906695;
	bh=CL8Bt3y+26GnTa3Hx7rUpCw4fnixt3BZgzL157rkuBs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VvlE5KUDTQpkb+ax7hp92/7vWt9VN1obvC5O6s6kr5/hp6eNJhv4Dz8NDbqZQo9ND
	 YZWhTDMUNrc5+Qeq0UgfAaKBdSnOZ4M7tz89EwlH1hc4GG7arRrdcTQ6DrQKUJfUmv
	 WLH/oX0fwHGwHmR8z9Re+7QaAKj8u1HSibH3VTennqo4IMC1PbS0Jm+I+9+tS5sDIB
	 0kf/47r2rXpa+i6hiTD5GFNzWxfsQhAswSyoJYt9lSkfuE0rrr7/Qh53cMbn6/08dl
	 kyJeHACzRLH9AUqDpoqYg3BFocRbQpZvSmFxgIeQ2PeltT/ibMj0CpjJUf+p8FZjr8
	 GtXGni+Y8NmGw==
Message-ID: <sashiko-outbox-170055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/39] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-3-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-3-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 15:51:34 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, t=
he
> driver might have done something crazy that is not permitted by the kerne=
l.
>=20
> Currently we check for three such cases in __mmap_new_file_vma(), but only
> if the legacy f_op->mmap hook is used:
>=20
> * Did sparc ADI result in invalid flags?
>=20
> * Did the driver alter vma->vm_start?
>=20
> * Did the driver make a file-backed mapping on a read-only file writable?
>=20
> Generalise these checks for both mmap_prepare and mmap and apply to all
> invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> in the core VMA code and the mmap_prepare compatibility layer.
> [ ... ]
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D3

