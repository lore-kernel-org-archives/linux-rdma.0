Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A211B30EF91
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 02:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117193; cv=none; b=DCw1hIkGRFaM4RDc5ncaBojHNvXdMXTQIoQf4AFW6rfS9j8NJLPWX2CRsbFHRdPCo53hGyKvtEXbXm71mx8fGuATZrUTEOOViGVqS2cfy95pgTEeZL1jbEk9zvvTZ6lfudtwuER6D716g0GHCWK6nzhXrY3Eh8doaaFS/U9SzW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117193; c=relaxed/simple;
	bh=1b4+ssV2GUJmG6mvv6ajWogYwgjZhU6qgvZjlJ/8ZpU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ksrTVzyqwePjq6WZV7JWRxBM/JVYrkyMUa3SHwM/3bQP6uXxX+w9Ua1RH4bqoFposRyy2YGoyDsHT7e2SjbKFib/fwk01UTg5iGmGw5zf6l3fBeBc2qyunGfz19WjsL6zxd7RvtEPa2ZUD9h0lHty3tdPNfvOgFGUgCqX2Q4QjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lg/NjMWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lg/NjMWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166FC1F000C4;
	Fri, 16 Oct 2026 02:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792117192;
	bh=Tfu7t6TAcOFQSSLIICmpxKBkBG0RDOAbdIKg+cS/RY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lg/NjMWrGKYCK4gSUcLnGGZNgBVHjRClvnzKYE4jKCJiYFvo/1pP+1mFKeLau7Zsi
	 Mwyqxj29ymDdNBD9r6u6AKhCSyOeTguCMYHV3LT88Rr3qgvlWnPFZZ+tmNz0a85UIR
	 kl57tRjeYeJQY1kkvNWfUUR//e0JbX9EPuLyDbiTEECFdMf8hwjxnrQVwftuoL6QzQ
	 i+pyEL31r1ehOLAh2D5nzv2liOdrQ6WijVdo1g0v3n0HcvQcITHBA44ex2lv8fpph8
	 NUVk3qRTUGc1Gqn9h7/OU59MOMHbDzuuQl7lvO6DljwnWevLzfWRHlfzD0sufx7tnX
	 dxFksR5Fmnj/Q==
Message-ID: <sashiko-outbox-173617@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Clear pkt->qp before the early drop exits in
 rxe_rcv()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhiwei Zhang" <202275009@qq.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
References: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 02:19:51 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
> uninitialized on the two paths that take an early goto:
>=20
> 	if (unlikely(skb->len < RXE_BTH_BYTES))
> 		goto drop;
>=20
> 	if (rxe_chk_dgid(rxe, skb) < 0)
> 		goto drop;
>=20
> 	pkt->opcode =3D bth_opcode(pkt);
> 	pkt->psn =3D bth_psn(pkt);
> 	pkt->qp =3D NULL;		<- too late for the gotos above
> 	...
> drop:
> 	if (pkt->qp)
> [ ... ]
> built in the environment used to prepare this, and the reproducer is
> left out of this message on purpose - both are available on request.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Zhiwei Zhang <202275009@qq.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_1BF6EE2B585=
3D22DD4A2F3EBADE737905209@qq.com?part=3D1

