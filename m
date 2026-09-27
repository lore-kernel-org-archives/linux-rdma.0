Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2094935893;
	Sun, 27 Sep 2026 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495244; cv=none; b=ULsW5KQN7KPML37MM17Cyw0Xl4pU7bQumQx+k/H/ki82DHO8PRs43q5pmEbOOZJQjzKE/NrCDzaLIF2xnS93Oruiynk6138465eFJI0FyM3hMdZ53u5/dP52vvsRXxhz765naunRbXfDiEAAsiyfO9EbJbo/P6CksUJemFDxWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495244; c=relaxed/simple;
	bh=jiHy0DQaFFcSNcg3tIbg7YFjl+KTNd2RjQ31ordNyN8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FuFo82BZRYhLpaSfQx02ORjh4R3Sq/sCpj69K5Ktthm4Yg/WXB6avIb56a8UzGiDOqGIlzbzMUWzs1alF9wc6mEQwuMTSfoFtfoDOXXwxNYpJ9Z8+5hHdR+vcf8ObP2WYYUPr7z6XUFhJIR5zcx1jG71EbjN9ZL+hPfMis6adco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHZVhh2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHZVhh2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E01F000FF;
	Sun, 27 Sep 2026 07:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790495242;
	bh=gXlXbLaEs7OTyKLRpiBz/n10Qv78R1KUq9PqHFwra0w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CHZVhh2OEx7+97fUwpwJfOqQNvEP+wDo//1mvbJzuSsWepmJXvD3lqiWTbXl+pasB
	 aA7GV1fmPWdRjTzo5wg4ddfBPKEfZuEApxY8uoEf1WSQ08vRAoXGZrEovouoZxxSat
	 kViHKDZ+LYx8P7Th4cgez4zsg7QY775AAxuVpVSi76PIw1Dbyug+5VYzdLMki5wVIA
	 AhAZRhL4zJ47GUFOhMuwunJDGTPwcXZN2f0s8jHIPSEcHl9jtpuI3g8rCtZVF8q71G
	 E3CB6KeOgK9wQP0G1rkdsjGqT3Gt/u14xn+TIEZ46/lvFxlariaXYlJ/P2HIC/mNnT
	 y+jJlOIhEyo2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: serialize sndbuf descriptor release with
 diagnostic dumps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
References: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 07:47:21 +0000
Message-Id: <20260927074722.444E01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An SMC-D connection can remain in the socket hash while smc_conn_kill()
> tears it down. For devices supporting DMB nocopy, smcd_buf_detach() frees
> the send buffer descriptor without taking the hash lock held by the
> diagnostic reader.
>=20
> __smc_diag_dump() can load a non-NULL conn->sndbuf_desc, then a concurrent
> smc_conn_kill() can clear the pointer and free the descriptor before the
> dump reads its len field. The socket lock held by the teardown path does
> not exclude the dump, and clearing the pointer before freeing it does
> not protect a reader that has already loaded it.
>=20
> KASAN reported:
>=20
>   BUG: KASAN: slab-use-after-free in __smc_diag_dump.constprop.0+0x2477/0=
x2b10
>   Call Trace:
> [ ... ]
> new dumps from seeing it. Free the descriptor after dropping the lock.
>=20
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927073203.3694=
279-1-nicoyip.dev@gmail.com?part=3D1

