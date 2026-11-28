Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795834828;
	b=D6M55c9FBzbGbPBVTyoFJ8nfVx/TUXXAU9GT0MVhyxfY2PHulNUgIAM9l7n2JouUKYcs
	 hAAQ6tADuaUE9Mr52rCAQoeC1aycvCy+76bYLz5ACWESvacM5+FCPijokDKJVFESs++yX
	 P3iyH9vwyTYSNqIM+vW2XDkb8Y9MIW/mdlbqaQMMAjrJaDoBUb4DirW1XRqAFFs6iRccQ
	 UDaeeONt2k6n81OXDQZAAPOqB01VcSdjDdJACn1TuWNuZTOTwDod/F5djtxgmh2NSlSe/
	 YAhCT8G1cq4B/KYCPNZILV0Nso4iiyvXjwv3hTV+wH32aFA3thO26LqmzHzCNph8zdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795834828;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=l5Jv8hSlCGf9mibFpPLH9kN9sNRHzp7ZN2NOPWfwVsQ=;
	b=SifrpIYzsu/6an8ANDWQHxaNQF/5BemYHpIvSleui+EqMNoe9/kGFeUlwF3lsh6M7Sy/
	 s5wFR/Y9fHJy1e4rCrOtrYkLyb+SdTyQWxdKz7LI4PFSzpVl1JHp2DIUMt4gov44MGedy
	 YtLsQMVlzXvbl2LGFCqE97iV+pmHtnKMLu+SHdZxOpAYKbgRCXF50pHk35qLtr16vbDSS
	 AFLU8YJ2cl+YPO22US8wYqqrF/O60nRMjcdkOy7YHhI4Un3a93H8LGqzlvarEWIHbits8
	 w1p+GOLLCeDm+ZEk3wULL/mLIYIMxrQG3lbe0aKpJ8t4yFvCwQUqsXceAqajyOo/uWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=U97uQFXJ;
	arc=none smtp.remote-ip=109.224.244.20
Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84232606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 03:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84232606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=U97uQFXJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1795834823; x=1796094023;
	bh=l5Jv8hSlCGf9mibFpPLH9kN9sNRHzp7ZN2NOPWfwVsQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=U97uQFXJ1DMYb/dPFGyFTCjaaegLa0V3WXFGxKdZITTzvEj/hZFsspOVVQqRxBRrD
	 lSv1BwZYsFAauI1gKFFJisb0I59fKbZp0hQeWFm+thM3u+RRg6ezkaLrZ6+Kw0U2P5
	 Lq9F6G4ckuSnP3Lqf/SqOSzQPlIcbvJPwYhK8Md3d7VxUuK0X3PoisiGi6i7CXghCS
	 dGbVemX7CEfFCquZ12nvJkF/9X50QtGS5peCY6zeN6UGIOygwujda6aaec8PW9i7+W
	 ETSGOKGz9ZgASP9WEnw/fHi/NNzPH0TiEgAQG/Mc9FtYn3vjMKqtb7LnnBGmKBPiQm
	 x+DxGUk+Dy/Gg==
Date: Sat, 28 Nov 2026 03:00:18 +0000
To: linux-rdma@vger.kernel.org
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Jacob Moroni <jmoroni@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] RDMA/irdma: remove listeners before dropping their last reference
Message-ID: <179583481252.4059565.5258024221855710290@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: a2aaebf58a0606b95ea00f091aa51a752f64ce2b
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

irdma_dec_refcnt_listen() can reduce a listener's reference count to
zero before taking listen_list_lock and removing it from the lookup
list.  A concurrent lookup can find the zero-reference listener and
attempt to acquire it during that window.

Serialize the final decrement and list removal with listener lookup.
Perform the remaining teardown after releasing the list lock.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")

Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
This patch has not been tested on physical hardware. The reproducer validat=
es the software lifetime ordering only.

Full dmesg/KASAN output:

