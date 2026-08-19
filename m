Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947B13BFAEF
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 02:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787106820; cv=none; b=fW4iiOCFUHh5nsM2XrBf+BndF9zfxi1NToj+ANes4nVaQKIJLKzdtfGrKTK48JLWgqBA86wOSjSqkkYiWDyG3kw3MjQ0Z9mEZUyTayrhGTXEzYV5+vsrLq3/rUSPBPR9oRuVPOItX0WMC6XXqnwlZDW+m8uvgH0w+7AcM75xBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787106820; c=relaxed/simple;
	bh=Iuarn4oLLGMAYXYIV7PHiY1UhbpceFCrWtAO6O1P5aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqGU3dPdm6RHKT/DDNMHqDpJiewZaPukqm6iFVvrzYieQSrctGUmBSBp0b02Db66mm1brgyM2+M0s5/x1CWrdlZvmtlk/JyC+g/Pao178pylkRRQSMkX300IoNSOmcqzvOt/RLq6iZj0BVqrluBSW97hY6p5zodjo4U1Yb9JJ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=m0Gdap07; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="m0Gdap07"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e347638adso686679a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 19:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787106817; x=1787711617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xRPyHCi0h1GBGhDDK1sqVcFWzJLHUXUdR+otM3wSwgg=;
        b=m0Gdap07AW7ZkWK8oEOhIPuwiQeJ76OwSTuTA23IAhEVoYbAROy7wz1E3hxM5rq7HK
         aSUiWOGu5RmSuUmUON9GHf/VWq1KDV/J08nZhR98T2oApXXU0RjQoDddngZtP8FF+9Fr
         LtBj3dF17DRoOSRhXt6gM1Nq9LqvzjwDt8TiY9m2AsSBH+Wv1fqCI6h6ML86YoKVWkax
         6bBZp6AMrbMf7Upi+DqMSu3ZPbWvR3bHZHVfnFTU1OsYT+FalgVaJihG/z7S65f0ifzJ
         wtwo6ANELEbaG7c/93SpCkLpxZJQvldueFkFeKMbSrKAZdIStKPNwnLYNB/C99TyM00Q
         GnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787106817; x=1787711617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xRPyHCi0h1GBGhDDK1sqVcFWzJLHUXUdR+otM3wSwgg=;
        b=o2Cf7QlO6bNIQFy0Oq/Bq5mTOYt8fD+KDNn2+7x9DF6CZfZ0KJj0i4A2Ee+NX5rpZO
         W9IJbZ5jDpw0/ET1PojfBXcpfO7vdDVv9/pfj/1NrsqH5smFNMab3zGuJGs2qRjD1gI2
         Q5qc+YYWZs3gk+3osWnMBn4NgMVk7gVZ+C4hQf+7qbU/pQpuQ7dcggmpIHJFSW6WP/wo
         IIRvgkENln+aNo+C+c02W4AiNN9+OxSfvjz/h2jESS5OpdAAEhV13VNPJVyKEUpo/obz
         z4b85UVovHPpP4jX+0w0dBrDQnlp+Ay/1EgXg7FrgAaLifp7yyii6XWFqg3GHKrKPXlN
         nwbQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQ1+4oo4t2sEszGSUvj4OE3aYL5FET++JREAYcGzucRXE0XqxRl5uYJh17dBFCwoynndrf6VnSPehB@vger.kernel.org
X-Gm-Message-State: AOJu0YzxfNomMrA/D8mD5iTxmregsIcL0NQUX40c3DdD8aUyJ4pnwHPw
	44qv4cwu+2eVMTyDFs1EqkexbViOM4e+fOnC7VUgs5jsPkiOWX2VvJZ3weK0ErCo9UE=
