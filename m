Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3215383F2
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188776; cv=none; b=ukFv8dDfyWV0D9yrFEZlaKg/pavjC8+4b1fLnpODEbD5PN621WRxzUth06oaijT4dxxut2AyPJmjaCptzlVZfpe3lTgRkAVhCUpbfSx3e+ElYiQmFbQDBNKEVt/M4Q072RG7YuydSaed70Mj4MwZCnh8Coc43tDxrVSOIHR5d50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188776; c=relaxed/simple;
	bh=xvVfhU/rhBzON30v3lLER/H5XSDtA/5WCZuabwZWrT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bkzj5MAT909hJLKZNjcvXlkWnJ1bprfhjbIov6Wo/C3hFtNFS8i8KbgRla5g6K0WLFN6WSn53/iS+4wY49SaU47+2CvVewQEcEs30fsOh8XCe+P507SBEUD8ou8YSurSq8SJ/bS5ErjqPzTXg7FAg/q8fvtxMnxI7V7CW3YN85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NbHNLt2w; arc=none smtp.client-ip=95.215.58.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NbHNLt2w"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xvVfhU/rhBzON30v3lLER/H5XSDtA/5WCZuabwZWrT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790188768; v=1; x=1790793568;
 b=NbHNLt2w4rgF1oxC1LE0aT0NmaOaal6Q9Lfgw0h733K3uN4loKdnqHJIZL74lHUfSwVZgrrl
 noYk4XP5VONvDU0KsXPR6HgAsBFSAz5x1DFb3vcWIsODiD+/Z3DRG65xvqo72HBbfmlQnqv5ZJe
 WSXupxsOJTlemb6sncmlw0Xs=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3ea29e3c32de8e0c;
	Wed, 23 Sep 2026 18:39:28 +0000
X-Mizu-Trace-ID: 3ea29e3c32de8e0c
X-Migadu-Flow: FLOW_OUT
Message-ID: <6c0a220c-7d9f-4b31-88b9-6882b1b09231@linux.dev>
Date: Wed, 23 Sep 2026 11:39:26 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] RDMA/rxe: unpublish the per-net tunnel socket before
To: Binbin Deng <18983559317@163.com>, zyjzyj2000@gmail.com, jgg@ziepe.ca,
 leon@kernel.org, dsahern@kernel.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260923051800.244740-1-18983559317@163.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260923051800.244740-1-18983559317@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/22 22:18, Binbin Deng 写道:
> KASAN reports a slab-use-after-free in ip6_route_output_flags()
> reached from rxe_find_route(), with the free in __sk_destruct() after
> rxe_sock_put(), and a user with CAP_NET_ADMIN can remove the device with
> "rdma link del rxe0" while RoCE v2 over IPv6 traffic keeps looking the
> socket up.
>
> BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
> Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x53/0x70
>   print_report+0xd0/0x630
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? ip6_route_output_flags+0x300/0x360
>   kasan_report+0xce/0x100
>   ? ip6_route_output_flags+0x300/0x360
>   ip6_route_output_flags+0x300/0x360
>   ip6_dst_lookup_tail.constprop.0+0x76c/0xcc0
>   ? ct_nmi_exit+0xc3/0xf0
>   ip6_dst_lookup_flow+0xf5/0x1e0
>   ? __pfx_ip6_dst_lookup_flow+0x10/0x10
>   rxe_find_route+0x426/0xa30
>   ? __kasan_slab_alloc+0x6e/0x70
>   ? __pfx_rxe_find_route+0x10/0x10
>   ? kmem_cache_alloc_node_noprof+0x141/0x370
>   ? kmalloc_reserve+0x103/0x2b0
>   ? rxe_icrc_generate+0x229/0x330
>   ? __pfx___alloc_skb+0x10/0x10
>   rxe_prepare+0x9e8/0x18b0
>   ? rxe_init_packet+0x3c7/0x4f0
>   rxe_requester+0x1a0f/0x51f0
>   ? rxe_completer+0x1de9/0x38c0
>   ? __pfx_rxe_completer+0x10/0x10
>   ? __queue_work+0x43e/0x11f0
>   ? __pfx_rxe_requester+0x10/0x10
>   ? irqentry_exit+0xd2/0x640
>   ? _raw_spin_lock_irqsave+0x85/0xe0
>   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   ? __pfx_rxe_sender+0x10/0x10
>   rxe_sender+0xe/0x30
>   do_work+0x144/0x470
>   process_one_work+0x633/0x1030
>   ? assign_work+0x11d/0x370
>   worker_thread+0x45b/0xd10
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0x2c6/0x3b0
>   ? recalc_sigpending+0x15c/0x1e0
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x36e/0x5a0
>   ? __pfx_ret_from_fork+0x10/0x10
>   ? __switch_to+0x572/0xdd0
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>
> Allocated by task 146020:
>   kasan_save_stack+0x33/0x60
>   kasan_save_track+0x14/0x30
>   __kasan_slab_alloc+0x6e/0x70
>   kmem_cache_alloc_noprof+0x130/0x360
>   sk_prot_alloc+0x56/0x210
>
> Fix by clearing the per-net pointer before the last reference is dropped.

Thanks a lot. I also confronted this problem. I fixed this problem with 
a lock.

It seems that this fix is better. If this fix is verified in your test 
environment,

I am ok with this fix.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Thanks a lot.

Zhu Yanjun

>
> Fixes: f1327abd6abed ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
> Signed-off-by: Binbin Deng <18983559317@163.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_net.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 53daaf4c1eb2..4153f03ed69a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -638,9 +638,15 @@ static void rxe_sock_put(struct sock *sk,
>   	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
>   		__sock_put(sk);
>   	} else {
> +		/*
> +		 * Clear the per-net pointer before the last reference is
> +		 * dropped.  rxe_ns_pernet_sk4/6() returns the pointer to readers
> +		 * that dereference it outside the RCU read-side critical section,
> +		 * so it must not stay visible once the socket has entered the
> +		 * teardown path.
> +		 */
> +		set_sk(net, NULL);
>   		rxe_release_udp_tunnel(sk);
> -		sk = NULL;
> -		set_sk(net, sk);
>   	}
>   }
>   

-- 
Best Regards,
Yanjun.Zhu

