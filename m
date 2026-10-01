Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8A5187EB;
	Thu,  1 Oct 2026 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862752; cv=none; b=jsJgRgL8EVHHdYYOBOiYBwHVtL9ryS1LxnhmVOPZjHc10G0eA52mDMVutnvwP3fai+I17b65+HWoj6remBTrBB4PZTs7XQSz65b6gRJ7oa7XsTc8YHPGGYOfLWdAL1RIbFcNV8jJzKqu/kALi4Ly08FvqVrqZvhcz8O75xAEReI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862752; c=relaxed/simple;
	bh=zUI9PjYrTfA2p3oupWrd3uSQCA5m9jjn5HdFZr2oEeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6Qk94AQZ5aImBqFB8bxJa+u0iG4b2qU716qWOjjADjUTqnfZk5gCBvg38sYGPSV46mMmKfjbNt3Q+TGs7knwvADxkgAkzLsOFX4ip4lRF2bxs4ogY7xT66yLrNI230Sue/GyUp8JOH4p76935SHeToRGKsxbNC2vJKhpfmNhN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYucQkNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYucQkNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D2D1F000FF;
	Thu,  1 Oct 2026 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790862748;
	bh=+EvW8cyzr2ZnHOw0fz/R9/i+oev1lc++H4MGIiM7I7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYucQkNFHheKiAUvTqdBJCmQLn+zT4E1utkUOcKwTorES8XfkyDWft+LxqQDjgXqb
	 vlqDRrIgfQWA3GyzX3lGGgLOn5KRGxEz+PukoR2G6fFQm+RcGJnZO97Mr7IEku/HUZ
	 s/IsNWkxPYVmzK2qhRNNgZTwY6H9VbUJ9p9g48YKjeCOQgbZoaS2TdDhq+gSSgSXzB
	 xNw9fWWln7+h1s+hnfaEYAHz68QSsQaRT8s/NcLhwKU+rYi6qp9fD8TyOb1vAgaMDP
	 r+D79zSquDZsgvOm5tbajDDCRd6eCZcVaHZ+4TIn4iflmQ1zWMo2lDXVtLKQpfyTrF
	 BuOk80FcdSL4A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shay Drory <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	erezsh@mellanox.com
Subject: Re: [PATCH 6.6.y] net/mlx5e: Fix netif state handling
Date: Thu,  1 Oct 2026 09:52:07 -0400
Message-ID: <2026-09-30-1-daily-reply-0003-mlx5e-netif-state-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930012143.95721-1-artem@trailofbits.com>
References: <20260930012143.95721-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This one addresses CVE-2024-38608. It releases probe resources even when
> register_netdev() failed before device-present state.

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
