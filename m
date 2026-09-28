Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90143E4A2
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576115; cv=none; b=tyhVpO7CgyTKu9rS3tLEwf5dFU/T8TZylbLdpZyaXyDuNHDeX09PJEGSI7gKHiXyp2cjp3VgBUUZeX7kxGxq1De/hHUj83BoFsom8PWT4YrdXLa/STZyyMuvE8nwQQcMGvaYA/xD4ZcEyFnJP5SiTIkid5RiJovyGAxQk1eky6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576115; c=relaxed/simple;
	bh=O0XXpdoaN29/MuFWwcLt3Cqp2MN2VrBm7VBnTBpJRrc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eiVBxs3i4iMUTos5O38eX3UfkGE0qOiLyyGo5Llv0b1gel6dEuE/8hYsM0luhscSnRRL0yZRFDFJZM81cYosQZ0IYUKUphS2yU5o0TjNq7Y5ffYjSEv/00fPYn+e7KdVkyJG9eAkfYraHu+T+eDbzCqQSjlgxtso8XYIO43fuaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErTAw/CK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErTAw/CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7BC1F00899;
	Mon, 28 Sep 2026 06:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576102;
	bh=b70TOZlKL8UeMahxz2Rdk9BGW/+LU0FgEJcA/amhmqI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ErTAw/CKILHZ1PJ30WBC3O0cFYF5T6oVbYOdnpYPhf+Q6utqk1eSUJmeBdciGav8N
	 O1pMJK+W+EgMGwEIXKVGtzAE1TDzqMmFzeAsEUse0WxkbSHnGuGhvbhsafgQGZZnEM
	 CpR9BAJnMP+PR/0RW0IpMJXZhAeWRj8zi7wKqSCb6gWp7FEn8bW73Cfp8dVZe3cUAU
	 NecF/KsbvRDMq5A/2CY0wjW2raLsDW4AvCoDraUSidv15g9F1/AEMzQ34YhWnN6qf4
	 61ibxlNf8d65CYXV4PN32DeFJm1JYed7x8cB+/s3ZpwNu552KnlWT1qHUux0AroWc9
	 KofGdXag9zsUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 02/12] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-3-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:01 +0000
Message-Id: <20260928061502.0C7BC1F00899@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D2

