Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FC37B41F
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430341; cv=none; b=q13PmHezY+E4gv23Cw2JAWHxPwz96zqQ1SiC7OuFR4KF7F0Kvvf3q/5zYR890+I2OHC0wt4MXW+uTTK0qTiFRx3w0MqsTDDYjLw2kleVi8e4qhaSWhhFy8DXjiq3DUTvpHRRXnAU8IuOhKXKfaqT6Wdfj4TM/3NVdvT9HvwHJ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430341; c=relaxed/simple;
	bh=0B5//ViF/TbMXn+ApUEVuOZBkW4PXlGr4Q8+6MTVUdU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HL+F9D5Rk+01bLECyzUMK+gMfD8du+OLHpiFQJM5RWoqbYe1YGLp2ED25cCJ/iXM/gwxGHZ1HVP9dIXbgbZYw5uepm8LtrSb/bg2udnbpG8UalGfzCXHLVfZ+IsFgoIlBN+12mc5CBw34oFf5Bm4FaO1IhQNluEXy57T25qXjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGx361Yw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGx361Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2821F00898;
	Thu,  8 Oct 2026 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430339;
	bh=5AuBrb7VbFeHfMs5bDdY1cgSekrCwMhMBRVCTR8bFOU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QGx361YwYCwEMhzssK0GxFTu+tp0dM9BAk+VpgvE5j2JHN8ocO4vxDpQwzdh0y/LH
	 acjyuZ+01gM/JQAPWQe5QUGV2ijIgTtBty0yfn1kvRZr8/Mc3+QngGx4dpEjgM8Z21
	 Lz86tLNEZX7fp3Y+sk8E2vn1ojwwcTZAg80GnzwSR9eMlfsta5Psp7Ueb6pd2KDmgR
	 95ZT+5jIbvg97FlReBV458rMYw7wGs6+PCxLkNArGeoBlvz8FC1vA/jaxlbhs1qeeh
	 rQbpcX1sCoiXJdH8c5YkKZNamZB9MpMEPzWfz9H5jP/GRkSgIJPAs/GDYv9KJIMXeS
	 rtAXL2W2S2ivg==
Message-ID: <sashiko-outbox-163550@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 02/13] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-3-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:18 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D2

