Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95794E56FD
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557660; cv=none; b=L6biD99yvJ9O1UMBLZ4QAlZH+Gym/wPNzoVA4P6Z3jJ6v2e8dqQqoQO68bg8XO6ckn/Bx0qYl1cL7U3m+uMaF2MuDeXeSH5WMBjwcl8dXSpbKRhjLKxzaOFpYHT6RkxcXuoaiVSaV8E7snb5V9mc50DT0+GSpFCVh9YcEDVtyzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557660; c=relaxed/simple;
	bh=nubzpTzPQVkuok1sPCCegqSBcFcucZva+0bnRFX17sg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a88UkEsRJFvPr49JfrJyv0yGfe7ZsyCLliOx9+3wQGeBQR3D8PIVeYcd4CLjCuQ6FR5jUCsrsTTxid2/XCBEjOtBb5Rsi1VIYki1A/ODA9muk7HMNrXEAyneRaVwojESr+Kl1sfemvoheysduz7r5ZrU/to0bBkO+lxRP95FOUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cp390Jaj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cp390Jaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BD21F0089B;
	Wed, 16 Sep 2026 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557631;
	bh=nubzpTzPQVkuok1sPCCegqSBcFcucZva+0bnRFX17sg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cp390JajRwqK95mwi7NXNF+MYCmRAFh9VwrU9mE0O8dkrHU2vpp/lyFEOQULz+mw5
	 En50B+9p4iqlCLgMNbrGWpIbszMo0GrFciLK2EfJ7jVlJen9nElIA+wiv8LLy1fwZo
	 EV4z0rLW7mbK7I7TKRsketU0dc3/b87mtNrk8UheY45nffmx3eS4rEvPviSDbBId+x
	 pCy3LBkjjf/oiksAcLcaNcLACm87kDMG8i7PMWHe6s+/Yps2WA5bzmKp+MUDRhVhgx
	 5iQcdmxjoP8Xpe4ETBPF/6I84HSY3nmwhxi7HzB3S4F8+86zXL9dEOthqt4QRKvTpn
	 TG/sX/wJKsA0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/6] net/mlx5: HWS, Fix error message in
 mlx5hws_cmd_generate_wqe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-3-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:31 +0000
Message-Id: <20260916112031.82BD21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Kernel log messages should end with '\n' for proper formatting.
>=20
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D2