[   19.382820] ice: Copyright (c) 2018, Intel Corporation.
[   19.433116] i40e: Intel(R) Ethernet Connection XL710 Network Driver
[   19.433123] i40e: Copyright (c) 2013 - 2019 Intel Corporation.
NSCV insmod irdma-listener-repro.ko
[   19.491024] irdma_listener_repro: loading out-of-tree module taints kern=
el.
[   20.135035] nscv-irdma: lock call site irdma_dec_refcnt_listen.isra.0+0x=
1d6/0x1070 [irdma]
[   20.141020] nscv-irdma: lock call site irdma_dec_refcnt_listen.isra.0+0x=
2d2/0x1070 [irdma]
[   20.146585] nscv-irdma: lock call site irdma_dec_refcnt_listen.isra.0+0x=
558/0x1070=20
** replaying previous printk message **
[   20.146585] nscv-irdma: lock call site irdma_dec_refcnt_listen.isra.0+0x=
558/0x1070 [irdma]
[   20.148055] nscv-irdma: app: rdma_listen() 10.0.0.1:18515 -> irdma_creat=
e_listen()=3D0 listener ff11000008265200 refcnt=3D1
[   20.148120] nscv-irdma: SYN from 10.0.0.2:40000 matched the listener (ir=
dma_find_listener ref), connection accepted and offloaded: cm_node ff110000=
0af4b800, listener refcnt=3D2
[   20.148129] nscv-irdma: app: rdma_destroy_id(listen id) -> irdma_destroy=
_listen()
[   20.148136] nscv-irdma: listener ff11000008265200 now state=3D1 refcnt=
=3D1, still on cm_core->listen_list
[   20.149037] nscv-irdma: close: last reference of the accepted connection=
's cm_node dropped: irdma_rem_ref_cm_node()
[   20.149102] nscv-irdma: close: refcount_dec_and_test(&listener->refcnt) =
hit 0 (listener ff11000008265200 state 1), about to take listen_list_lock
[   20.149125] nscv-irdma: app: rdma_listen() on the same port again: irdma=
_create_listen()
[   20.149159] ------------[ cut here ]------------
[   20.149164] refcount_t: addition on 0; use-after-free.
[   20.149183] WARNING: lib/refcount.c:25 at refcount_warn_saturate+0xc0/0x=
e0, CPU#1: nscv-irdma-list/105
[   20.176350] Modules linked in: irdma_listener_repro(O+) irdma i40e ice i=
dpf libeth_xdp libie_pci libie_cp libie libie_adminq libeth libie_fwlog ptp=
 9p 9pnet_virtio 9pnet netfs
[   20.180104] CPU: 1 UID: 0 PID: 105 Comm: nscv-irdma-list Tainted: G     =
      O        7.3.0 #1 PREEMPT(lazy)=20
