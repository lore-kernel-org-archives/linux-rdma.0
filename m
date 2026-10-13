Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BF95012B7;
	Tue, 13 Oct 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907316; cv=none; b=QuIMFU3G9KaAfc1xstxKwfPZdvhXZOn+WeUAJmYpToM1SHMAyWy/of4KGgaJHf84b6esVc9A7tu5GxRRcsbCqB/SS5O0lrDMjF3zXyWXXMIHlIBewgwQDxJkbOUVIqfwFvuZm8dFCS0Un9qG3Tx5A6G6fmtkIZiAMRamGQXE6YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907316; c=relaxed/simple;
	bh=t6DzFkLjIiDyk9waaTwEpoZQYy7bKnI/gr4fh2+gNg0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JUQrlvXFmIg08S7+eYQ9CqRwZ8k8oI0i1l6ehHe+cSzCYuJmSKM0JSrzMp7hfWMJaODxjMIiibwiwk6W/WAUC0kvplOpJ36FYJiDodm38NFzWVWGVwgEfxnl3VimWgGQP2CuJ4ui/r9Br3EwG7r12MOOcMODEd4avVqQuXUaWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMwmj8eH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMwmj8eH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE8C1F000FF;
	Tue, 13 Oct 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791907314;
	bh=t6DzFkLjIiDyk9waaTwEpoZQYy7bKnI/gr4fh2+gNg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GMwmj8eHl+vyjP2uAz9zB4l1eDACTnEXQuR0A05ZDEmU58zcg7htveLuxtGkhaiVr
	 lDjAXNQyW+9bBzSAlqf5hvZYb4Qi8XjteE+Ba6h5v4Bp6w346ewTQqWcJDLI+SGSiL
	 obB21vftOpTpKf4IDN5pP0gSXgde2EZMXn4XJD9IBGqKkg8n8FME79G7vKcqVoME3P
	 A3NSCT1nHNYq1N1izBrrSL3nM4qA3r7w75fBVEX/v58lQWoi6YCSxt0umcARI5bHHK
	 XKbf0rm1T+AJkq2HflpFrseyQy/y6tukfdLfGCtkvD3cZ7gpHhkdnrXqRYMvOBZv1+
	 Zt7prKtc94p4Q==
Message-ID: <sashiko-outbox-170080@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/39] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-4-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-4-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:01:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>=20
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>=20
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>=20
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D4

