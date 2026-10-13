Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F19519928;
	Tue, 13 Oct 2026 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913656; cv=none; b=VoNLsEk6jE9kX27hnjulGLD6Ve51/9B7rVDVfnzXNZsZ94V3XFUB4STINrAEgemr9LtYCUxacrKtab1/Y853ExQG4BJfScMD0Bg0m8EFT2272E4ts5o8Pl5SuNgWm0Ax+IlyNA8zzmIYzEmeOj6N2N5wgZcoGoM5JVUckuamaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913656; c=relaxed/simple;
	bh=iJt3VazH5xjJdC/oMoQ7EHqj4rdFTDEwNF1LLiGpjmw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HSi62BUuGZrXY3QZsuWBQzNzZzFhEVqJcROLybfjyBdcYWsAVfwh8FiBKQOQKm/0iCP1gDrsHoFM/9fRdUcOedfgtXZ275zz1XExCLyAM9edcLU5KjZ/4Fqz3nyWa11fcVBvc9FcD+fUWoktXX/D0KhaqP7nPMJmmEZoOe2sueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/BOf8mB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/BOf8mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDED91F000FF;
	Tue, 13 Oct 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791913654;
	bh=iJt3VazH5xjJdC/oMoQ7EHqj4rdFTDEwNF1LLiGpjmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I/BOf8mB5U0qunvapwogcv8DEPaiLtag4vW1dnb/6Dmob0KguRTRpkguIWrK9lILt
	 h4sgkCZBU9P7yecIJrMx8fLoPWWOuZ2AhdnquCVt4im4V52GknBV5yPoFF3at947eG
	 zIVqnJKqj1jElfmnnddf849prQ3Y9FteaQYHnzh6AqtYMiFRp7cjKGPJ9jDio9GQIM
	 6m4XfPWTnwM4xnk7xbs7WZVrFum3kRYPi65Dz4Br5a/a6iCQNHPvCr2wJUIwtipFcX
	 3uK43suTHdnfrGz0R5Mf2uiSSsXRpRLlGe1ZOx5fhApIVHHYkRkQshwCDW2DJdq0zK
	 Ll3Dpare4rZ6A==
Message-ID: <sashiko-outbox-170263@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/39] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-14-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-14-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:47:33 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>=20
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
> page cache or anonymous memory.
>=20
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>=20
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
> [ ... ]
>=20
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D14

