Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795834835;
	b=zR3cucXtacQY3v00UQd+VCfAxmDfxK6jHrfnyKHAVmyKNxQQupmabeOnI24cNKveGe7z
	 yn+wX5+fGBkeWLjt+EPSLX3gCbIR57tENRuRNPFTK9al+PBsC+r2+OTmAnTMXChn8IXGJ
	 Q1w3Guuj/gGgBKy9vQ4l6j5U73NA13dBMkSzCSPo3ILg4RqIIKv/Q3tc2gO/VjpaiwjMX
	 IEEXFdSXmS90tNptkbg55HHF7i/O3qurS6eUIqPGrWk9DRohBAx6z4wr0cBUYifZiUaVv
	 aCLjEkavzc6rsK66s9ivzbPvI4PdThOAuLjT/fU5jsKZIwoxTYkXBLd+PvHQ/edd5jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795834835;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RoAsLFeKI8HGAk3UGUHCl8nwvjqb9os0X4ZhNCLlAxY=;
	b=jIavE7oC/UQCo1g1SSdOcDSMkFeLCKxObXGeejBn/DSq7hlHtKgs6dVrws4wMrqhqIre
	 s6NJ0n9PjLiu22dQ5S4T7Edv8SSSQp6GUsbcDmIzFziTBay3GNFEnWaxSdOctkZj8QYh+
	 UIgbytBNOiNcOmO7lze+Dp/4Fhnn4HmIXVKTggO9xm5WWGU0pRGpsE/Y8D4pUwv9hZW4S
	 1Vta+U+fW3adLX/1GoXuxzewxGr4DDojBxPl6tIOd3gN8GzD0tzGld8obDIX4njD6ENOg
	 pHVhMC/LTS457i42jVqDD883JYs4jl0fIkDCIJpCKJdJALcGDqzKidR6iBpCawOy8yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=VXyZr5GV;
	arc=none smtp.remote-ip=185.70.43.18
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95344606A31E
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 03:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95344606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=VXyZr5GV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1795834831; x=1796094031;
	bh=RoAsLFeKI8HGAk3UGUHCl8nwvjqb9os0X4ZhNCLlAxY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=VXyZr5GViGDp/VFehFSGwU0wDclHkEc9o56LXPDwJ1PoJJf90lk5w5r5z8fzl4K+6
	 nXKLhpaqdB3nsit98a7ZEmpdx1jFcffmDVcvAtd8n5aN+hkRZulrj7zjY00S1hhYtz
	 fvS83GjbRG0JSa222BIrShRAeM+5qzU4sJPx6qyaaWVfHXc6xIseLMZKgYsNDu3BSg
	 Jmg0jF4pJPsQaUCzOBbfCDAgzRJ7nP4Ixdio+Pb1ENT2IITy4AZGVc959lqEQn9dm2
	 4nRMZETxGMaQQ7jlt7if5/owAUwq+fEqHlZVc//uULI/cygq/l6ttJxodkZ/Kd0O3o
	 c9HMV7J+vKkbg==
Date: Sat, 28 Nov 2026 03:00:27 +0000
To: linux-rdma@vger.kernel.org
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Michal Kalderon <mkalderon@marvell.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>, David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] RDMA/qedr: prevent listener teardown from racing MPA requests
Message-ID: <179583482032.4059708.5194029012702478533@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 86117b73c38bededf2cf8392ae3e5add619bc7d1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

A passive endpoint copies the listener callback context when its SYN
is accepted.  Destroying the listener frees the qedr listener even
though the lower-level endpoint may deliver an MPA request later,
causing the callback to dereference freed memory.  Listener lookup
itself is also not serialized with removal.

Associate pending passive endpoints with their listener under iw_lock.
Listener teardown removes the listener and detaches every pending
endpoint under the same lock.  An endpoint claims the association
before delivering an MPA request; detached requests are rejected
instead.

Run delivered callbacks in an RCU read-side section and defer both
lower and upper listener reclamation.  This also handles listener
destruction from inside the connection-request callback without
waiting on itself.

