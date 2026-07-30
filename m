Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860143C048
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419494; cv=none; b=JbVan221QZKj9Ga+vKM9eZukz/lhFtCJQrVXP1o/YXC5TMdDs7SvQSc6BiO4EXH+6nFwvQRoaPwySjHC1LCDSuLssgNUekvAVxjI9bD18Oyz4XWSYfrRQkd6PSAmXBQ2OdWfaFOqkt+MTRs+L8J+JW6lViNIHc3YTqjN+vd1gOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419494; c=relaxed/simple;
	bh=QB9e6QYTLT37A6LTuNS/sb4KauOL1X5ahdqXD9i1vTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1aTJB+mHq5qpdMaLhrW00ZNu+HcyFwQw3BdXTTxya/6e+dYjL4v/WV2x/pdI6AdFavjezz0E+irtQMq1dVrwdW4vMotZMDsVvTw/h8XMHvbXf5SV68KOZicyAIXWKgm6UcipqZOjzFiPKHsQFy+vRlfifguGdU1xcfs1aNUz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=uo3T4GVU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="uo3T4GVU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cace91f112so24399875ad.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 06:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785419490; x=1786024290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G5jWHAkfCEMcKnx0C640iI/dheyfGkHjWmoTceE6bKc=;
        b=uo3T4GVU3p45165NdrOvHzCdF1ZY7+OQ1B8ajEsQEvHQg+pKxWgSndCRmvj1U6T9y9
         6Ye3R9CnX56eIx82gGd19EgzZEPMn6FSxxPjGktfke6XYpP7yagONplx1MoY/71ydbFT
         3UpW70J+nmvv5/T1rS87QNWgc/dKwqebH6tdRKzrE/aEZce1QG2jCdTmMiu/D8LC1DCp
         gEabf5dGdZ2C0Riw2JBV5Saqi20qOm3yauW/dQ8kHa39Xq5j4WM4sJAPfLs45gKNTL4j
         bSWH9/OYvLwYOvqzkTPpifysFW1ntAqvwrjw0lUikQfC0SU96t7FyTILYzjMIeo1k9YY
         n1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419490; x=1786024290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G5jWHAkfCEMcKnx0C640iI/dheyfGkHjWmoTceE6bKc=;
        b=jnyx9RDgGNAJrPdDrowB6nnSc3C6flDEqB2Js3EdzhDjAXgPe/cZmbPRKNlqk9osLc
         MXHi2bDR7vPt80y+d7W0vxHQBRRTS01Vzggu55XZ+PfovYInUHmiF1HRUKChInpNhku6
         tlzcczBe9iiSsGcvVSKDVjyVTWs9VH6dX6QpWTUc0p7cTGI4s/uFfT8CQUvGCUZyOVdS
         kFwJ6q9+y2iAax1+5kEq4ETn1/NUHBnngBcq+G5oLetve9wCUdxHk7elv4elLRIqEckW
         qVBH4PsBA2tEhpX3xX62evD/347ALG4EZ5zIXZnAcAHLs1EtHgHyROqPA4+6sJNStxEO
         DlHQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxcuIPEWFux0sHXzFWnelbp4/oeaXhHVdmNEZWYNZvCAwf4mScYL/RpehD3oSEqYkc0BKD4/vuc+mR@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe710KaHIfc2xIJFHdW4pf0n2peQIbN6C3Z3KfkHdXt5UHPW7u
	YhmoHyO5S/eLPS0A9XaptzStAWQwr8PxWtwwYb0+zeAZ+gZec94Sq7EfmEZpVZBc6Co=
X-Gm-Gg: AR+sD10tkPnyEjNikszqTEoGlxd6uaW8kJjKq3LPO7VRDqppuw5WuXoUnuWvj15KErL
	ix7fMiEr5hYtoEZ7YhUNaVQBN5kO9RRAeYlm2ecve43R9XwgvR+n9K/kscj6/IrCPbQmlx9q2QL
	AQ3aVyDX/uGEaW15QT5snpTrukqS5PfJsg6M0qcukIxkc/UCrT0ofmEwOaCd6fj467+8lQkciMx
	gg4z3Uf9jd0MunvDsURNpb00NsUcTX9yf0qrv4hdH+jFjBZnjJhPlLxNgcAbjKishO/tc1DoYiJ
	hX2ZWbIXafD8EAbVchJAIFTsQmFCcWPnQHesVVRBQo5zgAuiVYm8NfcKjhXYRu0hyXF+6/o1BU4
	0GoMcLRmfRKjG42dTAsK9eweiTnttTeQe0JCgUOx9dAbekN1tWUMmid+fUOyfAVTCAJ8zrj1cZg
	rp9syogohN+1TJhvqzQWSZK+giY5cobedq+8sQ5IS+7KUlbYIGdZGObWw7HMLuhUaFiLtU3Lamf
	Aq5GTZ0
