Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A83911B2
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 01:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787101698; cv=none; b=B5Cq5dR68aOC9P3cxlYgfYlxwyqdKMCM+kzns8izf/CW8Z2Y22EsDjjXAiECGRrL+d3n/0TtU9kDC9DzU9/QBs0qae8EA2iy+MNnXINbFTVH/0PWesvpisulEoLRPFYjN1DJQ7QngrIYjcc1Y221UE17coqB2zHTMjIy/YrdDts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787101698; c=relaxed/simple;
	bh=jAQeYzvvLyNVGfKVGIAmvSwOrTxW0zzoAbou4bMsINg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iWu8xkC+EIz7KVgMZusegGOzkGsw6ZFc9ORxdbSpWUxUIG2DQxR9bv/qJnZy6XYvEoGRvj8tuspnH8OQaEjb+MfiIrVlhxkusa0hBAZmte4pMNhgSvA9MJMAPHNBCxTdhUNJliOrrfeyNdEqp126nV8C4ggMXECbNaZJNXAIQ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=AlhjEZ5W; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="AlhjEZ5W"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbedbaba5fdso229351a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 18:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787101695; x=1787706495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jry/dKaX/UfAjpeKl1i+a+yScO+yOSCniX8pNKgERP0=;
        b=AlhjEZ5WbximC1vg/xklNs+nlt9wscmrjDEtOb/mVB1oqf+CGtLIvu8OCe2JMtK2mA
         /WFe+0howteEwVbfBkOlQKBUeyzuu3GQZfgC4os0Wy3GhIE2Nn45Y62lhPFk+jp+iCed
         bKpxmITgTbw4y12xD7Ohj+KrLhEumGn0N2GUXUg4C1qIpaV21/1KnpsSO72xxJmwulPP
         wDfYYGkJZAbwj2gBvjACF59G6WaCYgAtiquBIPVHKFu/jif/OIBRwYM9vVk7P/C335Aa
         0fFIFLNpsVREcfV7FbZmIAr3e+UaW/iK9DvtaASQR6h87qZfkDxlJzx3ANHzLkD0thJ0
         6vXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787101695; x=1787706495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jry/dKaX/UfAjpeKl1i+a+yScO+yOSCniX8pNKgERP0=;
        b=jLxHL22EhRF77PbwLXZLvSwCuM3VRV3TMiFaLRjnUu8QtbchkMXtaj6WK9FOWf0bWL
         HFM6IYeCZK++6zGJ2CbdUX2WPIu+IB1G2Bj1VHAKPyiaf0BBGA4bwBJW1hGl6uC2A2GS
         pAJs2nLbt/1wunnsCRAE4Pg9m5paBHLSo4VtPczMNuVsTCa9z3RS0o85FjxW1eh2d0ir
         vGKnScFViCGrybTA5Q8/+eV4RgHazrC0pYFpUxy/YQGH+esDrMaFB1rwbnEtc8KyOv6D
         7LoGyBejkCF3yeFaCMJH0uKGK3MrTb4tHaX3CTSKO8jWrG8G8Lpm4G6ipadwQ9owQLsB
         7tig==
X-Forwarded-Encrypted: i=1; AHgh+RoHeoo0EEw4e8skXxsFDy/QEvJUDGeKSmw6gbpqOIsxZM48zag9eZVMZbwibmfzHVkEKOoienCwD0VA@vger.kernel.org
X-Gm-Message-State: AOJu0YyDDC6Z2ZJ6oLtHS6HJfYH9PeHApWhnLIsxFmrANvx5BUr/21Pl
	bV1JaMM6sp88jru4Ig4gdu5lh8AhBons0uI02HYKHC88m8h8r7ykFsRQkGn3roO4jIs=
X-Gm-Gg: AR+sD13oODVKXWcBIImIIpfMk3GowUoKYGUXU1DH0q9ZFQJmooT2+QyL56qI9vTw1Fr
	vV2LSdPk3HsILZ8v70NRxOzHcxp9YykMSlmezPessnFEvQridUs2qzTqJc6WSEYUBCI6ogCI6Fb
	TbuEQE12JdWGA0CcKWIHoIpxbrw1+LYOWjraSTgmlZOTH8VUcUKPzfzMlwkWPD01ITcyj/hZfiK
	9S0UnqstYc6iUh53+7xH0I/D1bCVfJ51eY0dB9aj2PT9S/HC/JbcNFOr9Bo8544+4l4jp0mfCan
	S+aDC8jlxD9d1IwjCduSZ+XY9kc84l76l2u6ie11mAtcqEy8M6ZCJzuJmpbGALeRrKt1Yqbe2p2
	xXrtjqAkTjGw1Jzxh6xEFvhsRn6JvfbOQmFEZN8eVrva9Ct8SIt5B/iIK3BqQ4FPRIeWde8/WA2
	E4256XfDcerWIWqbDyCvf3qpmw2EEp4kdYPPqGTIpCwP5SOPFwpHHl5fTaEQBCLD93J9Jw
X-Received: by 2002:a17:90b:4a46:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-3958083fc60mr1680125a91.4.1787101695082;
        Tue, 18 Aug 2026 18:08:15 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm653701a91.2.2026.08.18.18.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:08:14 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me
Cc: mgurtovoy@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dledford@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2] IB/iser: reject a remote invalidation of an unregistered direction
Date: Wed, 19 Aug 2026 10:08:04 +0900
Message-ID: <20260819010804.641772-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A write command whose data is sent entirely as immediate data is not
registered.  iser_reg_mem_fastreg() takes the DMA key path and leaves
rdma_reg[ISER_DIR_OUT].desc at NULL, while iser_dma_map_task_data() has
already set dir[ISER_DIR_OUT].

