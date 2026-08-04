Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F6430301;
	Tue,  4 Aug 2026 08:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830704; cv=none; b=OkmmJ6mKnFZfZDz7Wp6nUoZ549a4EGsGC5CZgP2suVSU81zCcpBDkZWGcsftTxtUxMCKMtIFjQv13QRlAS8CY/b+PYegrzw4hsoI+cw0Iavw6cB/+ZdzjxNnmiKadiMnO5Rj/Yi00FU+xrrioORhT7dOjurYRkoA8sbGyz91kRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830704; c=relaxed/simple;
	bh=EvIu7mj+n5pIjDxwLqnyzUhlmqcQ9usbRRqfX6n0GiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVFtSJY/x5FvxbWJEBPJ+9hZBxqsdGRbpPpu4HVdc52uGTw6aCZc1EVWfKDpMcdml3v1tPPyksLPCJpWK2JzbzEcGdclJu+S2cMBY6ulhpJ3g2+4aUu7Z+bXEgyEVKafEi/oFoLKnqdfzfObXIPcI0VsisfgJya4YC/1uoE4+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyxUv3VA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyxUv3VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232951F000E9;
	Tue,  4 Aug 2026 08:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785830699;
	bh=gargvWRhXOE9vkrlUSggMRF4hinnJjcgLMJ0pQPJxHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FyxUv3VAOzIv5YmUICswg15cxh6NtrlZosVf/VruI5qdWwi6F+WT4Hpai0XuL0rGx
	 ezfHFnCzw27f6KKjlPNzQVczosYPPzXBAzgL9JNUhsRjeYyVSyWTnfbZzfntEc5hVZ
	 RS5XVBE/xFLwML+8LJx/CHNjsUVS62UAq5swTsPwGho9stOUbn+S59beRyctkvxBic
	 s6LoDoUmK2pGxUunNk/rCn0zM+CihKYz/RXV/DWSCdqC6dNCJ3qdeBbILaxQmfl8gv
	 19+X3YlHtDUrKIwg2fq/gEGj1hQ3z6uXPjYKhflhpddI0Lk+VL4Yx5Ps7dFT1jElzX
	 3ZHArutTHecdA==
Date: Tue, 4 Aug 2026 11:04:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gal Pressman <gal@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
Message-ID: <20260804080455.GB326170@unreal>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
 <20260803182614.23f26c91@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803182614.23f26c91@kernel.org>

On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
> On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:
> > Prefix each cache name with the device name to make it unique.
> 
> Why do we need a per-device kmem_cache?
> Isn't the right fix to make this driver-level state?

This kmem_cache is required only for software managed steering mode, which is
configured per device by mlx5_fs_mode_set(). In general, resources
should be allocated only when they are actually needed.

I personally run everything in FW-managed steering mode, so this
kmem_cache is useless to me.

Thanks
