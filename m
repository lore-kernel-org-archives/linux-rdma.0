Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4943921D6;
	Tue,  1 Sep 2026 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270223; cv=none; b=t/1dpmo5qW3gHh1iJfueAivGASaqt8woqLa0Dbmc/+Bx3qVMgSyUjHwIOw6Io/NbVa02qiHz1N4qZz3pIuZUIRqstqPE1WkW75khNK1xjx+WOCaedo6hUa9kq/Z+SHkPocO9ajoN7TmN6/QZYbDaD1cbA6MddXUxDIwjZk2NRHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270223; c=relaxed/simple;
	bh=jDeqnTYR04htlYAGgIXCpZ0gn/nhNRbNZJ5U3qkqgkU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LSCCutDDXDqgpal9GtM3Q/rFGb009cHUgcKlYeHbH6rTyDxlXW29mbpP2YSe4S3Y+IpDmVShkTAx/nupPX9KQDn00UqRVnQSWWmIbQFk7gizlt4Kgr+wB0MVEHr1U5gJzPEQNC+5iDXTIFQ/3P/x4BxHr6vnOAGLkh6UNJcbnsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrDmJXJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrDmJXJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7481F000E9;
	Tue,  1 Sep 2026 13:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788270222;
	bh=TzKHzSaL5/LY7jl8L9Bf3mvdXlvXyFQOSUUBcbQVW7k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GrDmJXJJSw1+OdF+7dNzWnU04ijISueO+SbZKdhKxsURCw/Ey1mEZIwkPpltWdZAb
	 +sE0vZMgKZ4XEQVdmd5ftcPRky0PSKvWCCi4qXSgXuHeCYzAyfV5n4jjJKNz2Viapn
	 RgZxVAE0zBqATF6pYOUHYkVtTVBE1YNK+sZv+RdpvDHmRIFL1oZn8TvUVGa82SiD8w
	 ExJr8bi3TJz+X4FZFM9yU61Qp4M0ggUlsUMWAp1agIJcMwl9ElQsPS2BRAcYgZDpsO
	 L1xrsOlxZdmOfpXJnU6biYDZsF3FgPct38amqttEra9a0a0BVH3A/HuHGq9psZwSXx
	 X+CZud1u+ZzZA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Or Har-Toov <ohartoov@nvidia.com>, 
 Paolo Abeni <pabeni@redhat.com>, Selvin Xavier <selvin.xavier@broadcom.com>, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzkaller-bugs@googlegroups.com, 
 syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
In-Reply-To: <20260812081708.32468-1-krystianmkaniewski@gmail.com>
References: <20260812081708.32468-1-krystianmkaniewski@gmail.com>
Subject: Re: [PATCH v4] RDMA/core: Reject unregistering netdevs in
 ib_get_eth_speed
Message-Id: <178827021956.1355060.13131752972355103530.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:43:39 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 12 Aug 2026 10:16:41 +0200, Krystian Kaniewski wrote:
> ib_device_get_netdev() intentionally returns a referenced net_device even
> when it is unregistering, so matching and cleanup callers can still find
> the association. The reference keeps struct net_device allocated, but does
> not guarantee that the device remains operational.
> 
> ib_get_eth_speed() uses the returned device operationally by invoking its
> ethtool callback. Although that call is made under RTNL, the function does
> not verify the registration state first. An asynchronous RDMA port query
> can therefore call into a netdev after NETDEV_UNREGISTER and ndo_uninit
> have completed.
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
      https://git.kernel.org/rdma/rdma/c/ef9fbe1b93f3b6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

