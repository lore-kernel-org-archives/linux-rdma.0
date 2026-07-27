Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04B3F6C24
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146335; cv=none; b=N9ziImEXi5hNy42ibuUX/JbIMvBR1rjV4U8Vjir6Jzxm83pdkLV7xvT6PHb/YmovFaae3mnQRkjvHjYiy5NUV7EcvngIRcPAi8PPnhp5C9Ye6mRrAoBKDR48HcDUEG4wSy0QMyOhR43SfZat3LFSi9hOj6iHwoQSkOxyhuKlaj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146335; c=relaxed/simple;
	bh=crIQtX20obF3TC5dV0O2T3AsJII0J1ZZB9Qecwr67PI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pumYMI6mE1cYByBRjwUfqYMiIL/ytybcuxdrqLBRMQW9f5qwspMalkdQE6D5rOUZjX+0DrBmwqAHdwIaPSsjiCyrFTuVzlN/ZFJ/IToYhuB0tbztqUx+WuKJ585vnRmSIJ47DF3Tt2mRG5EsCc43OzxhcvC0hvwu4XHylOOlnz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=D2MIKSA8; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="D2MIKSA8"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8486672f03cso2394520b3a.0
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 02:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785146332; x=1785751132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+DRMmn4/PFMcmqnUYa9ddb19KSYep8avFsbVeSVbwFQ=;
        b=D2MIKSA8nJctnlnW+P463RspHheU7YjVtEMAmvb+krpZN1H+i89HYWeGGPo6D27O7n
         hotiFLgoARkOrD4RluJBwtr3Jr3oI8rjfezsX6RT+N+Hghd0lMr/eZqMmSwHTgVzpm9S
         fMORJmhqd5MwqQY2AUbPfOsu9beWvhkmackE2AbJupHxEXwP+MsrnXnBEQSjyTNm/WRf
         Y8nCwSyQ9OHlx5u5hKx3+le6qwTLr4wqjpbb0yuesqN2q0GjIAEPhLDMDk+fxV9Zr+g+
         2MeHNNMDTB5E79pOIwQqltsb36yjwrRo8InFyVlgRAiVwFBgf4Jf4rpiG1APJ9+qKAtK
         J7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785146332; x=1785751132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+DRMmn4/PFMcmqnUYa9ddb19KSYep8avFsbVeSVbwFQ=;
        b=L+J2bIXWHGiuLG6hwCVvpQ5YbIm9aMAQYFZasaBUu17XVGfeUwbwvajyc2+87pFPaH
         sSxbTh0mMQdkAQO+6ah5L54g+lOuvpqTNXm4YN3Ctv/Vq2fnbeUsgy/61g9T3Zy+ZRwn
         H0qvywDCXTPLlxOzNIudLcyBZhlV3wECnDgupeFd7+Ckha69amRj/NrHSDRE7+SCgFp1
         DLdw2jCeZSp+B818NzEPLn/vdh4oNtuxRNPjNOngSW0cXv7ZBOKG3ltEiMmjaUwCBLwi
         W5UermQ609yoOGV5oHPSSSBIw9cPHuo/a8oHvqhqqnk2IhSDFvjR7b5qu/JKzBYvG+2i
         4dhQ==
X-Forwarded-Encrypted: i=1; AHgh+RooWZtxD2VNPrGlzXWmCvxDqpwjW1bLJd6R8Yn//pcN+44WMFWsAI974wHKmM0OfNi+Ti5y0i9Dar48@vger.kernel.org
X-Gm-Message-State: AOJu0YyB9PxBZ+tHEfa+snfDL8YEnw6WZufsNNl/pBHB4OUeyK5flcG0
	BqCUj96NUaBl/XigqkaYnf0eRaR9IHDnNxTPjBY/FqWmJnXAHZFNn1ZBUmA/KXOBXeo=
X-Gm-Gg: AR+sD11wh/GxhvUP69SY3nRx6G5fLc27is/AMjanhiwu/9Sa+tzMsW6IjTPnsQSwYD0
	VSfE9RVVSeFwIG4qrP0sh9VSr2krJaRhJE0U3HNDclznu4DeZvP+Z1tbVl+OhqrTBrru5t1lo4i
	lPn3/7OSj+UY37+cPNxhSyL9rzCxXNRlhUmhLI1zKW24r3bp/LShXjq7bm1pA8BKChUQdeFdRna
	tV30CjPx3rIqJUA2J/R2an3KEK+pI16Z+NEDN5rkEaT3GAPc+j3tgjlAo9EGjMXVar5asWdwzHy
	451trnJyhCM8yjKQBcr8aTQWW/uDcmVRTgIFZPlydktXVedki0qoL/lpGXltJ30n0RxliQLhPgH
	XO+wNxr9DkT7RSc9x2ZA9M9NZBQX1x4sQsXLw5akbLZIXSx1P1Zv7uLLQm37BxmTYHcOQSKVB6W
	JZYHMvRAlHg04ZtfTg1eeOlxT0
