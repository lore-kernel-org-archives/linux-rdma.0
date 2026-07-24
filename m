Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD8314A8D
	for <linux-rdma@vger.kernel.org>; Fri, 24 Jul 2026 04:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784868815; cv=none; b=rklaJHcFS622hmBC3J2xmaaYGIv6qs1QF7krybEXcq3nGVzn0CL47pYlaaT7tBn3FzD6aYlq9vyi9+Lv0WO1pVYitM7u/wULvziieXQjJSmrp9OZLh07sW7bkXy8daVS3Rej9IKMm6NZXFpvOlo9TRF5px6pVSrtfVbgwAWEzz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784868815; c=relaxed/simple;
	bh=8hhpCauV9B0XHh+Hnm3eGrqfqRl5IvZHE11IcXpKxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSMFGGz3dqXBtg5itrHnKKDIzYfeOFU4F8Av4ZiyS4RtrAUUboWlx/rHhY1swt8oy+AllVHL1Om97j8YEr4Ms58UJxWWh4FioShYlHNwfRJCYdS/Oeat7ta3I3UPfAXF058vu99i33XcQr09KtlejtzM9CqLCkP2Q2gHKSG3RFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=d0ombMaa; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="d0ombMaa"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cea3004256so619505ad.0
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 21:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1784868812; x=1785473612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nBkOpq5Bp+PFLFXuwAdTIe/08W+WYHTKlNo6ov8KKew=;
        b=d0ombMaaKvh4gZvTGEOcIJoUgZ/9xMdXbBl3m/0oSEZWLujjUV/2VM0SsbhFBjxJug
         UvHur5t74dFHdj33kRJwVKp85uDEH9iQVJqZUTr1Z0nMI6cloHQ1M3NUuqodE62TLUzJ
         KYwQ2o8zXq46TmGantuWxnvWm8nUH6iV/kBUpA3igqVCPEzadVFc2C8MATyGEB+G1+Y6
         +66EjRB4mZ7iC95jr8BxBKfgcuLErdr5/esWHMMdaNEgHzgNDmom0GunQUIe0qWVzL2W
         oeBv5Oq4QYNa1yzgib+Ef4F/fPgzUtMDwKmt22FgHOf5JyLKbwD3RyL0wnZ2yJ/Cytg7
         flbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784868812; x=1785473612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nBkOpq5Bp+PFLFXuwAdTIe/08W+WYHTKlNo6ov8KKew=;
        b=Tktsn7179JgchpPPjA57qn1kmH0V2KWEIjvb2aD1yglIGD+iecWLU/GdDpXKsgngcf
         LYaWPFaTXrCURZQoUa52K7SjB3VVNT1HGLYYUnXvcNhFZp8nNiZyzS1zeESz+F/mdgqQ
         2P281x8rVk1EaixR2Q7NJX7EnbOxihwjjtykOT7scXi51tVvUahZsbEV9URNOQ1STnkw
         TTXb6KB2vLqQnVBNguAfjGDO56z1dwAzXUJBBKBBABQVgtH0dWe+ZmxlgDhXfuKe14/L
         fP0tPcYITPiByfRZI9qPwWb6DrzgSSKwPMaJrE4Y1mexAjPkgAssCV0iqkSTxS1aAVVa
         XLQg==
X-Forwarded-Encrypted: i=1; AHgh+RqG1+X5vdfsaZpwQyPFSTAV2JRWeQHeDetl7u8VN+1HZuTiYmQBnLrfpGYLAbBsFBnVX6aJ5UJPg6jF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3D0E1dYGQXbstf1lqHkeck5+elVSn7763yqv0EjgA/uDOPxGf
	MtxMApANkflyniUyUsvKmcffr48cRUpfyzFL97xZaI+eiv/kpHoQ8jc1KuC+CaYHGLk=
X-Gm-Gg: AR+sD13ftFbSn8WKzuTk8/K+LXf+o5nnz1p/dFoNhb9qEuIEszL1DGQSOOBvSJEDoEV
	Ikh0YUT2fbhjTJiDxrt/LVpTcPkB5XSbQIL/del9wRn6OIpOlBNzuJL6AkS9KB2taOp3nNLxkes
	AiSQcPvW3b8NrF5I/HiyI3ZIyF+u4cB+RJfG+dysZaBavuUHzeeXDR5YAaZ7GwdrRavZ75HXJoG
	KMdJW3SSDDn+OH1nOdW6w/0OdlNB1sarSlZvjmZAjXYed67x3Ta6w+R+/PMi5sUQ7Q5d/OOjKn7
	4CdQxlNcwDznl4srcpM6zpBQVryN6fcvniwUbrgB50ERPBNQMHQS8pAoVE4t/OTEcexdDWxec5k
	JgXHJdaRkamaPisBGQb0dYl71DS1PPF4yyN37snvKbZhC+ld1A1QKdAfb80/nmB6WLb7BISSuMZ
	RBjJoexsIWMg==
