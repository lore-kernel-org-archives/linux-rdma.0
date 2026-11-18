Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036516;
	b=bgEtJHPnYEK7MpZTrNhKkZmzE5fmnQZU3QeKok+XWkxwZOlOIaxJ7SLpoJtDhbYVBvE+
	 a5itkUvumn0x7g92DkE5h9KsTv87RySDRp4xyD322G5hHcWwxxb0KZb2l84Hn9GyHUn11
	 vbXtDKUtnSIgIUD/gse5iFPJR0244w9VG9hMDVVLQsbJ9T/s8DWm35KZb5FwXFK0I0rdx
	 9C9BV6C90wngOK6EWsTYTuWUeSgvy8DS6WkIhGv+30FXjaW+a15LDTfpFM7YwzdlCln0G
	 Y6H15fYxgBrfQdTkDxMPXpIHuNNxkxak7QAupHoSmdp1KZPo22NaDtv4YcpspY596kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BSuC+HsDeI4DjAKrMY9irkFyUndCsn3ziiIi05dtHP8=;
	b=N1TEl54PcOmbfZhPw2JQGQZkM4HD7VqJLbfleEnHgkmMFqBWq0BkzOMRdvMtEOld8Rbc
	 j9Jx9EgBnBoGKhOOvnFo00KvpCeXQRTD69gEgngBom2QGG6X6KsuscGuLGh3Y3u9J7FQt
	 vGvvk0Pfx6JFw8MJyw5MwnfPXuxIpwLhMDSPgH1rsScg7ChMsJd5eoo6P/9fsWjVCIYnj
	 ++B2kAkWv9q6egpnzNdiXcclsY3LXo2pf+NrP9H0iF0pSuJe/WGSz6W5YpEWcRs5Qq+Zv
	 O+2Qgx8UMrUFyQ6SgT+ddERFfzmg2UhFRO8cSAMo8mLTv325kdTXDuq0ejZykGRu23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=avEn7jgH;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC460A2603
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 21:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FDC460A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=avEn7jgH
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cddc597d062so947155a12.3
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036515; x=1795641315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BSuC+HsDeI4DjAKrMY9irkFyUndCsn3ziiIi05dtHP8=;
        b=avEn7jgHBuxn6CrCpkemgDCbRyDVvVH4Gd0nB14vjGQFfD9u3aMnRGcNUbnpO/LaOA
         0BPxcLaTU8wlVevVO+6zV5ZKcyXCCMrHklKW9TbwhwB5XzwukjDWFe6Gp6RdFAqniBCD
         mWo8aHtL7o2IHWRwSX4Dif+QmnwgOkJKYbE4sLgvl2aMGaBNKxJMujtHpl0lgMHwCbAa
         c6gvVJuR1bCT5/N9TVfbGkMf86oIEW+MTESYtAmEYIUOg+BGtz3dZk81Q1grc/p1qmov
         3WtAt50mFl9pvw4ypdgQ6cLTJF85vj/JZzULF2p2/c4C/7qpZCkWiNjGCJ+HyKf+5/1G
         GP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036515; x=1795641315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BSuC+HsDeI4DjAKrMY9irkFyUndCsn3ziiIi05dtHP8=;
        b=aYNlNryGGRzttRKTz4TSfn9kJne+WDhF40wNmrT/bWVAKpMyCuU2d5piPt2kgKVMYM
         x/QLHrHnISigHE+UxqCQqdeMcleYeMkVZ+hpAoWRay292KHMnmGgHeNe2L6Yi3NboFkM
         D5FlDrRMcdDz421QOu0Co22t45TpUOD7jEjOFtyg9lzbbatMXNPBCTOaYE4G5KI1X5cb
         NsRhiFd1c8YyMvu0obBcnAea80TWkrfxAQi0C94LHjl06M/EL9/opziiNVQxuNgIBRt3
         e+6fE+0RUt9VjJqm7INN79lbSfw7pzvm7Wsy6JMQqxCCUQ1ZP0bqVpnZW+nLRf+lhhx1
         k13g==