X-Received: by 2002:a05:6a00:392a:b0:848:2f7a:2e50 with SMTP id d2e1a72fcca58-84e5957266amr6287578b3a.63.1785146331561;
        Mon, 27 Jul 2026 02:58:51 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:fc36:f2a9:533e:766d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5344d9e9sm2863367b3a.55.2026.07.27.02.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 02:58:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH net v3] net/smc: fix out-of-bounds read of rkey array in SMC-Rv2 LLC processing
Date: Mon, 27 Jul 2026 18:58:33 +0900
Message-ID: <20260727095833.1079618-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An SMC-Rv2 LLC message can be longer than the 44-byte union smc_llc_msg.
If the device offers two receive SGEs, the part beyond 44 bytes is
scattered into the link group's shared v2 buffer. If it does not
(max_recv_sge == 1, so smc_link_shared_v2_rxbuf() is false), the whole
message is received into the link's own receive buffer.

smc_llc_enqueue() copies only sizeof(union smc_llc_msg) into the queue
entry, but the consumers keep reading the message past that point:

  smc_llc_rmt_delete_rkey()      rkey[i] at message offset 8 + 4 * i
  smc_llc_save_add_link_rkeys()  the v2 extension at message offset 44

In the non-shared layout those bytes are not in the queue entry at all,
so the reads run off the end of the queue entry allocation. The buffer
the message arrived in is no source either: smc_wr_rx_post() hands it
back to the device immediately after the handler runs, while the message
is consumed later from the llc_event_work work item.

Attach the body to the queue entry instead. smc_llc_enqueue() now takes
the completion length, and copies whatever arrived beyond the first 44
bytes into a flexible array at the tail of the same allocation. That
copy is the only place that has to know which of the two receive layouts
is in use; every consumer reads one buffer whose lifetime is the queue
entry's, and the shared/non-shared branches in smc_llc_rmt_delete_rkey(),
smc_llc_cli_add_link() and smc_llc_srv_add_link() go away.

Because the backing allocation is now the size of the received message
rather than a fixed 8 KiB buffer, the loop bounds have to come from the
received length too. num_rkeys and the v2 extension's rkey count are
peer-controlled and unrelated to the number of bytes the peer actually
sent - a peer can declare 255 rkeys in a 44-byte DELETE_RKEY - so both
are clamped to what was received, and the extension's count field is
only read once enough bytes for it have arrived. This is not hardening
added on top of the fix, it is part of it: the counts were never
validated before either, the reads happened to stay in bounds only
because the buffer they addressed was always 8 KiB. The commit message
of v2 of this patch deferred that check "as a separate hardening"; with
the body sized by the peer's message it cannot be deferred, so that is
withdrawn.

