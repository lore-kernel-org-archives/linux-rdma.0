Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2711653FD45;
	Tue, 13 Oct 2026 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919689; cv=none; b=HljOZMBWU1JuSTU7qxGCu9noSocXxllwrANFS/5xz3NiICxhiP2fDuwH/W3WVY8BN3XWwZM/OP+NxNiFc2PkefEBR6DpUnKYXEp3UWJEFM66ijnxB1BizsvHBBa04XUp0X3ykg1VpdYEgMzk/2o3ntcIJwo92764A4R1I7AhRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919689; c=relaxed/simple;
	bh=aM34kbZet7bcdvUoiKku14PrcBj7DgzemPC9SZ4FMc0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bZucIXoFNQQ70ohcCL0RCIYgT7wrBaUiVf5U51ayILfV6r/k6zeG1qLgiz2Z2YeqAnY893i0BwsX5469YT6KsiIyghh9fNEY8UZFMVgvY4yk5ROrm7EqlahRVg3DzgLzLNhVySi7e1AZAQ/cu+WycQNlOjhBe8F/4cyXbA+55B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffgQ8iYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffgQ8iYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCB11F000FF;
	Tue, 13 Oct 2026 19:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791919687;
	bh=aM34kbZet7bcdvUoiKku14PrcBj7DgzemPC9SZ4FMc0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ffgQ8iYm0XR1/5ANMLl5HQ60JWvKgAOqXJ7j9r2aML3UFAr2uoLPaYhUfX3J6ON/x
	 QGTN12IaG8YYV/zu830hHCft4oEfCjmht2O4ExM5Rxzd5KJjOGAxakEX0kGaltmvLA
	 bZXiAY8F1S6UsuURp45VS3YMNl/Gh8uzokii4UiQ+C40RdXv63aieMGhDKwiEBJ4FV
	 M8qesqUXxbD9VKADk8jqBHQYc50jeGPIufMINNGwthJ1QBO4pydc3XdWmJlFsXceAe
	 5uYukv5r2V9++BQ1yCItpor62pVDe1U2fCRy67E/vYEoxqm50XsInG8fYIrjb1EX/U
	 C+BKqUsxWrELw==
Message-ID: <sashiko-outbox-170388@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 23/39] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-23-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-23-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 19:28:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
>=20
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
>=20
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
>=20
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
>=20
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
>=20
> Nothing relies upon this being set during the mmap operation.
>=20
> mmap_prepare is unaffected by this so requires no fix.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D23

