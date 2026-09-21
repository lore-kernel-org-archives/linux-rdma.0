Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C63B14AC
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 08:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981168; cv=none; b=kKD8FAMaKUPDztLLLlnAGXWeFrehJh8tmkXifbyGSvMeeQgNCuVSQmqfwDdBtj2UU4p2WTQERKKrYGs9EM7dfB2vSzpEtC6ZY8jxqX26JmlNg4oK+Q45tD4zwIdgP89l4QKZUqGqDh9MoRUZ4kGiAnsMhzOigzCfG3JeqkIboic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981168; c=relaxed/simple;
	bh=V03lIirMSv/yxwGTSPaoyiODY8Chck5P//70hjmEM+k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qHACNPuGkR64tUbCYKlbl9gZDGPO6bKsJID68gN0GDK/K95wQQLMvJNN5G8wjQp1hTxB3q9fhjfDG2ND80wkjmS0ZCNDD8TGq3v9dlr7YMxjg7WDdoY2H47ONdFgeMsOBNQpJREGH90QRq6Su11YYG2t/dVhNODmRgGJV8cz/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIiV/rQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIiV/rQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBB01F000FF;
	Mon, 21 Sep 2026 08:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789981166;
	bh=V03lIirMSv/yxwGTSPaoyiODY8Chck5P//70hjmEM+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cIiV/rQlRptImayrTshnYEA+qlTgJ6V/P0QCMJ3u73gr5iXV0QoDDR7iamjd5DbqO
	 ACihz43eT1KJq3+tJeGs2KBz0D7SKP2zj3elHGsCTc1x7vU4EjsHnyF7eL5lUj89LV
	 ljsFks4LHSXz25N7Ye+gubukjn2BypQxGu789wTFGVtS1tetNVCz3emREf9p1eTklK
	 KrkmCgaT0BIo9Z4W/wi8VVSWDUbtNdq1yzndpaMS0Kc60y6XEdO3VusfbGmkTS9Uuk
	 uOT18gXzELDI75/Fkfmgw4JxdS6GUD3msO47ZV/sEZKB8lKCUfvmERiFmaxDij739c
	 sbRtUht5iDvRw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Add poll-EQ callback for ULP recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Praveen Kumar Kannoju" <praveen.kannoju@oracle.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921085006.1443240-1-praveen.kannoju@oracle.com>
References: <20260921085006.1443240-1-praveen.kannoju@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 08:59:26 +0000
Message-Id: <20260921085926.ABBB01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Some upper layer protocols, such as RDS, use mlx5 RDMA CQs whose
> completion EQs are not shared with mlx5e queues. If an EQ notification is
> missed for one of those CQs, the ULP can remain idle until another event
> arrives or a driver health recovery path polls the EQ.
>=20
> mlx5e already has a recovery path that polls a completion EQ from the tx
> timeout handler through mlx5_eq_poll_irq_disabled(). That mechanism is
> internal to the mlx5 core and is not reachable from RDMA ULPs such as RDS
> when they need to recover a CQ-associated EQ.
>=20
> Add an optional RDMA device operation, reap_eq, and an ib_reap_eq() helper
> so ULPs can ask the provider to poll the event queue associated with a CQ.
> Providers that do not implement the callback return -EOPNOTSUPP.
>=20
> The recovery poll path is sleepable: mlx5 disables the IRQ synchronously
> [ ... ]
>=20
> Use this only as a recovery path for missed EQ notifications. It is not a
> normal completion polling path.
>=20
> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921085006.1443=
240-1-praveen.kannoju@oracle.com?part=3D1

