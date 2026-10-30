Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336036;
	b=r5Awvoe5IFlh0qKZANKo0Ojv4305u6DdiXPGIA4S2CsVRTgjCxiIMjezkWbzBMuvc4Jl
	 gTHmUAaSafzStZX/oims3G3+h1FSq/sKtjFKd5o9LhxjXDXCGTrZUEEUjmktIc/8/Bf78
	 1LJysTkzxZTV4STNeipshpsXVtUHDbY81MYaYsH0SWAzO+vDmiYNurTtGXkABAGvv1VZe
	 kHI+3sa0Mmb9UxN2z3JR097D/LPCRjGi29I+yjUJGlnO4I8+z8xyMsTOYsrAWNAzeNOxY
	 v/QAmxVyPyX0Jz9M1jEp3A6G4kjA91ZlowXct/TXzr16iz54rTU1ZufZkLAgfixTRSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336036;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RfxvXmJEDtJravoTRF2A+IHc4e7ew0ejbpqgmsoYyXo=;
	b=1VUnv7zXyysZAcE0CmV4wb9cnRRmdUrXbAxPmFsGWtISQzGw5QlXa5dHUqMES7L64+j4
	 a6pjpDS1MjdZF7pmMeNH2wyoI6FO/vXS4atzpVnar0304GPcjJkmN5tq9FQ/WkvAb1h8t
	 1JZX1ixP6GdadNJissENpERrvaLgcWtiMYq1Ona/BJy9l/FDKz6rA1bg/NFM9nYxvfNzf
	 PlFeV7nbDjJdBITnpP7jtdttl4+LMB8ymmx1qmcD+iwpsxaWeP7sU0C1qUv9yuRE0tPdz
	 /jnvtgGTUFJTrob/2a7nHoKE923Ibirz3QlRMGG5VRbbNM8QBPrl/JPSgLO2X5SjZNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KECJcyiG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3551606A326
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KECJcyiG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DFC1F00A16;
	Fri, 30 Oct 2026 04:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336035;
	bh=RfxvXmJEDtJravoTRF2A+IHc4e7ew0ejbpqgmsoYyXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KECJcyiGmiUuDWqwLhP1R6ZnB2FJCNjdwPeXEAg8jngcEEK5mOXPyI/haP88RwYFF
	 LbZ6iK0VWBlhG/ddAydjWgVfzM/xLKTCvn6TaamOcgZ7RUEkjm4/ahsIV1u06bpgD5
	 b9phzAZJtPIEiOxSEiebAtQIF4SmXk3fISjR1AFxXyqe5MizA7YBCzAjmQtadGeYy+
	 w7UzNWIz5nGN6GgxtKeAggjpAlMuu3H6CVuyF9qyR8UKH0W649ySiX5BPm4tlukIcC
	 Saerfa+CCHK6uuTPfxwdvOYV5hlYcRe+7gZdd11paUgauYo2YscnKjfz09gCMTzG0J
	 46zGl9vOn3VJA==
Message-ID: <sashiko-outbox-190382@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 1/8] net: convert netmem_tx flag to enum
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-1-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-1-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bobby Eshleman <bobbyeshleman@meta.com>
>=20
> Devices that support netmem TX previously set dev->netmem_tx =3D true.
> This was checked in validate_xmit_unreadable_skb() to drop unreadable
> skbs (skbs with dmabuf-backed frags) before they reach drivers that
> would mishandle them or devices that would not have the iommu mappings
> for them.
>=20
> A subsequent patch will introduce a third state for virtual devices
> that forward unreadable skbs without ever performing DMA on them. To
> prepare for that, convert the boolean dev->netmem_tx into an enum:
>=20
> NETMEM_TX_NONE   - no netmem TX support (drop unreadable skbs)
> NETMEM_TX_DMA    - full support, device does DMA
>=20
> Update the existing NIC drivers (bnxt, gve, mlx5, fbnic) and the
> validators in net/core to use the new enum. No functional change.
>=20
> Acked-by: Harshitha Ramamurthy <hramamurthy@google.com>
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D1

