Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795265169;
	b=vQaahRUdqvGYKSvySWsgO50swN6mmfVey7z0W+xMNylq4EnshPiYsNNl/y3NElVaFs/j
	 AmosuDWRHMknR5om5QSasjxhuUI2ymT2tJnIIEqlugn3tau3IZfFeZTQTSY91QncNmXK+
	 dHsqlW494o3G/GCdYsmbOh4oFbSM0mESr95dtbH+juKhqtXdhbHzo+EGgc5zE02wslXzL
	 o8IbTQ7rTrnwYvLLCmzVyu0DYUiCOqKKuwquab1DqDNQxwyWfKHNuXYs5VuuOjMPkoC2N
	 crzd+E2L9lcAE+oJys3RomtcT0qYF4YVHVicTlcReDHnuGq2djmx7N6Fb4RwVUiip4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795265169;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BK4CUGMTIwEYA+gYiB01CQ3I3I5mhnEOKCVKFtTM4xQ=;
	b=ltbrFf/zrRHHUbr/3tqHJx0eSXGPkJGbV28XMLygv772IF1sLL6hg3NdhWcdKRwA8BJ8
	 bujkr9Hk70rhIEYrESI0pNKHzziOL+jcj3ebl7zmi7h4EGAZGelTEWZvaXiDcXgZN1JPE
	 LkQ7SwWInO2U7f0eQ/CRgBubOVqHY+piyYDVc+nK2WBnl6AI1z/6+augyCgx2BXMKC7KF
	 YPoudr486vT3VzMi+GoHUixxszzE809180DYfRhC0a9zyjzN8UpytWLGA9nXVFScPCnPL
	 PvVzXLLNAVXc9XRuWYZhBk5jbhskljE6pB/FDUyf+k1TrwAwE6qjbSttNTl35ZPweyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PeLTd7Hr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AC7606A32C;
	Sat, 21 Nov 2026 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PeLTd7Hr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8691F000C0;
	Sat, 21 Nov 2026 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795265169;
	bh=BK4CUGMTIwEYA+gYiB01CQ3I3I5mhnEOKCVKFtTM4xQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeLTd7Hr1ppNEnvDwL1lJ7rSX2IMlWhkl97bnlQwuzycTUKlGlTcL2qtDiYPXXjsK
	 x7H9k5nPPdVdTjhKJyvJB0mhupJcfe7irgQZOeWVjgpBUovU3L/cngGsCeNfjAg5E5
	 OYqP7W6xa5YlxqUql0j9z5XAQPuKSweMm8hSVBVRrgItBt6UYcOA9+ScjVu5c6IpAC
	 k5lfm2MdK+1ZpzFcHEQl22Axr7t5Vxt3MWsiiJZ68aOS8oGq6OThm8myHKJTF0DUeg
	 AoZJUTrtQmJf5Y9Yl8bJh0FAjLry46IygT67k+29eJbtF/wn3oGVKoXOUK04Z+FOrL
	 zAmU7TyLPGqwQ==
Message-ID: <sashiko-outbox-227018@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/3] net/smc: keep clcsock until socket release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261120124534.430200-2-mjambigi@linux.ibm.com>
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
 <20261120124534.430200-2-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 12:46:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/smc: missing Fixes trailer for clcsock asynchronous release
  fix
--

commit ebec662c447c805fe2e4f25a121ee577bf45f011
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

> net/smc: keep clcsock until socket release
>
> The clcsock of an SMC socket can be freed from asynchronous contexts:
> link group termination reaches smc_close_active_abort() and peer close
> reaches smc_close_passive_work(), and both can run while the socket is
> referenced by an open file. A task that uses the fd then operates on a
> released socket.
>
> Free the clcsock only when no socket file can reference it: from the
> release paths, and from the abnormal close paths only once the socket
> has no file left. __smc_release() now tears the connection down before
> it releases the clcsock: smc_conn_kill() and smc_close_passive_work()
> check conn->freed and return early once the connection has been freed.
>
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

[Severity: Low]
Should this bug fix include Fixes: tags for the commits that introduced
releasing clcsock while a socket file can still reference it?

  Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
  Fixes: 81cf4f4707af ("net/smc: remove close abort worker")
  Fixes: 42bfba9eaa33 ("net/smc: immediate termination for SMCD link groups=
")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120124534.4302=
00-1-mjambigi@linux.ibm.com?part=3D1
