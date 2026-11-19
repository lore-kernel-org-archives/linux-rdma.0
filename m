Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094236;
	b=wYeAZJZoCCg5w61v2faruXZDTLag/uw13G0qP9Cq0vxSLjQhN7Bt1Ll9cX3QpBwo+COF
	 jbJG0BgO/U493OzxoLcSJnrl80ndZEDjiIp8gWTdzPDyyKXjELaWjE6Ro1ma6b/sZscXA
	 W0etXIBeCLTBTTrx7KU4NtFsJ1PLnH3gpzi3c+Zxbz+9srShaTjJRQKxFtlfKEIQ6D8G9
	 SuFg1CpapE4HXc0cAfS6IjM5CnMUysZ9ImsuvCxTO85z/mhamP2EnWSnTnxMK/zGgEYWL
	 EpzyBMJ3hNWYPGscHFnBZqdwv04L4xr2wGBIkLCmKEOABfHcYkpsgO88/bW2yc/OEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=t9yc+TCyNIyjbiMxZAudGWDF6gZ29/nY97SiXPaoyVU=;
	b=NXd05YCAT0Ypldogi5SY0dSCUUsq2mBrT2E39g7DBFbEzVSLVQGlZ6XRLHLz9LReCzYW
	 x5YQkuRqmGnqGRyRxERdS8JOGmmRSpEsS+xo4VSUTfbyf/8AfE50RnUrnWi3VRS4Tynr+
	 WNbMPerI7+fLGJ0wgDFID+jruGJcGwXazABHzVBxtCCUKsjlYi5AsI1naMndlmWhaGnUm
	 9FcMi2ZPPrrhTk08rzn+C/904M5gkl0SHPDE+nbeBGf7pkegRvYax/bTnKO1AtHkQXXW5
	 1k7TW57WUZXJmPGDi7dUfjhIqIUp/HY8n+ewL2fFVlA7xM6mNK1xOXrgvMYJdCbeYGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OF+98h7q;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C78606A33B
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:17:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9C78606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OF+98h7q
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so622906b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 05:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094235; x=1795699035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9yc+TCyNIyjbiMxZAudGWDF6gZ29/nY97SiXPaoyVU=;
        b=OF+98h7qrE80dj7ZmJ5HTLnWubYV9Co1ueOf2NqEWziTlET4cCP+wPyfITDcdqdRW8
         hcWZZQmiA1sOJeAi+lvjSWnHW6nstRx5J+lVEqOXF0DO0rr7WVJGmQAPhRyUAtfp17PH
         jzu7RvAzH1+n7nr45eVFA8LH3i8/3VrV/O30VBbD+gsE/Wj+UWfbVjXWXhvNVwJ6MbZn
         mlCQmVYnnB2jnEFPz+HzN0Jj4jc7EsjSkvVW1vvrGr3zbNm21NZUlcIQaUv4E6/Xsl0U
         aXl1sTONEkNQd0IGhSTIwlPJO0ddVwhAtlbRi8atONw+Jjv/eUAesZMvBs0H+cpiePsF
         /46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094235; x=1795699035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9yc+TCyNIyjbiMxZAudGWDF6gZ29/nY97SiXPaoyVU=;
        b=RIcHoW5YTYxDRoHpefOVYrzbAXhrBwp6abt2QW1fQqsnhVJ6MIluQljqXHclqU4Q/4
         Vok7gcdkE0B2Gwmg0TplXjxr206rurXNROAHKo9J1kEWT8gvM7+hPhyCdd+8chWMPFXs
         gGk07/+wl25QX76EBdxUNF44UkcmvjpE2SMVq2VUPnjWb7SXsEsSjL4JxqZ4/n7xcnyw
         Q4TZ1wVxo1XarQ39AyS5u6/7eBF+G2bUuuegzE0gK9+uBIpl894EEVMjXiylpmISqqCR
         oMzn9IHQr50YEOlCSAGkr6hAaPiZRd+bnUZyhyPs4GQQ5gcs4HvZbGgFvf3a6F3meUAN
         JN0A==
X-Gm-Message-State: APuU4Z9u5bUJPcY2JuSzWROT6/k5c+o6+dF7pK7yPjbHO5Gp8IColQ24
	UwgLZ0eK1IAuIIJCNTLxFo4wrbL6ApydRAzB+o8NyEGjQDyyeltUmCNl2Lgx1tN5hCw=
X-Gm-Gg: AYBFou33hVUo1qyNPeFHEN5xGx654e7hZ4OBbpl8dmm7BXxPpKQji60Na+DCUPEH51c
	5BZpk4Ak7dvxcC9Bmlsui/gyMvl7iY3QOOws7ByXm6jDXWnd5e+K13WuwSzIsC1SBeSO5hfA6an
	a+CyIglS3AIenehexVqPTFookh4qJuL0uaI9VRWra5YR8Iq7TCPClCcTULPZA9KHzZsXswzwWOi
	bMQHrp2Qgw1OJSJjx/zYglKk69LZ6VXreiPXkPqnkscZDg9ABMrIfS++5CYOf+9o6ry4toJl/BF
	H3/LTc+NCASPXrwVPO3Q2foqq0qpyenU1rU+mYz6RB2c0HAgQUSw05xFusaJBjyaSEU3b2DOKqE
	LzLFc72R9iUs8SeC5fQZXYuOXORVvkvPfe82aNP9ohE0gIhE/RQlqdB+GPi8aTS1FCjOJj6POi7
	DjX1UDBBKn6OTXRwU5NG7rOCrrULq+bdKDfL9BuzWt2Hv0IdZGc0ymp3dqgbMot8x7uIt9CoUbW
	CVAMW0kyO+2flzVQCc5cBKjFyfFCJVcIAMtXdrkfY+EA4T4r66y0K9CBcnJ5KEpq6EpCXtjsZAI
	aeWgAL1IUzykbgAhXsPyGpaHwjYv30PdXpyX2PEcnfedhuNdPmmVOQkWDAr+3+j/7ZXbBD+VWI6
	R0J0mz3G2pv1x4vQjwC1AGX1c2fQ/WbvnJsRz4A==