Fixes: 65a91a6cdb86 ("qed: iWARP CM add listener functions and initial SYN =
processing")

Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
This patch has not been tested on physical hardware. The reproducer validat=
es the software lifetime ordering only.

Full dmesg/KASAN output:

[   21.005475] qed_iwarp_repro: loading out-of-tree module taints kernel.
[   21.407471] nscv-qed: app: rdma_listen(10.0.0.1:18515) -> qedr_iw_create=
_listen()=3D0 qedr li
** replaying previous printk message **
[   21.407471] nscv-qed: app: rdma_listen(10.0.0.1:18515) -> qedr_iw_create=
_listen()=3D0 qedr listener ff110000091d3100 (qed handle ff110000091b8580)
[   21.407591] nscv-qed: wire: SYN 10.0.0.2:40000 -> 10.0.0.1:18515 on the =
LL2 SYN queue: qed_iwarp_ll2_comp_syn_pkt()
[   21.407674] nscv-qed: fw: ramrod TCP_OFFLOAD posted (TCP offload of the =
passive connection)
[   21.407724] nscv-qed: passive ep ff1100000242ce00 created: event_cb=3Dqe=
dr_iw_event_handler [qedr] cb_context=3Dff110000091d3100 (the qedr listener=
, no reference)
[   21.407754] nscv-qed: app: rdma_destroy_id(listen id) -> qedr_iw_destroy=
_listen()
[   21.407961] nscv-qed: listener destroyed; ep ff1100000242ce00 still on e=
p_list with cb_context=3Dff110000091d3100
[   21.407976] nscv-qed: wire: peer sends the MPA request; fw: IWARP_EVENT_=
TYPE_ASYNC_CONNECT_COMPLETE -> qed_iwarp_async_event()
[   21.407989] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   21.407998] BUG: KASAN: slab-use-after-free in qedr_iw_event_handler+0x8=
9b/0x970 [qedr]
[   21.408040] Read of size 8 at addr ff110000091d3100 by task insmod/103
[   21.408055]=20
[   21.408070] CPU: 1 UID: 0 PID: 103 Comm: insmod Tainted: G           O  =
      7.3.0 #1 PREEMPT(lazy)=20
