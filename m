Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60135B14E
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755158; cv=none; b=EM/BcxEytJ/68AdPUYx+l8wR+gNvKlZJKLMlqDLVb5RzHGPrU+K09qiYwN7i2SBHVB5AS4B5fsbrjOOhShJzj+AYLqe7CJNLI209fn8obaSkx6ILsQTZHKVkq7ZJ/wLBI9uR7bFKxOunrBTQ2o7pIghpepz/xId52a7roeL07ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755158; c=relaxed/simple;
	bh=L2hIGMnoqTFf/j6Dojb2Gf63Or3/5KoxN43KtDUE0FM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oLlyCpxkjJHZlxuICThez8EAjmFhl4TC+whDZuxUwhpzDfpVeWPuoBQD++1qTCzZ9VxcOQ9ugv2AMCnVdZhcT9yRHEdJ0sBqrl9GD+ykSrehrFTx+k45c7Li2rbrRXWrRCNp8yCwVF7fihLVYUKv5UyWydTjww5/b22e3+9FDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+qB5nkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+qB5nkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB701F000FF;
	Fri, 18 Sep 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755156;
	bh=F0KB/YmGTXMaKywVq/mflc4rooupgNCa3V1VzrH5OYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G+qB5nkvTZcRfM2IC+IR6PPEDfP3/H5cuRW782myFMPMAsdiuCBM7vJ5R2lAZsFQl
	 RhnVBgN957AoYwIEpXok200G2lek2g42p4B6XVfJzoX/NHqW0x5RpvsH2X98pjfDrF
	 uWxkb1+GnFZUg6gLgb7MmDs/qGQxbUOHu6baqmMDXbyxDWKNjdliHhkzuAp7/W7/6g
	 IVqR8tKQVxu65U25WilbKu8cuU9qPM3jDX/Ano5JjwIetcAzvOKPRDLtfLaOwqG4Kf
	 aF6RYOSZ+EfNfYwdjjqnQ/hxyCh+LSZevGnp2MKwwfz5wIwtWxMMGS8C9nPH1Ui52i
	 w6KPxhcAF44qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 3/7] net/mlx5e: tc: Tie esw & accel blocking refs to
 the flow's lifetime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-4-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:35 +0000
Message-Id: <20260918181236.5DB701F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> TC flow creation acquires an esw user ref and, where required, an
> IPsec-blocking reference. mlx5e_delete_flower() releases these, but
> bulk cleanup (mlx5e_tc_nic_cleanup -> _mlx5e_tc_del_flow) destroys the
> remaining flows without releasing either.
>=20
> When bulk cleanup runs during suspend, the core device survives with
> stale counters, which can prevent subsequent eswitch mode changes and
> IPsec offload.
>=20
> For the same reason, two more bugs are that the refs are dropped in
> mlx5e_delete_flower(), before the flow is actually freed, leaving a
> window of time where:
> - a racing esw mode change could pull the rug from underneath the
>   existing flow, leading to use after free.
> - new IPsec objects might be installed, violating the restriction of
>   mutual exclusion between TC and IPsec.
>=20
> To fix these issues, this patch moves the reference acquisitions in
> mlx5e_alloc_flow(), before the HW objects are actually allocated, and
> moves the reference dropping to mlx5e_tc_del_flow(), after the HW
> objects are deallocated.
>=20
> Fixes: 7dc84de98bab ("net/mlx5: E-Switch, Protect changing mode while add=
ing rules")
> Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually excl=
usive on a netdev")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D3