X-Received: by 2002:a17:903:1b6e:b0:2cf:b330:e0e8 with SMTP id d9443c01a7336-2d035c1c815mr26373215ad.10.1785419489805;
        Thu, 30 Jul 2026 06:51:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c3721esm27804345ad.77.2026.07.30.06.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:51:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] IB/isert: reject full-feature PDUs that arrive before registration
Date: Thu, 30 Jul 2026 22:51:10 +0900
Message-ID: <20260730135110.1647384-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730135110.1647384-1-yhlee@isslab.korea.ac.kr>
References: <20260730135110.1647384-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The full-feature receive buffers are posted from isert_put_login_tx(),
which runs before __transport_register_session().  An initiator that does
not wait for the final Login Response can therefore still have a SCSI
command executed against an se_session whose se_tpg is NULL, with the same
oops as the previous patch.

Move the ISER_CONN_FULL_FEATURE transition into isert_get_rx_pdu(), where
it happens after the session has been registered, and reinstate the
connection on any PDU that arrives before it, the same call this function
already makes when a work completion fails.  The state is read without
isert_conn->mutex because isert_recv_done() runs on ib-comp-wq; the acquire
load pairs with the release store so that the session registration
preceding it is visible.

Measured over rxe with an initiator that fires SCSI commands into that
window without waiting for the Login Response, 400 login cycles per run:
the oops appeared in 7 of 10 runs with only the previous patch applied and
in 0 of 10 runs with this one on top.  The check fired 22 times across
those 10 runs, 16 in ISER_CONN_BOUND and 6 in ISER_CONN_TERMINATING, where
the reinstatement is a no-op because teardown has already latched.
Well-formed traffic is unaffected: 20 runs of a spec-conforming initiator,
400 login cycles each, pass with the check never firing.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v3: unmap login_tx_desc in isert_connect_release() (1/2); make the
    FULL_FEATURE store a release and the state check an acquire load, and
    log the value actually tested (2/2).  Both from Sashiko's review of v2.
    v2: https://lore.kernel.org/all/20260730063124.1554460-1-yhlee@isslab.korea.ac.kr/

Depends on 1/2 and must not be backported without it.

 drivers/infiniband/ulp/isert/ib_isert.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e117cd2e62c9..40290ab4bdb5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -956,11 +956,6 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 			if (ret)
 				return ret;
 
-			/* Now we are in FULL_FEATURE phase */
-			mutex_lock(&isert_conn->mutex);
-			isert_conn->state = ISER_CONN_FULL_FEATURE;
-			mutex_unlock(&isert_conn->mutex);
-
 			/* Sent from isert_get_rx_pdu() after registration. */
 			isert_conn->login_rsp_pending = true;
 			return 0;
@@ -1327,6 +1322,7 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct iser_ctrl *iser_ctrl = isert_get_iser_hdr(rx_desc);
 	uint64_t read_va = 0, write_va = 0;
 	uint32_t read_stag = 0, write_stag = 0;
+	enum iser_conn_state state;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc, "recv");
@@ -1335,6 +1331,15 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
+	/* A full-feature PDU before registration is a protocol violation. */
+	state = smp_load_acquire(&isert_conn->state);
+	if (unlikely(state != ISER_CONN_FULL_FEATURE)) {
+		isert_err("PDU received in state %d, resetting connection\n",
+			  state);
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		return;
+	}
+
 	rx_desc->in_use = true;
 
 	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
@@ -2598,6 +2603,12 @@ static void isert_get_rx_pdu(struct iscsit_conn *conn)
 	/* The session is registered by now; see isert_put_login_tx(). */
 	if (isert_conn->login_rsp_pending) {
 		isert_conn->login_rsp_pending = false;
+
+		mutex_lock(&isert_conn->mutex);
+		/* Pairs with the acquire in isert_recv_done(). */
+		smp_store_release(&isert_conn->state, ISER_CONN_FULL_FEATURE);
+		mutex_unlock(&isert_conn->mutex);
+
 		if (isert_login_post_send(isert_conn,
 					  &isert_conn->login_tx_desc))
 			return;
-- 
2.43.0

