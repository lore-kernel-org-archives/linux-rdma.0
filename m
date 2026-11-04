Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810627;
	b=TADxIf+8DreA07NqmBCcvj3ioRETv/b86K4o8scaU7paexzfEY2fHUIhXbkl646zK4/Y
	 6Y2jbjQZ61xT9wBgqpAufwKABJYllv3M/C9293rMDgAJ/xo5bbXykCSiof/LNudYz+Zx8
	 ujuKTclrCgjm67pcgnCCRJnlHgNSB9F6JHKa1Ld6Fsxc1rBFw0oSEcR/K3+9qs2EO+Is4
	 3MIT7gvnmA956LEdKcrpbZcfxVvQnmOL/LA/wEUrokRIM3h5K6sbM+871nWeLqs51jYi1
	 OlEcT7Rts5y9uqJYxa9un7Yudfctfd4olvQoo3ew/ebXADMjfOwCi0S6TZplB054TZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810627;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jNsimsXFAkSZDUX/msUHWCN6vmBxclFWfo6XU5o+pKY=;
	b=ibrYW/HurpRhXqJfZ8ehDgM9mh1yL8pMiSn5dwJp9iNYRZhoqLPL3BTFFIOJD1K7ml8/
	 KjFsP3S2hu9qvHuwTXZuVHa82AsTYNyLYQ7GSxE6ohYMV08LO/WKbc8JjoXfo/swiMCii
	 9/wenagFrdhZi2fBrtjZuY1UnR0FxL9EyQlu5S1nPidvgrneODMFJftXULlR8KETwrmua
	 0/d6CCgiePb0+YEkrB+ucazlsjqw4aEX3Ysqvk3fcOlvZdRg43ETLShl+NL60FrA4h9tp
	 AlKxMhC1CpCQVtD3aRRV49XZSL10cUyhVvfkh9tUEjPypyXw64Sctk6hJCnoChONJ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6t9tGs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0FB606A33F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q6t9tGs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5CE1F00919;
	Wed,  4 Nov 2026 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810627;
	bh=jNsimsXFAkSZDUX/msUHWCN6vmBxclFWfo6XU5o+pKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q6t9tGs9NVv/DUe8r9zh/L0mqI5EBzn5M+fRAO1PK7PTRVppI3vqiYktW+q1S0QbJ
	 WJkoNtSoxXnzC3t73K8K2eyi93pxOAAkWlaMpSyr9p27lHOunQc2xc60D885RzHeTz
	 EbZ5AJfjjggE4wqkn6hFGCrKeZtLvnBfY5ERte4LAlJe53MnX0hcUJ/O0sHx7luAFf
	 GHEosDSLMWtr+zCPkDbhyz2Ach2jPDT/Et2svzQwn4SZYWWjKVsKZG1D7gUDQgHTlx
	 hGqHrchkaXcAa7D96WmoCvv861xMycp+hAttIDOtNjFW8t0l1YOnddLJQmVzMQDATl
	 cTPnvGxuuy/yw==
Message-ID: <sashiko-outbox-197664@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 11/23] RDMA/mlx5: Add shadow FIFO
 infrastructure for UMR completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-12-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-12-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The UMR CQ is polled by the generic path, which finds the completed
> request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
> NIC can forge it to complete a request other than the one that really
> completed, or one that is not pending at all.
>=20
> The UMR QP is RC and signals every WR, so its completions arrive in
> posting order. In adversarial mode, keep a FIFO of the posted UMR
> contexts, so a follow-up patch can check each CQE against the oldest
> pending request instead of trusting it. Each context also records the
> SQ producer counter it was posted at, as its address alone doesn't
> identify the post: it is usually on the stack and reused across posts.
>=20
> Nothing consumes the FIFO yet.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D11

