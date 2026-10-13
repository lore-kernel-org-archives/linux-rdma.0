Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242151DDEB;
	Tue, 13 Oct 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915907; cv=none; b=oa1BqK4SnVtSysxGYTjTELcgQu0/xZnBCXHzlGSMxWfwQbw0N7DqVxlr0Z+5Oy1ThEzptK4VyXU5dI42WOiFHIB8W71xofr6KOZF6YosdjGoovun6b9UrofcUuNJnGFA8y0mkdOHSTDkSNA+7GO6CsRJPs5lIBB0OSbYC1BRkhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915907; c=relaxed/simple;
	bh=li/a6YbLGqEjXm3UWPm4r8L/fFx7TUvmqW68xWGjaWk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CrMZcmg0mX/MoZ4vesxCi7v7kvmNNIAuajfNDbciz/uBfpP/hUtPLyfvXGa5CTrEZSmRVfg+3YhtprWlRCJwaHipgyYeBQW1V/2/ZXjTyk+Om7KdlwdGwAo96+T3+FJ/3oeMWJ7H4q251bEw4VSzBHGC/cRup8cIu5uCEjCwqz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKAT2Bhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKAT2Bhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC491F000FF;
	Tue, 13 Oct 2026 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791915905;
	bh=li/a6YbLGqEjXm3UWPm4r8L/fFx7TUvmqW68xWGjaWk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jKAT2BhuQADlFkLgwi0TqX2Dcw2DQ4jk6CGqNj/986w3zZQzBH0ex52iWc+g/TlLa
	 oudZn6F3PIauHvhYQlbZXnm+eUpNfx+ixOoLGnJWxU69h1DseRJOJfNFmQqUzLgXkZ
	 9c/gpDKpEfj/uTVAjN+kTnkYA2S0/qMORNdV8DpMh8PEYpRtCncotjLjK/Ldv30M4c
	 kAAeXSKT4m9NGCxVg1sJEu7cZWzHQMPa5H2/0Isg0XXhiRAAiV40snHemc6OKp8jxO
	 Ye1+mqZQZT97QPiOueyAkFXXC4mlxBh+DZeIb/YNrHPN/caIxSMXBLNzW77BeFIYT8
	 gcFKYcppwTP3w==
Message-ID: <sashiko-outbox-170324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 18/39] scsi: sg: convert mmap hook to mmap_prepare
 and rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-18-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-18-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 18:25:04 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Move from the deprecated mmap hook to the new mmap_prepare hook.
>=20
> We are mapping kernel pages here, so use the discontiguous kernel mapping
> mmap action to do so.
>=20
> Unwind the rather confusing loop and instead map as many pages as we can =
at
> one time.
>=20
> Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
> the pages are populated for the length of the buffer at
> rsv_schp->page_order granularity as compound pages.
>=20
> The discontiguous kernel page mapping logic handles the compound pages for
> us.
>=20
> sfp->mmap_called keeps the buffer stable for us. As before it is never
> cleared, so a failed mmap also leaves it set.
>=20
> We also remove some useless vma, vma->vm_file NULL checks - these will
> always be non-NULL if you reached the mmap hook logic.
>=20
> We retain log output for consistency, but change what's output on page
> mapping to indicate that sg_discontig_get() does the work now.
>=20
> Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
> necessary as we invoke alloc_pages() which gives us refcounted folios that
> are fine for GUP to access (VMA_IO_BIT would prevent that).
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D18

