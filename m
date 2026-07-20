Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA993D3009;
	Mon, 20 Jul 2026 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538635; cv=none; b=RezuGCH4bVF/coESrt7Hd8jrvT511FEKJT6Ro8K+Gy1mkHP2LNW0K5wRV68qxFi1ezIqXxSTwVMX3tUVlk2D15lk7F2PhvhYKFVH9d4aljBA+ZBbynGkWdfyHe8ifZxorY8PZtFkueZo52AGsorpOqgHok/Yo8Wvz3r2vp2p6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538635; c=relaxed/simple;
	bh=1ur2sRrsV6M8TA663jX6fwz2NVI21BsbsMzp3x8hC/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyZk8ex9uZtgkojWQRuMc3hBI3+HPd23auzWMM+vlVc7CWQIVWIdXoTOfqYm4zPIdGN/oUKvlgsHKwcycaoCz17CnfV78H1mm1x83Mbcmi9XxSD/3H5SSZp1g+dqyG0+eQErT0buacsYII4COGUJ6I/PCAsCtuyVyw0mZKkKqcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeI6xOwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeI6xOwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75701F00A3D;
	Mon, 20 Jul 2026 09:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538634;
	bh=OlDOR6QIXX40SA1b1X3OI1GseNGDJ+TKy8N2BwkgN+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IeI6xOwhSiaGc/hVKFDmtK6NDZDy30PQbDbqfK4qPuHQBNOqWcapZsCcmFeP5y020
	 JTJS807DyZMV3t8NywHkWDnkgSOOuI9dVawpugpfYMpFeLZcq8k2SIT4Q+Sdr8/KED
	 H2yuMTofIXwj66CggXp9J72OGUtl0K2pl7qfseGc4CWzwngRfuybvgGoq+OJuMit2U
	 mbPcQe0xcm7DkB5n5QB97hiMoh40LcYFyftQzqY69aiNl5gsa3N9wbOpaeFSc0C16x
	 ZIe5zxvntbndWoDyNQNtXpev3oDmZBELUVnWMJ7eDCPz4D7PbsjBlcSgCYdXvKtYHN
	 phUhvXL/i1F4g==
Date: Mon, 20 Jul 2026 12:10:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: FW tracer, clamp firmware-reported
 num_string_db
Message-ID: <20260720091027.GD110966@unreal>
References: <20260717072543.1241094-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717072543.1241094-1-tariqt@nvidia.com>

On Fri, Jul 17, 2026 at 10:25:43AM +0300, Tariq Toukan wrote:
> From: Akiva Goldberger <agoldberger@nvidia.com>
> 
> mlx5_query_mtrc_caps() reads num_string_db from the MTRC capabilities
> register and uses it directly as a loop bound to populate the fixed-size
> base_address_out[STRINGS_DB_SECTIONS_NUM] and
> size_out[STRINGS_DB_SECTIONS_NUM] arrays in the tracer's str_db
> structure (STRINGS_DB_SECTIONS_NUM == 8).
> 
> The field is 4 bits wide, so firmware can report up to 15. A value
> greater than STRINGS_DB_SECTIONS_NUM makes the loop write past the end
> of those arrays, corrupting adjacent fields of the fw_tracer structure
> on the kernel heap. Clamp the firmware-reported value before it is used.
> 
> Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> index adcc73e2a5b3..404736c46adf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> @@ -64,6 +64,13 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
>  	tracer->str_db.num_string_trace =
>  			MLX5_GET(mtrc_cap, out, num_string_trace);
>  	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
> +	if (tracer->str_db.num_string_db > STRINGS_DB_SECTIONS_NUM) {
> +		mlx5_core_warn(dev,
> +			       "FWTracer: Firmware reports num_string_db (%u) > (%u), clamping\n",
> +			       tracer->str_db.num_string_db,
> +			       STRINGS_DB_SECTIONS_NUM);
> +		tracer->str_db.num_string_db = STRINGS_DB_SECTIONS_NUM;
> +	}

First, these lines are:

"tracer->str_db.num_string_db = min(tracer->str_db.num_string_db,
				    STRINGS_DB_SECTIONS_NUM);"

Second, this is a very naive approach to "securing" the system.
Everything originates from the firmware: registers, DMA, and data.
You cannot single out one field and claim the system is now "secure".

I am aware of another large vendor that added similar "clamping"
throughout their driver. That does not make the implementation correct
or particularly useful.

Thanks

>  	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
>  	tracer->str_db.loaded = false;
>  
> 
> base-commit: 3f1f755366687d051174739fb99f7d560202f60b
> -- 
> 2.44.0
> 
> 
