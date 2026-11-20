Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138043;
	b=i1kkIYJMmSeHqM1WZIN1g07h+a+tSilOWfwxzqZZ5ftNBoGoCTIYiehpelpWN2thLIr7
	 j5IzuEIWGpA0y0jwEhj7QzcziA3r1ieGri4Uy320p8mozKeoLxpkZLSW5Usv2+lVoSaTN
	 auL89lFPaPuOpmT4N997PX/OMqzCaazSvZOOvONF+367R7eiGdRATLMtBAvmOtMiTYgMl
	 PfnRqbDV/+yHyeEYN39amnI5GkcLeq6nmxmcaezEj4rZf1DAYzfvOuGC3m3s463gogLpD
	 oZwlkA2hpAC6wMx1GUf/5XTikZWWNnZEPT7PK84rQ1gUE2J6UkNzO5IR0YI/XWsKslg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138043;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bmyEuyBykzB64CxZ7JVI6mB0fb2FWwuHm4pOgEungCE=;
	b=NyCVtTDKdWZITierOBMZoQDu+gwi99QhmrvV0b44qQQ6P1lRpJNWeRlOMlN26JyAiEKv
	 y24fZRK/rtvvND+aR5QbmXmgZo0MwNHUrpIEnPujv5V22Rkxy0GsJWO9LFLNbt+fkIE6E
	 /Q2Xo2IeQCWVzBJJSvdppnnLWeF55FLguJH86ivRg/Ayc814qWUuym/032pU2ZqjkhWLG
	 ygoAVncn/VwH/1OVwKt6LAlqQLKeRIoTnVTWwMDlOlX9gi0HmSvdDOUdP4hDnn5FM9yw1
	 miPuSsmHDAaKcrY30vPYnPuk0ETREds04IOvqTKa6uC0vwTxKMK4pDQ/hImn5by9OSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBFKjnI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B93606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EBFKjnI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFA21F000C4;
	Fri, 20 Nov 2026 01:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138043;
	bh=bmyEuyBykzB64CxZ7JVI6mB0fb2FWwuHm4pOgEungCE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EBFKjnI5NnD5oGKUuxoY7vFPMZeKN2O1xugbktHxsBLnVNksvSUxmfbPRjIF0/jsY
	 LWRN7vQ+v6W8SEevdFHx7o0PlwNOBaKlpfYAcnaA8CNUVOZlPj1IEK/YHikMwX9KQ3
	 LgsH7s3G5NTA5/ZdcleavFFogMKUP3p7vcQhbqmPSMzXIXBhChZBBMXXjPC6SVTC0b
	 OCzvIzKvG3aINtbVHJ1y5qvi2Bc01qZXO+ggpcW1peA/n7TH4/xDeoWNcdSKLjWK5G
	 bz+h2z9jwb2VM6ynJU0dQy7DKE29MPj21UwBxH9hS14vu0sU0i+4rA4a/Qrat+rOjc
	 FMrg1KHMvL7Kg==
Message-ID: <sashiko-outbox-224304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Skip hairpin entries not ready in
 debugfs dump
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119012707.555494-1-lcy8047@gmail.com>
References: <20261119012707.555494-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:27:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/mlx5e: Fixes tag cites 0e414518d6d8 instead of 8a0594c09610
--

commit 1d92be457073f4715654759b7679a4d4615c15c5
Author: Changyul Lee <lcy8047@gmail.com>

> net/mlx5e: Skip hairpin entries not ready in debugfs dump
>
> Hairpin entries are added to the table before creation completes.
> Reading hairpin_table_dump can therefore dereference a NULL pointer
> while creation is in progress, or an error pointer if creation fails.
>
> Skip entries that are still being created or whose creation failed.
>
> Fixes: 0e414518d6d8 ("net/mlx5e: Add hairpin debugfs files")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

[Severity: Low]
In 0e414518d6d8 ("net/mlx5e: Add hairpin debugfs files"),
debugfs_hairpin_table_dump_show() only read hpe->peer_vhca_id, hpe->prio
and refcount_read(&hpe->refcnt), which are initialized before the entry is
added to tc->hairpin_tbl.  The hpe->hp dereferences were added later by
8a0594c09610 ("net/mlx5e: Add more information to hairpin table dump").

Should the Fixes tag be:

  Fixes: 8a0594c09610 ("net/mlx5e: Add more information to hairpin table du=
mp")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119012707.5554=
94-1-lcy8047@gmail.com?part=3D1
