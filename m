Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795344524;
	b=PsjP3PLwZvUW9MYsQh30Q2s6VXcRzhV9+H6dlXo80oN7nN5hNQn2f1U6YB4TInILrqro
	 pWhVwb3gvlIcTNQbtAMvr5X3Hqi12oOHxjSenBZnmt2sSaE/ki+kkbDLGzikBxQPtJwZs
	 CIQ+S38bQ+cODGmXT5R/maUIqKco7TJdphFSyTLIoq7HDo9NREZGp/nsOvk+WqM6mTQRZ
	 ZPa/7AilhOaLSzaOOqxUkXoweqy29IDhjWrvZV0lt7/3NMwz6G9GhEbZog77Np3QR2zRR
	 r4XTJmzbg1OOtpeT6ZYGFiLd1x7Q/FnF4CwSH03ws0VkLD+iQyYk96fmfCYkrpX6XPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795344524;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yB0RtNLcITCiqkA59EcEIO7uI1q7BIi/BtSvRE845M0=;
	b=Sldi2CQAw0ZdkDoPVeDqqFG07YSIPBGelZR1GFKIUtqFhPw2sd0jqvFpDCpTBQr9BsNZ
	 vJq/dJOI8GiUK2WZPg2HVS8OFwoVvjzB3U+VjvsNgDJDB4x79NhDGcotVQhnlnlExsDfR
	 kevzc8oOiZihZ2rPPfp+G2/J4a6R7NtXG7z4FJIioTJcnZNy5Cphbksl5FGG+sRguKqWm
	 05/WN3uKonhsKY9+sEFNIcpAX6h0W1oUa+ojsIjslF1WC5RBfe+oFdUC49uequcjGGYWc
	 olqiIY/HV62iShkElGDepFeNIh8ZvIdUeeQE3s5AqlfJCnO2um475xJM74l2WMl+GKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EFK/Qfjq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38697606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFK/Qfjq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF9E1F000C4;
	Sun, 22 Nov 2026 10:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795344523;
	bh=yB0RtNLcITCiqkA59EcEIO7uI1q7BIi/BtSvRE845M0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EFK/QfjqVmC7t7HO1mNV2yv8kQHtyyLywTGd1zuVug9u08bLQBKPAojvJuDwuxILU
	 uEcrLGDCp2K6/dSWgsIeGo93x9D8VmTLK9C9kxfPgl7NLpmPOL09D9IoyCpSi2Lly+
	 26+nGn9FP4j9FvQEIfjDrwPMRBBxI8I0SuqpqbuZvtt4pssjvBWxfT4aJUz/+rb+M7
	 h++8IjbmBIPScJbIbBi3t0KTNmvkwg0rAxh9QRWbPnJz9tjm39r4ucEM00SxJF7jE8
	 wku27VA4giSv44wlTET/g9iPGeHCbuKWjA4CJ9iFseFabs1f7/WnTs7y+nHbxER4Qg
	 gsT9N/Pw5aV5Q==
Message-ID: <sashiko-outbox-227899@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Preserve DEVX objects after failed output
 copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122103715.51731-1-lee@jaeyeong.cc>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
 <20261115135123.GD42525@unreal> <20261122103715.51731-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 10:48:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A DEVX create can successfully create and publish a hardware object
> before uverbs_copy_to() returns an error. The error path currently
> destroys the object directly and frees struct devx_obj without checking
> whether destruction succeeded.
>=20
> This is unsafe for DCTs. mlx5_core_destroy_dct() returns immediately if
> the DRAIN_DCT command fails, leaving core_dct in qp_table.dct_xa. A later
> DCT_DRAINED event retrieves the stale entry and completes the embedded
> completion after devx_obj was freed.
>=20
> The failure was reproduced by forcing DRAIN_DCT to fail and then
> delivering a DCT_DRAINED event:
>=20
>   BUG: KASAN: slab-use-after-free in complete+0x1a7/0x1b0
>   Write of size 4 at addr ffff88800b112ca8 by task insmod/77
> [ ... ]
>=20
> Fixes: c5ae1954c47d3 ("IB/mlx5: Use mlx5 core to create/destroy a DEVX DC=
T")
> Cc: stable@vger.kernel.org
> Signed-off-by: Finder16 <nakamurajames123@gmail.com>
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122103715.5173=
1-1-lee@jaeyeong.cc?part=3D1
