Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8640455295D
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 18:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583949; cv=none; b=t7HIstBmB0oHo7KrJWKSZfIltFgvp1lax8+neRSpCLsdK6djYF8l7LCCtoIpYawvs7g5Dbbsvczk0y1PjJcznbb1pO34pYmcyDQCsj+2IYDP+nSTVFerGHi2kdPPyPQ75JLWTbZOR2rVPPBHzJqe0FBE/l/4PqbTizBVxn/3+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583949; c=relaxed/simple;
	bh=LVaq/uCUoZ+uuybof+1qK3x7RlmLrtl49HeTDH3jZrk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eMduJLIjrIzj+ljutiU+PjtPXoEiXiZRebkST1UBJveGmP0Humj1NVgy0hBwzzDQWKh0+P1uwToOQdldMpp9cGM1JICaZWFOXTtx9SCVq7B57PudWU5Mh3PPelQXTke6fQKqh866PIoA4GnlOkKTLNWUEDyNAEELVgyj7SYGdKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7p1QCh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7p1QCh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B501F000FF;
	Wed, 16 Sep 2026 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789583927;
	bh=dTlhfOu/r640jp3JBvOjg2+WyUZ3RSX2U1tNpormwss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R7p1QCh30JPn8z1TM55UvCGo97N5+48FDAqkQn3Oo+QQgW2VRowFaD9xZc0Ktf69t
	 W1CJv7C29x/Mni2mpIovafGIA11RPVM5GY/XCg0NbwJXTVgyw/k/tLmCO0Xn88XRYu
	 ivn2C6gICM8FgC7dddrAhh7+sZpGUmhN5UjOQKV3B9Wq5K6iZInoexi19skYrlertw
	 uh6AtALUrdcB3MT2Jnym+2S7AkU0xft43FtjaLSv8wo4Ir7Y3Dv6lnhT9Nnmg+3ELw
	 GHRZwtbbLZibhXaMR8bGCg7sZ5vqYpsce2wKGsXs83q0fuLjsKyxJMrTXiOrD4Tcya
	 D5caV+GxHgW9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/nldev: Fix ib_device reference leak in
 nldev_dellink()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916183101.2092246-1-vulab@iscas.ac.cn>
References: <20260916183101.2092246-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 18:38:46 +0000
Message-Id: <20260916183847.31B501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> nldev_dellink() takes a reference on the ib_device with
> ib_device_get_by_index().  When the driver's dellink callback fails,
> the function returns the error directly without dropping that
> reference, leaking it.  Call ib_device_put() on the dellink error
> path before returning, matching the handling of the other error
> exits in this function.
>=20
> Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916183101.2092=
246-1-vulab@iscas.ac.cn?part=3D1

