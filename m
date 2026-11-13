Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794543710;
	b=zrKDDWaOiZeALrjVn84E6FePV4ssgghPttn+Y4n7mU1RSZp5kWVMbqqrtAnQDeksjMi2
	 voDSbnppQlnVHQi5qfIEn/Z8hd16dweF34JV0/dOAb/g2cx+XWH1PwowKy3DoMjo6ap1g
	 a1tCJUQT0Qkd/3FvmfyKRjkxSsPFrZaKII0d+5elihjJioAJEaJkRKKIyYT3lu0hFVciA
	 DRNWwWbYaVHXiVJ2xKjIlYRMvaKgpIJs1ChrHYeRSuXQDLgRHiZM6g6i1M1W5YXnX/WPF
	 3dnrcdomE4JyrZEx3JPXdc6y7d+ffRnmDVPhbBVHU9nQ5DkNdyTdHBumP1MSZ8B01Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794543710;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CzspkH4k5obUhdwKcezHVYQIsZeoynFbLwUe8wGq9B0=;
	b=AS3xxF/AdpHwtOstR7u3U+N75+3StS7sluRJ0KBW9rLf87eHsfrWmO4O30PojWj5YU2V
	 64AB4LI73Y60L3fOYWh95y4gEWeTQB2q3ejDIkm+teEe/dEydLbtz6KMRJjOFLgHlS6mf
	 bzDfvHCVNookAF/upd8FeuMvOOQquQ0wpTHp+ne0AaKO4nExMQa3gVwLfxxu8nDaj+n4T
	 SfQOmEoqRUn10cUBSU6clHESz3TvXEs400Ncg7UGTJBV6soV6H8vrS54hD3/YSstaJ/Kl
	 1aqYSXm0oBVt94CSZQfBubrzwHlgpsFA2Ne0eHkerMojhcP7ltjFQ9+hrDcAP161+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9VUeL2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8E606A323
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 04:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9VUeL2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C769A1F000C4;
	Fri, 13 Nov 2026 04:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794543710;
	bh=CzspkH4k5obUhdwKcezHVYQIsZeoynFbLwUe8wGq9B0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B9VUeL2wGvrL0OIqBTEzCcZiiOc28+1t0NmeNRij4qFMf9GmPtG5C06Yx7yx23RN0
	 oki7pkwNPJdBF5Jc13g3y7kkGLvyrNNUHBdxMIpk7RVzC59dTArL2UuoJxynbV/DO5
	 HfPAxypvSSe410T5+f2kCuThgZ7Z9e2pbkDVYkMAYzk5e4gHMjMiVe/uuXXYg+duUU
	 x21vdLsPgRSDGqt4p8uiprOjBL33lmK8MGI64w2H9USYDhv0CK/s9CDlcdys4fHjXG
	 Yir+hqZ28xv0f7HXtoeMuaxlh2z3+dArb2R+F2iYI5CE79tCJXiOhTe3lmxYTddbwF
	 u05PYxyYDrNRA==
Message-ID: <sashiko-outbox-212164@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Hold sync_lock while resetting VXLAN
 ports
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113040323.2090829-1-lcy8047@gmail.com>
References: <20261113040323.2090829-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 04:21:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5_vxlan_reset_to_default() walks vxlan->htable without sync_lock
> and calls mlx5_vxlan_del_port() for each user port. mlx5e_nic_disable()
> and mlx5e_uplink_rep_disable() call it after rtnl_unlock(), so the
> udp_tunnel_nic work can run mlx5e_vxlan_unset_port() at the same time.
> If that removes and frees the entry saved as the next one in
> hash_for_each_safe(), the walk then reads freed memory.
>=20
> Hold sync_lock over the whole walk, and add __mlx5_vxlan_del_port() for
> callers that already hold it.
>=20
> Fixes: c5eb51adf06b ("net/mlx5e: Fix VXLAN synchronization after function=
 reload")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113040323.2090=
829-1-lcy8047@gmail.com?part=3D1

