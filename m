Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438822;
	b=iSRan/G1M4xW08Ze6noGDW0phNog643sJNUhtYzdmZnP5w/bjOWf3YYkKa6EcTxQpaKB
	 RAUeRZ5AtTcHxDq06xQa4DVcYWY8UxKaqfM4MWNIr3bYGaGZ44O8lr2iCzgliutCAmN5l
	 cOEs7Mq5jMai89VfBJkKlABpSYr7fe02FcX6GEbaXA8n4k9ryUBTyaCWa4hutg61K602z
	 U+dPRkMPInIIJkpRYa6L0ESkKKRr5mAQ4nwlzI3mg0g2fqUaKF5DPnJNfegUqB9Lc+cBt
	 6C7trAtUI06VFoLakKQ4qy6fAwrSmRJzv/DZmB9atvdfpgRILllAHsB9RvZkSDvSUyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438822;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4u8vnU9F0X4pJFLt+slrayqCLvAK2CkUVXzfKeovRN8=;
	b=y2aVFwZmHB/uhfHF3c3pBnLf5yN1C8ELqrucfcNn5BquGRh6yQ04McmE53dA5/sarbWl
	 QbWGZCva9m2nb9v/HzD3RF4rShH4vcGmicUzbqAlpnZJaN2JHbdZzWdl8uP7WHPVBzeRj
	 BVt+5eqv1l7ng/wv62gMHgffZh/Ge9tBRFHzg++Fdkg9p+htc++3EUVUGwB6Faf7mOC/h
	 1J+VWo5Qn1sOhefm1pwLhwdr1hasx6ii2iM3ePLWeE/Ba/MH9V+D5JX3KLSKxs7ChhwHr
	 7ZxaXSmu7bSou+tQeyNFPvx36z3ngH2j3VgcrvNcvuFrE6FGCvzHbvvDWOeYAJmxBuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WvXV5zM7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB31606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 23:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WvXV5zM7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A00A1F00A07;
	Wed, 11 Nov 2026 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438821;
	bh=4u8vnU9F0X4pJFLt+slrayqCLvAK2CkUVXzfKeovRN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WvXV5zM7S+oeOJFsHefkXCA+Lq4U3oWt6+DOSd+MEoogB2qS/O9q1bW4WMydx2lD0
	 5DoHS6GG5yTZlPNXqnjvRWjuyNTLot2pNZCEhqa8HcOvPSxvWzTSb5wFddG1OvwQYw
	 zsEiaMj2ySCR0h4OKduyqV/YgpJbc8SbC+XulwpXnv5WeK995ksuViH90+r+Qt4eKl
	 XfKGnoo5/0+ZwIF4p+kaS0NLWTyvZclgYvpfMWimv0AQIN1nPqL0QoX6vKiov3Pfye
	 Eaw5RAWWiXmWXBO+GkOuWD2Qpku9MxCd52Sxs+LrINVmiBaauplFbfXloWYS9h4/OT
	 B0sthBVaDChdA==
Message-ID: <sashiko-outbox-209845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/5] net/mlx4: factor VLAN parsing into
 mlx4_en_prep_vlan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110231304.1859217-2-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-2-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 23:13:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which converts an skb VLAN tag into WQE fields into a
> small helper. This helper will be used by a follow-up series implementing
> software USO, to avoid code duplication.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110231304.1859=
217-1-joe@dama.to?part=3D1

