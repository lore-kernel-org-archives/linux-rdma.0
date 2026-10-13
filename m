Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FED513560;
	Tue, 13 Oct 2026 16:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909843; cv=none; b=h4f4ryn/omrmOAeekzH02niaCupZtg3yaYULCbEVdXU9WApjzYy1vtEbvUYIW4rR1Bpmm+rvskG13ziwHh+mQxCv1qxsxJKHKS2ITGD53LehNZyRUqx0XkX0Lhniv7nfkBFifDfYim+jETVG0wg4sNOIFdVCFNxJkRzpXS4jNVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909843; c=relaxed/simple;
	bh=6868E+xww7aXQUGRqUd13HGIKoj7XO93CAl9j9FYit8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tmPacu0orNs5I7pCWxLCLafvn3cl2TQwoyXrD8QWz5nyPQYHTc0R+X9VjsC8L20azb/2Rhs8vzxYk5eTIyscqDdcgzQO7yK70ObuOBg67RCBzx+oXTKk4qajwzSlyPmNXnMPkoH9ABrlLQjcwOQ8iQNEwpmn0yZM9ER1VzVk9sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMEEUTky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMEEUTky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6FE1F000FF;
	Tue, 13 Oct 2026 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791909842;
	bh=6868E+xww7aXQUGRqUd13HGIKoj7XO93CAl9j9FYit8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gMEEUTky8N+xuOFvGjBM0tLaOvsmO+W54yaBxEngBBLpb2UTxy/+G2B+wKDDgZRGl
	 TB9jEQAnWywuVCdhW68Z3Ubb/uDPsbYEPLOy/4aGvVkfNU00bIlewEyH9XGQVgaQDD
	 pMB2Q+l3DV/kXEaAVpS5INb8eUdX7lW8aH4DPe1SwROl2Rmb2yR6pvbxR8xS3dosrR
	 0uEU8ibxytsWHTy82JZ7rwxGTNodWuWIouxCHDkkMsWi16xa1qwoNqcuow17TfouqO
	 +oarUV62hircFCGlugS8HeiNOAb/NHwuVUfuEdYt91FnsJTREyYcO7sXuRfN92QlzO
	 1LEgzfdUPIrFg==
Message-ID: <sashiko-outbox-170144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/39] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-10-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-10-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:44:00 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
>=20
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
>=20
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to =
do
> this, which allows for iteration over pages in mon_bin_discontig_get().
>=20
> mon_bin_discontig_init() increments the rp->mmap_active reference count to
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
>=20
> [ ... ]
> access raises SIGBUS, as with other pre-populated kernel mappings.
>=20
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D10

