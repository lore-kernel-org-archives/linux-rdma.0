Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719867;
	b=LhBqu6NU+br2xxd7jvzW0XyDkcyJuY88xUq2Betp5dWcEEfvTrcfc2ttOp6BXiec3OUm
	 Lud1Xhl0/2mKs0k+S0BWK/rr8DGWa+EaZgk5PF5KX+lVRi7EHCU9tRsBeZ3JT6iECkXmb
	 NGNE+a/gwt5ulHFPb1sgB1YwSFUKu8g/vOg6hXeR0hRZGO7Tf2p036debniet0qeGpPoo
	 hYnoIsPzIWiG1Yt1veFikJSdz862FxduN3uGe6ksUwlqEZVeVxK1HN4OF7xdVH6A7abPH
	 YK4vhTfTxfgkFhjjI05l65eZdOnSuG+VuA51qP7HrGGt/4yZVaHJjmTP7setudPdHhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719867;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Y3kUf34boZHw1a7xo3DJMv9OLUvYTHwcOWlcJGn6b/Q=;
	b=2brRd7jwRkpW8GJVPOmqgAfPPWH1K4oSvx/iOETaFMcGK8qoc9FB5/wlizKFgKaxI6jg
	 WybyGbZmtNXaAnQqdRNQPQ/rqhFfst2vffuRcjQId23fWSf2pVlPR8ISh0HOSoBqaD7lf
	 D9aej/EqnGmaCqmZQdZVFKd4qlxFEyoqj3iZT8Y/Ch5O1sKcrSR6pzD6jkRyylLhDLzSN
	 r3aOniav5dpJcv3e0Uycb7C0qV8oRw8r/5ER25hOu+sEusjhlDIxkR3Ye/is8dZYQ35pU
	 RnTuKgE2P7iG7ZrOQPymJvZ+zQvzV38nsEdnNOl20Uh32OYFCj9nGxLV/30W/8cZmBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lkXSLK3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E07606A324;
	Tue,  3 Nov 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lkXSLK3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7951F000C1;
	Tue,  3 Nov 2026 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719866;
	bh=Y3kUf34boZHw1a7xo3DJMv9OLUvYTHwcOWlcJGn6b/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lkXSLK3v6YB9cC7ClPbpU/KgJ6Qp+vhZQeb22shfjV0lvNUaR9MwlsugOWDb/9Urh
	 AaKpO17PurFu7sBMc85q8/LgYd8CdQFxfFhCeZUztXwuOCJ7Eo7zVSr/F/86uKZ6eE
	 No6duRU0QsDwMzJInx04eM2U2vVzt75jpptVYYGsrceBBf42ERtw9comqH/ONrGxDR
	 cA7hJ5WJIh+YT030+gFvpfK6GUQsNc3KYDwb6EPpMACIBN7jHc5NeaJoDdMlTN+vcL
	 vVNaReidnote0rC7HV9QmANuO3pvfrMFZuPLZqw82RgDUr6fyljZd0zIb0ykYTxxrh
	 T4p173XtDHY8A==
Date: Tue, 3 Nov 2026 17:31:02 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Binbin Deng <18983559317@163.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] RDMA/iwpm: Fix use-after-free in mapping info dump
Message-ID: <20261103153102.GK264423@unreal>
References: <20261102081813.37754-1-18983559317@163.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102081813.37754-1-18983559317@163.com>

On Mon, Nov 02, 2026 at 04:18:13PM +0800, Binbin Deng wrote:
> iwpm_send_mapinfo() walks the mapinfo hash table while holding
> iwpm_mapinfo_lock, but when the current skb is full it temporarily drops
> that lock to send the skb and allocate another one.  The hlist iterator is
> not protected across that window:
> 
> CPU0                                                CPU1
> iwpm_send_mapinfo()
> spin_lock_irqsave(&iwpm_mapinfo_lock, flags)
> hlist_for_each_entry(..., map_info, ...)
>   map_info points at map_info A
>   fill the current skb
>   spin_unlock_irqrestore(&iwpm_mapinfo_lock,flags)
>   send the skb / allocate the next skb
>                                                     iwpm_remove_mapinfo()
>                                                     spin_lock_irqsave(&iwpm_mapinfo_lock,flags)
>                                                     find map_info A
>                                                     hlist_del_init(&A->hlist_node)
>                                                     kfree(A)
>                                                     spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags)
> spin_lock_irqsave(&iwpm_mapinfo_lock, flags)
> hlist_for_each_entry() reads A->hlist_node.next
> 
> CPU0 then resumes an iterator whose object has been freed, producing a
> use-after-free.  The race is reachable with many mapped iWARP CM IDs when
> the port mapper hello path dumps the mapinfo table concurrently with
> teardown of the ID at the iterator position.  It can be reported by KASAN
> or lead to memory corruption and a panic.
> 
> The spinlock still protects the hash table itself, but it cannot protect
> an iterator that is retained across an unlock.  Add a mutex which covers
> the complete dump and also serializes individual removal and full-table
> cleanup.  The netlink dump and CM ID teardown paths can sleep, so this
> outer lock is appropriate.
> 
> Found during a static-analysis-assisted audit: candidate sites were
> surfaced by a Coccinelle rule, and the reader/writer paths were
> confirmed by deep code inspection. Due to a lack of hardware
> infrastructure, the issue was not observed at runtime.

Sorry, but we should not add locks to legacy code without thorough testing.

Thanks
