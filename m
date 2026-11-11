Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422432;
	b=n7TPDehahgigdsYW7ztsEpX24U0Nmr8GrF3Itwr0tGLVMDmiVM0F7+xssQOSdvMeC5vC
	 73N8g1U09pdOxa/2nWURdBY/7Qsl/3HdUt9yfedZlGrRPXhKFAfxcJ+BLw0mjBgC6gfYa
	 xinUzQQqhS/3Fnkbtf4nIH/TvknltL6nKmZzx6mJkYB39new9IcdFxhIbqkZ5f+6wWEE5
	 4I8AzFuGXhoLciXupMxMgtwDHdeQN2EeIj3JiI9nXyytljfPWGVfdp8QFjqlYMyXPKmJI
	 7oVJxN7Ou3Dm0fTGegQr96ikDY3/ZekoOCnd2FtRC1LqHmwG2kZtkvsRX/5zCJBu1aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jTWc7Llr/y/yZQ3gQOZjsHB/0FTDC5bJI7znSnweIm4=;
	b=ZA8fTe97ptn9KdZxbUs+cVl0vrBL7iymDZVZVHpID2QZC0r/G02h0JIwHo09q0uHs1oz
	 3c2e0xAz3x0PxOWXGinJVeqHHiCnAR7vzHqnL02OIYOuMSd5XFUDT7QdvM6f5YOh/BzOx
	 DT0gBkJol8kKlylqgnm+RBbpvY7hfEnfGw+U+4vBYhcG6OlV+tZZSPreLM4Hemz9hzqL4
	 +GjEDp6bMdgumR2nfgBKaErJnaBahgbfgv2o0Y4ZsVdWSaiYHwdz/jSS238GLZHEg++fO
	 96eZ+yylx/sSUdwcEDbZfTCE/SuoQt77METqBZc9Nbda99Uy4yjjCCfLsqJIinn6wig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7sSRO2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BEC606A330
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7sSRO2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8FA1F00A06;
	Wed, 11 Nov 2026 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794422432;
	bh=jTWc7Llr/y/yZQ3gQOZjsHB/0FTDC5bJI7znSnweIm4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7sSRO2o+zLyimncJtayYHBGyguQ0I15Y1ynmmh8N2UtlHY3P8mk9lNcwh8EdgXMR
	 jBE5YdpHjHeiWlDUknU4NDF/L7jK3dE8QsEendNyWdpqK7WJ/FdAn1jwgweCRIcOVs
	 fF//nCOKNX5gAN0T7PWqpMidsWBry9nuGrtbaK60KyERGlK8OtAfVU5H77lwW8NN9R
	 l4YZqqnl6zM176zGnKozbZG85ZEt3ISaZZzAJL0wOodKzcBESgdCOM3XSq4w0/k2g4
	 lcJSTQMrwpFRHX7FtdQVfWuBAU9Di5lsSZ+8BGpTkgRQcS9XMfre3UsLN8pVU95nVx
	 qC2VY6urh2d4A==
Message-ID: <sashiko-outbox-209471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 03/13] net/mlx5e: Register supported netdevs
 as data direct users
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110183826.2927274-4-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:40:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> Register the netdev as a data direct user so it is notified when the
> affiliated data direct device is unbound.
>=20
> Register during NIC enable and unregister during disable so suspend
> and resume follow the data direct registration lifetime in mlx5_core.
>=20
> The notifier callback only traces the unbind event for now; tearing down
> the data direct datapath is wired up together with that datapath in
> later patches.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110183826.2927=
274-1-tariqt@nvidia.com?part=3D3

