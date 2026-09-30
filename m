Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D34CDDE6
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790771153; cv=none; b=SLGoSrdYWcm9CHGTGAD5kl1y09fl+hAUS40geP8VEjEx14m1flYtnQtw/uguO7LObl3rq6oX8/DYK4us9lylg8m6SbRxuCisBsN0wyihLPiXM6WSs8eTp6oKKoAEIMzHl1zvmeNcUx/I6Y31wXdxmeVZ6BpiUPSGbZj0oqBF67s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790771153; c=relaxed/simple;
	bh=jamKK5yEX8fIi2CdNALG7fgtzSqmZrrqnfo91Vmjxfs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sHhA9sXBvdYKid19McFcZ0RrYYjaN405/2ow2yScohKCeFsrSDtVJNAGKitg9ImMAZpK3K7fZSZP87VbUeWSwwXMktgOjfVYT+Yzgsty2baLMK//xu//W8WwcPBFDqZiA6Yu7pzGcY7xUdrTyrDVoyD0o95RMDUi8DokF/71lt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ceo487Ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ceo487Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC681F00898;
	Wed, 30 Sep 2026 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790771151;
	bh=jamKK5yEX8fIi2CdNALG7fgtzSqmZrrqnfo91Vmjxfs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ceo487Ud8YNn/YpYh1Y3KVL5/bMJ1lTReWsdw0Ktnnuu1huI84mCD7UEn3Tp1cG1h
	 JEwK+EP0dFNEWTnfMla5f7nppVtSUFv96g8S7VORT4ytHbxe9H5MAwW2CWnEvD7frk
	 qfckR7avHLhHNgG3eY+I61SU6PQNA+CZO4yHDrkbTPj9wqfCvNvu0l0IKkoaJMAdhf
	 lEyvVvWm6Phl1DNpW5Fg4onKyRZMjIgj+u8wcHMUb5sZRuCvLGkLTjqGt5fEZTB5Fb
	 AmvOMKSuaQh/C2HxxkI7u4tmRH+Os/js7pw5tPeMtknq3kh2+lEu+c8xeVqb8cXUQ9
	 ow/Wwc8kJ1//w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 4/4] net/mlx5e: tc: Tie esw & accel blocking refs
 to the flow's lifetime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930121119.141953-5-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
 <20260930121119.141953-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 12:25:51 +0000
Message-Id: <20260930122551.BEC681F00898@smtp.kernel.org>
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
> [ ... ]
> Fixes: 7dc84de98bab ("net/mlx5: E-Switch, Protect changing mode while add=
ing rules")
> Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually excl=
usive on a netdev")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930121119.1419=
53-1-tariqt@nvidia.com?part=3D4