X-Gm-Gg: AR+sD11PGon0sZqbJtMbpas1HRBqo/9WoC3AK/CZg8UHrFVZKvE3WM9W1cN6IiuFVu9
	cXiw3fBNlt75+cliefFsfdS+06X9h7IBAgyYeWAy5z3+D6IfgB2AosWrnElQpMAguiOD8Su+0K+
	G6/OFIRD7wOT6WgW4xyzpEMAXiX0IHB72ES/cohJnsq9ymOA9pJjSbeIeSCS48+o52AOGHD021W
	xJ1vBci09tLprPu1WutF78rEe1lPYWwyQK2Dfwkz+3CcRz6ZgVQ5XrnDnud4vfYzWjFAkcaHbjy
	1SwySwIAXgezbMHv8keiZVwOqC3/VmUAYqCLGIWgG4SdGRV+XBbqyDR4t9Ea+NTSD47g/Dm/Usb
	5bIsb4DJ3AHFsVSawHgzdcEmTTBPtix3iY2gMwX/rVsSkC4y3XlQ621uz33l8Sb7VtatQq1OKoh
	yQUiPe5g1zHzCf09NhHwckZuoKikRXig2nb4Xry3nvW9S+FoUoSbjdGCz/MZbw3Sx9pjX1
X-Received: by 2002:a17:90b:3fcf:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-39580ab840amr2698288a91.5.1787106816590;
        Tue, 18 Aug 2026 19:33:36 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f9aaa12sm786281a91.5.2026.08.18.19.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 19:33:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: leitao@debian.org,
	horms@kernel.org,
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
Subject: [PATCH net v7 3/3] net/smc: carry oversized SMC-Rv2 LLC messages in the queue entry
Date: Wed, 19 Aug 2026 11:33:06 +0900
Message-ID: <20260819023306.644849-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
References: <20260819023306.644849-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_llc_rmt_delete_rkey() and smc_llc_save_add_link_rkeys() read the part
of a v2 message that does not fit into the 44-byte union smc_llc_msg, and
both bound themselves by the size of the buffer it landed in, not by what
arrived. On a link with a shared v2 receive buffer a 44-byte
DELETE_RKEY_V2 declaring 255 rkeys reaches rkey[9..254] in whatever an
earlier message left in lgr->wr_rx_buf_v2, and passes each of them to
smc_rtoken_delete(). One of those 255 matched a registered rtoken and
deleted it. An ADD_LINK on such a link installs up to 255 rtokens from
the same bytes.

Copy the tail into the queue entry, so its length is the length of the
message that arrived, and declare the rkeys that fit inline as a member of
the union instead of reaching them through a cast. The same
DELETE_RKEY_V2 now processes the 9 rkeys it carries. The copy is limited
to the longest tail the two functions can read, so the peer does not pick
the size of the entry.

The bound the previous patch placed on links without a shared v2 receive
buffer is no longer needed.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Cc: stable@vger.kernel.org
Suggested-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Changes since v5: added the Fixes: and Cc: stable tags; asserted that the two
DELETE_RKEY_V2 layouts agree on offsetof(rkey); limited the copied tail to
what the two readers can use; corrected the comment in smc_wr_init_sge().

Measured over rxe with KASAN: a DELETE_RKEY_V2 carrying 12 rkeys over a link
with a shared v2 receive buffer round-trips all 12 values, the last three
coming from the copied tail; 8, 9 and 10 rkeys and a 44-byte message declaring
10 give 8, 9, 10 and 9 processed rkeys respectively. kmemleak reports nothing
over the link-addition path, and does report the queue entry when the free
added by patch 1 is removed again.

Five runs per cell with and without the new limit: a 44-byte DELETE_RKEY_V2
declaring 255 rkeys reports 9 processed on a link with and without a shared
v2 receive buffer, an ADD_LINK v2 extension installs the 6 rtokens the peer
sent, and no KASAN report appears. The only message the limit changes in
that lab is a REQ_ADD_LINK, which copied 16 bytes that have no reader and
now copies none. On the unpatched kernel the same DELETE_RKEY_V2 reports
254 and 255, and the ADD_LINK installs 255 rtokens per call.

Changes since v6: collected Sidraya's Reviewed-by; removed the extra
spaces after sentence-ending punctuation. No functional change.

 net/smc/smc_llc.c | 125 ++++++++++++++++++++++++++++++++--------------
 net/smc/smc_wr.c  |   6 +--
 2 files changed, 91 insertions(+), 40 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 748d65186f68..393aa0af18d1 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -157,6 +157,7 @@ struct smc_llc_msg_confirm_rkey {	/* type 0x06 */
 };
 
 #define SMC_LLC_DEL_RKEY_MAX	8
