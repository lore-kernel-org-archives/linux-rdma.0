Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B72346E54
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 09:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329322; cv=none; b=jakvUs6CpjhQwXoo0uq/l88lVQv5muB9QJcDf4t5Cx/AucIjH7Z3+loAd0BbvgqFuVnIzeG8yzdryV2ylK6Pd7kd78XZYPX8YfmcEXHhtSHdpREmp0FaEMDsqB3HArGqxgMnufezJYoXrbYW9hdCNR2HWLK04A6l5v8/N79nMSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329322; c=relaxed/simple;
	bh=nIY52/fbMoLnRmi/26/adQDvq+ak5mRH8saNe87zq/U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eg+aq7AYNhPP6ptJ5tCXqrladm06MXs5OoouXeHpJ96YW+kQVKhNnirMUM8CETv8KZQ0bIiLcCyaVcXutF+X7UP/QkT9QpC+SFmo/yIFdZKda0zWHfMTK95SZZF7GgMykxLCpqlkJ9Blnq3gq6JbBRLeQo/kI3FSDDvfiBuB5PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxcmr7R5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxcmr7R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0DB1F000FF;
	Fri, 25 Sep 2026 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790329319;
	bh=bdbXI87vSqEzZHzEdPClX/97QvgJrMlU1ViYv2CugNk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lxcmr7R5q+EbRT3kCy3QnO3ds5+4W2w8V8qiam3IVkLZk1vlvDU8de/S4zk8yUQ4P
	 bykKNq/rGinzOPiOdZ55odzC6nR7REHDCwsKsDZ6rt78+4rz4rJRH4IUrmR+6WYpyC
	 hR5uAHsEgaQFKNPAVWx28fJAI7H5Nqql19asZWgoSwv+TxYntkH9Am/q9X5W1PkSuF
	 clQSfM2HFcUOx2bTTUb6oLK5UJWTOXuZnjYhd9oe0F0AzE7OD0HuHQaMHiyE56Jbp8
	 NmsmuS7GbCa1+rYGKyi3McyGgiPv6LPETr6Mxg6RtfhnXaB37RtZonLuKJwWm6KPsB
	 B5yObFZV0QGXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] RDMA/ionic: Fix XArray initialization to use XArray
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
References: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 09:41:58 +0000
Message-Id: <20260925094158.CA0DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> xa_init_flags() takes XArray flags (XA_FLAGS_*), not gfp flags, even
> though the parameter is typed gfp_t. Passing GFP_ATOMIC leaves both
> lock-type bits clear, so xa_lock_type() resolves to XA_LOCK_NORMAL for
> qp_tbl and cq_tbl.
>=20
> Both tables are used with the IRQ-safe accessors: xa_store_irq() with
> GFP_KERNEL from process context, and xa_lock_irqsave() from the event
> queue path. When a store needs to grow the tree, __xas_nomem() drops
> the lock using the recorded lock type before allocating:
>=20
> 	if (gfpflags_allow_blocking(gfp)) {
> 		xas_unlock_type(xas, lock_type);
> 		xas->xa_alloc =3D kmem_cache_alloc_lru(...);
> 		xas_lock_type(xas, lock_type);
> 	}
>=20
> With XA_LOCK_NORMAL that is a plain spin_unlock(), so the sleeping
> GFP_KERNEL allocation runs with interrupts still disabled by
> xa_store_irq(), and lockdep annotates the lock with the wrong class.
>=20
> GFP_ATOMIC also happens to set __GFP_HIGH (0x20), which collides with
> XA_FLAGS_ACCOUNT (32U) and silently enables memcg accounting of the
> XArray nodes.
>=20
> Use XA_FLAGS_LOCK_IRQ so the lock type matches how the tables are
> actually accessed.
>=20
> Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925093638.3032=
149-1-abhijit.gangurde@amd.com?part=3D1

