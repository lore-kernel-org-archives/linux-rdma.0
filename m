Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835FA1E5B68;
	Wed, 15 Jul 2026 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126546; cv=none; b=EerUFSBFBHWiV6Gbv3r39XSyQUqA5VIw1OHcSXYJPezw+V3rEm/uzJzMj7E4OW9CPiRFFnG4NIDQkupKsX4/p5DpHLyD8LEoAzSkBjQBAJEqrHZAiu4FE3t0ynDcHTT/LcEXb2ICuR6pVmITy0achinm/AFRulcbKl5HOzHwGbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126546; c=relaxed/simple;
	bh=RA5eAl239pnC21oBM8FR2e98RaUjx/jaBE/mbW41fKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBGWEqTvkIwjrXldzwYjXHzbU7m6cVWNPMHjzlnWVDJ8pvbROyJtOZk/sj9D/Uhl4RHD64+92Zjv0C6MIcfoYgrKtILoOKl1z9Kq1m4VL7snOApNOQI0Sxf83JTiJNr1CFjc+7Pa3yA9PmOdZowLRtu0rDJoKGNbzxR+QvZzPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1Qf7K4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1Qf7K4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B961F000E9;
	Wed, 15 Jul 2026 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126545;
	bh=EcA8XKltHJY/ZWwJgQ4nUBhuW+JogaG1av/hmIt5pfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1Qf7K4OfbNOOv+QDCtK3D5P06ts0W90+8kGzOeOpL78YQBtUYc3iGMpa4wmzKoZC
	 hd+7KVKnsx8NzRnu1qceO0FTWtPXZpkf1vmOLmRJtmgz/zhDOeqP3QbR9W0PQzqkpk
	 PgIg6FrohxZ6LlXZTYAlV5uEKL2starLe0cGqJMuwOFmpCqD8/NMjJZ27ccmpbWSum
	 QVxOrbXWCyUBNy+IEB8id/QMcSVrbrjt7cRiVBOBgaETllOQP42/w5DO5lUnLQ6ZL+
	 szmtpjxosEjc1EUTaUX/q/lOX3182GyQaT9CR0uzGB9ErjX/E1aLPUvRUANL1wn2GR
	 8Q/JE6uF6mZ0A==
Date: Wed, 15 Jul 2026 15:42:17 +0100
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
Subject: Re: [PATCH net-next 15/15] net/mlx5e: psp: Report PSP dev
 registration errors
Message-ID: <20260715144217.GQ1364329@horms.kernel.org>
References: <20260707130858.969928-16-tariqt@nvidia.com>
 <20260714173151.1863310-2-horms@kernel.org>
 <ac799bee802e02b17f5f27e227c84df396d1e1c3.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac799bee802e02b17f5f27e227c84df396d1e1c3.camel@nvidia.com>

On Tue, Jul 14, 2026 at 08:08:03PM +0000, Cosmin Ratiu wrote:
> On Tue, 2026-07-14 at 18:31 +0100, Simon Horman wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> > Full review at: https://sashiko.dev
> > ---
> > --- Patch [15]: [PATCH net-next 15/15] net/mlx5e: psp: Report PSP dev
> > registration errors ---
> > commit 76afe7de4d1e708e7c01d267ef1fb9cf946de937
> > Author: Cosmin Ratiu <cratiu@nvidia.com>
> > 
> > net/mlx5e: psp: Report PSP dev registration errors
> > 
> > This commit updates mlx5e_psp_register() to return an error code
> > instead
> > of void when psp_dev_create() fails. The caller, mlx5e_nic_enable(),
> > is
> > also updated to check this return value and abort if PSP registration
> > fails.
> > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > > @@ -6199,7 +6199,9 @@ static int mlx5e_nic_enable(struct mlx5e_priv
> > > *priv)
> > >  
> > >  	mlx5e_fs_init_l2_addr(priv->fs, netdev);
> > >  	mlx5e_ipsec_init(priv);
> > > -	mlx5e_psp_register(priv);
> > > +	err = mlx5e_psp_register(priv);
> > > +	if (err)
> > > +		goto out_ipsec_cleanup;
> > 
> > [Severity: High]
> > Could propagating this error cause the entire network interface to
> > fail if
> > the optional PSP offload fails to register?
> > 
> > If psp_dev_create() fails (e.g., due to memory pressure or ID
> > exhaustion
> > in xa_alloc_cyclic), mlx5e_nic_enable() will now abort, resulting in
> > a
> > complete loss of networking capability for the device.
> > 
> > Notice how the code immediately following this handles MACsec
> > initialization
> > failures by logging the error and allowing the NIC to continue
> > operating:
> > 
> > 	err = mlx5e_macsec_init(priv);
> > 	if (err)
> > 		mlx5_core_err(mdev, "MACsec initialization failed,
> > %d\n", err);
> > 
> > Should PSP registration failure fall back gracefully and allow the
> > core NIC
> > to function without the offload, similar to how MACsec is handled?
> > 
> > >  
> > >  	err = mlx5e_macsec_init(priv);
> > >  	if (err)
> > >  		mlx5_core_err(mdev, "MACsec initialization failed,
> > > %d\n", err);
> 
> This is an intentional change, as discussed in this thread with Jakub:
> 
> https://lore.kernel.org/netdev/20260417050201.192070-1-tariqt@nvidia.com/t/#u
> 
> We carefully chose to fail device init on the very unlikely event PSP
> dev creation fails.

Thanks, sorry for not noticing that discussion earlier.
