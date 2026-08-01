Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF631E834
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785577366; cv=none; b=mUUoXGxFn3jDa4KKjBHvwLTH5QF8VowkM4VRjet8kmuFdzC2+fxSZLkMadCZ8LB8gahe0Lm8Qo+p94/oWj4wE03mDVdzEVU4AYS7OONw9TRDK9wUcvngJKBFpadwYBcSDbZMFywGbdSBR1ZI7muGklm1QOo9j+PrrHjsCr0Gjbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785577366; c=relaxed/simple;
	bh=3IV/STm+W/PRrV+345FjQ5tyi8uXF2hJfUgM1So2Y+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh52fO3i6E5hEa1ymsBPwPGqGA84Nuib72/Gf5kGW3EhA8DKWEWVdMYM3MGVq+bjF5Pb2MoH0P9MELuzibo2yxgb65xRlQbZeJybM2upIgMZN6Lf+GbRg5kiVvL4XE0qwRrbMb9A4s8oCyzTWCxh8mNeqIMUaZ+FTwb4o2p/KQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=doWYjHgS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="doWYjHgS"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so24522765ad.0
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 02:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785577362; x=1786182162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RODS9frLm1PCJomPW/GeW/0jLAoVijQ3t4Bi2Xu7P2k=;
        b=doWYjHgSwG5BiUGxX1vtQcmDJc483Da56xRVDq48T/pjq6l7O2QPKwGOpi2NQ7LzGX
         6UTnZmJH+lBOd22LuBgTUJO5NmuwHTDgnmxE7JiuvTaOcu/R3qO6Gi+n6xvxaLhcJTYU
         azgH8uyHgM1R2/RhpGE7gOHFx1jqQoj5fgByALwT6nlSEqkoXbK8SiAC2rwNqD54cTNn
         nI4PGiUnCAY8WzgdyxQqZAufrKz2lYafAnIYv+8ShthtgQ3BoreF+gu3Ed4FYp6cJTu/
         AnoDP4GueCwQj3ghUixbnWQnDuJzUdwEuPDC4BEcCHifH6dhdTveOpZ0AlG07OxJbnan
         cEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785577362; x=1786182162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RODS9frLm1PCJomPW/GeW/0jLAoVijQ3t4Bi2Xu7P2k=;
        b=qQ8OZrX0H2jf8wHmf0m0nvpIjIj6h+LzOPjy8QB4mdNJna4UHix+rzxU/5U6TOv8gQ
         6Yg5gYszVMOeRkk5PFFlWj+sbh9ZbaCC10FgL5zpDgoE30Fhj00S8i1NoSQzdCpFO169
         BaWa3zUyvwDp7IOQmalEDxw+f1FeZZYouQNKhYMxmItgTVQGtJvkUlgvt8C+ob+9pff9
         WOYcGsXVPe5wr2zgqitS+VPHhcM9QSDn12Ey/PRjlZByttLboARKvaagnIN+mEFmVdzQ
         4wGxPZYpGfnmTzEn/qCPaH5pgds3gYaPm++PjPP38g1XNIsfAMfFJ1vOWF2iI2vLgBRb
         dscw==
X-Forwarded-Encrypted: i=1; AHgh+Rq2TZAvoDozCkhltNXPFUGr5xt7GrMbX1DENFvGZg1tI5O6PllhqS0r4pQ662M7WUuKAQy6LAtVfNbv@vger.kernel.org
X-Gm-Message-State: AOJu0YzG2F/IpUUVCsC5WC4sG8rRUt5J6LmgCWGYd1jFQptGmF9gmcfi
	MWJ0PPS5DP9kzN/tpjKUyKPBNpO4jBGm2KHEfcLvGGLQ+0d8yMbM/cfgIOGfoWEdUmo=
X-Gm-Gg: AR+sD11aRnl0qBomW8xKOEzUntR14omgfOYC94OmKjOWjkoAjnqy6DeGRHItUEbHgmT
	ygumMrb3tFRLEWCtqhlLheZ0hUXXp7V9UgRqbvwP7Ff/svjBLyIXYdt1gTxUlaMfD9nwNNfllYA
	eB9gKrHQ/+XZcrvA2HNVFZk1Bk4fS9xKDYkilcFrJ76Qf8Yu8g4zuxf2F6gN3abRDe3X0zaajyJ
	8tL8a7z5PpV3xmxR8KKOsIc2AW3GlCXhAptybv14E5vQBzIeWjVEcpHCEOIG8z6datw6kjB87B1
	VAjLSIErSAggRTsPlV328vxqQi2nYSOP3dBQGsMUvRO68gU5fu0OuuZl5DlhQ4reU+pNmGAEvx1
	4p/Y14m+yHS0tagbr6CbLayNhrtIQHseaRmi9dwa+1Y04FkTHFDoDw1Qf3Fb/kFsnLN4i5ZIIEz
	V5XBcggw6P62ITOutix25QcAOZ6nTLwMRbk8EEvJN8ZPeT1aQpBgjoDbzgBl72FNmPGi7+HJXDQ
	V7cOBFeZNU=