iser_check_remote_inv() looks at dir[] alone and hands the descriptor to
iser_inv_desc(), which reads desc->sig_protected.  A target that answers
such a command with IB_WR_SEND_WITH_INV faults the initiator.
Leaving those commands unregistered is deliberate.

The same function already terminates the connection when a target sends
a remote invalidation the initiator did not ask for.  A target that
invalidates a direction that was never registered is in the same class,
so give it the same answer.

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
  CPU: 0 UID: 0 PID: 40 Comm: kworker/u8:2 Not tainted 7.2.0-rc5-ISERHOST-gf5098b6bae76-dirty #3 PREEMPT(lazy) 
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: rxe_wq do_work
  RIP: 0010:iser_task_rsp+0x6d6/0xec0
  Code: 48 c1 ea 03 80 3c 02 00 0f 85 ba 06 00 00 48 8b 9b 78 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 76 06 00 00 80 7b 20 00 0f 84 3d 04
  RSP: 0018:ffff88811b008db8 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000001848
  RDX: 0000000000000004 RSI: 1ffff11021587b12 RDI: 0000000000000020
  RBP: ffff88810adc1ae4 R08: ffff888109b7f860 R09: ffffffff90a922c0
  R10: ffff88810adc1a1c R11: 000000000000003c R12: ffff888109b7f800
  R13: ffff88810adc1acc R14: ffff888109b7f820 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88818a676000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000005afe2b CR3: 000000010af23005 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   __ib_process_cq+0xe1/0x390
   ib_poll_handler+0x6e/0x200
   irq_poll_softirq+0x1df/0x480
   ? clockevents_program_event+0x2ba/0x860
   ? __pfx_irq_poll_softirq+0x10/0x10
   handle_softirqs+0x18e/0x590
   ? __pfx_handle_softirqs+0x10/0x10
   ? __hrtimer_rearm_deferred+0x156/0x450
   do_softirq+0x3b/0x60
   </IRQ>
   <TASK>
   __local_bh_enable_ip+0x61/0x70
   __alloc_skb+0x732/0x890
   ? _raw_spin_lock_irqsave+0x85/0xe0
   ? __pfx___alloc_skb+0x10/0x10
   ? _raw_read_unlock_irqrestore+0x16/0x50
   rxe_init_packet+0x16b/0x4f0
   prepare_ack_packet+0xb8/0x830
   rxe_receiver+0x499/0x9980
   ? __pfx_rxe_receiver+0x10/0x10
   ? rxe_completer+0x29e5/0x38c0
   ? hrtimer_start_range_ns_common+0x75f/0x1730
   ? hrtimer_start_range_ns+0xa6/0x2c0
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? __pfx_rxe_receiver+0x10/0x10
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
  Modules linked in:
  ---[ end trace 0000000000000000 ]---

Fixes: 59caaed7a72a ("IB/iser: Support the remote invalidation exception")
Cc: stable@vger.kernel.org
Suggested-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Changes since v1:
 - reject instead of skipping (Max Gurtovoy; the AI review of v1 asked
   the same thing).  v1 let a bogus remote invalidation through
   silently; this reuses the -EPROTO path the function already has for
   an unexpected invalidation.
 - drop the claim about bidirectional commands, which was wrong:
   ISCSI_FLAG_CMD_READ and ISCSI_FLAG_CMD_WRITE are set in one if/else
   in libiscsi.c, so they cannot both be set.

v1: https://lore.kernel.org/linux-rdma/20260814054712.260495-1-yhlee@isslab.korea.ac.kr/

Measured over rxe with KASAN against an isert target that sends
SEND_WITH_INV for a command it never registered, armed only after the
disk is up so the window is open when it arrives: the fault appeared in
5 of 5 runs unpatched and in none of 5 with this patch.  A conforming
target is unaffected over 5 runs each way; the new path is not reached
at all there.

Against the hostile target the two forms differ in one measured way: v1
completed 6 to 21 small writes before the session collapsed, this one
completes none.  Neither approaches the 20000 the workload asks for.  No
reconnect loop was observed with either form - the session came back up
zero times in ten runs.

 drivers/infiniband/ulp/iser/iser_initiator.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 12a2d12fef070..7ea6888b479cf 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -598,11 +598,8 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 		iser_dbg("conn %p: remote invalidation for rkey %#x\n",
 			 iser_conn, rkey);
 
-		if (unlikely(!iser_conn->snd_w_inv)) {
-			iser_err("conn %p: unexpected remote invalidation, terminating connection\n",
-				 iser_conn);
-			return -EPROTO;
-		}
+		if (unlikely(!iser_conn->snd_w_inv))
+			goto bad_inv;
 
 		task = iscsi_itt_to_ctask(iser_conn->iscsi_conn, hdr->itt);
 		if (likely(task)) {
@@ -611,12 +608,16 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 
 			if (iser_task->dir[ISER_DIR_IN]) {
 				desc = iser_task->rdma_reg[ISER_DIR_IN].desc;
+				if (unlikely(!desc))
+					goto bad_inv;
 				if (unlikely(iser_inv_desc(desc, rkey)))
 					return -EINVAL;
 			}
 
 			if (iser_task->dir[ISER_DIR_OUT]) {
 				desc = iser_task->rdma_reg[ISER_DIR_OUT].desc;
+				if (unlikely(!desc))
+					goto bad_inv;
 				if (unlikely(iser_inv_desc(desc, rkey)))
 					return -EINVAL;
 			}
@@ -627,6 +628,11 @@ static int iser_check_remote_inv(struct iser_conn *iser_conn, struct ib_wc *wc,
 	}
 
 	return 0;
+
+bad_inv:
+	iser_err("conn %p: unexpected remote invalidation, terminating connection\n",
+		 iser_conn);
+	return -EPROTO;
 }
 
 
-- 
2.43.0

