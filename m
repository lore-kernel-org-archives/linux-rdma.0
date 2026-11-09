Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794227820;
	b=yqO7MnWAMguBD7vNayoLu0qg0HX990wI/q7J2rjB+lL4kBj38OTUEydUjZClGKW6rq7q
	 x5xZp29QunkXR2623ISkyQSnq0mKr7Ea8r9pDKsR78ka3sc3EsNL/Rq60pLyZsAGi1Cp1
	 /xOvU6b+/8XFt2neUUe28qqFKR08bf506Vl9J+f55jSAh0hjuCbMNx1gC0XsecGun/VvJ
	 RCzghVyRSTbjZVUpPkt1BpUfuPktepAl/myruPAXd94HD5hNun8tT58O1Q0iIa+eRzQO6
	 y+a014bYip/feqYOlR3sL+XGvo3rS7RxbL31NMC9tajZuo2BzQ+Qz/nruIUeXhhR1iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794227820;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fKxuCrJtu6Ja5jV/QQDxvrF56ensP03se5j+j5N86I8=;
	b=KZ8/wsH+C+7pjJrnnJvFfxXNrpuA8863T3p39giHUbgK5UejvUqaGJ2dNUO9I+fk9UKs
	 tL8GCOD1jqazgOCeSqpVI6ssErKmouYEHFXWgpTDyT1YXMPMs1wvLXvPY4Jq74Yarh3S9
	 Tgihndozgbqctka2JUiS3jCWLxpqcunxbYeAYbTLh2zrsPk9qDaCco1Mxn37BmoNDctPH
	 Ct1u4ujnLYcXAGzFBGJah0PBGWX2sioPFz6HckMDVHSsCxpwWNt7I7h8ofzRxjKpGH6Eu
	 lA2nZq4VdGcpqWkJAXYskmm6Fh6UpfMF6TDw93NhvH3oR7rvyrPDObwHb+FWLiC2RLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SeEfye0X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819A606A323
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 12:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SeEfye0X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FBC1F008A1;
	Mon,  9 Nov 2026 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794227820;
	bh=fKxuCrJtu6Ja5jV/QQDxvrF56ensP03se5j+j5N86I8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SeEfye0XJtmJnYP3Hbk+PeNVvPCoA6XpgbVgvZhRESJaswL+ddpRXxAHuB+HeEJwq
	 6wVp7TwarOJtqr80DAfeUdG9XEUxuHFE1KQ+NnYm6x4XSPf8wdCOFSza9x2w4Zs6Sx
	 ilUZmC4Aei/FZLIzo7hPNZ8Y5EyrFagylGlM1iOUZ1rJOzqpdN2OSxB2hYFLIZwIfz
	 rOK4XXwoU73srPjHVUnSFnNVEXkjOTobbL0znWvw5cX93gYhRNvcC6ZrvIy25mOkM+
	 GDE7Hx1eyWIDYr/RH4eT8xUP7kamLwgV6o/D+RmBvErj+aBVe90fRO4spOaU5FFu92
	 /+tVkr0OQikrg==
Message-ID: <sashiko-outbox-204962@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-rep-netdev-leak-v2-1-9a6d164142e5@nvidia.com>
References: <20261109-rep-netdev-leak-v2-1-9a6d164142e5@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 12:36:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
> device, which takes a netdev reference, and then adds the LAG demux
> rule. If mlx5_lag_demux_rule_add() fails, the error is returned
> without detaching the netdev. The eswitch does not call unload() for a
> representor whose load() failed, so the reference is never dropped and
> a later unregister_netdevice() of the representor waits forever while
> holding the eswitch representors lock.
>=20
> Add the demux rule before publishing the rep and attaching its netdev,
> so a failure there leaves nothing to undo. The rep pointers are still
> set before ib_device_set_netdev() sends the netdev attach event, so a
> listener never sees the attached port without its rep.
>=20
> If ib_device_set_netdev() fails, delete the demux rule and clear the
> rep pointers. ib_device_set_netdev() cannot fail here, as the port
> index is always valid and the port data was allocated when the uplink
> rep was loaded, so clearing the pointers does not race with lockless
> readers.
>=20
> Fixes: d6c9b4de8109 ("{net/RDMA}/mlx5: Add LAG demux table API and vport =
demux rules")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Chiara Meiohas <cmeiohas@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-rep-netdev=
-leak-v2-1-9a6d164142e5@nvidia.com?part=3D1

