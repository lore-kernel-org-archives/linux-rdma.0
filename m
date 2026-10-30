Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336032;
	b=n5sT4YrFRgWAbLajvoah+UUDsMoH3roVozS+gdykdVNhj4Jp3zkSD2c5mdVV8H9SyomA
	 5Msj+8hGzCDv+9Bhb1+9MaE/SfCyq9GU0Lw6zqV/Sm/ikLN2GbpM6/2DLQ6S4tBI5HTOM
	 HhmtMm/3N938fHPzBp3HeAFZr/xOuxmDeq0EDIOwMhuRso6gd/Vh5MDzmrhOHijA/q/Hg
	 8ZYs1udB+yu2VpmXp1OzJhxgfMI9pQXFM9RdgL9vToSyqSY6fY3m9webffyUANdNt1Y3c
	 K/y8E1ktpg8HqI/fpIeEVPnB+Aoy7mjBU3H+wtfHtwofqKSceKo+ik6TtW3sZA3yveQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336032;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WeaASdl3ZuZa9gGV1VC80Qt/7SoUUnXKClYZmm8Wjbc=;
	b=Qd3YJXUX9mt4paJ838XeuBIc4pFndVvJ2kJtSqs+sUQUMVeY7FFdU4qhVj2Uz3omeRtT
	 ROc+lxjFwq1zcbdtl91rFIYe0shF1AUpgDLq9+HA5JvpkFAUo6lBEpbeS7nrtsqAWLuFr
	 2SjVA8pe2iaKYq69PeGod9LyUO/nQ9Rb7cnwAZVcCVOz5VFaysnjoF+WcbtZAZg9fpAIG
	 pZF+T+EzcHCkGCp9H4z7aSCPVldvYwubl8yJ+E5AOwGSQzjaA8SfDtJ0w6bLE8m6VHuuu
	 G9bCxXX0ZsP5bxP8Ug/9cpjDhhDum81/eLSSVGGw/J30XWzaWeutOChhJPa3keZY7xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pm7QdImC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10473606A324
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pm7QdImC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50781F000C1;
	Fri, 30 Oct 2026 04:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336031;
	bh=WeaASdl3ZuZa9gGV1VC80Qt/7SoUUnXKClYZmm8Wjbc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pm7QdImCjCWehcTvgdSubvue1dl2iroTMP6wJIvOuRm5FGMhLHX+PrsInp0pLz2vf
	 FABYRdQ+8YSa4TP00JEb50xrwEgezC8c0SyxIgQF+oibg1u8CGRJIduLb03WCOKxbm
	 4+fMK6CDZaVBxAFTrCJPseJYec2m3LQLytCtjQ7/TSZYYk9AUF71hSbaglR+l/VHlb
	 qUAEhDieXmOdIZuSnGqmD/aRxN47XrVZaLxgpkeSPYknLdOlcPbBcnCt7tRDG4iqzu
	 0L+Zpqv3WwHIq53O+5WSf7WVyp6JEF3JCyi400CTbspZhvA+egxd7G4FoctZFb2Xb9
	 M/SuNbYs5xhTQ==
Message-ID: <sashiko-outbox-18387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/5] net/mlx5e: resize non-default RSS
 indirection tables on channel change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260511172719.330490-4-tariqt@nvidia.com>
References: <20260511172719.330490-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yael Chemla <ychemla@nvidia.com>
>=20
> When the channel count changes and the RQT size changes with it, a
> problem arise for non-default RSS contexts. The driver-side indirection
> table grows actual_table_size without filling the new entries; stale
> entries from a prior larger configuration may be re-exposed, causing
> mlx5e_calc_indir_rqns() to WARN on an out-of-range index.
>=20
> Replace mlx5e_rss_params_indir_modify_actual_size() with
> mlx5e_rss_ctx_resize(), which fills new entries by replicating
> the existing pattern, matching what ethtool_rxfh_ctxs_resize() does
> for the same case. And restrict the loop to non-default contexts.
>=20
> Call ethtool_rxfh_ctxs_can_resize() before acquiring state_lock to
> validate that all non-default contexts can be resized, and
> ethtool_rxfh_ctxs_resize() after releasing it to fold or unfold their
> indirection tables. Both functions acquire rss_lock internally and
> cannot be called under state_lock. RTNL, held by all set_channels
> callers, serialises context creation and deletion making the pre-lock
> check safe.
>=20
> Guard both ethtool calls on mlx5e_rx_res_rss_cnt() > 1: skip the
> validation and resize when no non-default contexts exist. This
> naturally covers representors and IPoIB, which share
> mlx5e_ethtool_set_channels() but cannot have non-default RSS contexts.
>=20
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260511172719.3304=
90-1-tariqt@nvidia.com?part=3D3

