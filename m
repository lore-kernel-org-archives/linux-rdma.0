Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873731;
	b=dfmcAoEQRXTzpIczrQdpY4zA6yrVsEZUP7toh91boCk9O4Glh8BQSTvqtpadISaoIxxh
	 U3d0yKvcmkLoaHyr7G5XPSZPTuhky+hfMldy+3RoZVTGcRL/9O8KGpP7x3qPhWYWKacy2
	 kIQWrT/2cXZhCtgHbes90i1lnCfZGVVp0XnTYs8EbuvebaIr48w5khwUNNkx1LF/0IwWq
	 ycHWD9oLMGWu/mc+ixKtOssX2MztFYNT1BMUuwLw47E0vml7LHA+XKUrZwouLDwbI5rIR
	 pDBDYRXrQibwSQMdax9WqVfVvjw2UhcHcV/zB0kTroZPjJVdQ1CvVSiYu8itRqu2USg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873731;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8MEGFMrQ1hY0tshqdsBkujhe8iKRpbG4GYjisim+SvA=;
	b=E33aCn7VUMdGJxMNWAy76EeJDfGg4QewsoyPS2m+EhQsT5miYtR37UbCvff8SyVLbKIF
	 F72puxTPgWcUzCampU7fnbAOq03z97F41m+jhCtVzk+QPjAGAn7xFB8jsxJPlh4QjAMF0
	 EqIIdESoFN5bZoxWDpj/o8Xcn+WTQUENTEKxI+ltzPZYYacSv9cuE+/CuX5vh155mgaC5
	 /W5uh1yZMCPKmVgTjR2EPiKS4NCj8GkF9S3t6LzF0vnZO2E2WM9bO07IDhmEaC9Fmpl1M
	 YPDl052w3qk+WGrdHB6nEC6ugpUnn9f3kUWuavKIuW7S2Kr9h+6gwKNaZKr3EU5zAMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUBxhTPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E60E606AA52;
	Thu,  5 Nov 2026 10:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUBxhTPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3FB1F00919;
	Thu,  5 Nov 2026 10:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873731;
	bh=8MEGFMrQ1hY0tshqdsBkujhe8iKRpbG4GYjisim+SvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lUBxhTPWODQ/cRmIu/e1qRZlkMb4te0HXLJSNJNf3RvaGX/UcMPCko3YhJlqgTrBE
	 IwBPZ3o8ijoQJJis+ubNSGeb8QhBcW2UFSyRji6XVKnVb0inPjFUkYZm4w4biaDebC
	 SPb+nblPBlxKuw63se33ccZDnRh1TrP0Glti5ZNHwoxbcIWkX+s8hBtSL/sv1B8ilM
	 vzGZZKa+p0C8sKIeAQVGzotmqTcTq6U6XLEkHE5+3kYgEfLsL8zEP5/4UGXGpJpq03
	 eJdyPn8U1cc6qJ4pYvS6vavp8M9ZuhNEPujFECVrpd5HY8zfMNlIdJcSYNhy8jNy8+
	 29FkCmwfCHu1w==
Message-ID: <sashiko-outbox-198829@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 02/19] PCI/P2PDMA: Document the TLP attribute
 assumptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-2-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-2-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:15:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA selects a mapping without receiving the Request's ordering or
> Address Type attributes. Its ACS handles only strictly ordered Requests
> carrying an Untranslated address.
>=20
> Document that the result is not defined for Relaxed Ordering or
> ATS-translated Requests because those TLP attributes can select different
> routes through the fabric.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D2

