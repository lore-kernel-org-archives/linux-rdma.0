Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255318;
	b=1aRAzoPOfvhBgqmSETmM0KF3gzzFeY/UA3myG/CMYFZzBDIh31RN4yCeyU85m3KJVROl
	 Vc1m0Ibc7Tuq9dTT0imogl5iCDpKBs66OSNKAOATydF/5nTN05doio1/+JY5F3f1L7nwu
	 G8qG695Ix2imBpLFpoEdvVNMJM1K3S+ghWpRghDHu/PoxJppX9HuBtzTmj+YZI/ar0Ld1
	 UE6I26p/vFhok/UBWUCFNL5Qa83GuZpF+KaJ7dJU18TWc31HwO/CTzYl/l1wXhnNDOb1/
	 4YgQEfWABCUABZ02BTVPX5CFnvG8pQuEOv1wQQKzmKnRBa9JVxpAQjeFEEgiUYkMFDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255318;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MGVt9qK6WX+3Czz+pWZZy1mBcReGCVkl6mVaj91Bj9M=;
	b=3KfuUiNqvc7yvb1NvQfWpBSV3HBjZ9tHYbhScVQLqt5SlKCsH+itazGofmrDG0Q/iZUX
	 PbY6exE2qxXlP77UknqzxtvHZyfRGOutwDGsXjwuxoji2Y2mk+uzqv75scK5FGrsI9GFQ
	 OpTU1EyCfEEKW3efyGsG903pDhpu5Y54SxEhbOxiIgjBhRJLGEpfBHf2KZ6E539VDf/TG
	 opWIIr6Te/WWxQvEuNKzz0a0w1TyCK4Bm0rgwbx1mn6tHZ+WG73FxO7+41IB/8KS3uxMe
	 ws2caqMJbEo8ImpPvSVmkPfL+dx5ENCKlaVRshruTXlOUvaapJFk0TAl1dgt3GEPY1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OUAisPbP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A1606A325
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OUAisPbP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2983C1F008A7;
	Mon,  9 Nov 2026 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794255318;
	bh=MGVt9qK6WX+3Czz+pWZZy1mBcReGCVkl6mVaj91Bj9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OUAisPbPCtehdK8Gmz7qJvZrkmfiMOGCa1jW0Ng0XNCK4ZeV3P6z2vqwZQE6dF7Hy
	 iGkzFULsQ1sZL+LXxztL1paF10J/4UEuVKG9cQZtY+rHpmhj/WbV8Hfhw+H7469klk
	 p5oALjwCTGsHSoImjIBQsNvzfjdLq6xXBM4oZzwjqguzbfgHHlZErEx8ZPwZVXHcdF
	 lyTdhEN1Aa2YY6R9qTe1EG1EzEAK8NnDkaHj2mDwRV49XvzrL4p9dqgb9OEvHv3buk
	 gMxYXaPcmQ3QkrFC1Z1JvyXDBuPi8P0JxQwnrGDA3Z7E5kzZQtyYDYDHoOTXfWwFIa
	 GUKAIIkossdig==
Message-ID: <sashiko-outbox-205560@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/iwpm: fix memory leak in iwpm_add_remote_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junyoung Jang" <graypanda.inzag@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109200330.2361828-1-graypanda.inzag@gmail.com>
References: <20261109200330.2361828-1-graypanda.inzag@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 20:15:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> NETLINK_RDMA accepts requests addressed to kernel port ID 0 from a local
> unprivileged socket. The IWCM RDMA_NL_IWPM_REMOTE_INFO callback has no
> RDMA_NL_ADMIN_PERM flag, and RDMA netlink routes this IWCM opcode to its
> dump callback even without NLM_F_DUMP.
>=20
> iwpm_remote_info_cb() parses the six required attributes and only checks
> that the local and mapped-local sockaddr_storage families match and that
> the remote and mapped-remote families match. Four family-255 addresses
> pass those checks. The callback allocates an iwpm_remote_info object
> with GFP_ATOMIC and passes it to iwpm_add_remote_info(). There,
> get_reminfo_hash_bucket() accepts only AF_INET and AF_INET6, so the
> family-255 lookup returns NULL. The object is neither linked into
> iwpm_reminfo_bucket nor freed, and the callback returns -EINVAL after
> this allocation side effect.
>=20
> iwpm_exit() only walks and frees linked hash entries, so closing the
> netlink socket does not recover these orphaned objects. As a result, an
> unprivileged local user in the initial network namespace can repeatedly
> send this request without CAP_NET_ADMIN to permanently leak unreclaimable
> kernel slab memory (kmalloc-512), leading to memory exhaustion and a
> denial of service (DoS).
>=20
> Initialize hash_bucket_head to NULL and, after the spinlock is released,
> free rem_info if no bucket accepted it. Freeing after unlock also covers
> the absent-table case without changing the protected list operation and
> follows the existing null-bucket cleanup pattern in iwpm_add_mapinfo().
>=20
> Fixes: 6eec17746175 ("RDMA/core: Enable the iWarp Port Mapper to provide =
the actual address of the connecting peer to its clients")
> Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109200330.2361=
828-1-graypanda.inzag@gmail.com?part=3D1