[   21.408097] Tainted: [O]=3DOOT_MODULE
[   21.408106] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   21.408117] Call Trace:
[   21.408127]  <TASK>
[   21.408137]  dump_stack_lvl+0x66/0xa0
[   21.408166]  print_report+0xd0/0x630
[   21.408194]  ? qedr_iw_event_handler+0x89b/0x970 [qedr]
[   21.408233]  ? __virt_addr_valid+0x209/0x3f0
[   21.408258]  ? qedr_iw_event_handler+0x89b/0x970 [qedr]
[   21.408296]  kasan_report+0xe4/0x120
[   21.408322]  ? qedr_iw_event_handler+0x89b/0x970 [qedr]
[   21.408369]  qedr_iw_event_handler+0x89b/0x970 [qedr]
[   21.408411]  ? __pfx_qedr_iw_event_handler+0x10/0x10 [qedr]
[   21.408453]  ? console_srcu_read_unlock+0x30/0x50
[   21.408476]  ? qed_iwarp_ll2_post_rx+0x78/0x290 [qed]
[   21.408680]  ? vprintk_emit+0x2e0/0x3e0
[   21.408700]  ? __pfx_qedr_iw_event_handler+0x10/0x10 [qedr]
[   21.408743]  qed_iwarp_async_event+0x59d/0x3d40 [qed]
[   21.408980]  ? __pfx_qed_iwarp_async_event+0x10/0x10 [qed]
[   21.409176]  ? __pfx__printk+0x10/0x10
[   21.409196]  ? kasan_quarantine_put+0xbc/0x1c0
[   21.409230]  repro_init+0x133c/0x1ff0 [qed_iwarp_repro]
[   21.409259]  ? qed_iwarp_async_event+0x4/0x3d40 [qed]
[   21.409453]  ? qedr_iw_destroy_listen+0x4/0x1c0 [qedr]
[   21.409496]  ? qed_iwarp_ll2_comp_syn_pkt+0x4/0x25d0 [qed]
[   21.409695]  ? __pfx_init_module+0x10/0x10 [qed_iwarp_repro]
[   21.409736]  ? __pfx_init_module+0x10/0x10 [qed_iwarp_repro]
[   21.409764]  do_one_initcall+0xc9/0x440
[   21.409788]  ? __pfx_do_one_initcall+0x10/0x10
[   21.409814]  ? do_init_module+0x92/0x7d0
[   21.409835]  ? __kmalloc_cache_noprof+0x23f/0x5c0
[   21.409857]  ? do_init_module+0x92/0x7d0
[   21.409878]  ? kasan_unpoison+0x27/0x60
[   21.409916]  do_init_module+0x27c/0x7d0
[   21.409943]  ? trace_hardirqs_on+0x18/0x160
[   21.409967]  ? __pfx_do_init_module+0x10/0x10
[   21.409987]  ? kasan_quarantine_put+0xbc/0x1c0
[   21.410008]  ? load_module+0x662a/0x7310
[   21.410029]  ? kfree+0x301/0x530
[   21.410057]  load_module+0x6516/0x7310
[   21.410104]  ? __pfx_load_module+0x10/0x10
[   21.410130]  ? security_file_permission+0x29/0x40
[   21.410159]  ? kernel_read_file+0x3fa/0x8f0
[   21.410194]  init_module_from_file+0x156/0x180
[   21.410219]  ? __pfx_init_module_from_file+0x10/0x10
[   21.410241]  ? __lock_acquire+0x570/0x1b00
[   21.410278]  ? idempotent_init_module+0x5e4/0x760
[   21.410301]  ? lock_release+0xc6/0x280
[   21.410320]  ? lockdep_init_map_type+0x5c/0x230
[   21.410343]  ? do_raw_spin_unlock+0x53/0x220
[   21.410370]  idempotent_init_module+0x228/0x760
[   21.410393]  ? cred_has_capability.isra.0+0x133/0x240
[   21.410416]  ? __pfx_idempotent_init_module+0x10/0x10
[   21.410437]  ? __pfx_cred_has_capability.isra.0+0x10/0x10
[   21.410479]  __x64_sys_finit_module+0xba/0x120
[   21.410506]  do_syscall_64+0x109/0x5e0
[   21.410532]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   21.410553] RIP: 0033:0x46716d
[   21.410569] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   21.410586] RSP: 002b:00007ffed1f5f9f8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   21.410610] RAX: ffffffffffffffda RBX: 000000000c469be0 RCX: 00000000004=
6716d
[   21.410624] RDX: 0000000000000000 RSI: 000000000c469be0 RDI: 00000000000=
00003
[   21.410636] RBP: 00007ffed1f5fa30 R08: 0000000000000020 R09: 00000000000=
00005
[   21.410649] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   21.410659] R13: 000000000c468d28 R14: 000000000c468d60 R15: 00000000000=
00000
[   21.410687]  </TASK>
[   21.410695]=20
[   21.410700] Allocated by task 103:
[   21.410711]  kasan_save_stack+0x33/0x60
[   21.410730]  kasan_save_track+0x14/0x30
[   21.410746]  __kasan_kmalloc+0x8f/0xa0
[   21.410763]  __kmalloc_cache_noprof+0x23f/0x5c0
[   21.410782]  qedr_iw_create_listen+0xe5/0x610 [qedr]
[   21.410819]  repro_init+0xb91/0x1ff0 [qed_iwarp_repro]
[   21.410841]  do_one_initcall+0xc9/0x440
[   21.410858]  do_init_module+0x27c/0x7d0
[   21.410876]  load_module+0x6516/0x7310
[   21.410893]  init_module_from_file+0x156/0x180
[   21.410927]  idempotent_init_module+0x228/0x760
[   21.410945]  __x64_sys_finit_module+0xba/0x120
[   21.410964]  do_syscall_64+0x109/0x5e0
[   21.410982]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   21.410998]=20
[   21.411003] Freed by task 103:
[   21.411012]  kasan_save_stack+0x33/0x60
[   21.411027]  kasan_save_track+0x14/0x30
[   21.411044]  kasan_save_free_info+0x3b/0x60
[   21.411058]  __kasan_slab_free+0x43/0x70
[   21.411075]  kfree+0x301/0x530
[   21.411093]  qedr_iw_destroy_listen+0x141/0x1c0 [qedr]
[   21.411129]  repro_init+0x123e/0x1ff0 [qed_iwarp_repro]
[   21.411150]  do_one_initcall+0xc9/0x440
[   21.411168]  do_init_module+0x27c/0x7d0
[   21.411185]  load_module+0x6516/0x7310
[   21.411202]  init_module_from_file+0x156/0x180
[   21.411220]  idempotent_init_module+0x228/0x760
[   21.411238]  __x64_sys_finit_module+0xba/0x120
[   21.411257]  do_syscall_64+0x109/0x5e0
[   21.411274]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   21.411290]=20
[   21.411295] The buggy address belongs to the object at ff110000091d3100
[   21.411295]  which belongs to the cache kmalloc-32 of size 32
[   21.411310] The buggy address is located 0 bytes inside of
[   21.411310]  freed 32-byte region [ff110000091d3100, ff110000091d3120)
[   21.411328]=20
[   21.411334] The buggy address belongs to the physical page:
[   21.411343] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0x91d3
[   21.411361] flags: 0x100000000000000(node=3D0|zone=3D1)
[   21.411376] page_type: f5(slab)
[   21.411395] raw: 0100000000000000 ff11000001038780 dead000000000100 dead=
000000000122
[   21.411412] raw: 0000000000000000 0000000000400040 00000000f5000000 0000=
000000000000
[   21.411421] page dumped because: kasan: bad access detected
[   21.411430]=20
[   21.411435] Memory state around the buggy address:
[   21.411444]  ff110000091d3000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   21.411456]  ff110000091d3080: fc fc fc fc fc fc fc fc 00 00 00 00 fc fc=
 fc fc
