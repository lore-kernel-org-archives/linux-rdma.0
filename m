Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1E4756D7
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153674; cv=none; b=Aw2N/fc6VMc5GBb6235fqYuOOpYqjaRfFPvl0UFezFF+57pFs0tZCzl6+ZWXwO904IbF54O2UlKxu5z8lnEtzzsAWQLDirbdY4+Xm8fvUgiTAdq8Yljf5WiwJqy946oy01t8mMJD1K3zQgFhff0cyCxWt9ucSgKPJ8GH8yZHi6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153674; c=relaxed/simple;
	bh=nofhYesRsVIKnWtNyi8ximVLxEAAV5tDo7C+yEtkHnA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rBb9YJ9eium3lyqH6iZmSj+UX6yuEIUcPbB6bDRvwYbjWXKtLoaL31ZDumU3vIm+yp7Dr26KAQ8rKeJ6ChU4YFgRX9eIRKwFvOhFrCidU9dBvFRyqR2P0b0OaYkEAmDS16EzWPBWQzlVIACzwo0g63WzOeQcbM8xw4V8rt+Qvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7KDkUYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7KDkUYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253B1F00898;
	Wed, 23 Sep 2026 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153665;
	bh=BL+q5/Zn+3u1vg7hmeFNQSTivlEKnSJd+lsJSJo4a+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U7KDkUYCt3P021rCbwxWblC/jFVpVoiSdoBnFkIjFyN8x7e7lR4z1xv35UaeSaaLI
	 lr48/uV568QBWStL4iz6UODMCFp+IDzZ9vjjXdr0+haT7ecP9+WwkpYNvvwPTg8BLt
	 E69indw/VCROeTVHhgZ8x/2SU1bhSqshcvsTfxN5oxRE3Iw3aaSMEYcALmoKb4d6r4
	 xGRTkzn/TjZ1c7rlSD4a3jRSn/TNoTGd5BDlvI8y+91IB25f4GLASH0iVJUNJdsKnY
	 WNGdlx1xP9Mpem2+rFb159KxafLNBCzBe9fpYWECdm3Uf3bi6LDku8ZJt1kqkAILf/
	 qddeMjwqoPVig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 02/12] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-3-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:24 +0000
Message-Id: <20260923085425.2253B1F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D2

