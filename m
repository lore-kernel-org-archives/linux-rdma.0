Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795288276;
	b=y+SzC3kN/LSQXcmbsfW/cRSz/hIEdpVWknxbxHXU50g8EkYggUe5RmtTrmsq3vkirKwA
	 K6MTyD7aWyhZ5c7QdZgBbWxqIhkQaCTgAT/NBK9cW9KH/L6afUVMceYAt3bc4pOSL6cPS
	 kh7xL0VkvLsJkFXJoJQwNVWuc81gbTj3Bs6qAsuoh2hGmzmjNN9IZkkQsMN9fV2TNUP6c
	 JOU7IpvpQzvJ6i+IlDCIDe2TrpOM4eP+IMTOOozNknnfnVlwx8zg+iYNkzy5uh9Mdozio
	 LYg5HIHzCsgoCfthG1h3yPQJ9H9M9DS13u7o7xHOaxwU/kgKDjczZMe0QKT1tUU+wUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795288276;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=L4eNTZonp+k+fZ1GyudD41c0bwWGbcvGd3rWqouDY4Y=;
	b=Iq13Aejwm3I4gc3TErcAXVm/zFZkfOfaJF+Dm49vlenPAtiHJ3Tnzl0A8hdM+osP9NBr
	 90fzAaW2k++8eZLcFimDOtSF4/ZkczXxEfoHjwAVUOpaIq0I8u4NJy++LuucFVG1O93l+
	 aDeKY2dhhC1qMs4/4LSIpygeijsVXnQF3b+wTJCv5HWVBfUznRnJA1bX0XvTo2An6JnY+
	 195saKR4/rtfERK3Ft+5dTZ3jXgviibAOy4odZZ7zBAL2de2VsH+rs/5zd/eAM7B2l3iG
	 0ITv7RIfZDtQcJlCH22KJFUGqGAI1nuqHfOtJoUJcSw2NpuGSEUdUgiSg8bWVSXuQ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbzPbNpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE29606A320;
	Sat, 21 Nov 2026 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbzPbNpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AD61F000C0;
	Sat, 21 Nov 2026 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795288276;
	bh=L4eNTZonp+k+fZ1GyudD41c0bwWGbcvGd3rWqouDY4Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bbzPbNpeZO0b/DMfj67XtGFQVBAX+rWG1AaXU0PgcDUvRBNLcin4paZH0yGnJZJR/
	 zjRAhrAzrfzHpB3xPGJ4lxjMByN3nLK7zbN+ot9UnJ7N/Kn2ZVeEe+BkKAFjGyI+ut
	 fxPDbQgKA1PamvZIqqfqwrBTj6JC4zaADNCXu6Nj1+CAxiFJlqV3p1jb3Um1JcLtar
	 +lNBGD3NAYDHIuxtfw6T7OTAnzJsd0RVx0hxluhpEyqcfS1Ta/KZIbA2UV2Aw7H1UP
	 RUpF7TpHUIKBMENCq6iu4XHTq2rtfAuMTB9anyXSJfgk4QTlAw2JWQFAh8Bw014BS0
	 T26PoilvJHeYw==
Date: Sat, 21 Nov 2026 11:11:14 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jinvas <jinvas@126.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 leonro@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, horms@kernel.org,
 alexious@zju.edu.cn
Subject: Re: [PATCH net v3 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Message-ID: <20261121111114.0ce8c76e@kernel.org>
In-Reply-To: <20261118134514.1765-2-jinvas@126.com>
References: <20261118134514.1765-1-jinvas@126.com>
	<20261118134514.1765-2-jinvas@126.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Nov 2026 21:45:14 +0800 Jinvas wrote:
> Signed-off-by: Jinvas <jinvas@126.com>

We need a real / legal name as author and sign off.
Correct me if I'm wrong but Jinvas does not look like one.
Please repost with your real name.
-- 
pw-bot: cr
