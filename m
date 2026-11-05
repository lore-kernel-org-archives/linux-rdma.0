Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793845386;
	b=snRRJtYaC6Lg6RBwyMmMdYyLH4l0vkOaxK6rLBrH1B59hPTUuh/Tt4hL/Cn/Tn/cTLj3
	 e2uPcryPcjBzMl/9mjmoJC/bxVofeRYk51DVIDZMTonfkEYUydE29TGcXmbas/63zgjyT
	 FOLqRh8xJ/I9g/2qvQy2Ik9fbr1DGMadI+1TJ3ZgJCmNOLykfxBM6pAgsCtAgO1humTNL
	 NnILQBy9D9y8IHyYSZ6WBMFi1o6T9ynsw4/uh8w+VCPV7Pts8GCD62+9zYhlLc50FNU6e
	 Gq4+nm8H2RqzM0yiBKCMOhmW7HdTcALNMn4aIN4weZ4pYeKLMM1lYube/Gd6HjY/Zhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793845386;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=zVvkIjU8fIWtL8CFjIrx2KKb8A7qjXgttlPSkbDgptw=;
	b=LJHhXkcridk94TAGXGxnYuKk5mCw+5jmx9BRy/qEY2hWdEyeRUpB41cS8VLuygqYBbxp
	 ohnF/bwh39m3xvpENKljm5VWhzvPN8lwhUQzBevB/CvLYnRjI0RS6nSC8E435VPFgUopC
	 6J/dmiWkJbcRS5CnKBvMOTmtOAzzkwPO3BBmfRfyg/duuXcqnbY+AyzS3jmtmRKKvULzH
	 t/fUnWYppOLQpbs5lSzDYnrsbutq1SmfDF1X++0YfnQsWHBkAlzU45thig+84zlst+Vnd
	 lVvBxEY7cESkYKjoLesl9mxZ2PqxhwMECzhGB1ZdSZfl6TOqMatJLeaLZHgKJ9H8Pzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=WbJk6Rmx;
	arc=none smtp.remote-ip=185.70.43.20
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC77606A328
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 02:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CC77606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=WbJk6Rmx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1793845382; x=1794104582;
	bh=zVvkIjU8fIWtL8CFjIrx2KKb8A7qjXgttlPSkbDgptw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=WbJk6RmxmV3t6PzXEu+XzH0oU1g73JUjndYqxQbfE/RHhYmF0sjkpgVUDRiHG2WiF
	 8ST5PXwS8reIOMUvZUsZeOQlpUonvxgE2Y+bJzU8C/gTDOXafws0tYGdq/HyvIlfhR
	 1nJmdpcW+seY60ou8/ntZ3QzRqSoLo20/QAXi8OSJSAhxCyjE68MgmKwSKtcpLVr9d
	 bcWjeEmnc7fhpRD/8YPwBYxecDzTix7RQAcQhDVbDyQV/9rthcGYaOdv/JEO0fz5qq
	 qylSuiTflLwwPeo21W2oJdVifBcCw700unIZSoNb9vw4QCBIGLMNe9Pvu6Lj2XXjiV
	 bR/As1ALY58Bw==
Date: Thu, 05 Nov 2026 02:22:58 +0000
To: Bernard Metzler <bernard.metzler@linux.dev>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] RDMA/siw: Fix early peer close handling on listeners
Message-ID: <20261105022253.368316-1-lee@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 9d02bc690b6ec8de08a9f845a622bc9e2e619e4d
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

A TCP child socket inherits the listener callbacks and sk_user_data before
kernel_accept() associates it with a new connection endpoint. If the peer
closes during this window, siw_cm_llp_state_change() queues a PEER_CLOSE
work item against the listening endpoint.

The worker releases that endpoint without removing it from the listener
list. A later listener teardown then walks the dangling entry, causing a
use-after-free in siw_destroy_listen(). KASAN reports:

  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x32/=
0x1a0
  Read of size 8 at addr ffff888008f502c8 by task rping/59

  CPU: 0 UID: 0 PID: 59 Comm: rping Tainted: G    B               7.4.0-rc1=
-g6628e7d4c6b2 #1 PREEMPT(lazy)
  Tainted: [B]=3DBAD_PAGE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 199=
6), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x54/0x70
   print_address_description+0x73/0x1f0
   ? __list_del_entry_valid_or_report+0x32/0x1a0
   print_report+0x58/0x70
   kasan_report+0x117/0x150
   ? add_taint+0x43/0x90
   ? __list_del_entry_valid_or_report+0x32/0x1a0
   __list_del_entry_valid_or_report+0x32/0x1a0
   siw_destroy_listen+0xe1/0x630
   destroy_cm_id+0x25c/0x480
   ? srso_return_thunk+0x5/0x5f
   ? srso_return_thunk+0x5/0x5f
   ? lock_acquire+0xf7/0x220
   ? _destroy_id+0x2d1/0xe30
   iw_destroy_cm_id+0xf/0x80
   _destroy_id+0x6cc/0xe30
   _cma_cancel_listens+0x2ee/0x360
   _destroy_id+0x2ad/0xe30
   ucma_destroy_private_ctx+0xb7/0x9d0
   ? srso_return_thunk+0x5/0x5f
   ? do_raw_spin_unlock+0x4d/0x230
   ucma_close+0xd5/0x130
   __fput+0x31a/0x720
   fput_close_sync+0x91/0x110
   filp_close_sync+0x18/0x30
   put_files_struct+0x25a/0x280
   do_exit+0x70e/0x1d00
   ? lock_acquire+0xf7/0x220
   ? get_signal+0x21c/0xf60
   do_group_exit+0x19e/0x250
   get_signal+0xf20/0xf60
   ? futex_wait+0x99/0x230
   arch_do_signal_or_restart+0x46/0x420
   exit_to_user_mode_loop+0xbd/0x510
   do_syscall_64+0x2ed/0x3b0
   ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
   ? srso_return_thunk+0x5/0x5f
   ? trace_hardirqs_off+0x65/0x90
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f92984c6e51
  Code: Unable to access opcode bytes at 0x7f92984c6e27.
  RSP: 002b:00007ffeae782d10 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
  RAX: fffffffffffffe00 RBX: 000055fb4e9819b8 RCX: 00007f92984c6e51
  RDX: 0000000000000000 RSI: 0000000000000189 RDI: 000055fb4e9819b8
  RBP: 00007ffeae782d50 R08: 0000000000000000 R09: 00000000ffffffff
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 0000000000000000 R14: 000055fb4e9819b8 R15: 000055fb4e97da25
   </TASK>

  Allocated by task 59:
   kasan_save_track+0x3e/0x80
   __kasan_kmalloc+0x72/0x90
   __kmalloc_cache_noprof+0x245/0x3c0
   siw_cep_alloc+0x4f/0x390
   siw_create_listen+0x39e/0xd60
   iw_cm_listen+0xfc/0x1d0
   rdma_listen+0x749/0xa90
   cma_listen_on_dev+0x404/0x760
   rdma_listen+0x3dc/0xa90
   ucma_listen+0xe2/0x180
   ucma_write+0x1bd/0x1e0
   vfs_write+0x1a9/0x8e0
   ksys_write+0xba/0x180
   do_syscall_64+0xee/0x3b0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

  Freed by task 30:
   kasan_save_track+0x3e/0x80
   kasan_save_free_info+0x40/0x50
   __kasan_slab_free+0x3a/0x60
   kfree+0x155/0x470
   siw_cm_work_handler+0x7af/0x2d40
   process_scheduled_works+0x970/0x12d0
   worker_thread+0x894/0xd20
   kthread+0x2db/0x3b0
   ret_from_fork+0x266/0x570
   ret_from_fork_asm+0x1a/0x30

  The buggy address belongs to the object at ffff888008f50200
   which belongs to the cache kmalloc-512 of size 512
  The buggy address is located 200 bytes inside of
   freed 512-byte region [ffff888008f50200, ffff888008f50400)

  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000
  index:0xffff888008f51400 pfn:0x8f50
  head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
  flags: 0x4000000000000240(workingset|head|zone=3D1)
  page_type: f5(slab)
  raw: 4000000000000240 ffff888005842040 ffff888005840d08 ffff888005840d08
  raw: ffff888008f51400 00000000000a0003 00000000f5000000 0000000000000000
  head: 4000000000000240 ffff888005842040 ffff888005840d08 ffff888005840d08
  head: ffff888008f51400 00000000000a0003 00000000f5000000 0000000000000000
  head: 4000000000000002 ffffea000023d401 00000000ffffffff 00000000ffffffff
  head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff888008f50180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888008f50200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  >ffff888008f50280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                ^
   ffff888008f50300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff888008f50380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

There is a second race while creating a listener. listen() starts
accepting connections before the endpoint is linked to the CM ID and
changed from IDLE to LISTENING. ACCEPT work queued in this interval can
run immediately, see the IDLE state, and return without accepting the
first child.

