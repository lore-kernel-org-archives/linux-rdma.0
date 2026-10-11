Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73524361651
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704791; cv=none; b=X8clwUT+ss+4T6D+ucxkumDMng33QHO33RnMbpJBDaB67Qb0i5fWH/lBBKMynr1oq1dZfJT6Zdzr9dmg0RoRya/+8wRXXw9/RE3PgjGI2AV1uiFDoW2d3Q2KP867eFqTiY0eu2Sr5EE5Y8vNquoG3RUEyhqyPsWcrpzfWonq5jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704791; c=relaxed/simple;
	bh=gXRa3wRsFgo/GJ5ct7UtYz3NA7siGGsaKyjWGVto59s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaggMW4bhdrGy3iIMPFZ/+faaoc+A9gj/tLeFc6zaxntkPvelLZUVVMHLeQEt05PfnyuuIjfLWT4tx18Fae5M/ZwmnMNWo4exYMYWtq0RVs9A1wS6Bi+fG5tD+lYtfaCMlQ1RFchLUBnMK39ZNWGiydgpgZr6dKqAwaOqP3H9LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqczmUZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqczmUZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAD41F0089B;
	Sun, 11 Oct 2026 07:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791704790;
	bh=920vhfNS1yZyIYQlZn9RTAlPhWqIsn3iAv9Sq/D3z7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YqczmUZR8MtxS+tT9Yc7wSdlfvUK5eZW3hDsYWDcnbtJaT0vKiX9QNQ0pRRL3v6P7
	 o02uoQeHU0YT2TQTaGnI4wDn1JnY+6ogtrw4Z58mxFOhqeKHWK6KQfHm9i7yMFwgb1
	 fjQgBpojBhKYF+ejpWr/ngMdheRHFEw/yxoaNYkPEKgXM3ZF6xPjV054MvUp+y+3LW
	 kW9sUJJTLNT/tT0lg3ltiQVz8LT1DrPdRxcQMFJYA0/bx2IkWd6D5YKxr/Nh9dEwGg
	 kbDP9g1A5tY3BtbR2h8PnX54L9LK22ZEGj7A5E2fjZqr0pep6k2P+Dxx13a5R/r2kv
	 cG7hYooGiCQrg==
Date: Sun, 11 Oct 2026 10:46:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix NULL deref in del_sa_roce_rule() on
 allocation failure
Message-ID: <20261011074625.GA27033@unreal>
References: <20261002110329.2350-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002110329.2350-1-lirongqing@baidu.com>

On Fri, Oct 02, 2026 at 07:03:29PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> get_macsec_device() allocates and links a new mlx5_macsec_device when
> the macdev has no existing entry, and returns NULL when that allocation
> fails.  del_sa_roce_rule() only flagged the NULL case with WARN_ON() and
> kept dereferencing macsec_device, so a MACsec SA delete event for a
> macdev that was never set up by the RoCE GID path would dereference NULL
> under memory pressure.
> 
> Return after the warning so the SA delete event is dropped instead of
> oopsing.
> 
> Fixes: 58dbd6428a68 ("RDMA/mlx5: Handles RoCE MACsec steering rules addition and deletion")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/hw/mlx5/macsec.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/macsec.c b/drivers/infiniband/hw/mlx5/macsec.c
> index 4732be5..37394ea 100644
> --- a/drivers/infiniband/hw/mlx5/macsec.c
> +++ b/drivers/infiniband/hw/mlx5/macsec.c
> @@ -119,7 +119,8 @@ static void del_sa_roce_rule(struct list_head *macsec_devices_list,
>  	struct mlx5_macsec_device *macsec_device;
>  
>  	macsec_device = get_macsec_device(data->macdev, macsec_devices_list);

At this point, `macsec_device` MUST already exist, and the allocation path
is used only during initialization.

Thanks

> -	WARN_ON(!macsec_device);
> +	if (WARN_ON(!macsec_device))
> +		return;
>  
>  	mlx5_macsec_del_roce_sa_rules(data->fs_id, data->macsec_fs,
>  				      &macsec_device->tx_rules_list,
> -- 
> 2.9.4
> 
