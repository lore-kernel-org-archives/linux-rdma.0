Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553534A2045;
	Tue, 13 Oct 2026 19:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791918777; cv=none; b=tQQhCbs8o9Kv36JvfcUcFEan/mbgHqYDCeCikuNgzJobCvWCg3ihM6oiE3ilkwVuDq2KMThySvsS9k2R7Uv13nj/fpWC5dt67/lg5nCEVakcCvwQcRUYJ9FJCrETPPBAqNqTTg5ka/3vLICa7K9yukzrKcyyUL5WIvJ5VJeZGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791918777; c=relaxed/simple;
	bh=fH4N8tAmhiU4RJ8c1GFHL+nGXghIrPNW1WgJ34BLZdg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GmtJavn5iKacG/04W3BhDd/OWvTsxy8F5e6pz1xosw5sw2FdO4/Q3TzF5YE+7FpaYc6V42BjoeUyPnDbjxJDzUE/lfFnTbkSaNDI/6f5uh8x4rE3F8hmZYXwcAohhUwKTA3pbvFD7S07DrnwkVVlrXjpXt/mhdmrc+b8sc6o9vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2eQL6Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2eQL6Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930621F00898;
	Tue, 13 Oct 2026 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791918774;
	bh=fH4N8tAmhiU4RJ8c1GFHL+nGXghIrPNW1WgJ34BLZdg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c2eQL6Xl6dXfohLiWHsIcEdldCVS5ErAyt5bRPew/GPx3R2JUjAdEJXf8cuMwvrvK
	 Pq4GczlYsCr86pms2ThfXW5nRO6vCU7ua6QxXurLGpp5MBjL0rciJ+BnoT+wUQqYtV
	 AR84lq/qb194d7tIFOcVUSOaj4dVqFCYtQXHOqRS5Lm5bNxH7eOl1q3vw0vV0YuG5d
	 EZroR3zU4LxcP7QM+lrpFXSVQT8Gaza6F9JZysdSmuS/uBGM24SD/sZm/wwd99BuVE
	 M7QnsPZRH8ExbUbnItCiiVJ6OUFRDtNpt6Wng0F7j3uNgho5O/YeTbGLX6YFWEIl4w
	 ta0bSYD2GZQNA==
Message-ID: <sashiko-outbox-170383@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/39] uprobes: remove VM_IO, set VM_MIXEDMAP for
 mapped kernel pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-22-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-22-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 19:12:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.
>=20
> Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
> the appropriate flag to set for those.
>=20
> This provides the semantics required - no VMA merging is permitted, but
> does not prevent GUP.
>=20
> However this has no meaningful impact as these are refcounted and thus can
> be GUPed.
>=20
> A previous commit already prevented __mm_populate() from being invoked on
> XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is =
no
> longer required.
>=20
> Both VMAs set a VMA name, so always_dump_vma() returns true before
> vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
> in core dump behaviour.
>=20
> Change this for both the core xol_add_vma() function and the x86-specific
> get_uprobe_trampoline() function.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D22

