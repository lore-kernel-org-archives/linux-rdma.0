Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792893857;
	b=MrMMGH9i3nCJgjqFwENIPqQDqrtWH7cHHX1VXxJKJKJSE0kmsUyiXdaCJuCjsZe43Vk3
	 sbV2xwVXiJm4WafikEzGfsWgQCnA16xcsvTCTG/WggF3usuwBK0NwaM/21QOXD0IUNjEv
	 kG3NkM8J/4aJxp41mg0N1N60M44nSQqNZiEYTd3kghRpVDXdmwM80qNtz4A/FSejEng6A
	 UCAQ69Q27RGO9S807uvWOruVry8v+FJEIMq/Alk5iAm4JI6lAt5FK4VbSJp7ToN0aPWSv
	 VYsA9Gw0eeHRJV2hw4FIwW1NGSDtultqiicrT/8M1gFfzGEgjW8LDyZV9dKFBgc+H+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792893857;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d2Q//byT7O7ar0NPalmFaIg6+2sSsrS4ldQbnr9CfKQ=;
	b=Xrsft1oJ7CihFbNhG34drjYXvwuJk5nnwqkSHWpiB+MeQgeCchhqe+axfSCmsnTsfrSE
	 sQHBQ4s9p87mH3gvVKeqeQrcTOGWQXBbrnEDl5KljsuQhW/TDYi5OmFxVW/iJpDmW4+yU
	 p1OXW/Z0d1aLvMm+d5NbyaJLKbM6Av9ZIB5HCiMuLR3NXzgGoi2bEB8ysJ77RiUl8BwV4
	 xpYuemamfM/Ku9M5iMaNmO87xBp7eXvZu6NDKjw5UkGGMBdfpBvVxeP33vwqgHDJAMFx1
	 ME1yRhn5mO/k7qVQk6+sZA/zfiUQLwTfG2jVZdutr49B1DLWu37YIHvt9fQLI0yYrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ze3nx+3A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC8606A31B
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ze3nx+3A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3D31F01825;
	Sun, 25 Oct 2026 02:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792893856;
	bh=d2Q//byT7O7ar0NPalmFaIg6+2sSsrS4ldQbnr9CfKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ze3nx+3AxzGwtcpbUgVtjbhncIpWTRURTPk+lNfe4+AVOwOHVQljsb3foJ3+i9Qxl
	 +ibGSMQCTcps7J2p365c7wyxlJcGduDIpt3EVnExINYFRDjhWLnmssKW8+HsCMFSGF
	 /Wosml64aN335WuTp6Mymq6kROKwk/6Vfe0Dg9bGB9s+jxW9OTXZBndw8fNVnU6jhX
	 ukE16RoMs0QQFB9LvxksJJLFrPrpYGVt30f6Ku1dPIdR45KOsBPeQTJ6zmNpezN24g
	 The5yT7Yok159XJv0200UjAlymABU7bVBjOLWubp/HalH8PbRBR/KrAFVZvrZ60kUf
	 rTIgPF1nj7Olw==
Message-ID: <sashiko-outbox-183974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/3] RDMA/srpt: bound the indirect descriptor table
 to the IU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025013748.3755639-2-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
 <20261025013748.3755639-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 02:04:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_get_desc_tbl() takes the number of INDIRECT descriptors from
> idb->table_desc.len, which the initiator controls, and checks it only
> against data_out_desc_cnt + data_in_desc_cnt, two more initiator fields.
> Both are u8, so the pair admits up to 510 descriptors, and nothing
> compares the table against the receive IU it has to live in.
> srpt_alloc_rw_ctxs() then walks idb->desc_list for that many entries.
>=20
> With the default srp_max_req_size of 8276 the table fits as long as the
> additional CDB is short, but ADDITIONAL CDB LENGTH is an initiator field
> too, and at its maximum of 252 bytes 510 descriptors end at
> 48 + 252 + 20 + 510 * 16 =3D 8480, which is past the end of the object.
>=20
>   BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x631/0x870
>   Read of size 4 at addr ffff888002d6a05c by task kunit_try_catch/43
>=20
> [ ... ]
> offset and covers the header as well.
>=20
> Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025013748.3755=
639-1-yhlee@isslab.korea.ac.kr?part=3D1