X-Gm-Message-State: APuU4Z+8WJqTTG1s2KUuhEjeODgSEy5HQgD0XJrY/brObcOTTjYNqF2Q
	SWRz4lBNpEyn9Ykuo2oVgK61y7ikJglEgDVlS3Oy/wPaxnlascLbGL3LaBeURuPN1Bc=
X-Gm-Gg: AZFdTZdxSjuGfJlwCiBZIGEQp3wyvjVV1sxlpO/hR6dl3HrTJHnhD1ygHe+FFY76o6c
	Dw3geNQjRPs9dE6wk8dvKVvf7J+n3Jnf0b1F1vlNqA1GTteGNKSOBIWzYBDPxre00NzdgwOseIo
	LgO06BdtZt/FlwsrBk8WQ9RsSyrJv1GxPNH44IJFASx+lWwkSYGtkEdBS/wFohhOFUwxZzAc0QQ
	N47Rtu/xi0YCbjyMPXnzhTqZUV3kO0bGr50MZIHNkdo4ytp7k5xlHXe0BZDa1lSpXsxi92sslYp
	XBTMG2O0DyV/vUMEXVxHZTylCRGorpyJOx1piJB7m05gK5tLCcljnWVL7Gtc0K2UvIbkId/qvLX
	XHbXZCRk0fFmmroejDPM1cy0Zzp/GORBaFTTLXH43N+EIGU55UEmSsnDygXTHazjLGj/cKLOdKG
	x3o3UnSgsCEHyCYa7VCEQymVSea4n4CQ5CecOtXXmcnhdTZjF1BezjL6mMc9HSvR05DqSKNDkAm
	+RU9m2LkTp/cSXCeC1e/igBPJ458oHSYsFr7eD3XC+aYzyq3aoZd9bueRlWvFmESr+kYWdeoxDX
	YTuF6pqgeJ1aamS8tpK2HcHnNO06k/ozAPsawi1Zmd0LP3zxuz3keq3ra3dWgxX4cx6mM3056ou
	Rl8K91kF1RDE0Vdk9oixt6KeJ5aHIKlr+DtV5pg==
X-Received: by 2002:a17:90b:224d:b0:3ac:a204:aa27 with SMTP id 98e67ed59e1d1-3b3d08551a3mr3978146a91.66.1795036514679;
        Wed, 18 Nov 2026 13:15:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d5689adasm2611719a91.1.2026.11.18.13.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:15:14 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] scsi: target: iscsi: retire an unsolicited NOP-In only once
Date: Thu, 19 Nov 2026 06:15:00 +0900
Message-ID: <20261118211503.2526705-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
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

iscsit_process_nop_out() answers a NOP-Out carrying a TTT by looking the
command up with iscsit_find_cmd_from_ttt(), which compares the tag and
nothing else and leaves the command on conn_cmd_list, while
iscsit_add_cmd_to_immediate_queue() allocates a fresh queue entry each
time.  Two NOP-Outs with the same TTT therefore queue the same command
twice, and the tx thread's ISTATE_REMOVE handling releases it twice.

For the NOP-In itself that second release is quiet: the command is a slice
of the session's preallocated tag pool rather than a slab object, and the
pointers iscsit_release_cmd() frees are all NULL for it.  What it can do is
land on whichever command has taken that tag in the meantime.

