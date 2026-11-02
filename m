Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600213;
	b=uXezMomMCDqDum0s06ZHQUE+EFRg52GpTAJ/0Reqj6J2Z/Ol12+g8bmqJddc+7PwoolT
	 TKE636FqCAmWbVgxVbR46nbOGHxtKXLTqL+aymS4ZmgYol9SRfUSFhw/ehhpSAQGnMUEv
	 piIu7XyhBXb3QNvbmOS4X004l4Y9qIsQgLdYZN9gQBA5dFo8EhU+OTsIyu0w2YROi+0hd
	 UW3YepDj8QKXCBfqfjDA2+/tywMpkUatuTV74n9ZiynGXwxEPKWk1NBrUtUGS/sX9uPTs
	 RnaJCoyj8Oh7W03EBIdi1nP6ktA6COekXBB0LxqXm/8sq6Fyg2TmD7sN03MUmwEaF0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lb2kJheomVmYz2wSo6iR+pYm0QqTiB9gTDVpHHBWxiY=;
	b=hKrlq+0/myaQCrEIK14bLyVNL9RcBtJO/Je5tnBxFvadN2cMTFZThBmyvR4otdnipS2c
	 4hLbnF9PhNPik3z8JfsWYNQhc3keCNp2vZz5PBijzg1eCrz8CV1dwYY1soAm+pfQ9ZUNO
	 HfDQuh/Ai1Mix0DvFvASPdC499JHh67ibdSVTXxBP54tGThVMeCQKLVoIb4G6qsoFHPFa
	 NFIl1BPR/W4hm6b0XvuJ34t8FWGv0Ot3xmCXqVZWUjU7RkL3+XfiiChWaEzj/C+NhTl0m
	 IdQ9T77/IvW1i8lEQ+jgvBnTfwZ78mz1MPy8vmElL41YGMG6QKKOp8YoWdn/ubrZ+uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e7lHhy2p;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D94606A333
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24D94606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e7lHhy2p
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a594d313a3so1480949b3a.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600211; x=1794205011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lb2kJheomVmYz2wSo6iR+pYm0QqTiB9gTDVpHHBWxiY=;
        b=e7lHhy2pwsV/suNqTsLmiGHI4aKK9XU10ChfG1g0+hlOPkSrMeba0Ix7ZrE8Idj7VY
         xJLet9Ak1J7clKBfMJP0qe2aM0CGAzxMtv5DhiJExha0jbYvjYB668F3GRkKHXuPt67a
         5JXxchhR9n8VbvDkqXA+abHtLdX9qhQkwnh6qKIjK8ZfEGPTjK5XVQdl5C3bOhFKla/t
         cvzD2CYal3OMxuw8SFCI07gUr77cajZ9vsuw7wNPwkJ2aS+XP0JcmuBc1SF9KZozI4O2
         1b7Ybst3AI7iNuTWngJ2+cNF0oADPs3VaCLhw/W/9QQpXwNN5GN3RYqMc6InCXPktXl0
         RCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600211; x=1794205011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lb2kJheomVmYz2wSo6iR+pYm0QqTiB9gTDVpHHBWxiY=;
        b=kbVBe7umhmxv33iTM9vN86VgH1lnd+31vXXBtvnqHTJaljTEpSEA9tyFkLTvIJ6NJO
         LYnwZ+nZs6FP7LsCzoPPg96P/GmgvbSy8lU0DWfIlYch9TlYugw4dQROIXqDw8xW6kGi
         xlcAI1a+M28QUVVHf6nBiF2sok357AHlYTDmEYuoqfAGGLX1NQhxpJEsbMrcCn0e/2TL
         iTvRW3gsS6m5IaCN4Zhpb9+/oGtlKX2iJFqLJmMbzxdoXls9L9oDEV6t+RBZyJm1d4gY
         4Oemf8kBgRZXibRYaNimwYdZStHiRZDham0ZwBkWoEAYWL+5kiK8QUz23XCMeWhTyDRU
         W09A==
X-Forwarded-Encrypted: i=1; AKwUvBywjK9vkTF62I5GgWa9zR9qnH7TOGdasw6SjqmDqFk2Nh/in09zBu76VcDFjHywMEsJ1wXbkTuMLvJa@vger.kernel.org
X-Gm-Message-State: AFq9FYLwJHYi385qP+ibUJhXLQvZzXgKlrD+guHvm+sm4Zi4EhlhzuCw
	gKCNzn0JG1eJHrvSBkNmN5T6eW1d1a8gdplpJRapFm+Xc9cYtHXp0/FO4Mit+IH4ICU=
