Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023949AA4E;
	Tue, 13 Oct 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791916446; cv=none; b=LiRn2KSTvAoQsochtXiKWSZ5kvn4AHBcS2qjrhc6Wfqh45zBSQ44cocaxfw22xJrpmTgRd+bMifnxP78k5BSbN77VPXEJAtsII++yFxSuF476NH2qce/8S+Sf1sS69qJ4VN6QRFfwP3g6EzaK4ZWGkX/xbtzHVPCxhjYRuUC7Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791916446; c=relaxed/simple;
	bh=dMGTN5mN0JWgXMdT2pBrEcUif2Y/jvLE76mI/Fmy0iM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GwC24EOlzmzpOEpRsASvT3UkHq7XMxmCJxe5ORIjRAkP6pPYVJyIeGkgvivLcEvnZ05TIUrPD+7LnrAlpAEvOX17TxjvMg5O0NopvDcuGQTcxOZCHA3N5wND95GqpO62YvqkGzYFJWfgRNs5g1f22At5XayF3GoDefyrL+0AZFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6V6YmIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6V6YmIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036011F000FF;
	Tue, 13 Oct 2026 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791916444;
	bh=dMGTN5mN0JWgXMdT2pBrEcUif2Y/jvLE76mI/Fmy0iM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A6V6YmIRHW+lbrtNjwQ1jbhHJjZKJwKeRjpHste9KRVLZoFB/Gd/36Oa9kS1dE00a
	 bJDNOtBbG0TT6RAl9vi5EACXIM+mikzSoMiLgmpdA4HhvSqj3APlDqj5LOG3iL7sA0
	 JXnoiBTg94X0z2e380G4TnIqND6emzptYlPTDqh/ItZ92sbD2aUg84hRIaZ8wFt/hh
	 GgljVLWcQT6x8KSszkZMigNZB67NpgpfZrmwGmcikKpyx8V3an0n7l+40Sx+26TCw6
	 hkvmEc0lizz/jEyHasaTiCXIt1aoMTadAj9bWyTnpbqj5ZILYbnd1LVfT2r4FJ2FXX
	 BY29H/yu3mueA==
Message-ID: <sashiko-outbox-170334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 19/39] fbdev: defio: assert FBINFO_VIRTFB, drop
 VM_IO, add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-19-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-19-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 18:34:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>=20
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>=20
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>=20
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D19

