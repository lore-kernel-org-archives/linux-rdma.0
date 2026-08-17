Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590A83E2740;
	Mon, 17 Aug 2026 23:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787010103; cv=none; b=RBJk580eBCgFuE9mToDmHte1qG+L8koTO9gHHgJQdZXjjFdJVxmDUGlsmwRFokZ7Vhz0yMcUGsz/21kjTjOVNmZA+0m2ro7e1VT2njvomNJ5SLbQxkA0pgAdMh9B58sXzyLE290dvndmpSze2edtJ4vt8GKhZXe/bUP2rGwuLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787010103; c=relaxed/simple;
	bh=NSWEWUUhNqA5bhUSXo1WZmqeSU/66RyMluciX+x3bic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBDB+f7v5vV8PTCSLedA2DhXFvNkZGYfgVgZrrViOBTjjgxK+un2CTCMJiXWh02jIEwTFzeA/FYsX1JPn08aLuY59+IndUvg18hEYbwDVkKUSd8t7PKlRgDOOIw4PdCz2j2F/gCyxxVVrx0sUp4rdsZloX1wWPo7X9P5U2Rsnh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFNrQ+o3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFNrQ+o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE591F000E9;
	Mon, 17 Aug 2026 23:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787010102;
	bh=lfyL9LMjoSjKUUyDjOZVHOs8RjoHWDf2seNtN+DBePM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jFNrQ+o3E6zxo/aOffkKVmCkWMD8zefJ8LKiFNc538MORH+MY6fsVQVflVUrSzyym
	 s5qnRRtHnTQWCU/pElvY9+gRS6CetzdI8nmRZKWHNjr6efS/R5mACCN+Pm0GpQfiTG
	 LUyz9/EywEijlFT+yNLSPQ3TM3sFKDuB20hc91BhvJJ6bbMLdpo3EXbgSvIhUarod/
	 eFz27zMppvcSyAI1xFqdVzZyuiFAQLnHsU3b9Y9MR+eByhnO6Ir8L0CbKTh8NZBfoo
	 ITh6dJPDbKoCmd9A/x3hd4hpfH42ucJjJFD24dhKRQcU1lovDgft35Urb3iKqYSnot
	 1BWO5r/I+HVMA==
Date: Mon, 17 Aug 2026 16:41:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 09/13] net: mana: share the EQ pool across a
 queue-set swap
Message-ID: <20260817164141.13053605@kernel.org>
In-Reply-To: <20260813050418.2906468-10-longli@microsoft.com>
References: <20260813050418.2906468-1-longli@microsoft.com>
	<20260813050418.2906468-10-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 22:04:14 -0700 Long Li wrote:
> Raising the channel count fails with -ENOSPC once the queue-set swap is
> in use:
> 
>   # ethtool -L ens1 combined 32
>   netlink error: No space left on device
>   mana 7870:00:00.0: No free MSI vectors available
> 
> Building a second set of EQs while the running set still held its own
> meant peak demand of old + new MSI-X vectors. With 32 usable vectors and
> a driver that comes up at 16 queues, 16 -> 17 already needs 33, so the
> advertised maximum is unreachable.
> 
> Make the EQ pool belong to the port rather than to a queue set, so both
> sets share it and peak usage is max(old, new) rather than the sum. The
> pool only ever grows, up to the maximum channel count ethtool reports,
> and is released on detach as before.

Warning: drivers/net/ethernet/microsoft/mana/mana_en.c:1909 No description found for return value of 'mana_grow_eqs'