X-Gm-Gg: AYBFou1z9DSdOBoULC5huuU4lVprcxEIoPqzQ8Lb1JiCmh3HseeHp/51sQkiSqNi+9z
	qen0VIMNOHhrOpMTVUTSv+LOgpEYujyIfHeDpwOOsH2OourbAc71JPUKbqPn79tQr2JI/CL4PHJ
	SZznDCf21HXQAJVGMcbups6jpbjHEwCBadsIZ9D2haandA/373omsw0G3e7yJizUrwUdArTjrkO
	/byLCWFxNe57Sg5FAUPBp2IpWBe6jgJPk8XiV1Bc/0hrgqRrArioBis/LJIfSHbT+e/a+4xCiZI
	970x1L9SzcIyoLv4O7+EPFINL1Aow4IPbtoinJhM1kCjqVAWmwTpntSLtYksMZINIlPk3jkJAb5
	5ImV+lUIRwjADUmQZ3vBDKj11uhKabB4ER3wAJ0Ha2582XXhGzsyXbcASK0ZH85dEyDSQtHFoTC
	xYDRkHe9paZlJX+sVNASrhjVEqUfiJGM0E9Sdsm+7UpzoN6fWCINtDUn3Pn3iHEZ9yvX1yLERm9
	ZVNGnuaxB4hW/+irP/a1GMBqaJ4pKxpCqu7x7FyDVEsBA9RYxpIHt7tSx3h8lWLIbzBtJ0tnMkX
	ddW/G4mtstzh6USGzcSOZfJKS7/RJbKMNkw69l0oYwWwmJlABcyRKi7kL0RoVpph1RfRNazw6Rs
	+7n6IJMdwGjM9zlihWpZZ+eTr2AOCOO6usuJYQA==
X-Received: by 2002:a05:6a00:7443:b0:89f:53b8:9751 with SMTP id d2e1a72fcca58-8a9bd2f072amr6725379b3a.16.1793600211453;
        Sun, 01 Nov 2026 22:16:51 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad9d03be0sm1509071b3a.27.2026.11.01.22.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:16:51 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] IB/isert: do not publish connections being released on a second list
Date: Mon,  2 Nov 2026 15:16:06 +0900
Message-ID: <20261102061608.617186-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
References: <20261102061608.617186-1-yhlee@isslab.korea.ac.kr>
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

isert_free_np() moves the connections left on isert_np->pending and
isert_np->accepted onto a stack-local list, drops isert_np->mutex and
releases them from there.  isert_conn->node is then linked into that
local list instead of being empty, which is the test
isert_handle_unbound_conn() uses to decide whether a connection still
needs cleaning up.  It runs from the RDMA CM handler, which is not
serialised against isert_free_np(), so it unlinks the connection from a
list it does not own and queues a second release for it.

