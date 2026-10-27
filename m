Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793111167;
	b=5tx28PMCcNlFtNzUoMuRMxhh0HEX/4tR6DzMvdtqhUz/2ohxZqw72EzS597hDmlQGvY1
	 LczUIkt1aLV/Q9SY3Jbz9Fuaz7+h8hBXRg6xsHbLoTb+o1xp9U8PiFwypL3WSha87MgsB
	 sQ2AvR+vIRq/pHQdOT8FwlfP0G9HLvdHouH8hpgzf+FGJ8q79OpS5Zg55TWH3AwQCAWWi
	 FPozWxgGkPvVjSUYzOZbGx6Y+1OWM3wcOLrm3o0p+1dk/R3b/B6hoxnmGw9NRBPqcm0M8
	 dHkMtALumX5alSmE2IqeOlPdGNxP6yDPKMXirmRti33vkngjf2sY61la0dt44dsxTLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111167;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z27crQTjHzX0wxvWS41zGiz/0QWCCGhHzWTW1/KXN7I=;
	b=cR3uCIzqy2uC5DbgbDnMT4x/SwQnPH6ngM3BVoDofTTcY5mNgNoriCfCxQtj9BAOxHSf
	 7D+HRft9aSZgHQ5ViUlOmtrte/WVuwjElNkPt5N9D6E3V6lfIYs6u5CJcZ6fYVI8kbLBs
	 NkL6Q4+SBe2uR12R7HNMlJuscG+XB20NKPhjH2Mh8F+jqtUQjWhKSVUSJLXggLsPzO4sD
	 XRQTtRsKbKsr39nSjRJI2GTy7+ooBXECid1qkzI/gjSKOtmsT7UOkRzgCu89AoRtWAA7M
	 xWZda/o/0UroVvMKl9bqWw2WBc0l7adH222gZWiFLkiZoC1Sv8WKYADC1xzTkaVfDJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JMtpTDrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BD3606A31A;
	Tue, 27 Oct 2026 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JMtpTDrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5896A1F01825;
	Tue, 27 Oct 2026 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111166;
	bh=z27crQTjHzX0wxvWS41zGiz/0QWCCGhHzWTW1/KXN7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JMtpTDrF7fiu7lDnMsUp94Cm+JN1Fy3FyhF04TMzNSoaY3KCMum3ks0k+Z8LNcD1+
	 LytnrXmA0L6MKn1657mK5HoWy+CeAHoIuVcict2nwF+WSUNB/1hEwuz1BwtTU6EOo9
	 U4b5LoIsFZBBtrGpFMo/8dYLjeMEbcY2DGWANS34JtaU9hhXNbXHXhliMU6ghaGFtx
	 fRwNuUm1l508qzA3qxRkfekH6d5IHKKdfrVapJg8ZQ/Jt4HQcsX8Z0n/qXJENzBPnR
	 Qbky46Y0NvH+kZTCVozpfldbogvBRwhkDkCA9Zw8NJeHhOqh95K1BxP1teF8yHore6
	 Aq5IpExvqeVFQ==
Date: Tue, 27 Oct 2026 14:26:01 +0000
From: Simon Horman <horms@kernel.org>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: macsec: free SC lookup entries after an
 RCU grace period
Message-ID: <20261027142601.GM257209@horms.kernel.org>
References: <179285888829.90275.17386097105525068016@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179285888829.90275.17386097105525068016@gmail.com>

On Sat, Oct 24, 2026 at 01:21:28PM -0300, Joas Antonio dos Santos wrote:
> macsec_del_rxsc_ctx() removes rx_sc->sc_xarray_element from
> macsec->sc_xarray with xa_erase() and frees it with kfree() right away.
> mlx5e_macsec_offload_handle_rx_skb() looks the element up with
> xa_load() under rcu_read_lock() and then dereferences ->rx_sc, so an RX
> completion that loaded the element just before xa_erase() reads freed
> memory. rx_sc itself is already freed with kfree_rcu_mightsleep(); only
> the element pointing to it was missed.
> 
> macsec_fs_id_del() has the same problem on the TX side: it removes
> fs_id_found from the SCI rhashtable and frees it with kfree(), while
> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() read it
> through mlx5_macsec_fs_get_fs_id_from_hashtable(), which uses
> rhashtable_lookup() under rcu_read_lock().
> 
> Free both with kvfree_rcu_mightsleep(). Both run in process context
> from the macsec offload ops, outside any spinlock, so sleeping is fine.
> 
> The sc_xarray_element issue was pointed out during review of
> "net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete"
> and left for a follow-up; this is that follow-up.
> 
> Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
> ---
> Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no new
> warnings). I do not have MACsec-capable ConnectX hardware, so this was
> not run on a real device and I have no reproducer against the driver
> itself. The free-while-reader-holds-RCU pattern was reproduced with a
> standalone test module under KASAN (slab-use-after-free on kmalloc-16),
> and the same module showed no reports after switching to
> kvfree_rcu_mightsleep().
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 38a3415ac..fb9126f6b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -839,7 +839,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
>  	list_del_rcu(&rx_sc->rx_sc_list_element);
>  	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
>  	dst_release(&rx_sc->md_dst->dst);
> -	kfree(rx_sc->sc_xarray_element);
> +	kvfree_rcu_mightsleep(rx_sc->sc_xarray_element);
>  	kfree_rcu_mightsleep(rx_sc);
>  }
>  

Hi Joas,

This patch does not apply because the problem in macsec_del_rxsc_ctx() has
already been addressed by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of
the MACsec xarray entry on RX SC deletion") using kfree_rcu.

I would suggest taking that approach in macsec_fs_id_del() too
unless there is a reason to use mightsleep.

Quoting the documentation of kfree_rcu_mightsleep():

/**
 * kfree_rcu_mightsleep() - kfree an object after a grace period.
 * @ptr: pointer to kfree for single-argument invocations.
 *
 * When it comes to head-less variant, only one argument
 * is passed and that is just a pointer which has to be
 * freed after a grace period. Therefore the semantic is
 *
 *     kfree_rcu_mightsleep(ptr);
 *
 * where @ptr is the pointer to be freed by kvfree().
 *
 * Please note, head-less way of freeing is permitted to
 * use from a context that has to follow might_sleep()
 * annotation. Otherwise, please switch and embed the
 * rcu_head structure within the type of @ptr.
 */

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> index efc516749..910fafe40 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> @@ -684,7 +684,7 @@ static void macsec_fs_id_del(struct list_head *macsec_devices_list, u32 fs_id,
>  
>  	xa_erase(fs_id_xa, fs_id);
>  
> -	kfree(fs_id_found);
> +	kvfree_rcu_mightsleep(fs_id_found);
>  
>  	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
>  		list_del(&macsec_device->macsec_devices_list_entry);

-- 
pw-bot: changes-requested