[   20.182352] Tainted: [O]=3DOOT_MODULE
[   20.183103] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   20.185467] RIP: 0010:refcount_warn_saturate+0xc0/0xe0
[   20.186584] Code: b6 ef 9e 03 67 48 0f b9 3a 5b 5d c3 cc cc cc cc 48 8d =
3d b3 ef 9e 03 67 48 0f b9 3a 5b 5d e9 97 b1 19 02 48 8d 3d b0 ef 9e 03 <67=
> 48 0f b9 3a 5b 5d e9 84 b1 19 02 48 89 df e8 0c 13 63 ff e9 66
[   20.190184] RSP: 0018:ff1100000b667bf8 EFLAGS: 00010046
[   20.191187] RAX: 0000000000000007 RBX: ff11000008265244 RCX: ffffffff93c=
17025
[   20.192460] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff976=
06080
[   20.193696] RBP: 0000000000000002 R08: 0000000000000001 R09: ffe21c00010=
4ca48
[   20.194917] R10: ff11000008265247 R11: 0000000000000000 R12: ff1100000ae=
95930
[   20.196057] R13: 0000000000004853 R14: dffffc0000000000 R15: ff110000082=
65200
[   20.197199] FS:  0000000000000000(0000) GS:ff1100010b0f7000(0000) knlGS:=
0000000000000000
[   20.198498] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.199446] CR2: 000000000052183b CR3: 0000000002701001 CR4: 00000000007=
71ef0
[   20.200527] PKRU: 55555554
[   20.200955] Call Trace:
[   20.201356]  <TASK>
[   20.201705]  irdma_find_listener+0x3cb/0x460 [irdma]
[   20.202524]  ? __pfx_irdma_find_listener+0x10/0x10 [irdma]
[   20.203355]  irdma_create_listen+0x3e2/0x2b20 [irdma]
[   20.204110]  ? vprintk_emit+0x2e0/0x3e0
[   20.204671]  ? __pfx_vprintk_emit+0x10/0x10
[   20.205274]  ? lockdep_hardirqs_on_prepare+0xdc/0x190
[   20.205988]  ? trace_hardirqs_on+0x18/0x160
[   20.206602]  ? __pfx_irdma_create_listen+0x10/0x10 [irdma]
[   20.207375]  ? lockdep_hardirqs_on_prepare+0xdc/0x190
[   20.208045]  ? trace_hardirqs_on+0x18/0x160
[   20.208614]  ? __pfx_listen_thread+0x10/0x10 [irdma_listener_repro]
[   20.209446]  listen_thread+0x3c/0x180 [irdma_listener_repro]
[   20.210207]  ? __pfx_listen_thread+0x10/0x10 [irdma_listener_repro]
[   20.211000]  kthread+0x2ce/0x3b0
[   20.211427]  ? __pfx_kthread+0x10/0x10
[   20.211907]  ret_from_fork+0x52e/0x780
[   20.212394]  ? __pfx_ret_from_fork+0x10/0x10
[   20.212938]  ? __switch_to+0x572/0xde0
[   20.213424]  ? __pfx_kthread+0x10/0x10
[   20.213903]  ret_from_fork_asm+0x1a/0x30
[   20.214413]  </TASK>
[   20.214688] irq event stamp: 20
[   20.215070] hardirqs last  enabled at (19): [<ffffffff92b1f4e2>] vprintk=
_store+0x792/0x8b0
[   20.216024] hardirqs last disabled at (20): [<ffffffff95dae000>] _raw_sp=
in_lock_irqsave+0x50/0x60
[   20.217047] softirqs last  enabled at (0): [<ffffffff9296f44d>] copy_pro=
cess+0x247d/0x89d0
[   20.218001] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   20.218737] ---[ end trace 0000000000000000 ]---
[   20.219347] nscv-irdma: app: irdma_create_listen() returned 0, cm_id->pr=
ovider_data=3Dff11000008265200 refcnt=3D3221225472 reused_node=3D1 state=3D=
2
[   20.219418] nscv-irdma: close: irdma_rem_ref_cm_node() returned, listene=
r freed
** replaying previous printk message **
[   20.425335] nscv-irdma: app: rdma_destroy_id(new listen id) -> irdma_des=
troy_listen(), provider_data=3Dff11000008265200
[   20.425355] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   20.425362] BUG: KASAN: slab-use-after-free in irdma_destroy_listen+0x10=
d/0x150 [irdma]
[   20.425434] Write of size 4 at addr ff11000008265240 by task insmod/103
[   20.425444]=20
[   20.425455] CPU: 2 UID: 0 PID: 103 Comm: insmod Tainted: G        W  O  =
      7.3.0 #1 PREEMPT(lazy)=20