X-Received: by 2002:a17:902:ea0c:b0:2ce:9439:59a5 with SMTP id d9443c01a7336-2d0523f3cdemr30235795ad.36.1785577361938;
        Sat, 01 Aug 2026 02:42:41 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c329:7b28:fe02:5dc8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b0eb486sm16006465ad.53.2026.08.01.02.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 02:42:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH net v5 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Sat,  1 Aug 2026 18:42:07 +0900
Message-ID: <20260801094208.1937951-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
References: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a link whose device has max_recv_sge == 1 there is no shared v2 receive
buffer, and smc_llc_save_add_link_rkeys() takes the v2 extension from 44
bytes past the start of the queue entry's inline message:

  ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg + SMC_WR_TX_SIZE);

The entry is a 72-byte allocation and the extension starts at offset 68, so
ext->num_rkeys at offset 94 is already past it.  This happens on every
SMC-Rv2 link addition, whatever the peer sends:

  BUG: KASAN: slab-out-of-bounds in smc_llc_save_add_link_rkeys+0x333/0x350
  Read of size 2 at addr ffff8880056406de by task smctest/106
  Call Trace:
   smc_llc_save_add_link_rkeys+0x333/0x350
   smc_llc_cli_add_link+0xca7/0x1e80
   __smc_connect+0x3f5c/0x4980
   smc_connect+0x42c/0x580
   __sys_connect+0xfc/0x130
  Allocated by task 44:
   smc_llc_enqueue+0x72/0x560
   smc_wr_rx_tasklet_fn+0x474/0xa80
  The buggy address is located 22 bytes to the right of
   allocated 72-byte region [ffff888005640680, ffff8880056406c8)

Whatever that read finds then bounds the ext->rt[] loop, so a peer that
declares 255 rkeys reads much further.  smc_llc_rmt_delete_rkey() has the
same shape for llcv2->rkey[].

Bound both loops by the buffer they read from, and skip the extension
altogether when there is no shared v2 receive buffer.  The extension
does arrive on the link, but smc_llc_enqueue() copies only
sizeof(union smc_llc_msg) into the queue entry, so what that code read
past the 44 inline bytes was heap and not peer data.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v4 -> v5: corrected the reason given for skipping the extension.  It does
arrive on the link; what is not there is the copy in the queue entry.  No
functional change.

Measured over rxe with KASAN and max_recv_sge forced to 1, five test cells
(plain 1-rkey delete, delete declaring 255, plain ADD_LINK v2, ADD_LINK
declaring 255, and an SMC-Rv1 link group).  Without this patch four of the
five report; with it none do.  With kasan_multi_shot the unpatched kernel
reports 491 times in a single ADD_LINK run, the patched one not at all.

 net/smc/smc_llc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 90746cd1e29a..02561f39d6d8 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1000,13 +1000,21 @@ static void smc_llc_save_add_link_rkeys(struct smc_link *link,
 					struct smc_link *link_new,
 					u8 *llc_msg)
 {
+	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
 	struct smc_llc_msg_add_link_v2_ext *ext;
 	struct smc_link_group *lgr = link->lgr;
 	int max, i;
 
+	/* Without a shared v2 receive buffer the extension is not copied
+	 * into the queue entry, so not even ext->num_rkeys is there.
+	 */
+	if (!smc_link_shared_v2_rxbuf(link))
+		return;
 	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
 						     SMC_WR_TX_SIZE);
 	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+	max = min_t(u32, max, (SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE - rt_off) /
+			      sizeof(ext->rt[0]));
 	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < max; i++) {
 		smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
@@ -1813,17 +1821,25 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	link = qentry->link;
 
 	if (lgr->smc_version == SMC_V2) {
+		const u32 rkey_off =
+			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
 		struct smc_llc_msg_delete_rkey_v2 *llcv2;
+		u32 buf_len;
 
 		if (smc_link_shared_v2_rxbuf(link)) {
 			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
 			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
+			buf_len = SMC_WR_BUF_V2_SIZE;
 		} else {
 			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
+			buf_len = sizeof(qentry->msg);
 		}
 		llcv2->num_inval_rkeys = 0;
 
 		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
+		/* bound by the buffer llcv2 points at */
+		max = min_t(u32, max, (buf_len - rkey_off) /
+				      sizeof(llcv2->rkey[0]));
 		for (i = 0; i < max; i++) {
 			if (smc_rtoken_delete(link, llcv2->rkey[i]))
 				llcv2->num_inval_rkeys++;
-- 
2.43.0

