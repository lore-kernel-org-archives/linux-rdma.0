Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300293ED13E;
	Tue, 13 Oct 2026 20:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791923686; cv=none; b=f528EwrQbuT94ATHYWa4lL5VY8HbUoiH0ctcN24F/FdFLlXw4gvktN5YUYXnRy9LxoJAAgOfrw50qquBx3KD1runMV961ygnx7Wl0ZiYIEtWt1d2nKmKrnQXsqoWtYwjOiouGTJR+Zr9SU/u+59s4AFo/2ZClzCY+rGEgN4+xZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791923686; c=relaxed/simple;
	bh=D4dBQMVImij6FKBPDznpNCmWqLg4JEmdsPgP2iwQHM4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ybbrv1mCWfBSg22DrIs2xLLHt0WG55utr3gRDoZEHSI0qVdgkcBUeCMYBKxWJgMRFFILp2MtDVkKMVxELmguxcxxFSYuwpA/zULriQytoBhBSZQCMy7KfklbEd5Nqo5kLC51PKHJd9EOZyeAWMmsxd7g05zCP8fsd+GbBktVzc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRUooKs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRUooKs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741571F000FF;
	Tue, 13 Oct 2026 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791923683;
	bh=D4dBQMVImij6FKBPDznpNCmWqLg4JEmdsPgP2iwQHM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SRUooKs6k7A+dtjFZGuGv+yjOn5xNzQf2t6vE7DDerxgIa9euXfAEzKZqgGriGaKV
	 iQvcWOGMznCnDqzHXR8HagxFpsqutkK1wSrbinn+IlCE8Le+sv47zj3OG6T64BGuXT
	 TeIkz3jwPPl1KlwvFqh8kTFamJZzIGoc0rtK86TsZfRRCWjj6jlCpO83WS8JKkGQu6
	 4U9KCvdyc9towrVxcx90TePCnk1mIW/aXn4kL7nH6JXziM2s8HtS1RYXA7slhyQts4
	 5Liz87vraRfEIN8b62GFKsORidsI9B2pCO/ZQSHWxTvUKjWEWHzef/PiLj4neu7C5E
	 UhGoOtzVpjsRw==
Message-ID: <sashiko-outbox-170467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:34:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> mappings which are mm-managed and whose contents were placed there by core
> mm's own fault path - rather than a custom ->fault handler.
>=20
> Mappings not managed by core mm do not fall into this category, as they a=
re
> populated by their owner, and nor of course does memory-mapped I/O.
>=20
> We exclude fixed mappings as these have a layout core mm cannot assume
> ordinary fault semantics over.
>=20
> hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> already does.
>=20
> Use this functionality to update the madvise MADV_DODUMP check to test for
> [ ... ]
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D30

