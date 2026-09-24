Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8E448E0FA
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246507; cv=none; b=KEXWVvQc42LqWyncNFDPn1IsyU6hB61UpBsekL1PFL9swMhim8/CLn7XdW+HALR7lDgP1TkKa8hi4KKCN9zwLm8PN1dK+GeV/TUZSWGD1D9eC9SykERQ9O80ZIvvMAkN3ucrcG0vgPHL6WOKlgYjuEo44A7lxBb0qJH7w4M1HfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246507; c=relaxed/simple;
	bh=eYgUCAZ3yye3djJwGcEM8KLRnF1QWQcoF18d2yshIuA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vBUvcNvUOGD+9WLcjBWhmYT3BXpvvazttr3u5/SnX0srXxIfVOBTWM2xeDO553rni+my+OpNRsR/KIZfbcHXvbRPus9KsvIRAcXlDcJXFb2ry0jseTUMnYMtABm5kjlyup+Gt/3qtJYUhwhMwrbbmI0pUYGTPxHQ7jNIKQrLFlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j35Ahbav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j35Ahbav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15101F0089E;
	Thu, 24 Sep 2026 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246504;
	bh=WkONLsNQMTE9t27v5dmwk9833GEQkb0Z5sptSz/jXHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j35AhbavpDU8qS48V3pEzJureBAaRVQZucvwWUOl257BeuRgyjO+q1Aj7ThQ6ZlBX
	 WL8QjN9o/CHb5PC6A5tQ2qhisgNqZmRPl11Tj1ttt3BUkMt6yUt91Dgd7M/pHSy5zn
	 11PLJZu1h32pmT9ypoBD0x8eT/f6eaK535VC9PhTEeRzYMIN4htqddT95Co8RwIYEP
	 cc8IUQV1vqjRxZCeiQX96hWwm4gV73Pp9Jgu52JPnh3n6KDUm7v2eVvPzODVzslQUN
	 0VvqyJOwfYXsqemB0c2P+vO95bCyMJD/c6YJDLyRSiQctkVzvEH7QtV0jFgI2o2on9
	 BOlDHB5NfwkCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 02/13] net/mlx5: E-switch, do not leave an
 unpaired devcom registered
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-3-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:43 +0000
Message-Id: <20260924104143.E15101F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5: UAF on unpaired devcom in sqs2vport_start
- [High] net/mlx5: NULL pointer dereference in mlx5e_tc_query_route_vport
--

commit f795a21baba8fe76b75fbf1109d13ce32a85a0d0
Author: Shay Drory <shayd@nvidia.com>
net/mlx5: E-switch, do not leave an unpaired devcom registered

This commit ensures that an unpaired eswitch offloads devcom component is
not left registered if the initial PAIR event fails. It calls
mlx5_esw_offloads_devcom_cleanup() to release the devcom component when
pairing is unsuccessful, avoiding incorrect state retention.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b62601682..e7d92d9bde16d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
[ ... ]
> @@ -3572,10 +3573,12 @@ void mlx5_esw_offloads_devcom_init(struct mlx5_es=
witch *esw,
>  	if (!esw->devcom)
>  		return;
> =20
> -	mlx5_devcom_send_event(esw->devcom,
> -			       ESW_OFFLOADS_DEVCOM_PAIR,
> -			       ESW_OFFLOADS_DEVCOM_UNPAIR,
> -			       esw);
> +	err =3D mlx5_devcom_send_event(esw->devcom,
> +				     ESW_OFFLOADS_DEVCOM_PAIR,
> +				     ESW_OFFLOADS_DEVCOM_UNPAIR,
> +				     esw);
> +	if (err)
> +		mlx5_esw_offloads_devcom_cleanup(esw);

[Severity: High]
Does this newly added cleanup path dynamically free the devcom component
while concurrent operations on registered netdevs might be accessing it?

In esw_offloads_enable(), mlx5_eswitch_enable_pf_vf_vports() registers
representor netdevs, making them visible to userspace. If the pairing
fails here, mlx5_esw_offloads_devcom_cleanup() immediately frees
esw->devcom (without an RCU grace period).

Because the representor netdevs are already registered, a concurrent
ndo_open (often triggered automatically by udev) will execute
mlx5e_sqs2vport_start(). This function accesses the devcom pointer
locklessly:

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:mlx5e_sqs2vport_start() {
    ...
    if (mlx5_devcom_comp_is_ready(esw->devcom) &&
        mlx5_devcom_for_each_peer_begin(esw->devcom))
        devcom_locked =3D true;
    ...
}

Could this race condition lead to accessing freed memory, triggering a UAF?

[Severity: High]
Can this also cause a NULL pointer dereference later on?

If the initial PAIR event fails, mlx5_esw_offloads_devcom_cleanup() is
called, setting esw->devcom =3D NULL. However, mlx5_esw_offloads_devcom_ini=
t()
returns void, so its caller esw_offloads_enable() ignores the failure and
successfully enables offloads mode.

When offloads are enabled, a user with CAP_NET_ADMIN can add a TC rule with
an encapsulation forwarding destination, causing the driver to invoke
mlx5e_tc_query_route_vport(), which blindly iterates over esw->devcom:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_tc_query_route_vport(=
) {
    ...
    mlx5_devcom_for_each_peer_entry_rcu(esw->devcom, esw, pos) {
    ...
}

Because esw->devcom is NULL, mlx5_devcom_get_next_peer_data_rcu()
unconditionally dereferences devcom->comp:

drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:mlx5_devcom_get_next_p=
eer_data_rcu() {
    ...
    struct mlx5_devcom_comp *comp =3D devcom->comp;
    ...
}

Would this result in a deterministic crash?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D2
