Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27913263F44;
	Thu, 22 Jan 2026 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769087152; cv=none; b=gCHFYAQOeQQFxntvXEF2LSF/x2aYMCrpOmqYITL5wL2SSR6WE1vSZ5Kw91e8yy13k7qtJe9DNQvIP+CBDJUPvnacPOUMBjCqpGCf/nMa8jBuBdsn2LJ9gcIw2vglxPm8gavMGg6nhnuk52o80EN+MhkiGtu+G+9Czfa/vspWZRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769087152; c=relaxed/simple;
	bh=vk6R37psom7G924SV6u1ozCfOC4tIJ3qHvx3qNzyIFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvl3E4jXNkKw8ZSGlyz68lylCbNcJC2Adovfsjy5Uqit1tjFtp9XCr8REDxa7lolcdJnQZK57YrEUGXVVYwMjmCxQf1z3MH2YueLCsSQUm+XAGYsswCbYztR77iPBpf5bMFay6RzXtlQtnrBTuXGZew4q4ULuJb5CjNLm5PdaUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlRi4NLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlRi4NLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F68C116C6;
	Thu, 22 Jan 2026 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769087151;
	bh=vk6R37psom7G924SV6u1ozCfOC4tIJ3qHvx3qNzyIFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlRi4NLcjM1vTlm9C9/nw9Rl9dyQgdj0NA9+J4nuNyFMruIet5Sj/HimHSIuhOrb1
	 LHwV/vDcd7SnLZK4epqTOL5PKfcppafYAhh8HObyNrkSP02jImYj38m7PMs0g0bBRw
	 ha8mRm9+iO77k1cZvM6ForgqlRF3CaXmUu0BYOOkH2gaBKhCvFU7cTrtiUyGRY0jwd
	 r2oN/gL2pGv9GPt+idQCye8yzUY8Cyv9wgA4QR6ooVAVLimfDhQE21waK8P+WLdTmU
	 Nk5lIF7TqRkmcbhIoWPz0PdAgn/9/bm9xMq7Fg3wK52BCrJbBgsafhpVXcxEN5pyV4
	 N8Nhk1TFAmKVQ==
Date: Thu, 22 Jan 2026 13:05:46 +0000
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net 0/4] mlx5 misc fixes 2026-01-20
Message-ID: <aXIgqglIyNy3RarN@horms.kernel.org>
References: <20260120081654.1639138-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120081654.1639138-1-tariqt@nvidia.com>

On Tue, Jan 20, 2026 at 10:16:50AM +0200, Tariq Toukan wrote:
> Hi,
> 
> This patchset provides misc bug fixes from the team to the mlx5 core and
> Eth drivers.

Thanks Tariq,

These changes all look good to me.

For the series:
Reviewed-by: Simon Horman <horms@kernel.org>
