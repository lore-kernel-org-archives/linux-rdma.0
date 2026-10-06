Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47CB38F935
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 11:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285616; cv=none; b=az83eW2CeZ/t86wtFM6gJ3PC2uZ4bn9yA0EQcvn2FUeb2ZyWjcokgyk93zIDUvNjOhBzhp69LVQ62yMzcCnYpfS8zPuxD8s95rTq7DV35XgKHxMB1zv7yxxFaOfDfFY7Znx3MpAmIFGXrmEmGHMeUUZvupApS9SPN76R4uuyxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285616; c=relaxed/simple;
	bh=D6wFdszDhGs5m+LuL7LKN1qrEKbU6wfUnSXNoz6G94o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kg0qnDiSp6TlW0R8B4Q7yiGhjMsH2JI3SWzmq2FXSnHxMFcSsgurIF97OdeNGKqlfK9bm3R94wZjQe5tMUUiIrQ1GzMDhW87phr8CoME9WYzyjot/GLUOPytEKexuWas1EgJFhQHNfduO5Hn5LvAMvt3JSRPxk+eb7OXevc5KDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXQx54ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXQx54ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104F71F000FF;
	Tue,  6 Oct 2026 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791285615;
	bh=D6wFdszDhGs5m+LuL7LKN1qrEKbU6wfUnSXNoz6G94o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XXQx54udECvNHIsDmsG5XpODyNU+yIrnSaj5RPLbjQDD63iPPGPFJS/2x0sEIy8Hw
	 t78k/JF3Ca1s0mpY6T6MzM9+oxRwkN/e5zR+TBu214bJ6YGVwaR7zPf5EVSKARGMt6
	 EK/9lBJH5kNbyhvzrs8ECBbXDBHsL/M+Ez5zrqk2w1veM45xHXLsCEP7fDKjIF65l0
	 tuzA8NQBLdA6KszbbZGxx8w608P+A9mo/WbgORMLHovGcTZFYNLow9uLBqs0VXnjKV
	 wxxT3R/Yw/6XN67QniFDulINfnBYyNBA65tehHOTJAqpQxRCdHy9Ls8PD1SvZA3St9
	 +LAqP9VeByunQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded
 representors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006110219.257714-1-tariqt@nvidia.com>
References: <20261006110219.257714-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 11:20:14 +0000
Message-Id: <20261006112015.104F71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Jianbo Liu <jianbol@nvidia.com>
>=20
> mlx5e_vport_uplink_rep_load() returns success when the uplink netdev is
> missing, so the ETH rep is marked loaded with a NULL netdev, the IB rep
> copies that NULL association, and nothing repairs it later. Unbind
> mlx5_core.eth.<N> in legacy mode, enter switchdev, bind it again, and
> rdma link show still reports no netdev on the uplink port. The netdev
> also keeps the NIC profile instead of the uplink rep profile.
>=20
> Add an attach_uplink_netdev rep op, run from the existing reload-reps
> work once mlx5_core_uplink_netdev_set() reports a netdev. ETH re-runs
> the uplink load, switching profile and setting rpriv->netdev; IB redoes
> ib_device_set_netdev(). Deferring to the work keeps the devlink lock
> out of probe context.
>=20
> Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against devi=
ce unbind")
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006110219.2577=
14-1-tariqt@nvidia.com?part=3D1

