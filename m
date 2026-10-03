Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AC39891F;
	Sat,  3 Oct 2026 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791053085; cv=none; b=hSzCTS76VB4FR6lK85O+FRN224KpvLalYMzqHr1s9TmBsWcXu3Pe0HIFocfJgWdisGIjRW4KVr58oWpxXmKJoP1A1Mdu6BCHI6uJwxEyDx7kPZY/2cTGxk2gmVe2QxgIY6hch+p3agx4Oyxxv2KF8QyV9XvfyWk+XhuGpEVsZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791053085; c=relaxed/simple;
	bh=djwuN0m/7/9bpnV5pMS3AznpA/JhjYY0AQVx8KATkpA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bXBcCjlEGOSYRxNNd7dZciXE0saXUfsfy04ydefjKVfCfOHaJmbnQ3vPbHYmfd6SaKZl3DUmtsuiREKpPdj4SJOPa9gbP5q2yc8Q5IXGRq5CeuHGQibWVtB3dXxSWSHW7V0m1IIN3eLJ4LKEYSRNKHndy0lecnG4HYBga8uXnyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYkdvHE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYkdvHE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F89D1F0089B;
	Sat,  3 Oct 2026 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791053084;
	bh=Z648LC4Cypr1kohal7dXErGf1vHB/jXWQWhe9tc9urE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GYkdvHE0lAioQYOnGUXm+FEULqBkIZ0YBq7vjOZTAi++PvVnVL2jiXP5Bb+HWOj2/
	 Vbzw6+70dtM+M+Xkt+jQwVKtYbTXrzb7+Z8iHM3vJlgWLSW9RBxPnLBl9ue+6BFUVG
	 xaudMP0C8fdEoup7mI7ldPloEI2SDgy1OXGl0i9ImAHm7ES30+jiO3/BNIvSWDizUb
	 sDVWHTH0i0P7pwmYhY6IJGcymWgtDk+jNK5dN2zVX/HllJ6bLiACa7myjjAcbU5Tl2
	 4Uznx11Sl3BXUWTe/8onPruptR0v7UAiIYmlkFgW7zy4KD47NnhhyuRA/hGGAnUudX
	 FHMFG5pz/qKvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/smc: serialize clcsock access with its
 release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
References: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 18:44:42 +0000
Message-Id: <20261003184443.5F89D1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Link-group termination can release the CLC socket through
> smc_close_active_abort() while the SMC socket is still open, for example
> after shutdown(SHUT_WR). A file reference keeps the SMC socket alive but
> does not prevent this asynchronous release of its CLC socket.
>=20
> smc_getname() can race the pointer removal and sock_release(). The same
> missing lifetime synchronization affects smc_set_keepalive(), diagnostic
> address copying and an in-flight SMC-R CDC receiver. smc_shutdown() can
> also reach its final CLC shutdown after its close helper drops the socket
> lock and a concurrent abort closes the socket. Holding the SMC socket
> lock alone is insufficient because CLC release runs outside that lock.
>=20
> KASAN reported the getname failure:
>=20
>   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
> [ ... ]
>=20
> Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003183325.2289=
707-1-nicoyip.dev@gmail.com?part=3D1

