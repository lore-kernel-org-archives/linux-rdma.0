Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F7D381EA8;
	Wed,  5 Aug 2026 10:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785925290; cv=none; b=lXMx4Q3yoWY0ji0DHmZ9QqZZr15qb0qdFw+MKIFzEO1bKie5jTnXqvHBKsXcmruWVUXfQI2EdBI9oxqX1qQpvRe2elNOhsc9pAzAzHfND+NHsdru0r+2oJRkmo9yq3ovG/UMX1UBs21NwgMsUGvQxVV9iBM1bqN7HZtdr3a0yeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785925290; c=relaxed/simple;
	bh=jFcJk6iBFQOwQedR2Pf2NTocslgF6McpwPTGXC2OmbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDCMv9bV1GEusS0fEjFtg3+DZM24AdXujT5L8hsJykdfKF0geIg4sHanhtZj+rSsBuS2agJSRQjbV34BdAUAzxHgdVsg49WwcPfuoxaRgh6QtCH8dqZ5h39WRG1blV3ooHbb93XPzXVufWnIxSKWQDe6//oTVSCz+DX31i+tu7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GngL/tec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GngL/tec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE9A1F00A3A;
	Wed,  5 Aug 2026 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785925289;
	bh=c0FOiFH+JxLfeNTDXOvG818sv5+LuE1N+I4iZ85EToA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GngL/teclGLxJZDCqVqG7DjNeF3A3ohWdCh9Upt2IBGOuCesoBIc0YYtUt+Uh6bKV
	 Zn5FN0xk3fUoDq6Tfugbarvva/JPiHKohXYGhK3kc17k0YF9e6YhjfJrTa2vMYqowl
	 DtWXOHUsUXOJZo90wEUW2E1mB2NNn9hCX5i+lJBvicvPb6rxf++XtAQGamqVFeHeEQ
	 SQ4CZc5L5s8SU/atGeijyQxdvYW4e0vFk96PShfPe/yZY9ovVFdB7uJOJip2SUmkrv
	 67D7LRBmxMh8Ia4YJqC5sDqrtpwceUpG5UiPC3UEEogvRmC+k07DFjTbNgs/MmzpOI
	 J6SbxOP3qEOFQ==
Date: Wed, 5 Aug 2026 11:21:23 +0100
From: Simon Horman <horms@kernel.org>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Breno Leitao <leitao@debian.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, paulros@microsoft.com
Subject: Re: [PATCH net-next v2] net: mana: Extend RX CQE coalescing up to 8
 packets
Message-ID: <20260805102123.GP51943@horms.kernel.org>
References: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>

On Fri, Jul 31, 2026 at 02:22:53PM -0700, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> To support up to 8 packets per CQE, update related CQE processing
> code and structures.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> v2:
>   Updated PF flag hanlding, and comments based on AI review.

Reviewed-by: Simon Horman <horms@kernel.org>

