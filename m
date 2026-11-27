Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818726;
	b=Cv+yjt54Z0kohXYvIVZIgDyCPrSyxuTy8VSHsftNOIIUWrDapS+p3rDvtOSnrpfcQrxw
	 sfoI4PiLIYBL6mdbnHgnfIO05+06zXiZlqqAShx2Lo33msb7QJXDILuTVUiRof/RFwn+6
	 /4/d7kvtDmwI9auG824UM6lNsKelxFdrcFUh7qq+ix4Jo9MsOBHiMy8STuorWYG8QOHRK
	 mcc7o5wahtl3tPu965Wvzv+3S+/78X3kPOD0Zr+JtfBiDlyPx83SV9TwrnqqJq9k2AJfU
	 ZO3HNRKafZJhVs+lKFIHywvPbxnOX6/BQlHw8heP7X1VEQiYDTc1p8YEvBaeS5dGMyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818726;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=FiqdaV7zUp63ODbs67Dxl+vNZIGjUZ6TW4mNWPQdGMI=;
	b=lBhA2q7WAmATzy/OPP3izabebNUvcBaGVYU3coPDScmHV7w68lLLuCnUQSO9iGEyeFAE
	 Qk7Cu2P2PnNQKZRs4KK8lVHhFPZ8aNpLh4w/mck1eMQHyhAC/RB62WUwg3sRTtikLPS8r
	 YxsbAxiZbtByvdA7o5H1bEBZ/QEpISfLbmVN10bwfMJ3fac1X6fVcYVKyfM67tw1u7ZFX
	 TZEeZT3nbTIDbXc7HHQ2EP+566j0zxrz6h/pTAw29ZrIDuBDdfTAVqQNtVxk3ECkVKEUs
	 c3k0ScGyCk5H1HpInWkeYFoINRQ9EeeI4OozzG9qk45D+S2dvRChdKeKPgFsxVmEq9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5doRaw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A05A606A31C;
	Fri, 27 Nov 2026 22:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5doRaw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78501F00893;
	Fri, 27 Nov 2026 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818725;
	bh=FiqdaV7zUp63ODbs67Dxl+vNZIGjUZ6TW4mNWPQdGMI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=P5doRaw4sMq0LjAqMnvj3ECiMeanlsuNtvpJsPOwg5K0LiM9Rknjfy29ld2ghvUs6
	 XEANU7ioqFpgl2WnJs1XAjKuOeWVjrPYIwxbYD2+L3Ad+sKYpUJUpC58Qb1CiO+2t2
	 zgAgnvyiKn+h/4x7Wa07ghmrHaKYjvBc60fCowU4bN1Mjb0mnMoQbMxPcbqqhIt0qq
	 PpTAZJqrCDtSz75XKom0hL+T91U0A+RwaGbXbAReZ4FbPggygm5NILGxtGX4mCdBAM
	 9XIfcOo1rDZTZMD/G+49OGVO67IrST4fD8QAqcMwswwdtQ+flIU+sjiqrlchltBadp
	 uFt7I9nqcPyvQ==
Subject: Re: [PATCH net 01/10] net/mlx5e: Initialize IPsec XArrays with
 XA_FLAGS_LOCK_BH
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:03 +0000
Message-ID: <179581872338.3135.9809199278681466764@kernel.org>
In-Reply-To: <20261126215614.792598-2-tariqt@nvidia.com>
References: <20261126215614.792598-2-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message overstates what the change to
  `ipsec_obj_id_map` fixes.

--

net/mlx5e: Initialize IPsec XArrays with XA_FLAGS_LOCK_BH

This commit adds XA_FLAGS_LOCK_BH when ipsec->sadb and
ipsec->ipsec_obj_id_map are initialized, because every mutation of
these arrays uses the _bh xarray accessors. The commit message says the
mismatch leaves bottom halves disabled while __xas_nomem() allocates a
node. It carries Fixes tags for both 403b383a3ce3 and 91bafc638ed4.

> Node insertion drops+reacquires the lock with the lock variants
> corresponding to the configured type. Using the wrong type therefore
> leaves bottom halves disabled during the allocation.

[ ... ]

> Fixes: 403b383a3ce3 ("net/mlx5e: Store all XFRM SAs in Xarray")
> Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in switchdev mode")

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 5c69e89b13a72..502d89a18f9ec 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -2804,7 +2804,8 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec,
>  		mutex_init(&ipsec->tx_esw->ft.mutex);
>  		mutex_init(&ipsec->rx_esw->ft.mutex);
>  		ipsec->tx_esw->ns = ns_esw;
> -		xa_init_flags(&ipsec->ipsec_obj_id_map, XA_FLAGS_ALLOC1);
> +		xa_init_flags(&ipsec->ipsec_obj_id_map,
> +			      XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);

[Severity: Low]
Is the Fixes: 91bafc638ed4 tag accurate for this hunk?

The description fits sadb. In mlx5e_xfrm_add_state(), xa_insert_bh() on
sadb is called with GFP_KERNEL, so __xas_nomem() drops and retakes the
lock using the configured lock type.

For ipsec_obj_id_map, the only call that allocates passes gfp == 0:

drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c:mlx5_esw_ipsec_rx_setup_modify_header() {
    ...
	err = xa_alloc_bh(&ipsec->ipsec_obj_id_map, &mapped_id,
			  xa_mk_value(sa_entry->ipsec_obj_id),
			  XA_LIMIT(1, ESW_IPSEC_RX_MAPPED_ID_MASK), 0);
    ...
}

With gfp == 0, gfpflags_allow_blocking() returns false. __xas_nomem()
then allocates with the lock still held and never calls
xas_unlock_type() or xas_lock_type():

lib/xarray.c:__xas_nomem() {
    ...
	if (gfpflags_allow_blocking(gfp)) {
		xas_unlock_type(xas, lock_type);
		xas->xa_alloc = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);
		xas_lock_type(xas, lock_type);
	} else {
		xas->xa_alloc = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);
	}
    ...
}

The other users of this array are xa_erase_bh() and xa_load(), and
neither of them allocates. The gfp was already 0 when 91bafc638ed4
added this code.

That would make this hunk a harmless consistency change rather than a
fix. Could the commit message say that the ipsec_obj_id_map change is
only for consistency? Alternatively, could the second Fixes tag be
dropped, so backporters don't assume 91bafc638ed4 had a live
sleep-in-atomic bug?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