X-Received: by 2002:a17:902:ec8e:b0:2c9:de53:f84f with SMTP id d9443c01a7336-2cfa6b7394fmr70538245ad.19.1784868812290;
        Thu, 23 Jul 2026 21:53:32 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f2e6247sm44281975ad.54.2026.07.23.21.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 21:53:31 -0700 (PDT)
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
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH net v2] net/smc: fix out-of-bounds read of rkey array in SMC-Rv2 LLC processing
Date: Fri, 24 Jul 2026 13:53:10 +0900
Message-ID: <20260724045310.430202-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723094027.391199-1-yhlee@isslab.korea.ac.kr>
References: <20260723094027.391199-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMC-Rv2 uses two receive-buffer layouts, selected by
smc_link_shared_v2_rxbuf() (i.e. lnk->wr_rx_sge_cnt > 1):

 - shared (device max_recv_sge >= 2): each receive work request posts a
   small primary SGE plus a spillover SGE that DMAs the message body into
   the per-link-group lgr->wr_rx_buf_v2 (SMC_WR_BUF_V2_SIZE = 8 KiB) at
   offset SMC_WR_TX_SIZE.

 - non-shared (device max_recv_sge == 1): each receive work request posts
   a single SGE of wr_rx_buflen == SMC_WR_BUF_V2_SIZE, so the whole
   message lands in the per-WR receive buffer.

smc_llc_rx_handler() hands the received buffer to smc_llc_enqueue(),
which copies only sizeof(union smc_llc_msg) bytes into the fixed-size
qentry->msg and queues the request; the LLC request is then processed
later from the llc_event_work work item, after smc_wr_rx_process_cqes()
has already reposted (and thus recycled) the per-WR receive buffer.

For the shared layout the rkey array survives in wr_rx_buf_v2, and
smc_llc_rmt_delete_rkey() and smc_llc_save_add_link_rkeys() read it from
there. For the non-shared layout nothing preserves the message body: both
functions instead read the rkey array from the truncated qentry copy
((struct smc_llc_msg_delete_rkey_v2 *)llc, and (u8 *)add_llc +
SMC_WR_TX_SIZE), running past the end of the ~72-byte qentry allocation.
The loop bound num_rkeys comes straight off the wire and is only capped at
SMC_LLC_RKEYS_PER_MSG_V2 (255), so a peer that sends a DELETE_RKEY or
ADD_LINK message with an oversized rkey count triggers an out-of-bounds
read of up to ~1 KiB (delete_rkey) or ~4 KiB (add_link) past a kmalloc-96
object.

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

Preserve the message body for the non-shared layout as well: in
smc_llc_rx_handler() copy the bytes beyond SMC_WR_TX_SIZE into
wr_rx_buf_v2 + SMC_WR_TX_SIZE before the receive work request is reposted,
exactly mirroring the spillover SGE of the shared layout. The header
(which for a message that fits in SMC_WR_TX_SIZE contains the whole rkey
array) is not copied here; smc_llc_rmt_delete_rkey() now restores it from
the per-qentry copy for both layouts, so a different v2 LLC message that
reaches the shared wr_rx_buf_v2 between reception and processing cannot
clobber it. The rkey array is then read from wr_rx_buf_v2, bounded by its
SMC_WR_BUF_V2_SIZE size.

The body copy is guarded by lgr->smc_version == SMC_V2, since
wr_rx_buf_v2 is only allocated for v2 link groups; keying it off the
link-group version rather than only the wire llc_version prevents a NULL
dereference should a v2-versioned LLC message arrive on a v1 link group.
It also removes a latent use-after-free on the SMC-R server add-link path,
where the non-shared code dereferenced add_llc after its qentry had been
freed by smc_llc_flow_qentry_del().

The rkey count is still only capped at SMC_LLC_RKEYS_PER_MSG_V2; the reads
now stay within the 8 KiB buffer regardless, and validating num_rkeys
against the received message length is left as a separate hardening.

