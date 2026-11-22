Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367160;
	b=lxKWOI3O3Ja81kOHeaNWlXNlpSZBIPaIWwla5vpJwWhLpbFzvUFFr9xzIpT9SNDakZNz
	 RYcj5FSUtm3UirCEICyTTavBQMIGGRtuhzc3bnw5lpURUanfdpaaw1dtUuBv8aQUR7Wj0
	 KAOprqaN1xziUeHu65MmNi7H5K9UeG4L0jOn+aKL9Ih75eYrvMG5l8CDVPasROfcRjEFm
	 6w2UUb2yKCAHmO3Li5A5vONWhh7M7h6fns3aCg0Zbz+CuBht0jKYBFd9LWY2XjLDAm+OQ
	 QzP7Lse5HetQc53g7k7YdBiQViqCbPcGhf9HOrB9tOGvAN5TFvVh2z2NHPLJpE/7f+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Rb7fTO2DCgAJDNqcst5wmDmFKbDZCY5IlEK6pDHrML0=;
	b=tKNrLhwF2lJCfRTA/3SKDPOv2mLPFM9TLOY0IuE7amWo1W9azaAooI4ypwWFILKZ1H5g
	 13/roZvBG6ycgXUw0BXGM7vWfO/CeKqYbofylG39h1uAAQIUUa5XcPIpCoKTaNeSZxUYO
	 lXZ8j84DjgvEKzNcorS7aTpIyK6q3rRWib0rcrIe0DybMY/iMlgmREMnKbv1Y2jTsgZch
	 Hsi8WKexk/nHFQB5eZu/JJ+ak5ylRhfBlmPGwVuSK4wklpLH2QNQMU019AegYw2bd3+eE
	 xO+49RljlYPf7uXbYjmHX47m0+CdpQNzni9xGBE+dAPRELbmvnZ1l9Hp4tFt4gMBQyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="RJpAiN9/";
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D49606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 17:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46D49606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RJpAiN9/
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9495d543c42so272369685a.3
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795367159; x=1795971959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rb7fTO2DCgAJDNqcst5wmDmFKbDZCY5IlEK6pDHrML0=;
        b=RJpAiN9/7zIHy0OFh9WCaDyRndkKY9hrKkqxjQNaQsotvBK31dc859Hrn2WXNtcO6z
         UbZJpcykhNhkV7KAjX9kQTLYa5VWmtd3NayJ/5ZHKU3hD6s+VXxWRTt0RqrxDe5qg7Yx
         Ek56ieHjZOzGX0VHmCocrVyknRZN6Twpt1j8NSvvoUp4ZHn1OKnSxfotNq5HTGwFYRCA
         wTacVdhs+kD4zh3aKh48g1LKEcjN4qioemgWbHm6fPGJMSHu9rquM4MrZ2vKr0aukHGQ
         fuB8wPvEdewQ7/BsO3vX/aXtCWRNCNPmUyUchO6JNQvS9s5yqZNXJfyHpm+7nqRpY19X
         3+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795367159; x=1795971959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rb7fTO2DCgAJDNqcst5wmDmFKbDZCY5IlEK6pDHrML0=;
        b=YMMpkK9aJK5VhzagvZyYqCrNWff18g3whFRYKFo00BZSoq0dmgP0pDVgokz66vdndN
         FCalRZoptw3WAEDmo87mfxBylmUkf7YbBTRrl5yzofqI17TqqrFqyhBhWvV2VJ5Y1Axi
         YS8Ysl7R64Nt40vd5bppBlOIU9TGY1mXHKrxoo3l5DcrOs8tKulYWTBRWqslym2zDTAq
         r1MsHcCw9Ld30D92pYr2ffIQ4lIA/myYemQOK2qQ1qEq3UVjqjXtbP7L8C6wKAo2yUEw
         5D6paCDtgdE+1NNH8MoPNs4WID+4CcaW8IsvBDCuxspfWj7YhRK/aP44w1SWJPHOAjsi
         josA==
X-Forwarded-Encrypted: i=1; AL+hErFUAlY+ioOl16D3mWclCaMFMXqBV5xGv2yTjRVz6OToS12TFGBka2XKs5DtP5nZ5GuxWXn5L/T5DZye@vger.kernel.org
X-Gm-Message-State: APuU4Z/6IaFtGvmrQK3QNTJ7WB/4C9amNqDq8dELkpcbjLdMdHzE8xc6
	6deQh5eOHpuYAELo17ed5OKRmGOZMC9w5piujCos5wk9C/a14OFDpflV