[   21.411469] >ff110000091d3100: fa fb fb fb fc fc fc fc 00 00 00 00 fc fc=
 fc fc
[   21.411478]                    ^
[   21.411487]  ff110000091d3180: 00 00 03 fc fc fc fc fc 00 00 03 fc fc fc=
 fc fc
[   21.411498]  ff110000091d3200: 00 00 00 00 fc fc fc fc 00 00 03 fc fc fc=
 fc fc
[   21.411508] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   21.411598] Disabling lock debugging due to kernel taint
[   21.411705] Oops: general protection fault, probably for non-canonical a=
ddress 0xe0aefc2f60000050: 0000 [#1] SMP KASAN NOPTI
[   21.642773] KASAN: maybe wild-memory-access in range [0x0578017b00000280=
-0x0578017b00000287]
[   21.643408] CPU: 1 UID: 0 PID: 103 Comm: insmod Tainted: G    B      O  =
      7.3.0 #1 PREEMPT(lazy)=20
[   21.644076] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE
[   21.644411] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014

 drivers/infiniband/hw/qedr/qedr.h           |  1 +
 drivers/infiniband/hw/qedr/qedr_iw_cm.c     | 12 +++-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 63 ++++++++++++++++++---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h |  4 ++
 4 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr=
/qedr.h
index a6c9a4d9ab935..b7dc3b5f3c916 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -535,6 +535,7 @@ struct qedr_iw_listener {
 =09struct iw_cm_id *cm_id;
 =09int=09=09backlog;
 =09void=09=09*qed_handle;
+=09struct rcu_head rcu;
 };
=20
 struct qedr_iw_ep {
diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/h=
w/qedr/qedr_iw_cm.c
index 8d38e74f1b127..322929144fbc4 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -719,6 +719,15 @@ int qedr_iw_create_listen(struct iw_cm_id *cm_id, int =
backlog)
 =09return rc;
 }
=20
+static void qedr_iw_free_listener(struct rcu_head *rcu)
+{
+=09struct qedr_iw_listener *listener;
+
+=09listener =3D container_of(rcu, struct qedr_iw_listener, rcu);
+=09listener->cm_id->rem_ref(listener->cm_id);
+=09kfree(listener);
+}
+
 int qedr_iw_destroy_listen(struct iw_cm_id *cm_id)
 {
 =09struct qedr_iw_listener *listener =3D cm_id->provider_data;
@@ -729,8 +738,7 @@ int qedr_iw_destroy_listen(struct iw_cm_id *cm_id)
 =09=09rc =3D dev->ops->iwarp_destroy_listen(dev->rdma_ctx,
 =09=09=09=09=09=09    listener->qed_handle);
=20
-=09cm_id->rem_ref(cm_id);
-=09kfree(listener);
+=09call_rcu(&listener->rcu, qedr_iw_free_listener);
 =09return rc;
 }
=20
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethe=
rnet/qlogic/qed/qed_iwarp.c
index 4d1ce9b1a3f2e..c064e0509de96 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -62,6 +62,14 @@ struct mpa_v2_hdr {
 static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code=
,
 =09=09=09=09 __le16 echo, union event_ring_data *data,
 =09=09=09=09 u8 fw_return_code);
+static int qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn,
+=09=09=09=09 struct qed_iwarp_ep *ep);
+
+static int qed_iwarp_listener_closed_event(void *context,
+=09=09=09=09=09   struct qed_iwarp_cm_event_params *params)
+{
+=09return 0;
+}
=20
 /* Override devinfo with iWARP specific values */
 void qed_iwarp_init_devinfo(struct qed_hwfn *p_hwfn)
