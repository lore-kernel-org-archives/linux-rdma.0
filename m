Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815201;
	b=CCaGVpGn7uN/2BPdgk+4IlBde0xVATuV6BmgM9Ypspif7RX2QQQRlbLqH5tZFbc94Ksj
	 QaPDHzMESqCPZCy8DkaQM1KssnjAQe1A7f7Bis6oZBVR85ZI9EdhCq+0WxtYpH8xxoNcV
	 0n0FOMUINSFvo7pBDwiVviltGXNaSNUa55aGgD9JZCLxUax2eny1UhzM5xtdGNOnMkJ1X
	 qIU+N7eu/E4C0AhKOHDiY+aPyAht/Eoxi0hzU36KrehYx6+PPk6eYkewGZ9aKSygYIWhr
	 o3pN3Gb+HvMnjoZJoX0OWoKrWlsa63f57/idvz+jNA7Vd9mVcsak+JyoyL+biclWGjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815201;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p2KzzmV+fEj6roFow+VKhIQ54aC/RY99BRW6vtGDgss=;
	b=b5zwNlSr8EOYO5nMy8dNsslnhpu+SAu6OPEXSPlxtJP6CXfp+fyulQqX1mD2MBFwlrt5
	 MmAUePXM3An9PR3vT/PDcEthI6s6ZppISXTJf5X9PEZNY3h6Jeb17HYURL+vNy0A1T24B
	 LqoQp2UD+ipAyvaRFW3AJ9ZMZIe+7H5TLaA5dpXMhocnz55Jfagqt4ufyU094tEtbTP79
	 t1arbFKiB+zmF7jNatQCX4Qq55p7VuxC1Z2BY2MTQ/2mfKEfdoMSCmu3sNrdDIQj/9Z7f
	 CP/HO/vWuG+tPvFwt6URWlkLJ6bNBZqDuuIBrNB2bLXkgMuILqxNsYIwg/bQBwAidMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ie7iwT2S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DC4606B0A1
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ie7iwT2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46621F000C1;
	Wed,  4 Nov 2026 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815201;
	bh=p2KzzmV+fEj6roFow+VKhIQ54aC/RY99BRW6vtGDgss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ie7iwT2SUDpZLZEwd4cpmfx352rZz91b83JJsjh7DfNby1s9tCEG1+aIerCFtAM8e
	 vsBou/laa32uVrp2nwTcwYjclcfRJjngo/mT0SbYXwuKc9k3d1kBR/xnvqhJZTJIJs
	 O9xnlK0WqhFXPLLcmFmAp5i8KIS4GNruoCpo1hMDf0pizWgt9FdgXjx3CCXQxUVq/T
	 RzXswfynqht1fGhdey6nmINxXj7OZvT5abkrUEH5keTZEpT2i/XkNTTyW13HN9g+pO
	 8VC3aHSmpT4bEW25CbNDaQQ0hdFpegf/WkJtzNTF5IYqVNopxhz4lcFIXo/1NES3G6
	 9361j+dq7KPjg==
Message-ID: <sashiko-outbox-197807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] SUNRPC: Reject add_xprt on a backchannel
 xprt_switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104-liange-v1-1-f097e10cea1b@kernel.org>
References: <20261104-liange-v1-0-f097e10cea1b@kernel.org>
 <20261104-liange-v1-1-f097e10cea1b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:59:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The add_xprt sysfs file clones the main transport of an xprt_switch,
> including its bc_xprt. On the xprt_switch of an NFSv4.1 callback
> client, the clone runs a backchannel setup routine against the main
> transport's svc_xprt. xs_setup_bc_tcp() overwrites xpt_bc_xprt
> without releasing the reference the original rpc_xprt held there, so
> the original rpc_xprt leaks along with its netns and module
> references. On an RDMA callback client the same write oopses
> instead, because the RDMA backchannel transport leaves xprt_class
> NULL.
>=20
> A backchannel transport rides on its svc_xprt and has no connection
> of its own to clone. Return -EOPNOTSUPP when the main transport has
> a bc_xprt, before reading its xprt_class, as
> rpc_sysfs_xprt_dstaddr_store() does for transports other than TCP
> and RDMA.
>=20
> Fixes: df210d9b0951 ("sunrpc: Add a sysfs file for adding a new xprt")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-liange-v1-=
0-f097e10cea1b@kernel.org?part=3D1

