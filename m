Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9C03BED6F;
	Wed,  4 Mar 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636366; cv=none; b=s3Jravt6TB6w2Dp2Qlxgtb4jCHCNEvQ9DC1+vp9RIvk7vOm2Dm6o23w01tP642C6pvnCPcIbGe9tMhy6NKsCQbs5yOqoYk8MNegBCMDzBl/c0UdFwX3qbR2aAx1KfFzVYr6sy5d3cL5erjmNsJy7GkUaB8VX4laPIugWesksZWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636366; c=relaxed/simple;
	bh=8m978avJtiE2qwB6faByNUDUe1e7gXag3V+oKgVdQq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG0Rk7ccFfZnDS0ckS3tlYm2kf0XJHbqoATvfXEnlLOuATzH4Nnp79ppr3CwHoLxzBDU+2SPl3xNCjzR3FomA8hLYiQWA77ATlo8qukd/WlCW4UHTcQujgCSdnIQ5bS1c0ic/Rv+P8eon8Kdbud3OkdPp48kWYhGuKviyfm0maQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtWTefmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtWTefmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55526C4CEF7;
	Wed,  4 Mar 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636366;
	bh=8m978avJtiE2qwB6faByNUDUe1e7gXag3V+oKgVdQq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZtWTefmXgeEhcwLoFHXUM1GGgI4QjmtCYv8wWgveRlhz/bPFHwoa0iJKLAM8J25X8
	 RScoKb4hzBZdcb4eyojTFnXNhz9XxM1HGKyR0lZrnwXgeeL0izQz9Q57qMoz6MNnh9
	 gTXo+4IUbCoFXxgN/oLsyJCtRxIUz0F2M/lKP1urewzhCIh9UDqNE+9ZMm66yaT+S5
	 EXOR/SF2D1DhaCr7xxA1aVSSskcjc9XPB5t9FcsEMsbHGz4+uidqSCEgZegulijpel
	 FulLg9DpmRPaemiUangA5QSg/sr3l2ZLEFwWkURTWy7cnMHD0iifmgVenelSg4fX/q
	 H1GBj8Dine3Gw==
Date: Wed, 4 Mar 2026 16:59:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Erick Archer <erick.archer@outlook.com>,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/6] RDMA/mana_ib: Allocate interrupt
 contexts on EQs
Message-ID: <20260304145923.GE12611@unreal>
References: <20260304000017.333312-1-longli@microsoft.com>
 <20260304000017.333312-7-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304000017.333312-7-longli@microsoft.com>

On Tue, Mar 03, 2026 at 04:00:17PM -0800, Long Li wrote:
> Use the GIC functions to allocate interrupt contexts for RDMA EQs. These
> interrupt contexts may be shared with Ethernet EQs when MSI-X vectors
> are limited.
> 
> The driver now supports allocating dedicated MSI-X for each EQ. Indicate
> this capability through driver capability bits.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/infiniband/hw/mana/main.c | 33 ++++++++++++++++++++++++++-----
>  include/net/mana/gdma.h           |  7 +++++--
>  2 files changed, 33 insertions(+), 7 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>
