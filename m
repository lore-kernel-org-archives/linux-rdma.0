Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0339E18E;
	Wed, 15 Jul 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126578; cv=none; b=GHIb+ynOh6wmrnEao5bykvrzq2zJlG7n17LADpS+HBPQW5pz/889eRVm49dheI7Kcvq+iY/+Gvx7k0FPOq5FMCcePoXLO1+uuHjNgy2BhQNDZqV84/UC8NucvX9mT06YCbflONMxkiyDICXGpnyZNvr3VVFzJ5Zt3338U0dC0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126578; c=relaxed/simple;
	bh=hZfKkntzRF3JWotGHA9KobmY7110d0rvs9C45TNTPhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heMGXr7mmz6w7f58HI/vkjNWztxr6EaoVVP/D/yHPpDq2r54itDTKyFtznZyI/dMP+haDhwF+OIjg8QOrB7dADkAG0vc081DOblWjylM9bJAw0/iDkvxXtKFf4k3O7x/3z5AupbTVdQ026BnDxagset8G3ewuCBsByZeCVzOgIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqrTUef5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqrTUef5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D760C1F000E9;
	Wed, 15 Jul 2026 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126576;
	bh=y94y46NC3K1ZZI8tlKiA/R/+i1PYrV6dRlO0JHTnWns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fqrTUef5hie4dseuKlvJZWMbM6oxzMfztOTlfDAO5YP6VUIDGCPQkD0/M91jQGTRd
	 pWbmXHdRI9tqw+6i0VtgnJZNvjaRJMBfnbnC/u7TkQ1dyMH9bws7pjlxdqIEsGoNCi
	 xmFYvssOGsmaJHXv3opkIkyDFhgIDbWmKR+T9McqG/mpiqIdfspTUH6zvad7vH1kGq
	 OyufaeddCz5b/+X24ioC/c9E+6bqSFa2g+yDCgauqAVYXjC1szXnIr2w2ogj+G8/g8
	 B3XxKmluDQIbRYydCJFMxplaNIHqetMj/rJkwG6WJBK1cNYfBvvzCdoYi57RI9MqMV
	 HAK20AqgF+hSA==
Date: Wed, 15 Jul 2026 15:42:49 +0100
From: Simon Horman <horms@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"daniel.zahka@gmail.com" <daniel.zahka@gmail.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"leon@kernel.org" <leon@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Raed Salem <raeds@nvidia.com>, Chris Mi <cmi@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"sdf.kernel@gmail.com" <sdf.kernel@gmail.com>,
	"kuba@kernel.org" <kuba@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	Saeed Mahameed <saeedm@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"aleksandr.loktionov@intel.com" <aleksandr.loktionov@intel.com>,
	Gal Pressman <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
	"jacob.e.keller@intel.com" <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 13/15] net/mlx5e: psp: Make PSP steering config
 dynamic
Message-ID: <20260715144249.GR1364329@horms.kernel.org>
References: <20260707130858.969928-14-tariqt@nvidia.com>
 <20260714173021.1862773-1-horms@kernel.org>
 <a7f3a36f058d7ee1298c8f3f5d5c65c1aa7863b6.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7f3a36f058d7ee1298c8f3f5d5c65c1aa7863b6.camel@nvidia.com>

On Tue, Jul 14, 2026 at 08:05:39PM +0000, Cosmin Ratiu wrote:
> On Tue, 2026-07-14 at 18:30 +0100, Simon Horman wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> > Full review at: https://sashiko.dev
> > ---
> > --- Patch [13]: [PATCH net-next 13/15] net/mlx5e: psp: Make PSP
> > steering config dynamic ---
> > commit 133d9a32cbf9c1b939ae4ca8473c41624c313951
> > Author: Cosmin Ratiu <cratiu@nvidia.com>
> > 
> > net/mlx5e: psp: Make PSP steering config dynamic
> > 
> > This commit changes PSP steering tables to only be created when PSP
> > configuration is enabled on a device, instead of at device
> > initialization
> > time. This avoids imposing steering overhead on all UDP packets when
> > PSP
> > is not being used.
> > 
> > > diff --git
> > > a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> > > index b526b3898c22e..3f212e46fc2f9 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> > > @@ -220,18 +220,7 @@ static inline void
> > > mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
> > >  
> > >  static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
> > >  {
> > > -	int err;
> > > -
> > > -	err = mlx5_accel_psp_fs_init_rx_tables(priv);
> > > -	if (err)
> > > -		goto out;
> > > -
> > > -	err = mlx5e_ktls_init_rx(priv);
> > > -	if (err)
> > > -		mlx5_accel_psp_fs_cleanup_rx_tables(priv);
> > > -
> > > -out:
> > > -	return err;
> > > +	return mlx5e_ktls_init_rx(priv);
> > >  }
> > >  
> > >  static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
> > > @@ -242,12 +231,6 @@ static inline void
> > > mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
> > >  
> > >  static inline int mlx5e_accel_init_tx(struct mlx5e_priv *priv)
> > >  {
> > > -	int err;
> > > -
> > > -	err = mlx5_accel_psp_fs_init_tx_tables(priv);
> > > -	if (err)
> > > -		return err;
> > > -
> > >  	return mlx5e_ktls_init_tx(priv);
> > >  }
> > 
> > [Severity: Critical]
> > Does removing the unconditional table creation here prevent PSP
> > tables
> > from being restored on device attach or resume?
> > 
> > Since mlx5_accel_psp_fs_cleanup_tx_tables() is still called during
> > device
> > detach or suspend, the PSP steering tables are destroyed. However,
> > because
> > mlx5e_accel_init_tx() no longer recreates them, the tables appear to
> > remain
> > missing after a suspend/resume or detach/attach cycle.
> > 
> > Because software psp_assoc structures remain bound to active sockets,
> > could
> > this leave the device in a state where the hardware TX steering table
> > (which
> > contains the CRYPTO_ENCRYPT action) is missing?
> > 
> > If so, would this cause egress traffic to bypass encryption and be
> > transmitted in plaintext?
> 
> When the device is suspended, 1. all TX keys are released and 2.
> steering rules are removed. 3. psp state is completely freed, including
> the configuration intention.
> 
> When the device is resumed, psp is reinitialized to a blank state.
> 
> Before these changes, psp was also reset to a blank state (no keys, but
> with steering rules readded). This also broke existing PSP connections.
> 
> I guess fixing this behavior during suspend is outside the scope of
> this series. I don't like it, we should do something about it, but not
> in this series.

Thanks, point taken.
I think we can leave this problem for another time.
