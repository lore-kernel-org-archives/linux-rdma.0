Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057077;
	b=x4tnIOD5I2vpmcmJGT10wCn7GNR+GDoeS03jjf9UUYYgS4cXZkIKMv4xy0JcG9y6A6VK
	 OoRK/4zj3WtrzpIZLZhegm5FodQMkD8SOfHWNM3l2UkhVW5OQcw0POvimDuq7ll2/Ldjw
	 nJOmh1OLPWoZv6f9kWsZoIPMCNeo308Jfi9FUYak9Ct1931YQMY4vlG7KKFRlW7IsLGGi
	 dnqqD9MOe3klEOjVod4dqPKU/+t0duzkMdptUpY+wsKOmiA/dJw5AeN0txiEAvIy5yod1
	 Vb+9TBQqWPMbMNAvxu06D5fUjVXtEQWTyc14ogr4PLNeVoOB+VZIYmxJuHQL1mmw3Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BqcEEIjFmeUM69vwTv8m9aSeb4ubNbrYt7jzF7m1D4c=;
	b=tgxlaK36hdZ6Cd5smux+cbMO+YAOp8ChXkuZ1aIkC2hM99bfc8LDO/YJ7sDQr04an5wU
	 hvmemhz6NCn+nNS354U6Jl+XYcqINDeyijZL5O1YpIxiJz2Nazi/IHFMEBsYzyiSpjRB7
	 +HcAA+YeRZKEsBcEwNOLfQKLErWn74qT8s4FGxdKVp2mwed5VRxwC/tB7gXcIlMBfosus
	 6s2TFLiWW6aAGzQkeiSKnKF0p5tyL3YeYrf6W/3Qz8PF7fR6GcGN5nfxwtPjlIJCKDnEY
	 5w2ytWLSxDJTltq1oA9kZaAQlPa0ezWdIzW+ymprolHDgMfWTZA+JGAEEryP1OPLF0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X8/yi7xb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D0606A325
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 02:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X8/yi7xb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1089F1F000C6;
	Thu, 19 Nov 2026 02:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795057077;
	bh=BqcEEIjFmeUM69vwTv8m9aSeb4ubNbrYt7jzF7m1D4c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X8/yi7xbqfnERRyhMIAVxAwAGpoW5YajE1NA+/aptxYP/V9nbOV2fsF2ui1bLZDXV
	 NNVYYyGyQKee9UCDPYhBj5oydv5SHsT/Fd2oNE9ER5p2nZ+tmFAMxxqoRxnUX6LrJt
	 4PeLv+OJlrm+akbF4u6GbYZmaBRM+fevFKfpEE599nPG+VurhY4cJDbxq0Ggb/1LwY
	 rXfhvwWHbr4sO8nmSQ7+MoF7lIrCngNO7w5D998ZhSumwSZvi2ERTim9XCeKGuRelj
	 BuAE+d29WfWzlCc4ZmtviyDpguOSXNaWySLm9PHktwlo0XuG4O3oGsJJatxoaSV7/I
	 vDMmZI+KIAHvg==
Message-ID: <sashiko-outbox-222352@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: TC, fix a NULL pointer write in the peer
 flow error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhao Li" <enderaoelyther@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118025708.86215-1-enderaoelyther@gmail.com>
References: <20261118025708.86215-1-enderaoelyther@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 02:57:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] net/mlx5e: missing lock in mlx5e_tc_clean_fdb_peer_flows()
  [1]
--

commit ee17d0ca384445e08f72eadef94d22d26656d903
Author: Zhao Li <enderaoelyther@gmail.com>

net/mlx5e: TC, fix a NULL pointer write in the peer flow error path

This commit moves the peer_flows xarray lookup before __mlx5e_add_fdb_flow()
in mlx5e_tc_add_fdb_peer_flow() so a missing peer entry returns -ENODEV
before creating and linking the duplicated flow.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4cd..d41969117d303 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4630,6 +4630,10 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_=
cls_offload *f,
>  	else
>  		in_mdev =3D priv->mdev;
> =20
> +	dup_peer_flows =3D xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> +	if (!dup_peer_flows)
> +		return -ENODEV;
> +
>  	flow_flags |=3D BIT(MLX5E_TC_FLOW_FLAG_PEER);
>  	parse_attr =3D flow->attr->parse_attr;
>  	peer_flow =3D __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
> @@ -4643,9 +4647,6 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_c=
ls_offload *f,
>  	peer_flow->peer_orig =3D flow;
>  	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
>  	flow_flag_set(flow, DUP);
> -	dup_peer_flows =3D xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> -	if (!dup_peer_flows)
> -		return -ENODEV;
>  	mutex_lock(&esw->offloads.peer_mutex);
>  	list_add_tail(&peer_flow->peer, dup_peer_flows);
>  	mutex_unlock(&esw->offloads.peer_mutex);

[Severity: Critical]
This problem wasn't introduced by this patch, but can
mlx5e_tc_clean_fdb_peer_flows() corrupt the dup_peer_flows list or cause a
use-after-free when racing with concurrent flow additions or deletions
[1]?

mlx5e_tc_add_fdb_peer_flow() and mlx5e_tc_del_fdb_peer_flow() hold
esw->offloads.peer_mutex while modifying dup_peer_flows, whereas
mlx5e_tc_clean_fdb_peer_flows() walks the same list without taking
peer_mutex:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_clean_fdb_peer_flo=
ws() {
	xa_for_each(&esw->offloads.peer_flows, index, dup_peer_flows)
		list_for_each_entry_safe(peer_flow, tmp_peer_flow,
					 dup_peer_flows, peer)
			mlx5e_tc_del_fdb_peer_flow(peer_flow);
}

list_for_each_entry_safe() only tolerates removals by the current iteration;
a concurrent mlx5e_tc_add_fdb_peer_flow() or mlx5e_tc_del_fdb_peer_flow()
modifying dup_peer_flows can invalidate tmp_peer_flow or corrupt the list
pointers mid-traversal.

[1] https://sashiko.dev/#/bug/linux-184eb70a-9503-4852-b7bd-b8b8cdd3b641

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118025708.8621=
5-1-enderaoelyther@gmail.com?part=3D1
