Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077963B3C03;
	Thu, 13 Aug 2026 09:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786613223; cv=none; b=nSCUV4QSuDDGiBizfdxO91Cgml+Ka+Lh3AvZcSbzGcLbrkz/SD4Mder8u2xDJgxXFLrBla8bSiEH1XDmpp8oSLnw/HlGI2loBPvDujm6n7X4iq5PsRcrurJuislbpcJuJkzEwFoDczfRnsh55Dowc+ilTFyIAQBmRtRyhMfNfgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786613223; c=relaxed/simple;
	bh=ArKXmPF7XhPzc89ALV/38aI65prPddkQnZkmiumSydU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkJ8eGeEKb8Ldp0FgdwwZujj/4AGn4RNhF69ZTV8L94aHtge4v9/t1dx0vAlaV4G8iuUBed4o/VVSQW9GMEQF4tm3ikgI2dzSrTQ8UqGeZjSobQvUUFeulelWAgHU50SyXfxTGG48H+tNdndg0TwbfEnZzNmYCqsw/EqUIIW6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eh2xdUvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eh2xdUvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F41F000E9;
	Thu, 13 Aug 2026 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613221;
	bh=C6XTY5gzAGH3cDKZJ2V7KZgEsCDVzSmAoVhpZskPvhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eh2xdUvdm9kOHRLQiyMuVHKL/LJgnYx+DFlhO/qif/OIqUhTnIKeBRJCiyIVNdwor
	 8t5lOGsZ2AldWjUuzmDIo52idnM6sdsBAaY1A/5r7enROSxhVzftHiGNxxLykdqFNu
	 5l/JkPZdEpBQGpULrdNfo+PhSo4ZqHImxoSJpTo2keROqewD3/wfoIql3XmVkLFgfB
	 nR8uyrw+RW6aw5DQGvjL1ImB3m057gYjneszcdQTgwTetXgkVbkFePzoCVMp4V0d6f
	 Xtj6FfZ2AngWdGLfPO+ydxcjzkg1Kx3gsHklu+zEgeUTewdHDywmw9Eyz4zVQbmJaV
	 fUBXr4BbskZpA==
Date: Thu, 13 Aug 2026 10:26:55 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Eran Ben Elisha <eranbe@nvidia.com>, Feng Liu <feliu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
	Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: rsc_dump and hv_vhca return NULL on
 create error
Message-ID: <20260813092655.GB196815@horms.kernel.org>
References: <20260811061637.3195320-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811061637.3195320-1-tariqt@nvidia.com>

On Tue, Aug 11, 2026 at 09:16:37AM +0300, Tariq Toukan wrote:
> From: Michael Guralnik <michaelgur@nvidia.com>
> 
> All callers of these create functions treat NULL and ERR_PTR as
> equivalent error cases. Align the return convention to NULL-on-failure
> to simplify the checks at usage sites.
> 
> Since its return value is never checked and failure is non-fatal, change
> hv_vhca init function to return void.
> 
> Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

...

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h

> @@ -63,9 +63,9 @@ static inline void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
>  {
>  }
>  
> -static inline int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
> +static inline void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
>  {
> -	return 0;
> +	return;
>  }

The AI-generated review on netdev-ai [1] points out that the
return; line is unnecessary and inconsistent with surrounding code.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260811061637.3195320-1-tariqt%40nvidia.com

But that not withstanding this looks good to me.

Reviewed-by: Simon Horman <horms@kernel.org>

