Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486974;
	b=DxU51g9IpdXLST3t8+LaMbbDkjT9MBynCthWTDwYEksbYkaYieu44OuWOg/T+pg1nCsd
	 8v89OyL5ryobnpI2gvO0EO/eBNckf3YbYoOGmuxfwsxCWWInFICmirrGdKtizA234fTd4
	 BYPOhdwGHdECg1TbU3z1TRGHBSsfmV0tCBHqeJTIm0DptX9aJv7pRBVTSpH/DFUaSbWUZ
	 bhC7kNosFyXch9h52mwsp32y0hX89E4ycqi1sGXIcghSjyrVgzHmFz9SDkJQSf5IAbWDQ
	 +oErUYx8XylSoe7omYExpDrQjG3ljrw/r+HlP+eNprXkaB/6YZAZNuuv8M0aRgC+LTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k6Vuq1WzDEw91ImvSwd+DyuVNfLrqVkP6llvwagyEyM=;
	b=hy70xrQ7HIwb3tA8r8DGslVPbGoRiRI5+izbwet/w70fz93vF6dUSYYVmeQWXkUWmRIX
	 g0rZ9+mXGBfkKsZnR3DKirRd4GBYQr1O4V6c9ouKbA42mU/KPgcL9WtrlpmKfhHI80Szw
	 Np8tuUZxhFWvOq07SG9j1ncG4cCoSzF61ei0/5mXCCjQNork7AcW2r2zZxMy/fUrVqbYQ
	 7DVdR+gF/MNySUqUriTrV7K7lxxSsBEmP0ANMOtwapPArQYPvfjAfvHGSdPNb80wguiqJ
	 fsGVbxId58Zhhfn5T8KwbueOpWNqCRvde3b+dxYUwGXSjk31ulfFt12BKiRMPAymKrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IS7ok0AB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBFE606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IS7ok0AB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4391F000C4;
	Tue, 20 Oct 2026 09:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792486974;
	bh=k6Vuq1WzDEw91ImvSwd+DyuVNfLrqVkP6llvwagyEyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IS7ok0ABvZl0zD/E9zwEGlo3fUoMTROfKu/JmDksTsU1jtXBunncPPFGLXA1VtvuH
	 lUyyU4aVYFKxw3oWmTrJ3IA1arr5vfbJuNay4umvwv6X4BT2Bbnf+pgWcenaUvt6ty
	 e4OudWxLOxzKTIJOnEo244RnLhOUqQ9V1LoAA87WKt0wcteh3P1xVFb6XI11wFByC4
	 AXA44hImlhKhTx60X94r+V1/i3r4vFlZo2jXrNO3uel1JBiqFpbYF1+esc/dsOqr/Q
	 UoMBN9ypa3wMaNZ36ZKuNAcqHNmwfRhpVEhg6PrYisqd6fm2WLpR50QhxPYji/wD1u
	 lDD5SROJeXvZA==
Message-ID: <sashiko-outbox-178680@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 08/13] RDMA/uverbs: factor out the queue
 pair attribute copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-8-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-8-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 09:02:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> modify_qp() validates a set of attributes that came from userspace and
> copies the ones its mask names into their kernel form. Queue pair
> creation needs the same work for a transport that is ready to send as
> soon as the pair exists, so move it into ib_uverbs_copy_qp_attr().
>=20
> No functional change.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D8