The same lookup also hands out a Reject, which the core allocates with
targ_xfer_tag 0 and leaves on conn_cmd_list until it is sent, so a NOP-Out
with a reserved ITT and TTT 0 is given the Reject instead of a NOP-In.
That one does reach the slab, through the header the Reject kept in
cmd->buf_ptr, and an initiator gets there one PDU after login on plain
iscsi_tcp: a Data-Out over MaxXmitDataSegmentLength is rejected without
its payload being dumped, so the receive loop reads the next 48 bytes on
the wire as a BHS.  Twenty such pairs in one write give 19 or 20 KASAN
reports, in 5 boots out of 5:

  [   10.546883] ==================================================================
  [   10.546895] BUG: KASAN: double-free in iscsit_release_cmd+0xff/0x390
  [   10.546957] Free of addr ffff88800e5d1680 by task iscsi_ttx/140
  [   10.546964]
  [   10.546976] CPU: 0 UID: 0 PID: 140 Comm: iscsi_ttx Not tainted 7.4.0-rc2-RJ9TA-00716-g23c62304dde2 #1 PREEMPT(lazy)
  [   10.546989] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [   10.546997] Call Trace:
  [   10.547002]  <TASK>
  [   10.547008]  dump_stack_lvl+0x66/0xa0
  [   10.547023]  print_report+0xd0/0x630
  [   10.547040]  ? iscsit_release_cmd+0xff/0x390
  [   10.547049]  ? iscsit_release_cmd+0xff/0x390
  [   10.547057]  ? __virt_addr_valid+0x209/0x3f0
  [   10.547071]  ? iscsit_release_cmd+0xff/0x390
  [   10.547079]  ? iscsit_release_cmd+0xff/0x390
  [   10.547087]  kasan_report_invalid_free+0xb8/0xe0
  [   10.547100]  ? iscsit_release_cmd+0xff/0x390
  [   10.547110]  ? iscsit_release_cmd+0xff/0x390
  [   10.547119]  check_slab_allocation+0xd9/0x100
  [   10.547131]  kfree+0x163/0x510
  [   10.547147]  iscsit_release_cmd+0xff/0x390
  [   10.547156]  iscsit_immediate_queue+0x17a/0xa90
  [   10.547167]  ? kmem_cache_free+0x1fe/0x500
  [   10.547176]  ? iscsit_get_cmd_from_immediate_queue+0x189/0x210
  [   10.547187]  iscsi_target_tx_thread+0x34d/0x700
  [   10.547201]  ? __kthread_parkme+0x9f/0x1f0
  [   10.547213]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [   10.547227]  ? __pfx_autoremove_wake_function+0x10/0x10
  [   10.547241]  ? __kthread_parkme+0xac/0x1f0
  [   10.547251]  ? __pfx_iscsi_target_tx_thread+0x10/0x10
  [   10.547263]  kthread+0x300/0x400
  [   10.547274]  ? __pfx_kthread+0x10/0x10
  [   10.547285]  ret_from_fork+0x52e/0x780
  [   10.547297]  ? __pfx_ret_from_fork+0x10/0x10
  [   10.547307]  ? __switch_to+0x572/0xdd0
  [   10.547321]  ? __pfx_kthread+0x10/0x10
  [   10.547332]  ret_from_fork_asm+0x1a/0x30
  [   10.547352]  </TASK>
  [   10.547357]
  [   10.547359] Allocated by task 141:
  [   10.547366]  kasan_save_stack+0x33/0x60
  [   10.547379]  kasan_save_track+0x14/0x30
  [   10.547388]  __kasan_kmalloc+0x8f/0xa0
  [   10.547397]  __kmalloc_node_track_caller_noprof+0x26d/0x680
  [   10.547409]  kmemdup_noprof+0x20/0x50
  [   10.550518]  iscsit_add_reject+0x99/0x2b0
  [   10.550532]  iscsit_check_dataout_hdr+0x26d/0x360
  [   10.550542]  iscsit_get_rx_pdu+0x5da/0x35d0
  [   10.550552]  iscsi_target_rx_thread+0x132/0x2f0
  [   10.550563]  kthread+0x300/0x400
  [   10.550573]  ret_from_fork+0x52e/0x780
  [   10.550582]  ret_from_fork_asm+0x1a/0x30
  [   10.550593]
  [   10.550596] Freed by task 140:
  [   10.550603]  kasan_save_stack+0x33/0x60
  [   10.550615]  kasan_save_track+0x14/0x30
  [   10.550623]  kasan_save_free_info+0x3b/0x60
  [   10.550631]  __kasan_slab_free+0x43/0x70
  [   10.550640]  kfree+0x2e5/0x510
  [   10.550651]  iscsit_release_cmd+0xff/0x390
  [   10.550659]  iscsit_immediate_queue+0x17a/0xa90
  [   10.550669]  iscsi_target_tx_thread+0x34d/0x700
  [   10.550679]  kthread+0x300/0x400
  [   10.550688]  ret_from_fork+0x52e/0x780
  [   10.550696]  ret_from_fork_asm+0x1a/0x30
  [   10.550706]
  [   10.550710] The buggy address belongs to the object at ffff88800e5d1680
  [   10.550710]  which belongs to the cache kmalloc-64 of size 64
  [   10.550719] The buggy address is located 0 bytes inside of
  [   10.550719]  64-byte region [ffff88800e5d1680, ffff88800e5d16c0)
  [   10.550729]
  [   10.550734] The buggy address belongs to the physical page:
  [   10.550743] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xe5d1
  [   10.550753] flags: 0x100000000000000(node=0|zone=1)
  [   10.550763] page_type: f5(slab)
  [   10.550776] raw: 0100000000000000 ffff888008c428c0 dead000000000100 dead000000000122
  [   10.550785] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
  [   10.550790] page dumped because: kasan: bad access detected
  [   10.550794]
  [   10.550796] Memory state around the buggy address:
  [   10.550801]  ffff88800e5d1580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
  [   10.550808]  ffff88800e5d1600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
  [   10.550813] >ffff88800e5d1680: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550818]                    ^
  [   10.550823]  ffff88800e5d1700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550829]  ffff88800e5d1780: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  [   10.550834] ==================================================================

