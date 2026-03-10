Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25583D16FB;
	Tue, 10 Mar 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164332; cv=none; b=o2jmf6eZ8DhJXBcz57k2CUYIoVBYTq39tISeY+ferxbbPmVOUfH8cvYjp0EBZlB/2q/QCTHwiZ5Mpsa6sDIMS+pc7C5VUsU5sY2jn4HAkErT4tg8wTikocH9+o3Z+L/WbWeTvZRVMXtvLW4xJTsuPmup4CrR9WTx2UZ/aMlSdII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164332; c=relaxed/simple;
	bh=ZR4y4Dq3vlE37/TjLc9+GBd+m8ZGfBUo/asRcrC4lhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pndRs3cnEWtZR4RqlpiOoaOyl9eZ0C7rIM2tf8MFZZTj60+Gx8+V7PKthHVoNfyqVlnG/KDxE2M8LSIogjQYyW+LgLVwqD6Xbp2j3vXLol67f4R6yBaVIE2F1eMw1yfdCBGwQTfrFXej7V7tQiqr2WYw0Qukoxkfh5ifs+Honb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JC32qGJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JC32qGJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533DAC19423;
	Tue, 10 Mar 2026 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164332;
	bh=ZR4y4Dq3vlE37/TjLc9+GBd+m8ZGfBUo/asRcrC4lhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JC32qGJ+O1hcVw4yzkk16cdbP5rOVLEJjDUF8gzRPUHidMvj/ULZ09YsNoXk7E+cp
	 /oF6zkXzywqzWRKjpqsSSBQZLPJzT2eRAF6Dx5F1apZ/IdE7uNYdbyy/o/7A2YdRqY
	 ooY92AxCgABedAJCfiukZPLSq16496A3/2DSJ2lUVUOKoxN+FpeGs1aiHdYz/AGXIS
	 Dcv2ZWxqfcWtXBj9eZJ04g91XbNtCgG5jWVbBxzXXY0m1N1Ttl2LjomrUq17yxCLuP
	 HXmJTvlbE3RxHnQIS8NsK+id6q0/Qit5LxHNZUruc5NdncudzlM2lMXktd3AB3zjX4
	 5IQpaGjMklYNw==
Date: Tue, 10 Mar 2026 17:38:46 +0000
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 0/5] net/mlx5e: Report more netdev stats
Message-ID: <20260310173846.GN461701@kernel.org>
References: <20260309095519.1854805-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309095519.1854805-1-tariqt@nvidia.com>

On Mon, Mar 09, 2026 at 11:55:14AM +0200, Tariq Toukan wrote:
> Hi,
> 
> This series by Gal extends the set of counters reported in netdev stats,
> by adding:
> - hw_gso_packets/bytes
> - RX HW-GRO stats
> - TX/RX csum
> - TX queue stop/wake
> 
> Regards,
> Tariq
> 
> V2:
> - Link to V1: https://lore.kernel.org/all/20260204193315.1722983-1-tariqt@nvidia.com/
> - Fix GRO counters of patch #2.

Thanks.

For the series,

Reviewed-by: Simon Horman <horms@kernel.org>

...
