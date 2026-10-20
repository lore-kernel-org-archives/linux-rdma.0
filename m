Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792459256;
	b=YKYWYWkir1EJfxJ2MKmg2USU6oXVq5/UnbEGKMeootGWQvDCuR6oA8/+iWCX8AYvRGE/
	 /IK2c4pbozj6xQzPzR9/7kjR1mJxMbX4rWRwr7SMTccCntAtM5KvFMRvlmR7OSi4lYFTR
	 6anhM5u6nsnpsVnMK7zcJiaWtzzwXRGnCNYeOqHpTdCslzrdJRSjA3PqzqUvxqNB+gA43
	 JB2o1B4V4zS1pBJtv9NqAaQ56kbhPC2v7a9Nku+31X8smvwBGBhnG0r8OS9EV06cJAw46
	 3QCT/xtVCgvRPdKYVEZoTMLBHlObZ1/2p3uTkA8WoEhGxQUIAWsgSxS8vmSidldhsJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792459256;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=rhYKI/4A+OzeChjsjjcXtlKpKqYRA62r9ajrnd4AZRo=;
	b=MNQTBanKXmp5Nq8Dlj9AJ+Lm4NPc69TFHMdtZR68Jd0NYYYmffddPmPmOjnndWInjcon
	 hDmjIIYDOh/7gH+aQ3eLW1ETCY0bq+eA5JJe+uAV56qhZrHyk5CDlqNhrBLb2yNN4al4l
	 ppcnzOSF2/7gx/yv5Fv9pR1DYux+6Cz/hZ9z+wRxEUh/tYqiCbqwK9KFc3DYM+/wkXyCh
	 HAV23389K+EztR1ONwqv2mfiknR+eqNGE2x4mMdyDPXBzgI3D1OhLEaiKtxFtH/QhsDW9
	 vO64VYVgxsaW42UhDsPsp4oflQNzksil/Lq06OtiaMlVK/84kkB+eqWzK9+UIqYrkDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAgK6rs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259B6606A319;
	Tue, 20 Oct 2026 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAgK6rs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3E51F000C4;
	Tue, 20 Oct 2026 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792459256;
	bh=rhYKI/4A+OzeChjsjjcXtlKpKqYRA62r9ajrnd4AZRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PAgK6rs+MsoTXvVPfRI9A5YBKFLYe6zC7y1MeHw8VVRJ+IDqIf3oP2fX0DXYAHhik
	 vE9ywrMb24IxGFHVQklP2ioCDCZvrazNNBsYGKY0a3t3yAXpxGevj3drmrGgDdnSpq
	 u0rC7lyBok4UucxRb6M08Owy6MbTz+wvnLneTUJbn9EUAtQ4FIugtxvhPESBoPTYwE
	 C8wQgLkG1AvZkB9h+WXz7BcKBV4JZHihFazcMDEWVbIAPZ9YICjw2O9AAeK8XtOUrH
	 vDhjTMFT9CwcCAQvIbkfdd9zd0vku86xpxaIVWMK/efqtAAJxnfgznCJSlhi0KAAMC
	 oRtZLzjXh7YdA==
Date: Mon, 19 Oct 2026 18:20:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, cjubran@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, saeedm@nvidia.com
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Select DCBX HOST/AUTO from
 capability flags in setdcbx
Message-ID: <20261019182054.7ea49d39@kernel.org>
In-Reply-To: <179180701752.434549.16734295951082648234@kernel.org>
References: <20261011112900.802150-2-tariqt@nvidia.com>
	<179180701752.434549.16734295951082648234@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Oct 2026 12:10:17 +0000 netdev-bot+sashiko@kernel.org wrote:
> - [Medium] mlx5e_dcbnl_setdcbx()
>   (drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c) now returns=E2=80=
=A6
> - [Medium] The patch reports firmware AUTO mode as CEE|IEEE|LLD_MANAGED
>   (0x0e), but only on the setdcbx HOST->AUTO transition path.

These look at the very least plausible, I'm assuming the lack of
dismissal/response means v2 is coming.
--=20
pw-bot: cr
