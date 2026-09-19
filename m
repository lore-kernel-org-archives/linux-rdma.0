Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE5C36B906
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 06:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798753; cv=none; b=nufXG2jga2+cspSQXAVgFw0oYwzI8YNdpCZc+ExnBw+GIUspxeYbdpEgVrtSXpHkaCYcZkjQj9AVF760o958AKA0Zn7QrFxurL3ChlYXTbWN9Shub5x/MMK0M8lQCx2A8ha7HLuFKV26gnrB+1S9uour73mLNPRHBq30hSDwpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798753; c=relaxed/simple;
	bh=+odTwXFHL2ZW1PKsx7zLryvFAb57rGTxa8AZhYd+kyg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OwYRZ9zrpPf8sB7JqNRxV+4IjGxSqiFf8HxXlBLxhJ6MnqpZiEtTdSh3sR9Rh8rAUR6xy3H0Gh4H+LTreIF3+OSEuNzZpDfhqOE6hvD6iWMPomw2J+Uogk7BsoiOQIv+NDjPxbQiAuf5RAZh9nPuqellRpuXBNj5l+fjqdhWLuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rxc5YlFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rxc5YlFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993AA1F000FF;
	Sat, 19 Sep 2026 06:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798750;
	bh=S4iaEF6+n7wJOjCVnFOk1pR0pI64O7ST9CIg7aCxLN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rxc5YlFPGmOdZdWWLcX+xr1bo7Bh4Y9rXFq2rI1bjrhpoNoc//XXuigiTNWPbQIkg
	 6Kc+ccnzFxeaMSm9jtwR7s4MplxNfvc/33e6JLGYVi6ZFq5PZ/preaGNJPF1/wyGfd
	 eMpBc2EP3FuGijzRYp2K8RSgFa/ypga8AcMbGYm33epN9OKFzqnePrQeud2w6MzTC8
	 nmEz/mRKyWfXb9bC6F7aJKcbVi0uTvbhAoYxa/g+IPBZ7k1vxrebZisHL63gl8ARzS
	 MX4sZHa5oklozb6iFJFY6D1tYMbPyFKR/deAKO5KmYKJC46Tr9jYESrSpzbMvZFRHR
	 MQwPT780y5TDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net/rds: restrict the rdma_cm ids to IB
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061042.250462-1-achender@kernel.org>
References: <20260919061042.250462-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 06:19:10 +0000
Message-Id: <20260919061910.993AA1F000FF@smtp.kernel.org>
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
> are bound, so that the listener is only installed on IB devices, an
> outgoing connection can only bind one, and the address check's bind
> fails outright on anything else (its explicit node_type test now only
> guards against a device with no node type at all).
>=20
> With that, the connect-request rejection for non-IB devices in the
> event handler becomes unreachable; it stays as the last line of
> defence and is what stable kernels without the new API rely on.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061042.2504=
62-1-achender@kernel.org?part=3D1