@@ -734,6 +742,7 @@ static void
 qed_iwarp_mpa_received(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 {
 =09struct qed_iwarp_info *iwarp_info =3D &p_hwfn->p_rdma_info->iwarp;
+=09struct qed_iwarp_listener *listener;
 =09struct qed_iwarp_cm_event_params params;
 =09struct mpa_v2_hdr *mpa_v2;
 =09union async_output *async_data;
@@ -812,7 +821,28 @@ qed_iwarp_mpa_received(struct qed_hwfn *p_hwfn, struct=
 qed_iwarp_ep *ep)
 =09params.status =3D 0;
=20
 =09ep->state =3D QED_IWARP_EP_MPA_REQ_RCVD;
+
+=09rcu_read_lock();
+=09spin_lock_bh(&iwarp_info->iw_lock);
+=09listener =3D ep->listener;
+=09ep->listener =3D NULL;
+=09if (listener) {
+=09=09ep->event_cb =3D listener->event_cb;
+=09=09ep->cb_context =3D listener->cb_context;
+=09}
+=09spin_unlock_bh(&iwarp_info->iw_lock);
+
+=09if (!listener) {
+=09=09rcu_read_unlock();
+=09=09ep->cm_info.private_data_len =3D 0;
+=09=09if (qed_iwarp_mpa_offload(p_hwfn, ep))
+=09=09=09DP_NOTICE(p_hwfn,
+=09=09=09=09  "Failed to reject connection for closed listener\n");
+=09=09return;
+=09}
+
 =09ep->event_cb(ep->cb_context, &params);
+=09rcu_read_unlock();
 }
=20
 static int
@@ -931,6 +961,7 @@ qed_iwarp_return_ep(struct qed_hwfn *p_hwfn, struct qed=
_iwarp_ep *ep)
 =09}
 =09spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
=20
+=09ep->listener =3D NULL;
 =09list_move_tail(&ep->list_entry,
 =09=09       &p_hwfn->p_rdma_info->iwarp.ep_free_list);
=20
@@ -2393,7 +2424,9 @@ qed_iwarp_ll2_comp_syn_pkt(void *cxt, struct qed_ll2_=
comp_rx_data *data)
 =09=09goto err;
=20
 =09/* Check if there is a listener for this 4-tuple+vlan */
+=09spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 =09listener =3D qed_iwarp_get_listener(p_hwfn, &cm_info);
+=09spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 =09if (!listener) {
 =09=09DP_VERBOSE(p_hwfn,
 =09=09=09   QED_MSG_RDMA,
@@ -2421,17 +2454,21 @@ qed_iwarp_ll2_comp_syn_pkt(void *cxt, struct qed_ll=
2_comp_rx_data *data)
 =09}
=20
 =09DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "Received syn on listening port\n");
