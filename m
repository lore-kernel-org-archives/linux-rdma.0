Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA9C3009E2;
	Wed, 23 Sep 2026 05:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140700; cv=none; b=JysUj0z7E++FoEZE1de+p4PrLj/eB7v2AEeO8lexzZN44t104hQXrroeh7xEd38Mt7eJ1E3g1nzddDuMiK6QQe9nKUFW1WuZ9QvQN/+RkFwvkZs6GGvaWHRtnXKSMyj0ztVWzALHvzVWBukb/Jmd1BSagoon5HPxQ4VS6SsPqDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140700; c=relaxed/simple;
	bh=lTst2yzFRnUqh3PxxziN2l1nZK8t4W5rYWqtVKN0d2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s+0rw2jPKsndtZ1pf0XHyMIbKlR4JuNsU+y+ZDYLpvkn07AzGdRp635+S2yNtRocghA+UqZl0JaehwhwnySsyqB6T1a4FWRAOp0bEZwlETfMhiF0YO90CRQqU5KBTP/3WKdR/o0ZtZ6/4TTDmXVFugjzw+5qLfd31d1rxJENNq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pejCAqck; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pejCAqck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=L2
	V/fxkj/NtCf9TX3NMx3LfEuCN5nDIGx4Z/rf/rZC8=; b=pejCAqckgrd+yk4Yur
	Oz5oUUxZHRjZtBRKMFkWTbr1zQA9dgWM8p7Uhk7R5yr/1UzbayvfTPBLq75E2di6
	yPH9HyqLP0zViW2Q0QRwWDjMAsuSPzdSyMBeUwENDCfsH7tPUKayfxSbcxh/qFMm
	SS8APklqQGsRVbw9SUeaYhjFw=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3H38KYbNqtjQeAQ--.4083S2;
	Wed, 23 Sep 2026 13:18:03 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v1] RDMA/rxe: unpublish the per-net tunnel socket before
Date: Wed, 23 Sep 2026 13:18:00 +0800
Message-ID: <20260923051800.244740-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H38KYbNqtjQeAQ--.4083S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryDAry7KryDWFW3ur17Jrb_yoW5Zw4kpF
	WrK3yYyr4rJr1jvr4ayr1jvF4Fva1rtr9xGF92ka4xZa15G3yaqFnxtryj9Fn5Cry8CFyU
	ZF1kAFyvkw4Fkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG9aPUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC3wvhxWqzYQsyfgAA3P

KASAN reports a slab-use-after-free in ip6_route_output_flags()
reached from rxe_find_route(), with the free in __sk_destruct() after
rxe_sock_put(), and a user with CAP_NET_ADMIN can remove the device with
"rdma link del rxe0" while RoCE v2 over IPv6 traffic keeps looking the
socket up.

BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 print_report+0xd0/0x630
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? ip6_route_output_flags+0x300/0x360
 kasan_report+0xce/0x100
 ? ip6_route_output_flags+0x300/0x360
 ip6_route_output_flags+0x300/0x360
 ip6_dst_lookup_tail.constprop.0+0x76c/0xcc0
 ? ct_nmi_exit+0xc3/0xf0
 ip6_dst_lookup_flow+0xf5/0x1e0
 ? __pfx_ip6_dst_lookup_flow+0x10/0x10
 rxe_find_route+0x426/0xa30
 ? __kasan_slab_alloc+0x6e/0x70
 ? __pfx_rxe_find_route+0x10/0x10
 ? kmem_cache_alloc_node_noprof+0x141/0x370
 ? kmalloc_reserve+0x103/0x2b0
 ? rxe_icrc_generate+0x229/0x330
 ? __pfx___alloc_skb+0x10/0x10
 rxe_prepare+0x9e8/0x18b0
 ? rxe_init_packet+0x3c7/0x4f0
 rxe_requester+0x1a0f/0x51f0
 ? rxe_completer+0x1de9/0x38c0
 ? __pfx_rxe_completer+0x10/0x10
 ? __queue_work+0x43e/0x11f0
 ? __pfx_rxe_requester+0x10/0x10
 ? irqentry_exit+0xd2/0x640
 ? _raw_spin_lock_irqsave+0x85/0xe0
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __pfx_rxe_sender+0x10/0x10
 rxe_sender+0xe/0x30
 do_work+0x144/0x470
 process_one_work+0x633/0x1030
 ? assign_work+0x11d/0x370
 worker_thread+0x45b/0xd10
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2c6/0x3b0
 ? recalc_sigpending+0x15c/0x1e0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x36e/0x5a0
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x572/0xdd0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 146020:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x6e/0x70
 kmem_cache_alloc_noprof+0x130/0x360
 sk_prot_alloc+0x56/0x210

Fix by clearing the per-net pointer before the last reference is dropped.

Fixes: f1327abd6abed ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..4153f03ed69a 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -638,9 +638,15 @@ static void rxe_sock_put(struct sock *sk,
 	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
 	} else {
+		/*
+		 * Clear the per-net pointer before the last reference is
+		 * dropped.  rxe_ns_pernet_sk4/6() returns the pointer to readers
+		 * that dereference it outside the RCU read-side critical section,
+		 * so it must not stay visible once the socket has entered the
+		 * teardown path.
+		 */
+		set_sk(net, NULL);
 		rxe_release_udp_tunnel(sk);
-		sk = NULL;
-		set_sk(net, sk);
 	}
 }
 
-- 
2.43.0

