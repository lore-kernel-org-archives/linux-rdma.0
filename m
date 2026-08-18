Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E639C360ED0;
	Tue, 18 Aug 2026 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065476; cv=none; b=CgBE/FTitjkRKWwy5jwbB6BJmKyfCbCLAc5B7Z9lKIJ3Se04yo5uMAfAG/eYEWA0ezcIPfov7NRiZZhI0rg03X3OumCREkceNRKOUHV5U+CVTIwUblda/uYiEpRm4BERrWNHMdq1aCDllv6R99DblyluI/gpg9ZpjYOp/K+wzO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065476; c=relaxed/simple;
	bh=6mUfceiuC6mjKhlz/yljhGCcRO3lF7UGZBH388IERuY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Joa30083XnaGv0jvJzHHpAP6qEFFEBiL4rteWHh3nS8XqFCU0dFdHaJS2uRGNpCFW5TMHMZ57hUKT+HIv0xBgOgWtwCYJy3Osn/IFFClbMzGZpXWytV2IsR/uJdEYwD28NFd6h/Lg2nU+XVjE04iN4A6eVWZLc0XBjltZ7vFPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KucfrgeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KucfrgeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA551F000E9;
	Tue, 18 Aug 2026 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787065475;
	bh=IT3Y0rfZDg4aZ73IReS7aRJEq46bHr5HiuIQsxfsquo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KucfrgeLed2rZKxqPsHEXRmOmb5xzGtbiKl51fxBhVbDfwObEedRhIj+J5zH8jJ9D
	 uKdnk2WiE2RaZ4OtqmgRTEocMNBfuaZ5+e20hp6cDfsqZ00t+JUJPYzfhRKMaIo/vX
	 /m6HmdknxnX9YKF5ciKpNxxntq2t9SILnUdbQgd+LTg69D2D1R8QZch+okoyUnNVTz
	 0W2GPYc9kgK2DiurU7VkUAZAmXfF0xtSp/OOYcSe2xLZnZ6RQeKYR62hdnGydw/mvt
	 hD3QK1qq5/1xQBreIAKTMKZBDM+POdBBsD0X3rGZIWfuvcVTpPJMKTEn43lBGZypFx
	 lAgQm4XV+wYBQ==
Date: Tue, 18 Aug 2026 08:04:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, net-next] net/mlx5: Use kfree() to match kzalloc_obj()
 in mlx5_events_cleanup()
Message-ID: <20260818080434.0d036f8e@kernel.org>
In-Reply-To: <20260818122530.1726-1-lirongqing@baidu.com>
References: <20260818122530.1726-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Aug 2026 20:25:30 +0800 lirongqing wrote:
> dev->priv.events is allocated in mlx5_events_init() with kzalloc_obj(),
> which is a kmalloc-family allocator, so it must be released with kfree().

## Form letter - net-next-closed

The merge window for v7.3 has started, and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We will only consider applying net-next patches which were posted
before the announcement:

https://lore.kernel.org/20260816155953.072d73da@kernel.org

Fixes are obviously welcome at any time. net-next patches may be sent
for review and discussion only with an RFC tag.

Please repost when net-next reopens.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer
pv-bot: closed