-=09/* There may be an open ep on this connection if this is a syn
-=09 * retrasnmit... need to make sure there isn't...
-=09 */
-=09if (qed_iwarp_ep_exists(p_hwfn, &cm_info))
-=09=09goto err;
-
 =09ep =3D qed_iwarp_get_free_ep(p_hwfn);
 =09if (!ep)
 =09=09goto err;
=20
 =09spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
+=09listener =3D qed_iwarp_get_listener(p_hwfn, &cm_info);
+=09if (!listener || qed_iwarp_ep_exists(p_hwfn, &cm_info)) {
+=09=09spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
+=09=09qed_iwarp_return_ep(p_hwfn, ep);
+=09=09goto err;
+=09}
+
+=09ep->listener =3D listener;
+=09ep->event_cb =3D qed_iwarp_listener_closed_event;
+=09ep->cb_context =3D NULL;
 =09list_add_tail(&ep->list_entry, &p_hwfn->p_rdma_info->iwarp.ep_list);
 =09spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
=20
@@ -2444,8 +2481,6 @@ qed_iwarp_ll2_comp_syn_pkt(void *cxt, struct qed_ll2_=
comp_rx_data *data)
 =09ep->mss =3D p_hwfn->p_rdma_info->iwarp.max_mtu - hdr_size;
 =09ep->mss =3D min_t(u16, QED_IWARP_MAX_FW_MSS, ep->mss);
=20
-=09ep->event_cb =3D listener->event_cb;
-=09ep->cb_context =3D listener->cb_context;
 =09ep->connect_mode =3D TCP_CONNECT_PASSIVE;
=20
 =09ep->syn =3D buf;
@@ -3201,14 +3236,24 @@ int qed_iwarp_destroy_listen(void *rdma_cxt, void *=
handle)
 {
 =09struct qed_iwarp_listener *listener =3D handle;
 =09struct qed_hwfn *p_hwfn =3D rdma_cxt;
+=09struct qed_iwarp_ep *ep;
=20
 =09DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "handle=3D%p\n", handle);
=20
 =09spin_lock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
 =09list_del(&listener->list_entry);
+=09list_for_each_entry(ep, &p_hwfn->p_rdma_info->iwarp.ep_list,
+=09=09=09    list_entry) {
+=09=09if (ep->listener !=3D listener)
+=09=09=09continue;
+
+=09=09ep->listener =3D NULL;
+=09=09ep->event_cb =3D qed_iwarp_listener_closed_event;
+=09=09ep->cb_context =3D NULL;
+=09}
 =09spin_unlock_bh(&p_hwfn->p_rdma_info->iwarp.iw_lock);
=20
-=09kfree(listener);
+=09kfree_rcu(listener, rcu);
=20
 =09return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h b/drivers/net/ethe=
rnet/qlogic/qed/qed_iwarp.h
index c3872cd9457fd..86a06eefc6237 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.h
@@ -7,6 +7,8 @@
 #ifndef _QED_IWARP_H
 #define _QED_IWARP_H
=20
+#include <linux/rcupdate.h>
+
 enum qed_iwarp_qp_state {
 =09QED_IWARP_QP_STATE_IDLE,
 =09QED_IWARP_QP_STATE_RTS,
@@ -111,6 +113,7 @@ struct qed_iwarp_ep_memory {
  */
 struct qed_iwarp_ep {
 =09struct list_head list_entry;
+=09struct qed_iwarp_listener *listener;
 =09struct qed_rdma_qp *qp;
 =09struct qed_iwarp_ep_memory *ep_buffer_virt;
 =09dma_addr_t ep_buffer_phys;
@@ -143,6 +146,7 @@ struct qed_iwarp_ep {
=20
 struct qed_iwarp_listener {
 =09struct list_head list_entry;
+=09struct rcu_head rcu;
=20
 =09/* The event_cb function is called for connection requests.
 =09 * The cb_context is passed to the event_cb function.