X-Received: by 2002:a05:6a00:4c10:b0:8b5:a3a5:6d57 with SMTP id d2e1a72fcca58-8c7daf05388mr874126b3a.4.1795094234986;
        Thu, 19 Nov 2026 05:17:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:14 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] scsi: target: iscsi: retire an unsolicited NOP-In only once
Date: Thu, 19 Nov 2026 22:16:57 +0900
Message-ID: <20261119131700.2722108-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
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
time.  Two NOP-Outs with the same TTT queue the same command twice, and
the tx thread's ISTATE_REMOVE handling releases it twice.  For the NOP-In
itself that release is quiet - it is a slice of the session's tag pool,
not a slab object - but it can land on whichever command has taken that
tag in the meantime.

The same lookup also hands out a Reject, which the core allocates with
targ_xfer_tag 0 and leaves on conn_cmd_list until it is sent, so a NOP-Out
with a reserved ITT and TTT 0 is given the Reject instead of a NOP-In.
That one does reach the slab, through the header the Reject kept in
cmd->buf_ptr, and an initiator gets there one PDU after login on plain
iscsi_tcp: a Data-Out over MaxXmitDataSegmentLength is rejected without its
payload being dumped, so the receive loop reads the next 48 bytes as a BHS.
Twenty such pairs in one write give 19 or 20 KASAN reports, 5 boots of 5:

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

Give the NOP-Out path its own lookup, which matches the opcode and state as
well as the tag, takes the command under conn->cmd_lock - the lock the tx
thread holds while freeing it - and clears the tag in the same section, so
a second answer finds nothing.  The opcode test keeps the Reject and a
session's first READ, which also carry tag 0, out of this path.  The state
test is needed because iscsit_add_nopin() publishes the command before it
queues the send and the tags are sequential, so a guessed answer could
otherwise queue ISTATE_REMOVE first.  ISTATE_SENT_NOPIN_WANT_RESPONSE is
now written under the same lock once iscsit_build_nopin_rsp() has put the
tag in the header and before the PDU can reach the wire: a real answer
cannot come first, clearing the tag no longer changes the wire, and the
single tx thread runs that ISTATE_REMOVE only after the send returns.
iscsit_find_cmd_from_ttt() and its SNACK caller are untouched.

The same shape was reported in 2015 and fixed by taking one holder of TTT 0
away rather than by looking at the kind of command: a Test Unit Ready left
at TTT 0 was matched to the first NOP-In and queued for removal twice:
commit 9547308bda29 ("target/iscsi: Fix double free of a TUR followed by a solicited NOPOUT").

Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaugh@catern.com/
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target.c | 54 +++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e759..1e2a1ec11d58b4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1783,6 +1783,35 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_setup_nop_out);
 
+/*
+ * Take the NOP-In under cmd_lock, which the tx thread holds when it unlinks
+ * and frees the command, and clear its tag so only the first answer gets it.
+ * i_state tells a tag that is on the wire from one that is only queued.
+ */
+static struct iscsit_cmd *iscsit_take_nopin_from_ttt(struct iscsit_conn *conn,
+						     u32 targ_xfer_tag)
+{
+	struct iscsit_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
+		if (cmd->iscsi_opcode != ISCSI_OP_NOOP_IN ||
+		    cmd->targ_xfer_tag != targ_xfer_tag ||
+		    cmd->i_state != ISTATE_SENT_NOPIN_WANT_RESPONSE)
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
@@ -1821,14 +1850,13 @@ int iscsit_process_nop_out(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
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
@@ -3035,6 +3063,17 @@ static int iscsit_send_unsolicited_nopin(
 
 	iscsit_build_nopin_rsp(cmd, conn, hdr, false);
 
+	/*
+	 * The tag is in the header now, so mark the command answerable before
+	 * the PDU can reach the wire.  iscsit_take_nopin_from_ttt() takes the
+	 * same lock, so an answer either sees the mark or finds nothing.
+	 */
+	if (want_response) {
+		spin_lock_bh(&conn->cmd_lock);
+		cmd->i_state = ISTATE_SENT_NOPIN_WANT_RESPONSE;
+		spin_unlock_bh(&conn->cmd_lock);
+	}
+
 	pr_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
 		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
 
@@ -3042,10 +3081,11 @@ static int iscsit_send_unsolicited_nopin(
 	if (ret < 0)
 		return ret;
 
-	spin_lock_bh(&cmd->istate_lock);
-	cmd->i_state = want_response ?
-		ISTATE_SENT_NOPIN_WANT_RESPONSE : ISTATE_SENT_STATUS;
-	spin_unlock_bh(&cmd->istate_lock);
+	if (!want_response) {
+		spin_lock_bh(&cmd->istate_lock);
+		cmd->i_state = ISTATE_SENT_STATUS;
+		spin_unlock_bh(&cmd->istate_lock);
+	}
 
 	return 0;
 }
-- 
2.43.0

