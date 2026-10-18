Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124624C9001;
	Sun, 18 Oct 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792333090; cv=none; b=s7p783jlRaOgGCsUjqj9wpP4sVKLohDgf/Bs6bmmV10912RzfXiO4QwwPY5gE0rlvFY2PjI5aWdekOuz2M42+AF+dWaB8ZiNbeJU6l22qS/btBbsfkib1cPX/KGXtS6cIU4zHEL4/B3jJsNJ8+XwTkKnRuyLBwlCHwAuMIE9o4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792333090; c=relaxed/simple;
	bh=RyYPkF7JYAtIIpoRgVDc9hhRIEDqxsddqgSxy2nWM14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnePd6BDNynzn94m+fdw0A3SkFc17StKtVbrCs5qrIHZXFcZDRUwjzJxGhLeC3RqwRDFvCnazd1AGcGSNtjXAz7l7IWxUbeDsyNagori3iLcGfP/A2aEHb3+BB2leeEtbYbVGeuLceOo4OxrOSmxhSkeNqYlI97PvA1Z6M2D2D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCO7mrmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCO7mrmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295241F000C4;
	Sun, 18 Oct 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792333086;
	bh=500BieEE03ZQk7GfNGyCVLVUnF5Q67T/cTHd5SpJPhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iCO7mrmDvaa6L9zXZ3FfY66K1TcuMlK+C2v4b6AZAae3JZQxmImb586a4R/8Kr8LZ
	 xtwIHCsSMQHkA+ZkLC5VIicslPmPEbo7A7bmFvNZVBHJi1zATOMq0JoqPUMKjr75fr
	 OqUQav0cT34CaCyAlACvw3+JMnyrIVEeH13HCy4wZPzViPjj4US0i4Dtl4PbtBiya5
	 jmr7pNB6sDZ1Wxlll4QroI3gQHUZ5TK8YNujy6PHMWUN+zyX3E2O7nVTIoi6lautRv
	 JL1gRTTts7U0mZGM2OKtBH6MMEmc4Q7JhP1R3amqF8t6+LLlLUdvOI0bO1IM7EQXZe
	 z4bE8ap/MyGKQ==
Date: Sun, 18 Oct 2026 15:18:01 +0100
From: Simon Horman <horms@kernel.org>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix reformat pool creation race
Message-ID: <20261018141801.GK503057@horms.kernel.org>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <20261012100555.1317878-2-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012100555.1317878-2-acassen@corp.free.fr>

On Mon, Oct 12, 2026 at 12:05:53PM +0200, Alexandre Cassen wrote:
> mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
> Two callers allocating the first reformat of a size at once both
> create one and the second fails with -EBUSY. TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.
> 
> Sashiko AI review of an earlier series spotted this issue.
> 
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
> 
> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>

