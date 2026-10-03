Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44DF3A254A
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050186; cv=none; b=oYFmVLivBJwASiePTR1ig4lU/h+QQ2vtQV0zAa+h1zN7WgUr2+g+UmkN9vMqCWcRQfZjjpUCi58tkRy3Jo1GDJ1nHCrWj1AZ7hByyKWYH/BZ90w9Bn/0+X6ka24RHXB5HFXmuWqx/Df8pSA8rNeI0xU2k9nw1cZw9z3jHcIqlDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050186; c=relaxed/simple;
	bh=s+Yhxz9O7HHimZyXZfwenNAh5frWl1PaBK04fjFuVMI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rk4y5BUVr/8mu6Q93Oi2Q/G6nucC2gFOeBN0s7UZAQWkUxu2/Y7RkbVRpicPmNCVaML//VmrJg7Bq7EMWmPDf6Kw4MZ9NSK0ToahrR4KmokJI8Xhb8Q7ZapVEkZsS88739f9zesUliWRisEMHNa9B0dbWOvuYN9zs/Y3zQ6UmV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHk7oJvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHk7oJvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF371F0089B;
	Sat,  3 Oct 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050185;
	bh=emLXdmdTKM+7roOTId+k8QRCTIAmzp1U0nD0qEVpYpM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IHk7oJvHQLvrgTSkLO24da/YtWZuVQote1qtsVBDrbXL3DApPjwWORlXZ3Epco67a
	 vHxNBA8V0o3oVzCSOkr8JXrtJ7ZishG0S0mT59EpNN2n852P9jzNhIe/mbo05HaWqu
	 XyRuLC9zbxjwcPXjxw9YBgaOAOD4LW+i8iP3pOCAaIRSZE3KD+pZspekGjMm4FC5td
	 0a2eMluRO2Yebcq/ZpNIfbp/Rf1K9MJe/uAIMBThBshwcKSvynjDMu86rKjPjOcsaT
	 T+yKYWF7zd44tQwr/SiZHHs8VXj69cSMtPlA6L62cp4TWZGyYIJuhmXun4x4b7t5Zk
	 /wM2xI/yCf8IA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 02/13] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163215.250253-3-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
 <20261003163215.250253-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:25 +0000
Message-Id: <20261003175625.7CF371F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> trans->conn_alloc() may allocate transport data for every path of a
> multipath connection - rds_tcp_conn_alloc() does - which is why the
> lost-creation-race exit of __rds_conn_create() loops over all npaths
> when it frees the connection it just built.  The passive-connection
> exit right above it frees only path 0.
>=20
> That is not a leak today: a passive twin is only created for an IB
> loopback connection (an incoming TCP connect to a local address is
> refused with -EOPNOTSUPP before it gets here), and the IB transport is
> not multipath, so npaths is 1 on that exit.  But the two exits express
> the same "undo conn_alloc()" step in two different ways, and the
> following patches add another exit of the same kind.  Move the loop
> into a helper and use it everywhere, so that the step cannot silently
> diverge if a multipath transport ever grows a passive twin.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163215.2502=
53-1-achender@kernel.org?part=3D2