+#define SMC_LLC_DEL_RKEY_V2_INLINE	9
 #define SMC_LLC_FLAG_RKEY_RETRY	0x10
 #define SMC_LLC_FLAG_RKEY_NEG	0x20
 
@@ -177,6 +178,15 @@ struct smc_llc_msg_delete_rkey_v2 {	/* type 0x29 */
 	__be32 rkey[];
 };
 
+/* the leading rkeys of a DELETE_RKEY_V2 fit into union smc_llc_msg */
+struct smc_llc_msg_delete_rkey_v2_inline {	/* type 0x29 */
+	struct smc_llc_hdr hd;
+	u8 num_rkeys;
+	u8 num_inval_rkeys;
+	u8 reserved[2];
+	__be32 rkey[SMC_LLC_DEL_RKEY_V2_INLINE];
+};
+
 union smc_llc_msg {
 	struct smc_llc_msg_confirm_link confirm_link;
 	struct smc_llc_msg_add_link add_link;
@@ -186,6 +196,7 @@ union smc_llc_msg {
 
 	struct smc_llc_msg_confirm_rkey confirm_rkey;
 	struct smc_llc_msg_delete_rkey delete_rkey;
+	struct smc_llc_msg_delete_rkey_v2_inline delete_rkey_v2;
 
 	struct smc_llc_msg_test_link test_link;
 	struct {
@@ -194,15 +205,25 @@ union smc_llc_msg {
 	} raw;
 };
 
+static_assert(SMC_LLC_DEL_RKEY_V2_INLINE ==
+	      (sizeof(union smc_llc_msg) -
+	       offsetof(struct smc_llc_msg_delete_rkey_v2, rkey)) /
+	      sizeof(__be32));
+static_assert(offsetof(struct smc_llc_msg_delete_rkey_v2_inline, rkey) ==
+	      offsetof(struct smc_llc_msg_delete_rkey_v2, rkey));
+
 #define SMC_LLC_FLAG_RESP		0x80
 
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
@@ -998,22 +1019,19 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
 
 static void smc_llc_save_add_link_rkeys(struct smc_link *link,
 					struct smc_link *link_new,
-					u8 *llc_msg)
+					struct smc_llc_qentry *qentry)
 {
 	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
 	struct smc_llc_msg_add_link_v2_ext *ext;
 	struct smc_link_group *lgr = link->lgr;
 	int max, i;
 
-	/* Without a shared v2 receive buffer the extension is not copied
-	 * into the queue entry, so not even ext->num_rkeys is there.
-	 */
-	if (!smc_link_shared_v2_rxbuf(link))
+	/* the rkey count itself is only there if enough bytes arrived */
+	if (qentry->body_len < rt_off)
 		return;
-	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
-						     SMC_WR_TX_SIZE);
+	ext = (struct smc_llc_msg_add_link_v2_ext *)qentry->body;
 	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
-	max = min_t(u32, max, (SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE - rt_off) /
+	max = min_t(u32, max, (qentry->body_len - rt_off) /
 			      sizeof(ext->rt[0]));
 	down_write(&lgr->rmbs_lock);
 	for (i = 0; i < max; i++) {
@@ -1107,9 +1125,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
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
@@ -1510,9 +1526,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
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
@@ -1561,7 +1575,8 @@ void smc_llc_add_link_local(struct smc_link *link)
 	add_llc.hd.common.llc_type = SMC_LLC_ADD_LINK;
 	smc_llc_init_msg_hdr(&add_llc.hd, link->lgr, sizeof(add_llc));
 	/* no dev and port needed */
-	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc);
+	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc,
+			sizeof(union smc_llc_msg));
 }
 
 /* worker to process an add link message */
@@ -1597,7 +1612,8 @@ void smc_llc_srv_delete_link_local(struct smc_link *link, u8 del_link_id)
 	del_llc.link_num = del_link_id;
 	del_llc.reason = htonl(SMC_LLC_DEL_LOST_PATH);
 	del_llc.hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
