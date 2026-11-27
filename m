Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795816686;
	b=4J9Xn7Tf++dG9k8INNyyNYJUWKjRvE/38EbVRtfqwGpuaUcfEJIn7owItJZgzV/4OL+t
	 DyDVcniSCD0tdx5O3L49PtGNYumECDgvsYCe+v5rVjmIMumFyMRTQjt6pSq8mSkk6ouoM
	 rkgJ6WWLvbTxRvbnnUdPOZ4iuntdCt5JgZ4U9MO4Kdjn47TBj+czgPXzrtsGyj+tyACqi
	 5xBF3f65Z7oniLGG1cZXRokOLXaOIO3DEoEooqCfqNt3pBQEIza+yoroVRh9sgQr5fGhz
	 zuEiRsNlSokrPmBZOYfIlwKP8B20gzedp9ORM2iUnfUUY/DJj8ZoEIibcCnRG1FCdLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795816686;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kzRuCoqIbS37GKkeoJ9OwR11nJk73DST2omF1WqQtWU=;
	b=eQtUAP0TU+3fyZQf+H+xey51C7ii9J38VocuupAHRo3qUYsX4Twg4ixtd6RqeJLyapC3
	 PMoDmFy1v5NrA/XJ+Suu5xUrhHnlq5W7sOskEOBTey15oTSZQjSJqFQNIzpS3jvhicFA2
	 WVAnOfRhPVFhvg4U05hUhsZREfPjikJ/oyiCwzk6jrYuYKrDJBhfOmCEWrAbB4usxxPqc
	 KT+cUFWwqfYsYTpAuwTaNB8MZoLXayx8yEno97nkHH6AFSwJiQiZ7POmzhp1LsNIHFYEA
	 WgCzpLOb6GavgBn4DYzQYc/Ef8n53CCTYaeV9BFKiGfltA3ujHMUp/cm2nmn1UtyA3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFWXzW6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A8606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFWXzW6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A98F1F000C1;
	Fri, 27 Nov 2026 21:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795816685;
	bh=kzRuCoqIbS37GKkeoJ9OwR11nJk73DST2omF1WqQtWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BFWXzW6UXhbGxba11VNvmrBvA+7o6yCLm3bk9w6EY7wOizA48+6QV+acAouGU2wFo
	 sDASFpZULGfMZvYv343/7DLQoPDOkxa+P2IaKhgy2oqB/Y5vX45M3PxmUxs1Eb/8Tp
	 PIoLKafCfwwPgOdrio6QH93Ea3TTx/A+L5Qq0wowvCMeR7TnpgMGgKxx+tqv53VSeF
	 EOlg15u505J9gF7pOPNVSeRz/tRoGkM5ddMEVzADOs9PWGR2VMyv5fEMNxS+fzq26S
	 dYKIHzGW035dvxxmAjKwOYO31gs3r4Nmnj3P2POearLOBUt9ngQalfZHSTU7uPb2RA
	 qYwOqa2+Ez8FA==
Message-ID: <sashiko-outbox-238304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 01/10] net/mlx5e: Initialize IPsec XArrays with
 XA_FLAGS_LOCK_BH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126215614.792598-2-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
 <20261126215614.792598-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:58:04 +0000
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
- [Critical] net/mlx5e: use-after-free in mlx5e_ipsec_netevent_event()
  [1]
--

commit 766bb77d37b4fbf59433c00ce0e158a9137f45fc
Author: Jianbo Liu <jianbol@nvidia.com>

net/mlx5e: Initialize IPsec XArrays with XA_FLAGS_LOCK_BH

This commit adds XA_FLAGS_LOCK_BH when initializing the ipsec->sadb and
ipsec->ipsec_obj_id_map XArrays to match their _bh accessor usage.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index fa6cb51fdb939..a549851c83827 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -1014,7 +1014,7 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
>  	if (!ipsec)
>  		return;
> =20
> -	xa_init_flags(&ipsec->sadb, XA_FLAGS_ALLOC);
> +	xa_init_flags(&ipsec->sadb, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_BH);
>  	ipsec->mdev =3D priv->mdev;
>  	init_completion(&ipsec->comp);
>  	ipsec->wq =3D alloc_workqueue("mlx5e_ipsec: %s", WQ_UNBOUND, 0,

[Severity: Critical]
This problem wasn't introduced by this patch, but can
mlx5e_ipsec_netevent_event() hit a use-after-free on sa_entry while
iterating ipsec->sadb [1]?

xa_for_each_marked() only holds the RCU read lock during the XArray lookup,
leaving the loop body unprotected while mlx5e_xfrm_free_state() frees
sa_entry synchronously with kfree():

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:mlx5e_ipsec_neteve=
nt_event() {
	...
	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
		attrs =3D &sa_entry->attrs;
		...
		queue_work(ipsec->wq, &sa_entry->work->work);
	}
	...
}

CPU0                                CPU1
mlx5e_ipsec_netevent_event()
  xa_for_each_marked(&ipsec->sadb, ...)
                                    mlx5e_xfrm_free_state()
                                      kfree(sa_entry)
    attrs =3D &sa_entry->attrs;
    ...
    queue_work(..., &sa_entry->work->work);  <-- use-after-free

[1] https://sashiko.dev/#/bug/linux-e041e0a2-c15e-4144-a77f-97cf6554a9fa

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126215614.7925=
98-1-tariqt@nvidia.com?part=3D1
