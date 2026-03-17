Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830A393DD4;
	Tue, 17 Mar 2026 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773783414; cv=none; b=rAyBeFv/AKPQWJ5xq/58XDz5fh7aSqdnXNXedg2NdwqZ72ZgmuiybZaD+9eNWX9yKwHFrOC1rkjnBOBADHrGpJ9BUvvzNQP4qaEJVDy0pSnNSlE+4CsY5NltfYnNuC6EaGC99+3NmLWxkvznCkE/esJThRPRtNKUw6gOtHbK268=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773783414; c=relaxed/simple;
	bh=WWos0CIJdDKbbk4GU32hFCM0ziRNiQmdwxc+vHTJM48=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERl7WYgZ32PzUEIA2NVOysWhaEr3INzmoyzAaa2NlDCiKH1ihF/FGb4zs4DXRgh4Is6NO+SapoPcByXPB8qLMDEvQbshkEevW6/Uwoc9YasYFy5nlcJROgfddl32Y1UeoKfxejIw2ocHF+yTOVgouWnANIRmHYB6HV6ewQ2vu5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhOXq+zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhOXq+zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C85C4CEF7;
	Tue, 17 Mar 2026 21:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773783414;
	bh=WWos0CIJdDKbbk4GU32hFCM0ziRNiQmdwxc+vHTJM48=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XhOXq+zRzLkQDMDeTIGxFU2n9U+H1LFFMhyMYBk1iwqUNPzntzpvsJD++7/v4rY80
	 PdAOT0CHGSbgwgycAwce9lvNSYx+ULwzzR/mBfgH2G0JAVUAFGADBomK+1MlRkEXUV
	 +iKgEmhdCx3JPMME0hdeq2ol1VYlnefx8Tumm581NH4zGnEV8cfw5h1EVpZgsLvHUv
	 0ChoeAbLyy8u6yZeaFXaOZZi6gXPpdhpi+g19yiPsab5hbQvZkVnWT+7xFhkA2MvRE
	 yjw36dYBsnnAiognwzIcDm5D0IJF9w8JqD5RLEbcKX/YwM/FvoSh6Fu5WJlNmaoEoq
	 oDSlzhfjNlFtQ==
Date: Tue, 17 Mar 2026 14:36:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5e: Enable mac forwarding on uplink
 representor
Message-ID: <20260317143653.0eaa50a1@kernel.org>
In-Reply-To: <abmZf3bRl2uQ69EA@sx113>
References: <20260310104841.1862380-1-tariqt@nvidia.com>
	<20260311203319.76d35ce0@kernel.org>
	<abmZf3bRl2uQ69EA@sx113>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 11:12:15 -0700 Saeed Mahameed wrote:
> On 11 Mar 20:33, Jakub Kicinski wrote:
> >On Tue, 10 Mar 2026 12:48:41 +0200 Tariq Toukan wrote:  
> >> This small patch enables mac forwarding to MPFs via uplink representor,  
> >
> >"mac forwarding to MPF via uplink representor"
> >Can't wrap my head around this "via". Could you explain this better?
> >Perhaps some tool can spit out a little diagram to make the flow clear?
> >  
> 
> Mac forwarding in the sense of linux bridge mac forwarding mechanism which
> requires set_rx_mode ndo to be implemented. 
> 
> Linux-bridge --> mlx5-uplink-rep --> set_rx_mode --> set up mac in HW.

And the actual forwarding happens in SW bridge? This is just to
configure the Rx filter not to discard on Rx?
