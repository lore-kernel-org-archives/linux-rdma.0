Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E411D39B4A3;
	Wed, 17 Jun 2026 09:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781687908; cv=none; b=p0cn+kwt8jKTV8s6f2Gr7r5s8S/qTWRDqODsjgTZANL0+rTeICufgv33ew9V6l+uM50kX7xFdo4jRMnCb/ge7xvLRvSnvXcuR+x8rbAH9G0kZ4uHjB3gnZCMPf6Yem5QB/jb0WCRPZxIUuZpQ4Vay/IEUiojpS/bHHJCNqg/OU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781687908; c=relaxed/simple;
	bh=jU+y4zwGW5m9F+uZkVQ/IsuSU9Z9wtD6LH5H8jCyUPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu3P5hf+pZsF0KrwxHO5jdst89EYaNvLe2tmNrcBU52qSSUuma17Uy9n0RqKuQq/98xYJZCAJzcWF6kxXqohtXHlDB+FoSZhz9SLjZJsHdAeVo6A14l1aLnM046dw16XAMqwUYCbqhvWzcGyD6dOOxzfQOLWYNY8FEf//PX1+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKvst9fX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKvst9fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F21A1F000E9;
	Wed, 17 Jun 2026 09:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781687907;
	bh=EtNxW7/37fBEOlp38QPfab6gfweMcAFcEQ1RgfKloiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKvst9fXi2R1TDymljJrc6AzQ+h9tCJfP4PIijyCLDV76XTG3aUP7jios0lc8vvJW
	 wrRahawIRsQ+OPKPdq7je/hchFPjjHCPZohsuaNjxm1BcPjxTCDVY8n2/mCm2aAM7H
	 zXLrsbXwC+8ziBuz7+e9gDXD5MCmnpwl3Lju9Y8xKD6VyVNK+tviH3ZXMN+LjOqn30
	 zjKGX2rO5i/EVprgo85hlksRklXiFopnO57f/mv+7cG+7s0fEDqX6b+LDUE6POjJOg
	 YGhsPv3hyVNyUXUpEOJqlWfTz0ZBfayCvtda9zGnSUnHNCy5JVQkfNgcospb47T/sG
	 7cnRM1qBtkO+Q==
From: Simon Horman <horms@kernel.org>
To: doruk@0sec.ai
Cc: Simon Horman <horms@kernel.org>,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	borisp@nvidia.com,
	sd@queasysnail.net,
	raeds@nvidia.com,
	ehakim@nvidia.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete
Date: Wed, 17 Jun 2026 10:16:35 +0100
Message-ID: <20260617091634.846438-2-horms@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615140534.52691-1-doruk@0sec.ai>
References: <20260615140534.52691-1-doruk@0sec.ai>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev
---
net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete

This patch replaces metadata_dst_free() with dst_release() during MACsec
RX SC deletion. It relies on the dst subsystem's refcounting to defer freeing
the metadata_dst until the last reference is dropped, aiming to fix a
use-after-free when an skb still references it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 71b3a059c9647..2a4e7ed76d315 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -829,7 +829,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
>  	 */
>  	list_del_rcu(&rx_sc->rx_sc_list_element);
>  	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> -	metadata_dst_free(rx_sc->md_dst);
> +	dst_release(&rx_sc->md_dst->dst);

[Severity: High]
Does this change introduce a new use-after-free in the RX datapath?

When dst_release() drops the refcount to 0, concurrent readers in
mlx5e_macsec_offload_handle_rx_skb() can still find the object via RCU
and call dst_hold(). Because dst_hold() uses rcuref_get(), it fails on a
0-refcount object without incrementing the count.

However, the datapath still attaches the 0-refcount dst to the skb. When the
skb is later freed, skb_dst_drop() will call dst_release() on already-freed
memory.

Should the datapath be updated to use dst_hold_safe() instead?

>  	kfree(rx_sc->sc_xarray_element);

[Severity: High]
This is a pre-existing issue, but does this synchronous kfree() cause a
use-after-free for concurrent datapath readers?

The element was just removed from the RCU-protected xarray via xa_erase(),
but the RX datapath can still be accessing it via xa_load() under
rcu_read_lock() in mlx5e_macsec_offload_handle_rx_skb().

Should this use an RCU-deferred free mechanism instead?

[Severity: Critical]
This is a pre-existing issue, but does mlx5e_macsec_offload_handle_rx_skb()
blindly dereference the result of xa_load()?

drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:mlx5e_macsec_offload_handle_rx_skb() {
    ...
    sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
    rx_sc = sc_xarray_element->rx_sc;
    ...
}

If xa_load() returns NULL (e.g., if the entry was concurrently deleted by
xa_erase() or the packet has an unrecognized fs_id), will this cause a
deterministic kernel panic?

Is a NULL check needed before accessing the returned element?

>  	kfree_rcu_mightsleep(rx_sc);
>  }
