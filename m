Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792741388;
	b=iZKv2kFUQnakDrPTvBI4bXcqr/td2xPgXhmSlb6i4C1yEvwoILnwCPGp/J3zqoA7wuVj
	 CBv6hoxgNf9tOSnL6U7Tg0Km8ZhdUC0Q2m8cs0AeFIiigaxJvIP08r/ZYJ+rj+Ql5BRG1
	 W9Nn0dmG1j9AvpHCjY8EhSWCmf3TTUQJJMnvoq5FcZKQC76oc7AeWcVJxGR2rXdaO0Qvd
	 E86/IGUf5vL/I8lEiYOQIAohUfh7Q9X5OLgNfpNlc2J6ZbNCcFzOO7aq67zLzC3lcb9Vc
	 dIuEg5ZRNvs8gBYeeSxuyCCVPk21eZKCPbxBLsZMeqG0BmIllhZQH9Cq2J6GrToY40Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792741388;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6TZenaSTGZ3yRB3f3/UyPC4EHPaD4yvLjdI/8pAcBkU=;
	b=sZHrM0fdhCif0CkXCfHJK6dA3xZYLboSZY2tjTvVJx1Gzyg9jjNuEZ9l+Blx2J+KEIQl
	 CG4f7qvYhgEEEfaPf6ta0sztpCf+ON1WWxXLm76G/NAw25jpwtxvSWwgCNMwLsoPGWNUv
	 6KxLSd1aYFQ0xovAX4mc4+28SeVxqSSzDYelPtejzX/GKdesQdSeDKTppU91BnzUH3P0x
	 Rr6LmZaMb4uQwJzdZWr8SFJ4KjS2punS12Da4ZW9EtFcVgzM/wevlVRWTS/u0Ny2D/BZ8
	 HtpAhVA9s1RrHrrf0kgg+xYJcv1n0VbkwdpFmTig20HbQR035X+ou/Fw25VEnLwtYwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8POhvah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E3606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 07:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8POhvah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC2C1F031E5;
	Fri, 23 Oct 2026 07:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792741387;
	bh=6TZenaSTGZ3yRB3f3/UyPC4EHPaD4yvLjdI/8pAcBkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d8POhvahyyHzZrNf1d8reER1Bfijfu9z3r3Ll+cauFzWkMJWKJhGJCPChNfkDpnAR
	 0g9tsQhewP+Y4vSlNY9jLRNi6baMKxLoTPjSoRqNCJFo4mzuvwKlzA5w4Lja3afL3K
	 wdjxwiZl7BmEvIb0/zrqCUqWpAYsMFG0gcbrFC3eUPwrW0LDYTKZfNYhkDJuGYFmrr
	 ENLgxC3TB8IPGF3g1P0XXObrxVZ7m0DNm+uxRErPom3ogF6FFzWq4q0M1dXG4mxQxP
	 1SuPdu6f7PY6vInFdnt3k5cYUKHAHyC7a1KZ6mfxGjuPImf7wC3jEHnxCOs1iED+PG
	 tgn3qGdc9u8ZA==
Message-ID: <sashiko-outbox-182432@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/usnic: fix wild pointer dereference in
 usnic_ib_qp_grp_dump_rows()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Ximo" <lixicaicai@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023073349.1287022-1-lixicaicai@gmail.com>
References: <20261023073349.1287022-1-lixicaicai@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 07:43:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Wang Haoran <haoranwangsec@gmail.com>
>=20
> While auditing list_first_entry() users we found that
> usnic_ib_qp_grp_dump_rows() calls list_first_entry() on
> qp_grp->flows_lst without checking whether the list is empty.
> list_first_entry() never returns NULL: on an empty list head->next =3D=3D
> head, so container_of() yields a bogus non-NULL pointer derived from
> the list head address. The function then dereferences it twice through
> "default_flow->flow->flow_id", which reads a garbage pointer out of
> the enclosing structure and dereferences that in turn, almost
> certainly causing a kernel oops.
>=20
> The empty-list state is reachable on a normal path: transitioning a QP
> group to IB_QPS_RESET via usnic_ib_qp_grp_modify() calls
> release_and_remove_all_flows(), which empties flows_lst, while
> [ ... ]
> on the same VF) is a plain libibverbs flow.
>=20
> Reported-by: Wang Haoran <haoranwangsec@gmail.com>
> Reported-by: Li Ximo <lixicaicai@gmail.com>
> Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023073349.1287=
022-1-lixicaicai@gmail.com?part=3D1

