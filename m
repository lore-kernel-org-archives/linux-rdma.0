Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE4C54707C
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 06:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790491046; cv=none; b=J+A70M3KVUqbAQPaEO5Dd2U8bRGAG70Gf12Qeq1APB6CNcOdwEDfj7ky0/AZmhpV1HUAOqx/CtjWCkpgZY6f8VnViINijAyXJLYYrSoDF5f908Rjg9qAJ3uu8UT+5rsAPYrmXrbyz27H+D4+B7vyM4v5EOdYuKskG+PdAhDM78g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790491046; c=relaxed/simple;
	bh=P11DG/RrqXXTHBs4EDc3iRtmuJRim5um5D74j8aoQ4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TLl5aNPM33Bu6vxU5ntJplc39CS5y8tf3ZVfn9+zHrR3o5CpjeolPaaNbmNMRqqR9oNQWqJiqLT5KeD2WWRG920tEeg+dPd9DPhh2fD2haJ9SwO7Ub2g8435pek/5Xt85x0roYAz7OWHYl+Zevk12XlX8IyF9+hFZ5lIg/0A6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMakOTb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMakOTb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742561F000FF;
	Sun, 27 Sep 2026 06:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790491044;
	bh=kOOZChsmLUyueUYA20PgsjR34tGBtYUHSHx9h/ZnG3Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iMakOTb9BacHQUrU7O+A33wlgGowEvdNcAvUhfuhyLWn7koBCq18/TLSxGI5JEYgY
	 4VZjW2L1KeL7nQ2yzfvSTQXTwly31IIaglnPiwZkH65OEwEbh22t6BrMtNFtbGPL1u
	 T4hG+l2Gjybq+CLzkzjOF0xDu3p+S50zMLP/tl2oKl5Q9/lZ2nKK39FkO9TGLz9OOq
	 tnoezoRaJlTjjvKJhVmeffXbXHCLMuVOUYPTk+wa5bSYNU9hU/tOr33yDs6JP59EsR
	 CHAcp00mAIIckR0iE0M5PRtlpR34xSZ0C0WYlptPQMVMg2hl1fXNKitbrl1OQGRtzB
	 ZSA/fHN1ThRUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 1/2] net/rds: restrict the rdma_cm ids to IB
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927063058.170273-2-achender@kernel.org>
References: <20260927063058.170273-1-achender@kernel.org>
 <20260927063058.170273-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 06:37:23 +0000
Message-Id: <20260927063724.742561F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> RDS only has an IB transport, but it never tells the rdma_cm so.  The
> listener created in rds_rdma_listen_init() is therefore installed on
> every RDMA device in the system, including iWARP RNICs, and the id an
> outgoing connection resolves through in rds_ib_conn_path_connect()
> may be bound to whichever device the address resolution picks:
> rds_ib_laddr_check() only vouched for the local address being served
> by one of RDS's IB devices, while cma_acquire_dev_by_src_ip() walks
> every RDMA device for the same address, so a software iWARP device
> attached to the same netdev can win.  The event handler then runs
> the IB transport's callbacks against a device that is not one.
>=20
> The rdma_cm has an API for exactly this since commit a760e80e90f5
> ("RDMA/core: introduce rdma_restrict_node_type()").  Restrict all
> three ids RDS creates - the listener, the per-connection id and the
> probe id in rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA before they
> [ ... ]
> removed and left the ids unrestricted, hence the Fixes tag.
>=20
> Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927063058.1702=
73-1-achender@kernel.org?part=3D1