[   20.425475] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
[   20.425480] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   20.425487] Call Trace:
[   20.425494]  <TASK>
[   20.425501]  dump_stack_lvl+0x66/0xa0
[   20.425521]  print_report+0xd0/0x630
[   20.425539]  ? irdma_destroy_listen+0x10d/0x150 [irdma]
[   20.425602]  ? __virt_addr_valid+0x209/0x3f0
[   20.425618]  ? irdma_destroy_listen+0x10d/0x150 [irdma]
[   20.425681]  kasan_report+0xe4/0x120
[   20.425697]  ? irdma_destroy_listen+0x10d/0x150 [irdma]
[   20.425765]  irdma_destroy_listen+0x10d/0x150 [irdma]
[   20.425833]  repro_init+0x918/0xff0 [irdma_listener_repro]
[   20.425851]  ? irdma_cm_timer_tick+0x180/0xcc0 [irdma]
[   20.425917]  ? __pfx_init_module+0x10/0x10 [irdma_listener_repro]
[   20.425935]  ? __pfx_init_module+0x10/0x10 [irdma_listener_repro]
[   20.425950]  do_one_initcall+0xc9/0x440
[   20.425966]  ? __pfx_do_one_initcall+0x10/0x10
[   20.425982]  ? do_init_module+0x92/0x7d0
[   20.425996]  ? __kmalloc_cache_noprof+0x23f/0x5c0
[   20.426012]  ? do_init_module+0x92/0x7d0
[   20.426024]  ? kasan_unpoison+0x27/0x60
[   20.426039]  do_init_module+0x27c/0x7d0
[   20.426055]  ? trace_hardirqs_on+0x18/0x160
[   20.426071]  ? __pfx_do_init_module+0x10/0x10
[   20.426083]  ? kasan_quarantine_put+0xbc/0x1c0
[   20.426096]  ? load_module+0x662a/0x7310
[   20.426108]  ? kfree+0x301/0x530
[   20.426126]  load_module+0x6516/0x7310
[   20.426152]  ? __pfx_load_module+0x10/0x10
[   20.426214]  ? security_file_permission+0x29/0x40
[   20.426234]  ? kernel_read_file+0x3fa/0x8f0
[   20.426261]  init_module_from_file+0x156/0x180
[   20.426276]  ? __pfx_init_module_from_file+0x10/0x10
[   20.426291]  ? __lock_acquire+0x570/0x1b00
[   20.426314]  ? idempotent_init_module+0x5e4/0x760
[   20.426328]  ? lock_release+0xc6/0x280
[   20.426340]  ? lockdep_init_map_type+0x5c/0x230
[   20.426354]  ? do_raw_spin_unlock+0x53/0x220
[   20.426371]  idempotent_init_module+0x228/0x760
[   20.426385]  ? cred_has_capability.isra.0+0x133/0x240
[   20.426400]  ? __pfx_idempotent_init_module+0x10/0x10
[   20.426413]  ? __pfx_cred_has_capability.isra.0+0x10/0x10
[   20.426438]  __x64_sys_finit_module+0xba/0x120
[   20.426454]  do_syscall_64+0x109/0x5e0
[   20.426472]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   20.426483] RIP: 0033:0x46716d
[   20.426494] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   20.426505] RSP: 002b:00007ffcbb871938 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   20.426520] RAX: ffffffffffffffda RBX: 000000000ef2abe0 RCX: 00000000004=
6716d
[   20.426529] RDX: 0000000000000000 RSI: 000000000ef2abe0 RDI: 00000000000=
00003
[   20.426535] RBP: 00007ffcbb871970 R08: 0000000000000020 R09: 00000000000=
00005
[   20.426542] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   20.426549] R13: 000000000ef29d30 R14: 000000000ef29d70 R15: 00000000000=
00000
[   20.426564]  </TASK>
[   20.426569]=20
[   20.426572] Allocated by task 103:
[   20.426578]  kasan_save_stack+0x33/0x60
[   20.426591]  kasan_save_track+0x14/0x30
[   20.426601]  __kasan_kmalloc+0x8f/0xa0
[   20.426610]  __kmalloc_cache_noprof+0x23f/0x5c0
[   20.426623]  irdma_create_listen+0xc74/0x2b20 [irdma]
[   20.426696]  repro_init+0x422/0xff0 [irdma_listener_repro]
[   20.426708]  do_one_initcall+0xc9/0x440
[   20.426719]  do_init_module+0x27c/0x7d0
[   20.426730]  load_module+0x6516/0x7310
[   20.426741]  init_module_from_file+0x156/0x180
[   20.426752]  idempotent_init_module+0x228/0x760
[   20.426764]  __x64_sys_finit_module+0xba/0x120
[   20.426776]  do_syscall_64+0x109/0x5e0
[   20.426788]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   20.426796]=20
[   20.426799] Freed by task 104:
[   20.426804]  kasan_save_stack+0x33/0x60
[   20.426814]  kasan_save_track+0x14/0x30
[   20.426824]  kasan_save_free_info+0x3b/0x60
[   20.426832]  __kasan_slab_free+0x43/0x70
[   20.426843]  kfree+0x301/0x530
[   20.426855]  irdma_dec_refcnt_listen.isra.0+0x8d4/0x1070 [irdma]
[   20.426927]  irdma_rem_ref_cm_node+0x39c/0xd70 [irdma]
[   20.426999]  close_thread+0x23/0x50 [irdma_listener_repro]
[   20.427012]  kthread+0x2ce/0x3b0
[   20.427024]  ret_from_fork+0x52e/0x780
[   20.427035]  ret_from_fork_asm+0x1a/0x30
[   20.427046]=20
[   20.427049] The buggy address belongs to the object at ff11000008265200
[   20.427049]  which belongs to the cache kmalloc-128 of size 128
[   20.427058] The buggy address is located 64 bytes inside of
[   20.427058]  freed 128-byte region [ff11000008265200, ff11000008265280)
[   20.427069]=20
[   20.427072] The buggy address belongs to the physical page:
[   20.427079] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
xff11000008265c00 pfn:0x8265
[   20.427089] flags: 0x100000000000200(workingset|node=3D0|zone=3D1)
[   20.427100] page_type: f5(slab)
[   20.427112] raw: 0100000000000200 ff11000001038a00 ff11000001032648 ff11=
000001032648
[   20.427122] raw: ff11000008265c00 000000000010000c 00000000f5000000 0000=
000000000000
[   20.427127] page dumped because: kasan: bad access detected
[   20.427132]=20
[   20.427135] Memory state around the buggy address:
[   20.427141]  ff11000008265100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   20.427148]  ff11000008265180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   20.427154] >ff11000008265200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   20.427159]                                            ^
[   20.427165]  ff11000008265280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   20.427186]  ff11000008265300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   20.427191] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   20.427282] Disabling lock debugging due to kernel taint
[   20.427313] ------------[ cut here ]------------

 drivers/infiniband/hw/irdma/cm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma=
/cm.c
index 91c0e72982836..1b58b4635ac62 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1879,6 +1879,7 @@ static int irdma_dec_refcnt_listen(struct irdma_cm_co=
re *cm_core,
 =09struct list_head reset_list;
 =09struct irdma_cm_info nfo;
 =09enum irdma_cm_node_state old_state;
+=09bool free_listener;
 =09unsigned long flags;
=20
 =09trace_irdma_dec_refcnt_listen(listener, __builtin_return_address(0));
@@ -1912,11 +1913,13 @@ static int irdma_dec_refcnt_listen(struct irdma_cm_=
core *cm_core,
 =09=09}
 =09}
=20
-=09if (refcount_dec_and_test(&listener->refcnt)) {
-=09=09spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+=09spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+=09free_listener =3D refcount_dec_and_test(&listener->refcnt);
+=09if (free_listener)
 =09=09list_del(&listener->list);
-=09=09spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+=09spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
=20
+=09if (free_listener) {
 =09=09if (apbvt_del)
 =09=09=09irdma_del_apbvt(listener->iwdev,
 =09=09=09=09=09listener->apbvt_entry);

