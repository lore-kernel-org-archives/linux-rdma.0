Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793466908;
	b=UKGAtJJ3mTSMbId9M81AVSDmAxFtYYoAEld4lgSLCiqhvexUeurYnSv8N2JxqoEMwMI3
	 mAs7+PXyWQF3yLxqRMLhFVKO9pzYTo3uGkWExvJal9PP+fBb62N0hl8E9Kicf7kYZMDtK
	 DVoA42sb+YFSRbN6XrWO07JLHqCFolSjf4hKcHm6JOR59dJY8Pb2/peVDGElDr2NvdXCx
	 GVA6fmejK5KNwDQKqd9zFEB5ZL+ZkgCF2uKRrJZ63C+lEliuo8k/zuUyho9wRcuyoUkc0
	 7NL3tR18PHDEJgTTxfblYjk1GhQo/YpKJtRciWr4gnxqhLeXaPt1ddlRjgBZ/OdLsyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793466908;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bHlvjqB25V4L8nTFSkvwTyjVDrH38SIIXQz2UDWl2zQ=;
	b=XKUxCGu0HXVb09I1Gs/jh31mSrndHfIok9TFt1IoZjaLS/TB81f18TKOgcr4uAqddCtB
	 X/QwpM7avjSt5DisfGi8uwsUOh2d9EyM0UimpHQB5rolH6qDzSoeh0oyMcfTFAphuva2S
	 IUs2g1q9+cc828Qc/M2Y1wegLg2VgbleXzkDkNByI5gqZ3mH7qo1zyJUHK6byNy7Wo+sy
	 51pN3VfXSQLRvw+LQ11jwiKYoMQ0ctfn+9BlYLUytGm1lz+TuIOsGZ7/RhIZ7FP6HJsnB
	 +4ECpOC6JIFUbGiyZ5rf5QgBPX5h4sBatmDS8p0Ylfk68qw1dCVGKKIFG/Wkx+G73qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQpgKMWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D749606A31D;
	Sat, 31 Oct 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQpgKMWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C391F00919;
	Sat, 31 Oct 2026 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793466907;
	bh=bHlvjqB25V4L8nTFSkvwTyjVDrH38SIIXQz2UDWl2zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kQpgKMWnLaqZ7hr2kQf07gjCaH2p+09H85n8fc9S7xwlLfSrzANZPnYctO+ucFdkO
	 I+71FkIrUlGV92iOiJvcfMWQ3xJJwU/RTuucKtJavSUZL/pOoUqBjq2O/nYigdRFNr
	 sb+4VATVXZj3VxxQANApN8lMUjMfqH4twjmyU/caLitWCi6u20RJCr7s+9sf6mmfaH
	 WYjNCPutZoFk14PfLTxujd2rNdNnz+X1+ZUOuXXPv3eKJ369zp13G2Y/ju1GFrjhfY
	 nvOmPu8H8XTWXYPN8uPANBscguZc5k+quFKXAGPSNSsJBZbizUWDkecbqc5ls+SEHc
	 dtCvYFPuM2cmg==
Date: Sat, 31 Oct 2026 17:15:02 +0000
From: Simon Horman <horms@kernel.org>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an
 RCU grace period
Message-ID: <20261031171502.GP257209@horms.kernel.org>
References: <179313582625.87630.11382992904624255106@gmail.com>
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
In-Reply-To: <179313582625.87630.11382992904624255106@gmail.com>

On Tue, Oct 27, 2026 at 06:17:06PM -0300, Joas Antonio dos Santos wrote:
> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
> rhashtable_remove_fast() and then frees it with kfree() right away.
> 
> The TX (SCI) table is read locklessly from the transmit path:
> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
> rhashtable_lookup() under rcu_read_lock() and then reads
> mlx5_fs_id->id. A transmit that looked the entry up just before it was
> removed reads freed memory.
> 
> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
> device inside macsec steering") the SCI table held struct
> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
> with the new struct mlx5_fs_id, but frees it with a plain kfree().
> 
> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
> 
> The same issue was flagged by the Sashiko AI review as a pre-existing
> problem while reviewing the HW-GRO for PSP series.
> 
> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
> Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
> ---
> v2:
> - Drop the macsec.c hunk: the sc_xarray_element free was already fixed
>   by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of the MACsec xarray
>   entry on RX SC deletion"). (Simon)
> - Embed an rcu_head and use kfree_rcu() instead of
>   kvfree_rcu_mightsleep(). (Simon)
> - Fixes: now points at the commit that introduced the kfree().
> - v1: https://lore.kernel.org/all/179285888829.90275.17386097105525068016@gmail.com/
> 
> Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no new
> warnings). I do not have
> MACsec-capable ConnectX hardware, so this was not run on a device.

Thanks for the update, and testing and discovery information.

Reviewed-by: Simon Horman <horms@kernel.org>