X-Gm-Gg: AZFdTZegS+q8YS6++LNBbasvPptDjsqS3MWsxfCPjE1HZBp/dCNEGT7Y0D3GUmWXTOm
	1IfSAFLYpFgqOZMaIL39kX1AQ2zj8geNMufnrDBmOIuICh/6883LZYpqEpyXWe3usz1GTU/DyHa
	uryy2SMWrbEdmkbM8nE/7df3Zez40l1vtlL3iEss+9EKZHX3g1DmqaRMZylHVY0vV3VfaBYrAUa
	D8UB2XArxOXYgVkgqB/oTi/7xCA6jgMfA5zA2UyKD+L1DF17gGmW/7Nm20eq7R4e7bN+lYrkpUP
	fy/74aJMbzcbbXHxUK5jpgJIFgoMH6qA/Kzjwx6d4zmydaIetQ/03Pt+3I8h13JOCkLrCvxh2QN
	ghlV63nicEVN5J2p0de8iASnabkVhlnTJMGdD7Emf0cN0YVxA+7wudnU6f3+3+756HrbiLjy12K
	LrEoYaOh/CHIfYRI9tyyLKCsLx5+SjKnXhuw5hI51ni7ZQ0RwSffIHzMVia53YjktOwrWGHiOqe
	pXYM7BG25vOqU2ircw6XcwNUj4CJXXr96kHe2ixv6XmtbPl2GG5ULlBslTP58gLIxyzYkfBZCl+
	IadbpdHN399XjtSvULghylCmwvOyuxGjzO6/m6/YDTJpE3xYo1j1BUeRL2pyqWfrYJaQGYA6oYs
	a5k/lawxoQGHKBbHzCieuSI2PbHWLjDLdkAqsHCpydtt7C/S9/y2E6XEJdl/TlLVBV5ovEdwoAu
	PMvIqYYrYJrkngNW8uBSGav1+EU3UDDfuu7/wa7AnSuVl4qgo=
X-Received: by 2002:a05:620a:31a3:b0:947:7f9b:f841 with SMTP id af79cd13be357-949ba9864e1mr1578229785a.31.1795367159037;
        Sun, 22 Nov 2026 09:05:59 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c8ee:a73:9097:862f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb4219c4sm635682385a.41.2026.11.22.09.05.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 09:05:58 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2] RDMA/rxe: Require a responder resource for FLUSH
Date: Sun, 22 Nov 2026 12:05:51 -0500
Message-ID: <20261122170551.19582-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

process_flush() keeps its state in a responder resource from
rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
refuses those requests when max_dest_rd_atomic is 0, but it does not
check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
free_rd_atomic_resource().

