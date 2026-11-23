Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795426396;
	b=rivDCyLuchrBSOBzLVAiF8dCzCANH7Fm9Qqmh5MRRCcx/q7reDf8Bu3jwRX4ruRRq/Kn
	 G8zGyxxJNLbwMeUEfC2VhD8l06y18eDWiWxFiBKX8nIlDSRwI/wwXrpf5B74TdGlOnW/X
	 g5T8hU5XPnGdWXIiUkyXB+rcy0LR4SOqbpQCWdRnsZIiKO9cA6qWx4Ti3f5HS3cMm7t5+
	 8EwJs+Wqdv6/N3XN5aV5agrI7QXwazy62CGtojVEg+XL3HPTPnzHC09K5WvHoRRuOSNWZ
	 YyVe/H49AVFKkYFjxkL6GiRqqDY2Vd8HTfuRW+ZwDkYyLE2MvEMwkBTM0VZtWGKPoKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795426396;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GGmkv4nw2045Y5xoLlaLJyKcSJJx07dC/S1HeYHyLH8=;
	b=CQV/If++IuyT8SGcPx5o0ZSkWEu0ek2wfwZdUK6AQN9pLzUwr1F5DyG/x5UNI5lEdR9N
	 D9bq88medyKmjhQN6VIqWaHYR3HzFzzjM/CGznqUN1tyT55R+2hevqZDTLfLu6ed2Hwuh
	 IbePaJhTFDAxTRmPQ2CYsaryk2Ay5yg0F2AUl/8iwNDOwkktB/3YORmmjmfZyGLpFQjQv
	 ro7t9TJfVYFCSF9c5eaE5OLkQsS2An9kXgra0uuHFJbKOlqYAck1feRFfBnjTKrEyCiEd
	 70qbAkZsQgr+AKRk/URmdLg0Erjj2aC7QuS0XULoWSsZMuDv/XyppFojadIG6nN4gvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ck1p4wCB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D6B606A32D
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ck1p4wCB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0590C1F000EB;
	Mon, 23 Nov 2026 09:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426396;
	bh=GGmkv4nw2045Y5xoLlaLJyKcSJJx07dC/S1HeYHyLH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ck1p4wCBAnVZM0CVmguwj7ygHV43fbo2OtciPzX2FEEe/dhILOXQbrfUqPQHUdNn9
	 Bfpc5tfKKhbSvy85DSlb116hQ5rdG+hP2mK+YZXMVVWZvZyDl+bjisb3LueEwMDyK+
	 2siSKKsNMOdCJtbG1GuFVvwWfDjkHkmVXMp70+WYbkOCvKyzp1O4xS6fGHMNlp5bAM
	 glz5yE6dO/pma/kC7pcXZRdxJthFmfjvp+nIIUwwzYGIS1iCDrPD0j7DoWLzK/XiqK
	 8xNgGcjTTkpznaBlYHQssDlTLYJAUh1/dbz6GzArAZe0EOssCpFQlZ6nVOWFjEgyPO
	 h6b4EDjtV8mig==
Message-ID: <sashiko-outbox-228980@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc] RDMA/rxe: Allocate the MR page array with
 kvzalloc()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
References: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 09:33:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A user MR keeps a struct rxe_mr_page, 16 bytes on 64-bit, for every
> PAGE_SIZE page it covers, in one array allocated with kzalloc() when the
> MR is registered. Before the array, the pages were kept in an xarray.
>=20
> With 4 KiB pages, the array of an MR larger than 1 GiB exceeds
> KMALLOC_MAX_SIZE, so registering it fails with -ENOMEM, and the first
> attempt warns:
>=20
>   WARNING: mm/slub.c:5459 at ___kmalloc_large_node+0xe9/0x130
>   Call Trace:
>    __kmalloc_large_node_noprof
>    __kmalloc_noprof
>    __alloc_mr_page_info
>    rxe_mr_init_user
>    rxe_reg_user_mr
>=20
> Allocate the array with kvzalloc_objs() and free it with kvfree(), so
> that MRs of any size can be registered again.
>=20
> Registering an MR over THP-backed memory, median of 3:
>=20
>   size     before (ms)   after (ms)   change
>   1 GiB            5.3          5.2      -2%
>   2 GiB        -ENOMEM         10.8      n/a
>   4 GiB        -ENOMEM         21.1      n/a
>   16 GiB       -ENOMEM         85.9      n/a
>=20
> Fixes: 12985e5915a0b ("RDMA/rxe: Fix iova-to-va conversion for MR page si=
zes !=3D PAGE_SIZE")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123-bug-rdma-r=
xe-large-mr-v1-1-8d0748ac4a3f@linux.dev?part=3D1