-	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc);
+	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc,
+			sizeof(union smc_llc_msg));
 }
 
 static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
@@ -1819,27 +1835,28 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	link = qentry->link;
 
 	if (lgr->smc_version == SMC_V2) {
-		const u32 rkey_off =
-			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
-		struct smc_llc_msg_delete_rkey_v2 *llcv2;
-		u32 buf_len;
-
-		if (smc_link_shared_v2_rxbuf(link)) {
-			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
-			buf_len = SMC_WR_BUF_V2_SIZE;
-		} else {
-			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
-			buf_len = sizeof(qentry->msg);
-		}
+		struct smc_llc_msg_delete_rkey_v2_inline *llcv2;
+
+		/* The leading SMC_LLC_DEL_RKEY_V2_INLINE rkeys are declared in
+		 * the message itself, any further ones were received into
+		 * qentry->body.
+		 */
+		llcv2 = &qentry->msg.delete_rkey_v2;
 		llcv2->num_inval_rkeys = 0;
 
 		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
-		/* bound by the buffer llcv2 points at */
-		max = min_t(u32, max, (buf_len - rkey_off) /
-				      sizeof(llcv2->rkey[0]));
+		max = min_t(u32, max, SMC_LLC_DEL_RKEY_V2_INLINE +
+				      qentry->body_len / sizeof(__be32));
 		for (i = 0; i < max; i++) {
-			if (smc_rtoken_delete(link, llcv2->rkey[i]))
+			__be32 rkey;
+
+			if (i < SMC_LLC_DEL_RKEY_V2_INLINE)
+				rkey = llcv2->rkey[i];
+			else
+				memcpy(&rkey, qentry->body +
+					      (i - SMC_LLC_DEL_RKEY_V2_INLINE) *
+					      sizeof(rkey), sizeof(rkey));
+			if (smc_rtoken_delete(link, rkey))
 				llcv2->num_inval_rkeys++;
 		}
 		memset(&llc->rkey[0], 0, sizeof(llc->rkey));
@@ -2080,18 +2097,52 @@ static void smc_llc_rx_response(struct smc_link *link,
 	wake_up(&link->lgr->llc_msg_waiter);
 }
 
-static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
+/* the longest tail either reader of qentry->body can use */
+static u32 smc_llc_max_body_len(union smc_llc_msg *llc)
+{
+	switch (llc->raw.hdr.common.llc_type) {
+	case SMC_LLC_ADD_LINK:
+		return offsetof(struct smc_llc_msg_add_link_v2_ext, rt) +
+		       SMC_LLC_RKEYS_PER_MSG_V2 *
+		       sizeof(struct smc_llc_msg_add_link_cont_rt);
+	case SMC_LLC_DELETE_RKEY:
+		return (SMC_LLC_RKEYS_PER_MSG_V2 -
+			SMC_LLC_DEL_RKEY_V2_INLINE) * sizeof(__be32);
+	default:
+		return 0;
+	}
+}
+
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
+	body_len = min_t(u32, body_len, smc_llc_max_body_len(llc));
 
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
@@ -2123,7 +2174,7 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 			return; /* invalid message */
 	}
 
-	smc_llc_enqueue(link, llc);
+	smc_llc_enqueue(link, llc, wc->byte_len);
 }
 
 /***************************** worker, utils *********************************/
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 59c92b46945c..97ba46893b17 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -602,9 +602,9 @@ static void smc_wr_init_sge(struct smc_link *lnk)
 
 	/* With SMC-Rv2 there can be messages larger than SMC_WR_TX_SIZE.
 	 * Each ib_recv_wr gets 2 sges, the second one is a spillover buffer
-	 * and the same buffer for all sges. When a larger message arrived then
-	 * the content of the first small sge is copied to the beginning of
-	 * the larger spillover buffer, allowing easy data mapping.
+	 * and the same buffer for all sges. The spillover sge starts at
+	 * SMC_WR_TX_SIZE, so the leading bytes of that buffer are never
+	 * written.
 	 */
 	for (i = 0; i < lnk->wr_rx_cnt; i++) {
 		int x = i * lnk->wr_rx_sge_cnt;
-- 
2.43.0