Passing the queue entry down also closes a use-after-free on the same
path. smc_llc_srv_add_link() frees the queue entry before it reads the
rkeys (net/smc/smc_llc.c, v7.2-rc5):

  1494        smc_llc_save_add_link_info(link_new, add_llc);
  1495        smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
  ...
  1503        if (lgr->smc_version == SMC_V2) {
  1504                u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
  1505                        (u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;
  1506                smc_llc_save_add_link_rkeys(link, link_new, llc_msg);

add_llc points into the queue entry that line 1495 has already freed, so
on a non-shared link the extension is read from freed memory. Detach the
entry from the flow with smc_llc_flow_qentry_clr() and free it when the
function is done with it. It was introduced by the same commit.

Unpatched, a peer that declares 255 rkeys in a 44-byte DELETE_RKEY
reads past the queue entry:

  BUG: KASAN: slab-out-of-bounds in smc_llc_rmt_delete_rkey+0x6a4/0x780
  Read of size 4 at addr ffff8880059ee748 by task kworker/0:0H/11
  Workqueue: events_highpri smc_llc_event_work
  Call Trace:
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   kasan_report+0xce/0x100
   smc_llc_rmt_delete_rkey+0x6a4/0x780
   smc_llc_event_handler+0xa13/0xef0
   smc_llc_event_work+0x189/0x260
   process_one_work+0x633/0x1030
   worker_thread+0x45b/0xd10
   kthread+0x2c6/0x3b0
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30
  Allocated by task 43:
   __kmalloc_cache_noprof+0x158/0x370
   smc_llc_enqueue+0x72/0x560
   smc_wr_rx_tasklet_fn+0x474/0xa80
   ...
  The buggy address is located 0 bytes to the right of
   allocated 72-byte region [ffff8880059ee700, ffff8880059ee748)

Reachability does not depend on the peer being able to send a large
message: the counts are read out of a normally sized message, and a
malicious peer only has to declare more rkeys than it actually sent.
Kernel-side injection is needed in the reproducer only because Linux
never misdeclares its own count.

Reproduced under KASAN with soft-RoCE (rdma_rxe) between two network
namespaces, with wr_rx_sge_cnt forced to 1 (rxe itself advertises 32
receive SGEs) and a test-only parameter that raises num_rkeys in the
DELETE_RKEY the kernel sends. Not exercised: a real HCA with
max_recv_sge == 1, a non-Linux peer that sends a DELETE_RKEY longer than
44 bytes, and anything beyond the two link groups and two connections
the test sets up.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Suggested-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v3:
 - Carry the v2 message body on the qentry itself instead of the
   per-link-group lgr->wr_rx_buf_v2, as suggested by D. Wythe. The body
   travels in the same allocation as a trailing flexible array, so the
   shared and non-shared layouts no longer diverge in any consumer and
   the existing kfree(qentry) sites are unchanged.
 - Bound the rkey counts by the number of bytes actually received. With
   a per-qentry body the backing allocation is exactly as large as what
   arrived, so this is required for memory safety rather than being the
   separate hardening promised in v2.
 - Keep the qentry alive in smc_llc_srv_add_link() until the rkeys have
   been read; the non-shared path there dereferenced it after it had
   already been freed.
 - Rebased onto v7.2-rc5; net/smc is unchanged between the v2 base and
   this one.

v2:
 - Guard the copy on lgr->smc_version == SMC_V2 to avoid a NULL
   dereference of wr_rx_buf_v2 on a v1 link group.
 - Copy the message body only, restoring the header from the per-qentry
   copy.

Previous postings:
  v1 20260723094027.391199-1-yhlee@isslab.korea.ac.kr
  v2 20260724061606.433735-1-yhlee@isslab.korea.ac.kr

 net/smc/smc_llc.c | 70 +++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 954b2ff1815c..997664bbe4f2 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -199,10 +199,13 @@ union smc_llc_msg {
 struct smc_llc_qentry {
 	struct list_head list;
 	struct smc_link *link;
+	u16 body_len;
 	union smc_llc_msg msg;
+	u8 body[] __counted_by(body_len);
 };
 
-static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc);
+static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc,
+			    u32 byte_len);
 
 struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow)
 {
@@ -998,15 +1001,20 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 
 static void smc_llc_save_add_link_rkeys(struct smc_link *link,
 					struct smc_link *link_new,
-					u8 *llc_msg)
+					struct smc_llc_qentry *qentry)
 {
+	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
 	struct smc_llc_msg_add_link_v2_ext *ext;
 	struct smc_link_group *lgr = link->lgr;
 	int max, i;
 
-	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
-						     SMC_WR_TX_SIZE);
+	/* the rkey count itself is only there if enough bytes arrived */
+	if (qentry->body_len < rt_off)
+		return;
+	ext = (struct smc_llc_msg_add_link_v2_ext *)qentry->body;
 	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+	max = min_t(u32, max, (qentry->body_len - rt_off) /
+			      sizeof(ext->rt[0]));
 	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < max; i++) {
 		smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
@@ -1099,9 +1107,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (rc)
 		goto out_clear_lnk;
 	if (lgr->smc_version == SMC_V2) {
-		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
-			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
-		smc_llc_save_add_link_rkeys(link, lnk_new, llc_msg);
+		smc_llc_save_add_link_rkeys(link, lnk_new, qentry);
 	} else {
 		rc = smc_llc_cli_rkey_exchange(link, lnk_new);
 		if (rc) {
@@ -1481,7 +1487,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	}
 	add_llc = &qentry->msg.add_link;
 	if (add_llc->hd.flags & SMC_LLC_FLAG_ADD_LNK_REJ) {
-		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 		rc = -ENOLINK;
 		goto out_err;
 	}
@@ -1492,7 +1498,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
 	}
 	smc_llc_save_add_link_info(link_new, add_llc);
-	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 
 	rc = smc_ib_ready_link(link_new);
 	if (rc)
@@ -1501,9 +1507,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	if (rc)
 		goto out_err;
 	if (lgr->smc_version == SMC_V2) {
-		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
-			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;
-		smc_llc_save_add_link_rkeys(link, link_new, llc_msg);
+		smc_llc_save_add_link_rkeys(link, link_new, qentry);
 	} else {
 		rc = smc_llc_srv_rkey_exchange(link, link_new);
 		if (rc)
@@ -1512,6 +1516,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
+	kfree(qentry);
 	kfree(ini);
 	return 0;
 out_err:
@@ -1520,6 +1525,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 		smcr_link_clear(link_new, false);
 	}
 out:
+	kfree(qentry);
 	kfree(ini);
 	if (send_req_add_link_resp)
 		smc_llc_send_req_add_link_response(req_qentry);
@@ -1552,7 +1558,8 @@ void smc_llc_add_link_local(struct smc_link *link)
 	add_llc.hd.common.llc_type = SMC_LLC_ADD_LINK;
 	smc_llc_init_msg_hdr(&add_llc.hd, link->lgr, sizeof(add_llc));
 	/* no dev and port needed */
-	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc);
+	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc,
+			sizeof(union smc_llc_msg));
 }
 
 /* worker to process an add link message */