Take the connections off isert_np one at a time, so that
isert_conn->node is empty once isert_np->mutex is dropped.  The release
keeps running with no mutex held, which commit 691b0480933f ("IB/isert:
Fix dead lock in ib_isert") needs: releasing a connection destroys its
cm_id, and rdma_destroy_id() waits for the handler_mutex that the CM
handler holds while it waits for isert_np->mutex.

Reproduced with a test-only delay added inside isert_free_np()'s release
loop: 36 reports in each of three unpatched runs, none in three patched
runs.

  BUG: KASAN: slab-use-after-free in isert_free_np+0x6a4/0xab0
  Read of size 8 at addr ffff888109249040 by task rmdir/193

  CPU: 1 UID: 0 PID: 193 Comm: rmdir Not tainted 7.3.0-BASET-13248-g103b309e2033 #15 PREEMPT(full)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? isert_free_np+0x6a4/0xab0
   kasan_report+0xce/0x100
   ? isert_free_np+0x6a4/0xab0
   isert_free_np+0x6a4/0xab0
   ? __pfx_isert_free_np+0x10/0x10
   iscsit_del_np+0x163/0x340
   iscsit_tpg_del_network_portal+0x3c3/0x530
   ? mutex_unlock+0x7b/0xd0
   lio_target_call_delnpfromtpg+0x40/0x60
   config_item_cleanup+0x115/0x190
   configfs_rmdir+0x7c7/0x9f0
   ? __pfx_configfs_rmdir+0x10/0x10
   vfs_rmdir+0x291/0x770
   ? lookup_one_qstr_excl+0x1a/0x1d0
   filename_rmdir+0x35d/0x4f0
   ? __pfx_filename_rmdir+0x10/0x10
   ? kasan_save_track+0x14/0x30
   ? __kasan_slab_alloc+0x6e/0x70
   ? strncpy_from_user+0x2b/0x1c0
   __x64_sys_rmdir+0x41/0x60
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 10:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_cache_noprof+0x148/0x360
   isert_cma_handler+0x1e3/0x2840
   cma_cm_event_handler+0x3e/0x240
   cma_ib_req_handler+0x17d9/0x4480
   cm_process_work+0x41/0x330
   cm_work_handler+0x5727/0xc160
   process_one_work+0x697/0x1060
   worker_thread+0x45b/0xd10
   kthread+0x2c8/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 43:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x121/0x390
   process_one_work+0x697/0x1060
   worker_thread+0x45b/0xd10
   kthread+0x2c8/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  Last potentially related work creation:
   kasan_save_stack+0x33/0x60
   kasan_record_aux_stack+0x8c/0xa0
   __queue_work+0x7a1/0x15e0
   queue_work_on+0x5d/0x70
   isert_disconnected_handler.isra.0+0x20b/0x380
   isert_cma_handler+0xd71/0x2840
   cma_cm_event_handler+0x3e/0x240
   cma_ib_handler+0x190/0x750
   cm_process_work+0x41/0x330
   cm_work_handler+0x582b/0xc160
   process_one_work+0x697/0x1060
   worker_thread+0x45b/0xd10
   kthread+0x2c8/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30

  The buggy address belongs to the object at ffff888109248000
   which belongs to the cache kmalloc-8k of size 8192
  The buggy address is located 4160 bytes inside of
   freed 8192-byte region [ffff888109248000, ffff88810924a000)

Fixes: 691b0480933f ("IB/isert: Fix dead lock in ib_isert")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 54 ++++++++++++++-----------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index efa8d7b7844c97..5371bba71ba3cb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2479,12 +2479,29 @@ isert_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 	return 0;
 }
 
+static struct isert_conn *
+isert_np_take_conn(struct isert_np *isert_np)
+{
+	struct isert_conn *isert_conn;
+
+	lockdep_assert_held(&isert_np->mutex);
+
+	isert_conn = list_first_entry_or_null(&isert_np->pending,
+					      struct isert_conn, node);
+	if (!isert_conn)
+		isert_conn = list_first_entry_or_null(&isert_np->accepted,
+						      struct isert_conn, node);
+	if (isert_conn)
+		list_del_init(&isert_conn->node);
+
+	return isert_conn;
+}
+
 static void
 isert_free_np(struct iscsi_np *np)
 {
 	struct isert_np *isert_np = np->np_context;
-	struct isert_conn *isert_conn, *n;
-	LIST_HEAD(drop_conn_list);
+	struct isert_conn *isert_conn;
 
 	if (isert_np->cm_id)
 		rdma_destroy_id(isert_np->cm_id);
@@ -2497,31 +2514,22 @@ isert_free_np(struct iscsi_np *np)
 	 * up in accepted and pending lists.
 	 */
 	mutex_lock(&isert_np->mutex);
-	if (!list_empty(&isert_np->pending)) {
+	if (!list_empty(&isert_np->pending))
 		isert_info("Still have isert pending connections\n");
-		list_for_each_entry_safe(isert_conn, n,
-					 &isert_np->pending,
-					 node) {
-			isert_info("cleaning isert_conn %p state (%d)\n",
-				   isert_conn, isert_conn->state);
-			list_move_tail(&isert_conn->node, &drop_conn_list);
-		}
-	}
-
-	if (!list_empty(&isert_np->accepted)) {
+	if (!list_empty(&isert_np->accepted))
 		isert_info("Still have isert accepted connections\n");
-		list_for_each_entry_safe(isert_conn, n,
-					 &isert_np->accepted,
-					 node) {
-			isert_info("cleaning isert_conn %p state (%d)\n",
-				   isert_conn, isert_conn->state);
-			list_move_tail(&isert_conn->node, &drop_conn_list);
-		}
-	}
 	mutex_unlock(&isert_np->mutex);
 
-	list_for_each_entry_safe(isert_conn, n, &drop_conn_list, node) {
-		list_del_init(&isert_conn->node);
+	for (;;) {
+		mutex_lock(&isert_np->mutex);
+		isert_conn = isert_np_take_conn(isert_np);
+		mutex_unlock(&isert_np->mutex);
+
+		if (!isert_conn)
+			break;
+
+		isert_info("cleaning isert_conn %p state (%d)\n",
+			   isert_conn, isert_conn->state);
 		isert_connect_release(isert_conn);
 	}
 
-- 
2.43.0

