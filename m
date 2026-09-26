Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E232A1BF;
	Sat, 26 Sep 2026 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446591; cv=none; b=FvUGl+MgNqKb+D7G1BEZuCtA9UoYIb5H6GDUnXwwOuLBkFfZB93swqDcbUQH8cDRbCt/5dIcjb4euzRGFpv1/F4piUT4y5ngVbS/n2SuFBD414RV0J0A6URxqLnbxrSxiR/fzFDYL7tlrpYSSrRB0XxWN4q73t4IRHOpGDIT6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446591; c=relaxed/simple;
	bh=kYNJyFSFsrl6bSZot2T+CzA/1hVCyrR4Sv39LfcpTxk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TJb6FRT7vV2kcDTjqrweG5r56mRwXBaqPf8g5xw5PnKvNeqsRu4YSFYW8M0PzePrX4HcnDfNEb6Q+lSyHqoJoyT1+VcxNXFVVKrjBO9QbeS+imLBgiekYArRDO18Z/wsofMhECYv3Cnz7M/mwTS6fSEISvSudced/KeQXp+jqRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDDxlQwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDDxlQwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408421F000FF;
	Sat, 26 Sep 2026 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446589;
	bh=hJwAlg/YJyQ/xHQBkBO7KtkuuR226zYz9tSaCN4LphM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HDDxlQwajW1sUcMTwKo/4jwj+NyMorYmxPItAaPi1Sh9129Tc+3444r/P60DD5Z1t
	 rUREZNH4mirKmK1JwBZ1Fv2IGmBfy/ZC2+pkEHL0o05hXm/8Iq35EfuqzjuBpXu+Nn
	 PB3QZlCgT37Vxlu294HH1aNCsnrmOye3rx99hwFggfJf1n2B516OgOVARRRdAHY67p
	 Wqw8SAy7o7a3QQ+bx266D/28tH+6abmhEZNpSggKVf+lthMMVtggEFsZHk39TN+63m
	 J962iyZYNhwtv4CBcK56qG5ozOYj15iTKrlxWuQnDlD/HIx2fE0SNYQvTtxvaabYd2
	 lrnXSd+wpSu4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: protect clcsock lifetime in smc_getname
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260926180404.2721010-1-nicoyip.dev@gmail.com>
References: <20260926180404.2721010-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 18:16:28 +0000
Message-Id: <20260926181629.408421F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_getname() dereferences smc->clcsock without holding
> clcsock_release_lock. Link-group termination can release the CLC socket
> through smc_close_active_abort() while the SMC socket is still open,
> for example after shutdown(SHUT_WR).
>=20
> A getsockname() caller can load smc->clcsock, then the termination worker
> can clear the pointer and call sock_release() before the caller accesses
> clcsock->ops or invokes getname(). This causes a use-after-free; if the
> worker clears the pointer before the load, it causes a NULL dereference.
> The syscall's file reference keeps the SMC socket alive but does not
> prevent asynchronous release of its CLC socket.
>=20
> KASAN reported:
>=20
>   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
> [ ... ]
> state check and the callback's return value otherwise.
>=20
> Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926180404.2721=
010-1-nicoyip.dev@gmail.com?part=3D1