@@ -1588,7 +1595,8 @@ void smc_llc_srv_delete_link_local(struct smc_link *link, u8 del_link_id)
 	del_llc.link_num = del_link_id;
 	del_llc.reason = htonl(SMC_LLC_DEL_LOST_PATH);
 	del_llc.hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
-	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc);
+	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc,
+			sizeof(union smc_llc_msg));
 }
 
 static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
@@ -1811,16 +1819,15 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 
 	if (lgr->smc_version == SMC_V2) {
 		struct smc_llc_msg_delete_rkey_v2 *llcv2;
+		const u32 rkey_off =
+			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
 
-		if (smc_link_shared_v2_rxbuf(link)) {
-			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
-		} else {
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
-		}
+		llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
 		llcv2->num_inval_rkeys = 0;
 
 		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+		max = min_t(u32, max, (sizeof(qentry->msg) + qentry->body_len -
+				       rkey_off) / sizeof(llcv2->rkey[0]));
 		for (i = 0; i < max; i++) {
 			if (smc_rtoken_delete(link, llcv2->rkey[i]))
 				llcv2->num_inval_rkeys++;
@@ -2063,18 +2070,35 @@ static void smc_llc_rx_response(struct smc_link *link,
 	wake_up(&link->lgr->llc_msg_waiter);
 }
 
-static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
+static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc,
+			    u32 byte_len)
 {
 	struct smc_link_group *lgr = link->lgr;
 	struct smc_llc_qentry *qentry;
 	unsigned long flags;
+	u16 body_len = 0;
+
+	/* V2 messages can be longer than the inline union smc_llc_msg. Carry
+	 * the remainder in the qentry itself, so that its lifetime and its
+	 * length match the message the peer actually sent.
+	 */
+	if (lgr->smc_version == SMC_V2 && byte_len > SMC_WR_TX_SIZE)
+		body_len = min_t(u32, byte_len, SMC_WR_BUF_V2_SIZE) -
+			   SMC_WR_TX_SIZE;
 
-	qentry = kmalloc_obj(*qentry, GFP_ATOMIC);
+	qentry = kmalloc_flex(*qentry, body, body_len, GFP_ATOMIC);
 	if (!qentry)
 		return;
+	qentry->body_len = body_len;
 	qentry->link = link;
 	INIT_LIST_HEAD(&qentry->list);
 	memcpy(&qentry->msg, llc, sizeof(union smc_llc_msg));
+	if (body_len) {
+		u8 *src = smc_link_shared_v2_rxbuf(link) ?
+			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
+
+		memcpy(qentry->body, src + SMC_WR_TX_SIZE, body_len);
+	}
 
 	/* process responses immediately */
 	if ((llc->raw.hdr.flags & SMC_LLC_FLAG_RESP) &&
@@ -2106,7 +2130,7 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 			return; /* invalid message */
 	}
 
-	smc_llc_enqueue(link, llc);
+	smc_llc_enqueue(link, llc, wc->byte_len);
 }
 
 /***************************** worker, utils *********************************/
-- 
2.43.0

