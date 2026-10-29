Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281225;
	b=P/RcWCnI3LLelDw/tSr0HS7y+z4KH+62fcc+eIq5x4LBLMlcm/EorZfLd+QRLxZ3AWv7
	 aTlseTE5u6XrxWQKBCTEVh+zIFWwdu6ttoAnlq1gEvolhF8AELGjbwfIbwngrtSgEJCMR
	 VHVL/pb0/vJdUHSO4f1+oZaI70IMVAmrhrJnvzLy+B4X6dtW/NOTeE19dK/T2gFCgeIky
	 OZHHy0gXuqzslS4ggzxMrjYdGZtkFWf7idOotm+bmesODKVIrBwtNRdmfPNwFDzO5OW71
	 nLqrNYqOJVRIcHMte0ZbD2Vx8oZMzwCzeKWetVvqebaveCvMcgtx+botPsRIUtWs0DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281225;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=07JjotIloxTzjzNMlQHCq+ClgGZqNT7xFNot9yY4/RM=;
	b=0VjLb6k0gY/rZE7TaUoJh/cyhz4R/sxVqxYBaAyDO+eWzkv5KsuNFg6jfOPdBall1F8e
	 mkuuIit4XZ45aZ2/z6DaI6IS7UIhQ4cz4HubQLktL2GS8nCXG+DP97kXWgLEpcw2ror6x
	 33e/Fym3SV+/zHpVvZGOD71Ua/hhY4f+RKt4CG7dak8iOPE0GpPWgjVm/eO6+RXi4S/qZ
	 WTT5+iPjlYm/LWah4k+zCXM1pyWSapua3IndQRnm03rCfiAaEW8sg4Kq5/xuLibxWsxF7
	 v3uGRVKBctA/ClCqwucTtG2sJX7gtwD25+P7/3bsPbK623at3l4rg5lnqRAPnIPlSdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AufeTjOh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39C3606A31A;
	Thu, 29 Oct 2026 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AufeTjOh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71FB1F01241;
	Thu, 29 Oct 2026 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281224;
	bh=07JjotIloxTzjzNMlQHCq+ClgGZqNT7xFNot9yY4/RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AufeTjOhIaoLfT1l6sed/fAoOX1VpUkEehP54UEAyicqiA4X/gNWKab5tLckSMayw
	 RIlE3Ip5eeC0wBxEEEeBdmSFjEiURRnKIxQMYmm41Y+uEUSnHQ1t/W+edwpxcvF11n
	 4rVTihUZqJFbHRG3tBHUnMqPHoDSxwjt9cfcsrvcTOG423Nd9M81yyr06RffHoJ2r1
	 x4QWsS2pH2SbFbYMmr7zVB8SEl7qCQuMtSHHwF4bV3iXCXjROqYih2Gx7p8YN9UBd3
	 C1EyHhK2UozSGGz8yR5K9BWBSW2pwLS2HOPU68pFEt5Iw/aHNETy/IgF2uwn6GrCmx
	 5EYdzKi0nOk7w==
Date: Thu, 29 Oct 2026 13:40:19 +0000
From: Simon Horman <horms@kernel.org>
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, borisp@nvidia.com,
	witu@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: Re: [PATCH net v1] net/mlx5e: kTLS, Fix missing error unwind when
 enabling RX offload
Message-ID: <20261029134019.GG257209@horms.kernel.org>
References: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
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
In-Reply-To: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>

On Mon, Oct 26, 2026 at 06:53:46PM +0900, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
> ICOSQ"), the async ICOSQ is only created when an XDP program is attached
> or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
> the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
> the channels so that they get the queue, but it ignores the return value
> of mlx5e_safe_reopen_channels().
> 
> If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
> which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
> enabled. The next offloaded RX connection then dereferences the NULL
> c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
> not help, as the flag is already set and the reopen is skipped.
> 
> Propagate the error, clear the flag and destroy the accel TCP flow
> tables again, so that the feature stays disabled and the next attempt
> retries the reopen.
> 
> Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> ---
> Found by code inspection while backporting commit abed42f9cd80 to a
> downstream kernel. I do not have a crypto-enabled ConnectX NIC, so the
> failure has not been reproduced and the fix is only compile-tested.
> 
> The crash itself is the one described in the changelog of abed42f9cd80
> ("async ICOSQ allocation is not triggered, causing a NULL pointer
> crash"). This patch only covers the case where the reopen that should
> create the queue fails. ktls.c is also the only caller that ignores the
> return value of mlx5e_safe_reopen_channels(); the callers in health.c
> and reporter_tx.c check it.
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

I agree that a minimal approach to addressing this problem is appropriate
for net.

Reviewed-by: Simon Horman <horms@kernel.org>

However, I do think the logic of this function is becoming somewhat
convoluted and would benefit from:

1. Handling error paths in conditionals while leaving
   the main thread of execution unconditional.

2. Use goto for unwind.

This is approach is complicated by the function needing to
handle the enable condition. But at any rate, maybe a follow-up patch do do
something like this would be worthwhile?

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 3cc1213c2f68..0f5dcd1b822e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 	mutex_lock(&priv->state_lock);
 	if (enable) {
 		err = mlx5e_accel_fs_tcp_create(priv->fs);
-		if (!err && !priv->ktls_rx_was_enabled) {
-			priv->ktls_rx_was_enabled = true;
-			err = mlx5e_safe_reopen_channels(priv);
-			if (err) {
-				priv->ktls_rx_was_enabled = false;
-				mlx5e_accel_fs_tcp_destroy(priv->fs);
-			}
+		if (err || priv->ktls_rx_was_enabled)
+			goto out_unlock;
+
+		priv->ktls_rx_was_enabled = true;
+		err = mlx5e_safe_reopen_channels(priv);
+		if (err) {
+			priv->ktls_rx_was_enabled = false;
+			enable = false;
 		}
-	} else {
-		mlx5e_accel_fs_tcp_destroy(priv->fs);
 	}
-	mutex_unlock(&priv->state_lock);
 
+	if (!enable)
+		mlx5e_accel_fs_tcp_destroy(priv->fs);
+
+out_unlock:
+	mutex_unlock(&priv->state_lock);
 	return err;
 }
 

...
