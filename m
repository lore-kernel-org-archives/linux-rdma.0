Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041823B19CE;
	Wed, 18 Mar 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773847676; cv=none; b=I1UfbIR5LuecNwoO9+zZ7icgDsbd4OG6W6AWwaSmQveJuRMJLqoLPtEZ1X+JnYKhIuBzQKxK9KySuAei34lRkdxWhW2zH91eKbC/oOQvtXbcFKr+iQ0Qxi7clNeBBWfUv68mrhkhci2ttkXisJQG9fpZYFTvKwxvbB9yGciCjRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773847676; c=relaxed/simple;
	bh=xYwT38Ow/A3np5f840+TVPKUu5ff7b4db3s9FCASpD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffeFnYBAE2z8FVv8/ddjUeDNeLtc9UpQDWd2mabrbdr1wAEgfK5jwdwu78AeU+0URbUepmU0VXmddS/Pqy8rRnRhxuzzOBeA66Tqr8xDetHiutoI5m5BmBm96ckOsMd2RB/v2/BFQmAkk6Tqq2wanKCbDVRCIsWPX7LuG/b+EN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxSrfrc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxSrfrc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A78FC19421;
	Wed, 18 Mar 2026 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773847675;
	bh=xYwT38Ow/A3np5f840+TVPKUu5ff7b4db3s9FCASpD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SxSrfrc4lL0AbgBzcupyRzdGjYOR+gn+toV/zxwxCpFsEAy/lbFGLfGOBpPWHkSDs
	 tuQokcNAh+JIephWchqus7hSaWm5YXfvH0wAvNhTRmMA+8WS+AnZlW+OGsUPpHML1a
	 /yBewVCbw/Bkr9+75peBls2XRefr3igpIV/QvXZoF6CRu5lLykCPRtkIR/7n8DWJAZ
	 FS+6+cKW7BBX8fiqJRALeDGJrLw1NMqXABkv/VVRmb0ZyOU44LmFHhujeCjxbd5yGe
	 CimMbpLOSoFKnYgMLAvHjTdK7p/92bnKOjRN1gTKTbiybB4MnxZ4OWB38mGBwqxZXv
	 RuTGVTKRcuG+g==
Date: Wed, 18 Mar 2026 15:27:49 +0000
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>
Subject: Re: [PATCH net-next 0/2] net/mlx5: Support PTM on ARM architecture
Message-ID: <20260318152749.GE1753385@horms.kernel.org>
References: <20260316133607.8738-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316133607.8738-1-tariqt@nvidia.com>

On Mon, Mar 16, 2026 at 03:36:05PM +0200, Tariq Toukan wrote:
> Hi,
> 
> This series by Carolina refactors mlx5 crosststamp initialization and
> enables cross-timestamp support on ARM.
> 
> Regards,
> Tariq
> 
> Carolina Jubran (2):
>   net/mlx5: Move crosststamp setup into helper function
>   net/mlx5: Support cross-timestamping on ARM architectures

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>

