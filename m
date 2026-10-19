Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C8029B799;
	Mon, 19 Oct 2026 02:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792377463; cv=none; b=HoS3yw+NyabiAeP84RWZ7han10n9BVRbYIninlEEdZYNJ5AUQs1H5g2GEJMoYR4PStRm0x86UH2PmzTgRCHvE7mkCp6Y3mDfbXqeAEWwk9IRuIM67Dvmvvdj7khwjVxr57F6a1NRDgjpSDdKkubbnYTh/cTmtWzrH+qmk1yMFpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792377463; c=relaxed/simple;
	bh=Ne22HZHF3ftP1jJ2EjXkQ08ZhZkXyg6EsfRRb1elP/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iJZNligfFs4h7rdb4bIpHqhrSiblcmKxqv3E2+Cohq40OvAhj70noOw5irJMl+W9nFUDQYRd9yTA9nHaOgJ7/VVAQxjmZFJWQpKnaFpD4ItqREvi2sIUfm4I1kEHjuVXHo4jJvrpmLGAxeuQxZAW7qRmF2uL2CUrrKIbVj7/T8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=V65nQY58; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V65nQY58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ur
	osF5d5jH3k+RjYUb3z7Oe+ERQDd0Ayei3t9d+QsJI=; b=V65nQY58Oh7BHNSAuT
	jGQ/zZii+c4hZPBB0hyBQhd6YZYSSLr7b+IlVIoxtARqN0Gahb7L9vgaKq68DED+
	1KwiKPXYAVlOEUuCoPKkkhQ/oDHe1sO6VFir/85AfjICGJTKbXKBNN4KxVY7WUvs
	eZicWRjs1cCR5DgRVc5ROKgEs=
Received: from colol4bi5.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgBHJ3BfgtVqiyl7Ag--.51517S2;
	Mon, 19 Oct 2026 10:37:20 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v2] RDMA/rxe: unpublish the per-net tunnel socket before
Date: Mon, 19 Oct 2026 10:37:17 +0800
Message-ID: <20261019023717.455067-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgBHJ3BfgtVqiyl7Ag--.51517S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryDAry7KryDWFW3ur17Jrb_yoW5Zr13pF
	WrK3yYyr4fJw1jvr43Ar10vF4Fva1rKr9rGF929a4Iva13G3yqqFnIq34j9FnxCry8CF1U
	ZF1DAFyvka1F9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U2sjnUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC-AHIrGrVgmH2vgAA3N

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
It has been confirmed that this fix has been validated in the test environment.

Fixes: f1327abd6abed ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Tested-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..fc597e02c85c 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -638,9 +638,8 @@ static void rxe_sock_put(struct sock *sk,
 	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
 	} else {
+		set_sk(net, NULL);
 		rxe_release_udp_tunnel(sk);
-		sk = NULL;
-		set_sk(net, sk);
 	}
 }
 
-- 
2.43.0