Triggering the bug requires a RoCE device that advertises
max_recv_sge == 1 (a configuration the Fixes: change added support for)
and a peer emitting an oversized rkey count. Reproduced under KASAN with
soft-RoCE (rdma_rxe) after forcing wr_rx_sge_cnt = 1.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: guard the wr_rx_buf_v2 copy with lgr->smc_version == SMC_V2 (v1 keyed
    the copy off the wire llc_version only, so a v2-versioned LLC message
    received on a v1 link group could dereference the NULL wr_rx_buf_v2);
    copy only the message body and restore the header from the per-qentry
    copy in smc_llc_rmt_delete_rkey(), so a later v2 message reaching
    wr_rx_buf_v2 cannot clobber it; note num_rkeys is not validated
    against the message length.
    v1: https://lore.kernel.org/netdev/20260723094027.391199-1-yhlee@isslab.korea.ac.kr
 net/smc/smc_llc.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 954b2ff1815c..84d8d9024efa 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1099,9 +1099,8 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (rc)
 		goto out_clear_lnk;
 	if (lgr->smc_version == SMC_V2) {
-		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
-			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
-		smc_llc_save_add_link_rkeys(link, lnk_new, llc_msg);
+		smc_llc_save_add_link_rkeys(link, lnk_new,
+					    (u8 *)lgr->wr_rx_buf_v2);
 	} else {
 		rc = smc_llc_cli_rkey_exchange(link, lnk_new);
 		if (rc) {
@@ -1501,9 +1500,8 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	if (rc)
 		goto out_err;
 	if (lgr->smc_version == SMC_V2) {
-		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
-			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;
-		smc_llc_save_add_link_rkeys(link, link_new, llc_msg);
+		smc_llc_save_add_link_rkeys(link, link_new,
+					    (u8 *)lgr->wr_rx_buf_v2);
 	} else {
 		rc = smc_llc_srv_rkey_exchange(link, link_new);
 		if (rc)
@@ -1812,12 +1810,15 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	if (lgr->smc_version == SMC_V2) {
 		struct smc_llc_msg_delete_rkey_v2 *llcv2;
 
-		if (smc_link_shared_v2_rxbuf(link)) {
-			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
-		} else {
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
-		}
+		/* Restore the header - and, for a message that fits in
+		 * SMC_WR_TX_SIZE, the whole rkey array - from the per-qentry copy
+		 * for both rxbuf layouts, so a v2 message that reached
+		 * wr_rx_buf_v2 in the meantime cannot clobber it.  The body of a
+		 * larger message is already in wr_rx_buf_v2 (shared: spillover
+		 * DMA; non-shared: smc_llc_rx_handler()).
+		 */
+		memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
+		llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
 		llcv2->num_inval_rkeys = 0;
 
 		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
@@ -2104,6 +2105,26 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 	} else {
 		if (llc->raw.hdr.length_v2 < sizeof(*llc))
 			return; /* invalid message */
+		/* For the non-shared v2 rxbuf layout the message body beyond
+		 * SMC_WR_TX_SIZE lives only in the per-WR receive buffer, which
+		 * is reposted as soon as this handler returns.  The LLC event
+		 * handlers run later from a work item and read the body from
+		 * wr_rx_buf_v2, so copy it there now - only the body, mirroring
+		 * the shared-rxbuf layout where the spillover SGE DMAs the body
+		 * into wr_rx_buf_v2 + SMC_WR_TX_SIZE.  The header is left to the
+		 * handlers, which restore it from the per-qentry copy, so a later
+		 * message reaching wr_rx_buf_v2 cannot clobber it.  wr_rx_buf_v2
+		 * only exists for SMC_V2 link groups, so the link-group version
+		 * is checked (not just the wire llc_version) to avoid a NULL
+		 * dereference on a v1 link group.
+		 */
+		if (link->lgr->smc_version == SMC_V2 &&
+		    !smc_link_shared_v2_rxbuf(link) &&
+		    wc->byte_len > SMC_WR_TX_SIZE)
+			memcpy((u8 *)link->lgr->wr_rx_buf_v2 + SMC_WR_TX_SIZE,
+			       (u8 *)llc + SMC_WR_TX_SIZE,
+			       min_t(u32, wc->byte_len, SMC_WR_BUF_V2_SIZE) -
+			       SMC_WR_TX_SIZE);
 	}
 
 	smc_llc_enqueue(link, llc);
-- 
2.43.0

