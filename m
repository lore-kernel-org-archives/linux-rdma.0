Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348756;
	b=L0b/f/CANApkx/xAGJyHte110lq81SMZf16TU1HTi8ZxcdObh/1w+/zHvFaDbiapc2Ix
	 k1wIiPzCxLjkdxWGW4cEX49zVwA0C6fKBxPaSGKbuDrSs4szCjWNrKu/124YQgB8wVgI/
	 jeA51CpZrCJfJuMhpPCrmz44vA5diuNky3umXVTqzUZyw7fBFyYGi0kV2VOa3xtc/1yxb
	 YBGaEb4pE+5KT4PU79WEI8+juvXqknP1nwlAHUWRS+/HHNxFnweJLUN9/njWS5xqUQY8h
	 HLhfgNUJmxtfJz4r43M+h/51fvfapP4D2CEkBDaAiIVQOi+gHJpa6lKAFI1pLBy+dbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348756;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yyok/7kTqnmIKTiZKOdqHEMv9e2GxdKkMvuJpoDTbc4=;
	b=J/IH217G7oLua13WUZDn3LPbPA1y1HJj8kRTOeK8V5C0ibWvTvixEym+FkiwNomjZVbx
	 OMhcnlArImWDYBLjTXVFw0dd0Ik4SIhUuvXfVdCWCxVAsrvNqEkCNYwJzUf09atde4HS5
	 aOX1W6LA54Kh6+Hj/SILtDeFfHOyXUeS9qn4INi5FnSjpA8K4a2z6O5WuwGpkMbBUULDx
	 fawdAYsir7jPJsXLG9K6Yw74tCblt/yz0hL7dxFJ2tgcmK2sfv3bueRuBfnZcJl1tO2LL
	 boTPhNyblyJfLzrrIEkxearsj+1lKp5eblmowLdbNWRhO237hFMh1xOxFCE+lYQ8OwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HTzGyBTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284B1606A31A;
	Fri, 30 Oct 2026 08:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HTzGyBTm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BA61F000C1;
	Fri, 30 Oct 2026 08:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793348755;
	bh=yyok/7kTqnmIKTiZKOdqHEMv9e2GxdKkMvuJpoDTbc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HTzGyBTmW80MuUJ01VRc3CawL+cBO03XtXw0+oNf9fn26Cvgrl2tGbb0lC533FKMk
	 E4uDS1yZ0yKu89xK6zU1GlR4ghOqoIBgTfbN7Hud5tKEiBUg8tfAvWM8dfRrydaKJA
	 K1oMOk3fKeWxw+BDAlsjH+sgtaqdgrWfEN8gX4/KlNCn/KTWGJB5sStZjOQ7JCuEHD
	 DX78heTEzsoK6rHr2L/OyFzrlwJ3m2xbXvd8zP7s618i/PttYuvQbKGOo92sBU1V3q
	 T8rc+8Q/8bFVAkmug8th+C9T5YtrWAet3LxOP+n80EMiOijCn3JenihPn+sMYvAB9W
	 +4sHsFO38Ly1Q==
Date: Fri, 30 Oct 2026 08:25:50 +0000
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
Message-ID: <20261030082550.GM257209@horms.kernel.org>
References: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
 <20261029134019.GG257209@horms.kernel.org>
 <8a565dd0-f2a7-4d18-9df7-bcf1ed303a59@linux.dev>
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
In-Reply-To: <8a565dd0-f2a7-4d18-9df7-bcf1ed303a59@linux.dev>

On Fri, Oct 30, 2026 at 10:08:31AM +0800, Xuanqiang Luo wrote:
> On 2026/10/29 at 21:40 Simon Horman wrote:
> > On Mon, Oct 26, 2026 at 06:53:46PM +0900, Xuanqiang Luo wrote:
> > > From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> > > 
> > > Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
> > > ICOSQ"), the async ICOSQ is only created when an XDP program is attached
> > > or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
> > > the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
> > > the channels so that they get the queue, but it ignores the return value
> > > of mlx5e_safe_reopen_channels().
> > > 
> > > If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
> > > which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
> > > enabled. The next offloaded RX connection then dereferences the NULL
> > > c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
> > > not help, as the flag is already set and the reopen is skipped.
> > > 
> > > Propagate the error, clear the flag and destroy the accel TCP flow
> > > tables again, so that the feature stays disabled and the next attempt
> > > retries the reopen.
> > > 
> > > Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
> > > Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> > > ---
> > > Found by code inspection while backporting commit abed42f9cd80 to a
> > > downstream kernel. I do not have a crypto-enabled ConnectX NIC, so the
> > > failure has not been reproduced and the fix is only compile-tested.
> > > 
> > > The crash itself is the one described in the changelog of abed42f9cd80
> > > ("async ICOSQ allocation is not triggered, causing a NULL pointer
> > > crash"). This patch only covers the case where the reopen that should
> > > create the queue fails. ktls.c is also the only caller that ignores the
> > > return value of mlx5e_safe_reopen_channels(); the callers in health.c
> > > and reporter_tx.c check it.
> > > 
> > >   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > I agree that a minimal approach to addressing this problem is appropriate
> > for net.
> > 
> > Reviewed-by: Simon Horman <horms@kernel.org>
> 
> Thanks for the review!
> 
> > 
> > However, I do think the logic of this function is becoming somewhat
> > convoluted and would benefit from:
> > 
> > 1. Handling error paths in conditionals while leaving
> >     the main thread of execution unconditional.
> > 
> > 2. Use goto for unwind.
> > 
> > This is approach is complicated by the function needing to
> > handle the enable condition. But at any rate, maybe a follow-up patch do do
> > something like this would be worthwhile?
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> > index 3cc1213c2f68..0f5dcd1b822e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> > @@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
> >   	mutex_lock(&priv->state_lock);
> >   	if (enable) {
> >   		err = mlx5e_accel_fs_tcp_create(priv->fs);
> > -		if (!err && !priv->ktls_rx_was_enabled) {
> > -			priv->ktls_rx_was_enabled = true;
> > -			err = mlx5e_safe_reopen_channels(priv);
> > -			if (err) {
> > -				priv->ktls_rx_was_enabled = false;
> > -				mlx5e_accel_fs_tcp_destroy(priv->fs);
> > -			}
> > +		if (err || priv->ktls_rx_was_enabled)
> > +			goto out_unlock;
> > +
> > +		priv->ktls_rx_was_enabled = true;
> > +		err = mlx5e_safe_reopen_channels(priv);
> > +		if (err) {
> > +			priv->ktls_rx_was_enabled = false;
> > +			enable = false;
> >   		}
> > -	} else {
> > -		mlx5e_accel_fs_tcp_destroy(priv->fs);
> >   	}
> > -	mutex_unlock(&priv->state_lock);
> > +	if (!enable)
> > +		mlx5e_accel_fs_tcp_destroy(priv->fs);
> > +
> > +out_unlock:
> > +	mutex_unlock(&priv->state_lock);
> >   	return err;
> >   }
> Thanks for the suggestion. Agreed, the nesting is getting hard to
> follow. I'll send a cleanup along these lines to net-next once this
> fix has made it there.

Likewise, thanks.

Just to be clear, the patch I provided informally in my previous email
is compile tested only.
