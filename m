Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1C1349CD7;
	Mon, 27 Jul 2026 02:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785118445; cv=none; b=flfc1apoBPkVciQZyfC8MEJhqHhtZFjiQTVpGIp2LSQUtrla39sotI9UQFk87njRIuJN1pfHqe+5YIVOzmOvvJ4RBjNrNfXVlvHdMdjU99DBAXlE2fNJF4cdPExiBDg8HdDdPUMSB04PuqbxGV0fmV13mrJCfR113MJArijaEo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785118445; c=relaxed/simple;
	bh=UcyWkhB1BwqyVGewzPWhmauGmdL0yqumW3alZv/j3zQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZOlZAZT5n5sscHxatYHHADZk7tqG/rl61G8qOgXHlBD6LnsAQOHM3G/0YQCQUaEPBW8IGFRKYsAJD09US2LKwuiW9KcodBI9Wv/pQdJDTPRuIAu4rPVrE2BAzYZ/DBSqHubpbMUoSQmsoSDwGUFcPul4Kgm0WhgHNUJphbmZkvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnaWqrFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnaWqrFh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C70D1C2BCB3;
	Mon, 27 Jul 2026 02:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785118444;
	bh=UcyWkhB1BwqyVGewzPWhmauGmdL0yqumW3alZv/j3zQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=GnaWqrFhb6gX+1bSws1JWfWjaX46zMpbLsFcN2PGHSmi4JpfoB3VjO5HnzboxsKBw
	 cKIZIujR5JT/NYxS3dDgqwYNShQiAlpdnFqmrNAvPS5n79TXMUF26BgdV2JJYk3P69
	 vfQyNpzfdclXQOv1dBeAlFyAGgsOnrJEWa44wZojaBNw5N2FapObjDEbGvxC/6fW1L
	 LfT7jGbW/2FsWOV+qo9nFtrKMAlMpXns6wuwZxK8QgocfulxCJpOACwFOa3GOIko6f
	 6pmYsNawv8qo/cgYqqBNZYlRojvTCbLTWWledxqkYwGlTvPGx3qgBxodCKRehWWm9X
	 qgkjX3e5l5SzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3998C53200;
	Mon, 27 Jul 2026 02:14:04 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sun, 26 Jul 2026 21:14:04 -0500
Subject: [PATCH net] net/smc: drain the rx tasklet before detaching the
 ghost sndbuf
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260726-b4-disp-a135b4e5-v1-1-705aaec79986@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ5EMBCA4VeROe8kVS1rX0UcVAfjYKWDSMS7K
 47f4f8PEApMAr/kgEAbC/+niPSTQDs0U0/IPhq00rkqdI7OoGeZsUkz6wxZLI21hXFeldkXYjY
 H6nh/llX9WlY3UrvcHzjPC8SRSId0AAAA
X-Change-ID: 20260726-b4-disp-a135b4e5-945574bd0938
To: Dust Li <dust.li@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785118443; l=4217;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=wYjklXpHMVg2rxAnVlYLWc6qQreV8jc7yrCCSeUtrwM=;
 b=1GEGA8s3WVGo60Q4bcloSNg1Gju64r30GQhhMxdGRBVQOQGm5bUWZLlmQF5+7v/EwNEdFwmyY
 3MQ0zZej/HwDEyRt3LXmJTVZTCeaahQGJu4AWQ4SoAroZrHNEg2RKd0
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

On the SMC-D DMB-nocopy path smcd_buf_detach() frees conn->sndbuf_desc
while the receive tasklet can still be running: both teardown sites free
first and drain afterwards. A tasklet already past the conn->killed check
then dereferences the freed buffer in smc_cdc_msg_recv_action(), which
reaches the same field again through smc_tx_prepared_sends().

Drain the tasklet before the detach at both sites, mirroring rmb_desc,
which smc_buf_unuse() only releases after the drain.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Found with KASAN on an SMC-D loopback rig (CONFIG_SMC_LO, x86_64).

The teardown is driven through smc_conn_kill() by arming abort_work from a debug
module parameter: on SMC-D nothing in the receive path queues that work, while on
SMC-R smc_cdc_msg_validate() queues it for an out-of-range peer seqno. Everything
after the abort is the unmodified path. A second parameter holds the receive tasklet
just past the conn->killed check, so the free lands mid-run.

  arm         ordering           abort armed   result
  vulnerable  detach then drain  yes           KASAN slab-use-after-free
  control     detach then drain  no            clean
  patched     drain then detach  yes           clean

Same module, same boot, same trigger, same delay; only the ordering differs.

  BUG: KASAN: slab-use-after-free in smc_cdc_msg_recv_action+0x1ed9/0x1f20 [smc]
  Read of size 4 at addr ffff88810f6c9720 by task kworker/3:1/147
  Workqueue: smc_close_wq smc_conn_abort_work [smc]
   <IRQ>
    smc_cdc_msg_recv_action+0x1ed9/0x1f20 [smc]
    smcd_cdc_rx_tsklet+0x1f2/0x2f0 [smc]
    tasklet_action_common+0x2fd/0x850
    handle_softirqs+0x18c/0x4f0
    do_softirq+0x3a/0x60
   </IRQ>
   <TASK>
    __local_bh_enable_ip+0x5d/0x60
    smc_cdc_get_slot_and_msg_send+0x253/0x680 [smc]
    smc_conn_kill+0xa8/0x4d0 [smc]
    smc_conn_abort_work+0x34/0x90 [smc]
   </TASK>

  Allocated by task 70:
    smcd_buf_attach+0xbd/0x2a0 [smc]
    smc_listen_work+0x2499/0x49a0 [smc]

  Freed by task 44:
    kfree+0x135/0x390
    smc_conn_kill+0x3ab/0x4d0 [smc]
    smc_conn_abort_work+0x34/0x90 [smc]

  The buggy address belongs to the object at ffff88810f6c9700
   which belongs to the cache kmalloc-128 of size 128
  The buggy address is located 32 bytes inside of
   freed 128-byte region [ffff88810f6c9700, ffff88810f6c9780)

The read is conn->sndbuf_desc->len.

A plain close() does not get there: smc_close_active() always moves the socket to
SMC_PEERCLOSEWAIT1, so the free happens in smc_close_passive_work() after the peer's
close CDC -- the same event that stops feeding the tasklet. About 18000 such teardowns
produced nothing. The ordering is wrong either way, and smc_conn_kill() has no such
coupling.

Logs on request.
---
 net/smc/smc_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index cf6b620fef05..da64e7a6bd73 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1270,9 +1270,9 @@ void smc_conn_free(struct smc_connection *conn)
 	if (lgr->is_smcd) {
 		if (!list_empty(&lgr->list))
 			smc_ism_unset_conn(conn);
+		tasklet_kill(&conn->rx_tsklet);
 		if (smc_ism_support_dmb_nocopy(lgr->smcd))
 			smcd_buf_detach(conn);
-		tasklet_kill(&conn->rx_tsklet);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 		if (current_work() != &conn->abort_work)
@@ -1525,12 +1525,12 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
 	smc_sk_wake_ups(smc);
 	if (conn->lgr->is_smcd) {
 		smc_ism_unset_conn(conn);
-		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
-			smcd_buf_detach(conn);
 		if (soft)
 			tasklet_kill(&conn->rx_tsklet);
 		else
 			tasklet_unlock_wait(&conn->rx_tsklet);
+		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
+			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 	}

---
base-commit: 4235cb24ec1e8e96843f3671ba4da2a6ccca2c7b
change-id: 20260726-b4-disp-a135b4e5-945574bd0938

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


