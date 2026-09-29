Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C43D1A81;
	Tue, 29 Sep 2026 18:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706396; cv=none; b=C5aGMPk5ewkM3yZEe0j9kztrAFwg64GzzcG0qYMZUcyh7VbarDARNTugYOTaDu6ucDEpy46o1gb+Oj0BvgXIH3hIrWseWVY3fJTn+0XfBdzO8xDF/9vACg4q7w/j2dKlDmV5J02639BNZGqr7YxbQHZ06RuwY5Z0OoXZSO9JSlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706396; c=relaxed/simple;
	bh=orOYJTkAHSxJMWaavQy6P97bAtAsCAmBEP0Bh3+7kq0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mDlAg/vHxdZknPwD9eUNCbq7Sb6EfA5yiJO6MJF8wOjpQeGvcHBxNxMg46eD5UfBP61cZxHEqsEKUvZzEE58pfUm9Msz1R3ZQ2TENPZ0V6ZlbV6grQe+DZ58qgqa+tkEJ+WuA5EgRRz5Jl2nHmT3l3TDvL8jKXLWhpmscTzTma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFl8JZxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFl8JZxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713B51F000FF;
	Tue, 29 Sep 2026 18:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790706395;
	bh=bQSRWiPFCp0WuPOdLwqND2Vj0WYgcd51Ue3OqBmjjrA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mFl8JZxOiJz0oRFn0f+aOUev5ID0FO3xBlGUQjncaZ50G3e21Phf65prsyGbCBUyU
	 DHjEJQqGFbxRMX73UCUVJnxmDSSask6EwMrbzPB1N082VwZf3fH2naWqJVof/CQXuK
	 tXjG6XuRpXqcPnw0QNySIRIE1BWK25vXoSN3z2eQ3ws8oswuy5aRg8HTWUgHOhbQ9A
	 BMvZeev3IwS57EMgY1seVUVgB6tzDTZ3giWridBvATILj8XgaGqUUBGWVaFLxLBX0I
	 AfSBlzm1gFxf20+sBzy2PpzkEilo0m7KdsX/XR8JmsY9dY07re4fY7dP4+cbtK5WNv
	 DaDT4GMAQOCPQ==
From: Leon Romanovsky <leon@kernel.org>
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, dsahern@kernel.org, 
 Binbin Deng <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923051800.244740-1-18983559317@163.com>
References: <20260923051800.244740-1-18983559317@163.com>
Subject: Re: [PATCH v1] RDMA/rxe: unpublish the per-net tunnel socket
 before
Message-Id: <179070639231.3971791.8235917019478270539.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:26:32 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 23 Sep 2026 13:18:00 +0800, Binbin Deng wrote:
> KASAN reports a slab-use-after-free in ip6_route_output_flags()
> reached from rxe_find_route(), with the free in __sk_destruct() after
> rxe_sock_put(), and a user with CAP_NET_ADMIN can remove the device with
> "rdma link del rxe0" while RoCE v2 over IPv6 traffic keeps looking the
> socket up.
> 
> BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
> Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x53/0x70
>  print_report+0xd0/0x630
>  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>  ? ip6_route_output_flags+0x300/0x360
>  kasan_report+0xce/0x100
>  ? ip6_route_output_flags+0x300/0x360
>  ip6_route_output_flags+0x300/0x360
>  ip6_dst_lookup_tail.constprop.0+0x76c/0xcc0
>  ? ct_nmi_exit+0xc3/0xf0
>  ip6_dst_lookup_flow+0xf5/0x1e0
>  ? __pfx_ip6_dst_lookup_flow+0x10/0x10
>  rxe_find_route+0x426/0xa30
>  ? __kasan_slab_alloc+0x6e/0x70
>  ? __pfx_rxe_find_route+0x10/0x10
>  ? kmem_cache_alloc_node_noprof+0x141/0x370
>  ? kmalloc_reserve+0x103/0x2b0
>  ? rxe_icrc_generate+0x229/0x330
>  ? __pfx___alloc_skb+0x10/0x10
>  rxe_prepare+0x9e8/0x18b0
>  ? rxe_init_packet+0x3c7/0x4f0
>  rxe_requester+0x1a0f/0x51f0
>  ? rxe_completer+0x1de9/0x38c0
>  ? __pfx_rxe_completer+0x10/0x10
>  ? __queue_work+0x43e/0x11f0
>  ? __pfx_rxe_requester+0x10/0x10
>  ? irqentry_exit+0xd2/0x640
>  ? _raw_spin_lock_irqsave+0x85/0xe0
>  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>  ? __pfx_rxe_sender+0x10/0x10
>  rxe_sender+0xe/0x30
>  do_work+0x144/0x470
>  process_one_work+0x633/0x1030
>  ? assign_work+0x11d/0x370
>  worker_thread+0x45b/0xd10
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x2c6/0x3b0
>  ? recalc_sigpending+0x15c/0x1e0
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x36e/0x5a0
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0x572/0xdd0
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: unpublish the per-net tunnel socket before
      https://git.kernel.org/rdma/rdma/c/4af07308d8227a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