A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
responder:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:0 Not tainted 7.4.0-rc3-gaebb72744764 #1 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: rxe_wq do_work
  RIP: 0010:free_rd_atomic_resource+0x15/0x50
  Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
  RSP: 0018:ff110000013479f8 EFLAGS: 00000202
  RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
  RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
  RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
  R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
  R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
  FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   rxe_receiver+0x5f6e/0x9a20
   ? flush_workqueue_prep_pwqs+0x1a4/0xe80
   ? kthread+0x2b0/0x3b0
   ? __pfx_rxe_receiver+0x10/0x10
   ? update_cfs_rq_load_avg+0x5a/0x560
   ? pick_task_fair+0x468/0x1a60
   ? __pfx_rxe_receiver+0x10/0x10
   ? _raw_spin_lock_irqsave+0x86/0xe0
   ? __pfx_rxe_receiver+0x10/0x10
   do_work+0x144/0x470
   process_one_work+0x6fc/0x1180
   ? __pfx___schedule+0x10/0x10
   ? __pfx_process_one_work+0x10/0x10
   ? _raw_spin_lock_irq+0x81/0xe0
   ? __pfx_do_work+0x10/0x10
   ? assign_work+0x11d/0x410
   worker_thread+0x45b/0xd10
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x2c8/0x3b0
   ? recalc_sigpending+0x15c/0x1e0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x36e/0x5a0
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x572/0xdc0
   ? __switch_to_asm+0x33/0x70
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Modules linked in:
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:free_rd_atomic_resource+0x15/0x50
  Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
  RSP: 0018:ff110000013479f8 EFLAGS: 00000202
  RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
  RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
  RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
  R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
  R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
  FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
  PKRU: 55555554

  ------------[ cut here ]------------
  WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup+0x21b/0x290, CPU#0: t028/87
  Modules linked in:
  CPU: 0 UID: 0 PID: 87 Comm: t028 Tainted: G      D             7.4.0-rc3-gaebb72744764 #1 PREEMPT(lazy)
  Tainted: [D]=DIE
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:__rxe_cleanup+0x21b/0x290
  Code: f7 fe ff ff 4c 89 e7 e8 43 99 ad fd 84 c0 0f 85 6f ff ff ff be 50 c3 00 00 4c 89 e7 e8 9e 22 f3 00 85 c0 0f 85 5a ff ff ff 90 <0f> 0b 90 eb 04 90 0f 0b 90 bd 92 ff ff ff e9 48 ff ff ff 90 0f 0b
  RSP: 0018:ff110000053f78f8 EFLAGS: 00000246
  RAX: 0000000000000000 RBX: ff110000059f9160 RCX: ffe21c0000a7ef08
  RDX: 0000000000000000 RSI: ff110000053f7860 RDI: ff110000059f9190
  RBP: 0000000000000001 R08: 0000000000000001 R09: ffe21c0000a7eef5
  R10: 0000000000000003 R11: ffffffff89c14700 R12: ff110000059f9188
  R13: ff110000059f9170 R14: ff11000004794ea0 R15: 1fe2200000a7ef1f
  FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: dffffc0000000002 CR3: 000000001b872000 CR4: 0000000000751ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __pfx___rxe_cleanup+0x10/0x10
   ? rxe_qp_chk_destroy+0x61/0xc0
   rxe_destroy_qp+0x2f/0x180
   ib_destroy_qp_user+0x30f/0x4f0
   ? __pfx_ib_destroy_qp_user+0x10/0x10
   ? stack_trace_save+0x8e/0xc0
   uverbs_free_qp+0x7c/0x150
   ? put_files_struct+0x181/0x310
   destroy_hw_idr_uobject+0x7e/0x130
   ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
   uverbs_destroy_uobject+0xdf/0x770
   __uverbs_cleanup_ufile+0x18b/0x390
   ? __pfx___uverbs_cleanup_ufile+0x10/0x10
   ? __pfx_down_write+0x10/0x10
   uverbs_destroy_ufile_hw+0x6d/0x260
   ib_uverbs_close+0x46/0x270
   __fput+0x2f8/0x9e0
   fput_close_sync+0xe2/0x190
   ? __pfx_fput_close_sync+0x10/0x10
   filp_close_sync+0x18/0x30
   put_files_struct+0x181/0x310
   do_exit+0x6ab/0x25f0
   ? __pfx_do_exit+0x10/0x10
   ? zap_other_threads+0xb9/0x300
   ? __pfx_zap_other_threads+0x10/0x10
   ? handle_mm_fault+0x13d/0x420
   do_group_exit+0xab/0x220
   __x64_sys_exit_group+0x39/0x40
   x64_sys_call+0x1962/0x1970
   do_syscall_64+0xdf/0x4c0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f34f928a21d
  Code: Unable to access opcode bytes at 0x7f34f928a1f3.
  RSP: 002b:00007ffeed584088 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
  RAX: ffffffffffffffda RBX: 00007f34f93a0fa8 RCX: 00007f34f928a21d
  RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
  RBP: 00007ffeed5840e0 R08: 00007ffeed584030 R09: 0000000000000000
  R10: 000055d8b71c93e0 R11: 0000000000000202 R12: 0000000000000001
  R13: 0000000000000000 R14: 0000000000000000 R15: 00007f34f93a0fc0
   </TASK>
  ---[ end trace 0000000000000000 ]---

The responder task dies, and when the test exits, destroying the QP
warns on a timeout in __rxe_cleanup() (the WARNING above) and then
hangs.

Add RXE_FLUSH_MASK to the check, so a FLUSH gets the same Invalid
Request NAK a READ would, and the requester sees IB_WC_REM_INV_REQ_ERR.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Opus 5.5 and
reviewed by me.

Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

v2: the full kernel log of the oops and the later WARNING, as Leon
asked (timestamps removed). The code change is the same as v1.
v1: https://lore.kernel.org/r/20261119151332.95466-1-astellman@stellman-greene.com

Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
code from rdma for-next (7404c82cbf12). The reproducer is a short
libibverbs program; I can send it off-list.

 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 1b7f31737225..38b5b0c2abe3 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -340,7 +340,8 @@ static enum resp_states check_resource(struct rxe_qp *qp,
 {
 	struct rxe_srq *srq = qp->srq;
 
-	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK)) {
+	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK |
+			 RXE_FLUSH_MASK)) {
 		/* it is the requesters job to not send
 		 * too many read/atomic ops, we just
 		 * recycle the responder resource queue

base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
-- 
2.43.0

