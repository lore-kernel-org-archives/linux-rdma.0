Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6524301719;
	Fri, 12 Jun 2026 02:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781230834; cv=none; b=cpYHeq04AB8lxrx7HoCMJXSURg8k+dm2fFllsmDgHLMcW913fiHDkZjqIJkuNDR16AHhJMT2sKG0TH3G9o4Q0i6+Bcg+slrUIrqlQ8nYVfOr+DFqrBqAaeYtxbzbvNNGezCO3OTVCJvGPmL8kC+rUWDRmxQ7kS4H26000hPEaKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781230834; c=relaxed/simple;
	bh=vpmKus06yL4rbLJ5tzxv4gej6TE0AhnBAZZvBiXColg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D76gpd/zMf4tC7U2Z98Kgz4NPCZHWZwATisG+Q0v4VZEyxnMXmp1t3vATdSSiOY1JcPAnA0c2ORx2o6D2260KkXKjOhLLdRk3u0JLRluXnrrwDeAI9birJrMR08Qg71kUkgxkybWdPaolp39IK/Zr7x5u1Lg5vlOXqnDjVAi0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehDWcXW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehDWcXW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946B31F000E9;
	Fri, 12 Jun 2026 02:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781230833;
	bh=vpmKus06yL4rbLJ5tzxv4gej6TE0AhnBAZZvBiXColg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ehDWcXW9iYg3r7KdsvIHjhffXDXu9/bgjpTf3TZWSnG1iIy8dahQePenrylZHh59d
	 EW7MwCfccp6Gxoj4pL52QM+zch+ePgnJNmVY8M8oOUFpZBJUAUNd9mbryOKvh/FCbc
	 GPYCIa8hygRS6MJUtTrsH8Xqz0etj8euyZkrU+7IyLlmBhvnuM9Gb2kr07C02gjEzn
	 MCZQsdZSS2n+/KqboPrKo/Ly/dCxBHNYjpDqnvABckA2xUbUd9BFUaguM8gAk0uzCv
	 5JVHQuNFY3ExwV+uxc3zI/WgldwHfCHBK10dkb0Vo18v0hCJ4jx2MlxpSdVa0ybx94
	 2NUjGrLhpsVJQ==
Date: Thu, 11 Jun 2026 19:20:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Shay Drory
 <shayd@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Edward Srouji
 <edwards@nvidia.com>, Simon Horman <horms@kernel.org>, Maher Sanalla
 <msanalla@nvidia.com>, Parav Pandit <parav@nvidia.com>, Kees Cook
 <kees@kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Patrisious Haddad
 <phaddad@nvidia.com>, <netdev@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
 <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 00/15] net/mlx5: Add switchdev mode support
 for Socket Direct single netdev, part 2/2
Message-ID: <20260611192031.1b3f7d0c@kernel.org>
In-Reply-To: <20260608135547.482825-1-tariqt@nvidia.com>
References: <20260608135547.482825-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Jun 2026 16:55:32 +0300 Tariq Toukan wrote:
> This series enables Socket Direct single netdev to operate in switchdev
> mode with shared FDB. SD single netdev combines multiple PCI functions
> behind a single netdev interface. To support switchdev offloads, these
> functions must participate in virtual LAG (shared FDB).

Have you checked both Sashikos? I picked 3 errors at random that show
up in both instances and none of them are covered by the list in the
cover letter (netdev's complain about patch 5, complaints about
buggy unwind paths)