Give the NOP-Out path its own lookup, which matches the opcode as well as
the tag, takes the command under conn->cmd_lock - the lock the tx thread
holds when it unlinks the command just before freeing it - and clears the
tag in the same critical section, so a second answer finds nothing.  The
opcode test keeps the Reject, and the first READ of a session, which also
carries tag 0, out of this path.  i_state is not the token, because
iscsit_send_unsolicited_nopin() writes ISTATE_SENT_NOPIN_WANT_RESPONSE
only after the NOP-In is on the wire and an answer may arrive first.
iscsit_find_cmd_from_ttt() and its Data ACK SNACK caller are untouched.

The same shape was reported in 2015 and fixed by taking one holder of TTT
0 away rather than by looking at the kind of command: a Test Unit Ready
left at TTT 0 was matched to the first NOP-In and queued for removal
twice, so every non-READ SCSI command was given 0xFFFFFFFF instead:
commit 9547308bda29 ("target/iscsi: Fix double free of a TUR followed by a solicited NOPOUT").

Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaugh@catern.com/
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target.c | 32 ++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e759..b0dd3e84e68e04 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1783,6 +1783,33 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_setup_nop_out);
 
+/*
+ * Take the NOP-In under cmd_lock, which the tx thread holds when it unlinks
+ * and frees the command, and clear its tag so only the first answer gets it.
+ */
+static struct iscsit_cmd *iscsit_take_nopin_from_ttt(struct iscsit_conn *conn,
+						     u32 targ_xfer_tag)
+{
+	struct iscsit_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
+		if (cmd->iscsi_opcode != ISCSI_OP_NOOP_IN ||
+		    cmd->targ_xfer_tag != targ_xfer_tag)
+			continue;
+
+		cmd->targ_xfer_tag = 0xFFFFFFFF;
+		cmd->i_state = ISTATE_REMOVE;
+		spin_unlock_bh(&conn->cmd_lock);
+		return cmd;
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+
+	pr_err("Unable to locate NOP-In for TTT: 0x%08x on CID: %u\n",
+	       targ_xfer_tag, conn->cid);
+	return NULL;
+}
+
 int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 			   struct iscsi_nopout *hdr)
 {
@@ -1821,14 +1848,13 @@ int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * This was a response to a unsolicited NOPIN ping.
 	 */
 	if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
-		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
+		cmd_p = iscsit_take_nopin_from_ttt(conn, be32_to_cpu(hdr->ttt));
 		if (!cmd_p)
 			return -EINVAL;
 
 		iscsit_stop_nopin_response_timer(conn);
 
-		cmd_p->i_state = ISTATE_REMOVE;
-		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, cmd_p->i_state);
+		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, ISTATE_REMOVE);
 
 		iscsit_start_nopin_timer(conn);
 		return 0;
-- 
2.43.0