Keep the listener endpoint in use from allocation until its CM ID, listener
list entry, and LISTENING state have all been published. This makes early
ACCEPT work wait for listener setup to complete.

During accept, serialize the endpoint handoff with socket state changes and
reject a child that has already reached TCP_CLOSE or TCP_CLOSE_WAIT. Ignore
close notifications inherited from the listener before that handoff. Live
accepted sockets continue through the normal close path.

The issue was found by static analysis.

The unpatched kernel reproduced the KASAN report above in an x86_64 QEMU
guest. With a temporary 500 ms delay after listen(), the previous version
lost the first child and timed out waiting for an MPA response; this
version accepted the same child and returned an MPA response.
RST-before-accept and MPA-request-followed-by-FIN tests also completed
without KASAN or lockdep reports. The final SIW object was built with
LLVM 22.1.8 and W=3D1.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Suggested-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/r/33abff2233b36a51e468d691cb4327d0294d2734.16=
20343860.git.metze@samba.org
Cc: stable@vger.kernel.org
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
Changes in v3:
- Serialize listener setup so early ACCEPT work cannot be consumed in IDLE.
- Include the complete KASAN report requested by Leon.

Changes in v2:
- Cover the IDLE interval between listen() and the LISTENING transition.
- Serialize accepted-socket handoff and reject an already closed child.

 drivers/infiniband/sw/siw/siw_cm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index ed49818793dde..90adb9543d9d0 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -973,6 +973,7 @@ static void siw_accept_newconn(struct siw_cep *cep)
 =09struct socket *s =3D cep->sock;
 =09struct socket *new_s =3D NULL;
 =09struct siw_cep *new_cep =3D NULL;
+=09bool peer_closed;
 =09int rv =3D 0; /* debug only. should disappear */
=20
 =09if (cep->state !=3D SIW_EPSTATE_LISTENING)
@@ -1009,11 +1010,23 @@ static void siw_accept_newconn(struct siw_cep *cep)
 =09}
 =09new_cep->sock =3D new_s;
 =09siw_cep_get(new_cep);
-=09new_s->sk->sk_user_data =3D new_cep;
=20
 =09if (siw_tcp_nagle =3D=3D false)
 =09=09tcp_sock_set_nodelay(new_s->sk);
+
+=09lock_sock(new_s->sk);
+=09write_lock_bh(&new_s->sk->sk_callback_lock);
 =09new_cep->state =3D SIW_EPSTATE_AWAIT_MPAREQ;
+=09new_s->sk->sk_user_data =3D new_cep;
+=09peer_closed =3D new_s->sk->sk_state =3D=3D TCP_CLOSE ||
+=09=09      new_s->sk->sk_state =3D=3D TCP_CLOSE_WAIT;
+=09write_unlock_bh(&new_s->sk->sk_callback_lock);
+=09release_sock(new_s->sk);
+
+=09if (peer_closed) {
+=09=09rv =3D -ECONNRESET;
+=09=09goto error;
+=09}
=20
 =09rv =3D siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
 =09if (rv)
@@ -1361,6 +1374,10 @@ static void siw_cm_llp_state_change(struct sock *sk)
=20
 =09case TCP_CLOSE:
 =09case TCP_CLOSE_WAIT:
+=09=09if (cep->state =3D=3D SIW_EPSTATE_LISTENING ||
+=09=09    (cep->state =3D=3D SIW_EPSTATE_IDLE &&
+=09=09     !READ_ONCE(sk->sk_socket)))
+=09=09=09break;
 =09=09if (cep->qp)
 =09=09=09cep->qp->tx_ctx.tx_suspend =3D 1;
 =09=09siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
@@ -1880,6 +1897,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 =09=09rv =3D -ENOMEM;
 =09=09goto error;
 =09}
+=09siw_cep_set_inuse(cep);
 =09siw_cep_socket_assoc(cep, s);
=20
 =09rv =3D siw_cm_alloc_work(cep, backlog);
@@ -1932,14 +1950,13 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
=20
 =09siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
=20
+=09siw_cep_set_free(cep);
 =09return 0;
=20
 error:
 =09siw_dbg(id->device, "failed: %d\n", rv);
=20
 =09if (cep) {
-=09=09siw_cep_set_inuse(cep);
-
 =09=09siw_free_cm_id(cep);
 =09=09siw_socket_disassoc(s);
 =09=09cep->state =3D SIW_EPSTATE_CLOSED;
--=20
2.43.0


