Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795837064;
	b=gkoTjIBpX8oIlTp5gcBif8d+6WlsttTHZy9M+0S7sIgE3479mzR0PHtDIYHWQM8cZWRM
	 Gy8rIsf0oAeSaLbE/LCZYp1fib3yhLd9dHr8gVIL4LdCg2CMO5RzkvEvjAHC2Dyf2vSvq
	 ZAEpPSCW7Hq/+O+csYWGJOo86XeApQtRPkvLPgVEuTf2MiSYk2JKAa2QJ4oe6vDyzGK+J
	 XLgKqs4csKfimPzNW78V22CmnmnnWy9Td1pKQnST5pLM2wffkppOd+3G6NkcdImXWlonH
	 o422Rk9XINA1Y0OTiSw6TlRqtmRRcgYsw1IutOAOB+Q8JevBzOEXwAWbHSqtKGbu0YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795837064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CoOSrxK+y3duBfRBPRX/cABY+OCMf/PDrt2oQl6NHUg=;
	b=bGAhm0WSs4Vo4G1Rjim0iZU3xx4nmEaMegElpmTvKvK+Vo3nB54HOQSr+cwBsi9KJTdK
	 wvX4dQQvQ/tc28gWBcgK04If7Q1mIE2ZKujZQrcoyD/DDL7TmTYNwGiMkW+tTuE08tgUl
	 ta/nXFgzkssS7ErZL+KC9IyVYXbjkPBJRW1ZgfxU5u4AQaGmms6wJdzXk1U2W8G4cuWTb
	 Ajsu8lOhvx5KRQSuFfw78ifTbDSpTr3/xBPvcvr1TlzAGTxhqULtCaJ0rRpgHvRknQAbC
	 4btirgcHfcb9xxl6JNES1LJkxP9831odfDDREi8m/IH4EGXYS7UCD0B/vQv0tFVBbvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=ZVqfHwS0;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E1606A32C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 03:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD1E1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=ZVqfHwS0
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a070755c8cso4192665b3a.0
        for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 19:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795837063; x=1796441863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CoOSrxK+y3duBfRBPRX/cABY+OCMf/PDrt2oQl6NHUg=;
        b=ZVqfHwS0yY6hgOTchfvwgYvA39Vbn9CgOLbgnbOhlMuIrvLQo1S95FPGUYgXzRDkwi
         R4jeXPmLTI8dz76eAd5GrGUHAOINYeuavetVDJRVWkUyqg1D4UzwTim1ZyS3k0N9nFAY
         rbgGTTTZoVtxZDdwOXuDAMWkQ6EimirerceNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795837063; x=1796441863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CoOSrxK+y3duBfRBPRX/cABY+OCMf/PDrt2oQl6NHUg=;
        b=L0uespGZxh29mE+V4tIFJec9Fv40Fm5AI3jn9qbNx8v1HpPNFoRBdAH28XmcLZmm/S
         WvMXJoC6FUakgS5Pmp932RTZUb9mpliozxhP7D+0d0v4d7y0R2pGiQWl35vhK0r5Kmdk
         zu2wE+ZcOc7IaHIMywDoGzWfnnwxq997bRwEEQ+EI0a9n+d56bMFpETj7PP8YNxd0h34
         qn5Oy6peTMbTYdJ+BPcWm3f7ovHAYAFjFzLlepxyp0XiOydwjox+fItxByxVfd8MziMi
         49j78vqq0fgqctcoRW8Ew3NF12T8AgcqaE49/7MilzTZjZ88rxKKpr0EsxMkSV5O0qqU
         rTpg==
X-Forwarded-Encrypted: i=1; AL+hErGCMj6RzUOAO1Z643HfbGG8T984GJ2tTf8wY0J3ZYwaWjrYJf9OF3cpVd1p/CcDyzKZIlJ+106xW/Oj@vger.kernel.org
X-Gm-Message-State: APuU4Z9efpBqk+VhuSeH9U8+1nmM5+ue4WxBrHbFVJas+8FIJ5u4GaHA
	wtw7StDvhXTKCEbp37RsWLYj+0slLOgyf4JCEzvzKLpKar5ZR28ywfZubzQP48rnSYw=
X-Gm-Gg: AZFdTZeeT97C5rmNwBN3tjhquatyJ3aZKSKJ8EQu0JU8joGI4f3VtXKHV/0uGPkO5Mc
	LS6ip+SZ0NIIFJByqTbdNXoCoYUMIAACf4uu4pMoYtZvAohSvQIEzUP0mLb59HNZzMZqliJs1lk
	VN0w7khJaHSDV3acMkPXezJGINe581WSMBz9XlAvZDpezh397r6eRuFUUtawbHciFIYN0bWoDtT
	J08+nsdWA5ILrtrRw8C3fjoAAFvyAaawHib7dCmXA05+aFsAMSXCI7spp29qYdQR0Gnd9+pz5Rx
	F0iG9N0ovVXgJZk/AXkV/8ZGHIi6BM/1CpxSoLJBy7b3YcKUoSE3RoUqn8pPjq5g7dqP5vNvBXk
	8Yx+2Fx/TEkpJvMnm0VXlmYXknLsF73FZeqffimsCxV2ZnYHErVoNEzpk+l9tRpKKgl+ihD4Nyr
	I4AXZ0+5jcJyYQejTEXt2pp+Wxr/Wm6GmU6FH3ltYDQ+upmuyNMaO79IBIQoRp5RbYJkHbAWVPG
	sI687fhADGi1IaZgMBoBEjOTXn5dS0QNFNGH99Bl5eNCecqA8CMG82GTcfXjwfuZ/w0QcL8x66Q
	Xhdp+NdEJG/T+vSA/AkLAl+Gdf1i40Wm1XF2jA2AjRRIQ6iQttJnG8oqQaoUKyr8NtcHilaAa8O
	UvDlM6Lv6BJ7uiOfE7paVIGKR4Bl/k+U1TzuNxq80q7JDFbqfC/Ww1/hn+uOB6xyhCw==
X-Received: by 2002:aa7:88d4:0:b0:880:7dad:3e5 with SMTP id d2e1a72fcca58-8c87d12283bmr26030379b3a.51.1795837063176;
        Fri, 27 Nov 2026 19:37:43 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4aca2sm13517969b3a.32.2026.11.27.19.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 19:37:42 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: Allison Henderson <achender@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>
Subject: [PATCH net] net/rds: do not leave ic->i_cm_id pointing at a freed cm_id
Date: Sat, 28 Nov 2026 09:07:37 +0530
Message-Id: <20261128033737.467966-1-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
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

rds_ib_conn_path_shutdown() frees the connection's rdma_cm_id and only
clears ic->i_cm_id afterwards:

	rdma_destroy_id(ic->i_cm_id);
	if (ic->rds_ibdev)
		rds_ib_remove_conn(ic->rds_ibdev, conn);
	ic->i_cm_id = NULL;

rds_ib_remove_conn() takes locks and can sleep, so the pointer is left
pointing at freed memory for a while.  Both FRMR paths read it with
nothing that excludes this teardown - rds_ib_get_mr() from sendmsg()'s
RDS_CMSG_RDMA_MAP handling, and rds_ib_unreg_frmr() from the MR pool
flush - and the NULL test in rds_ib_unreg_frmr() does not help, because
the pointer is not NULL, it is dangling:

  BUG: KASAN: slab-use-after-free in rds_ib_unreg_frmr+0x119/0x860
  Read of size 8 at addr ffff888022d67010
   rds_ib_unreg_frmr+0x119/0x860
   rds_ib_flush_mr_pool+0x685/0x9f0
   rds_ib_flush_mrs+0x57/0xc0
   rds_release+0xc9/0x220
   __sock_release+0x65/0x160

  Allocated by task 37:
   __rdma_create_id+0x48/0x4f0
   __rdma_create_kernel_id+0x3c/0x80
   rds_ib_conn_path_connect+0xfa/0x320

  Freed by task 9508:
   kfree+0x1c7/0x660
   rds_ib_conn_path_shutdown+0xc2b/0xd30
   rds_conn_shutdown+0x3ca/0x940

The same dangling pointer reaches the registration side, where a fuzzer
found it posting a work request to the QP of a cm_id already destroyed -
rxe reports that as "qp has been destroyed" from its own
WARN_ON_ONCE(!qp->valid) and then faults on qp->state_lock.

Clear ic->i_cm_id before destroying it, so a racing reader sees NULL
rather than freed memory, and check the pointer in rds_ib_post_reg_frmr()
the way rds_ib_unreg_frmr() already does - it is the one FRMR site that
dereferenced it without a test.

This does not serialise the two sides: a reader that has already loaded a
non-NULL pointer can still be preempted before using it.  Closing that
would mean giving the registration path the exclusion the other users of
ic->i_cm_id have, which is a larger change than this one.

We found this with a syzkaller-based fuzzing harness driven by an AI tool.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
Cc: stable@vger.kernel.org
Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>
---
 net/rds/ib_cm.c   | 12 ++++++++++--
 net/rds/ib_frmr.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 16bfeaaf3b97..17d748f08607 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1077,6 +1077,7 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 {
 	struct rds_connection *conn = cp->cp_conn;
 	struct rds_ib_connection *ic = conn->c_transport_data;
+	struct rdma_cm_id *cm_id;
 	int err = 0;
 
 	rdsdebug("cm %p pd %p cq %p %p qp %p\n", ic->i_cm_id,
@@ -1178,7 +1179,15 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		if (ic->i_recvs)
 			rds_ib_recv_clear_ring(ic);
 
-		rdma_destroy_id(ic->i_cm_id);
+		/* Clear the pointer before freeing what it points at.
+		 * rds_ib_unreg_frmr() and rds_ib_get_mr() read ic->i_cm_id
+		 * without holding anything that excludes this teardown, and
+		 * rds_ib_remove_conn() below can sleep, so a pointer left
+		 * behind here is one they dereference after the free.
+		 */
+		cm_id = ic->i_cm_id;
+		ic->i_cm_id = NULL;
+		rdma_destroy_id(cm_id);
 
 		/*
 		 * Move connection back to the nodev list.
@@ -1186,7 +1195,6 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		if (ic->rds_ibdev)
 			rds_ib_remove_conn(ic->rds_ibdev, conn);
 
-		ic->i_cm_id = NULL;
 		ic->i_pd = NULL;
 		ic->i_send_cq = NULL;
 		ic->i_recv_cq = NULL;
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 8397aa4a17ac..09e732ac2324 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -124,6 +124,7 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 {
 	struct rds_ib_frmr *frmr = &ibmr->u.frmr;
 	struct ib_reg_wr reg_wr;
+	struct rdma_cm_id *i_cm_id;
 	int ret, off = 0;
 
 	while (atomic_dec_return(&ibmr->ic->i_fastreg_wrs) <= 0) {
@@ -164,7 +165,16 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 			IB_ACCESS_REMOTE_WRITE;
 	reg_wr.wr.send_flags = IB_SEND_SIGNALED;
 
-	ret = ib_post_send(ibmr->ic->i_cm_id->qp, &reg_wr.wr, NULL);
+	/* Check it the way rds_ib_unreg_frmr() does: the teardown clears
+	 * ic->i_cm_id, and nothing here excludes it.
+	 */
+	i_cm_id = ibmr->ic->i_cm_id;
+	if (!i_cm_id || !i_cm_id->qp) {
+		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
+		ret = -ECONNABORTED;
+		goto out_inc;
+	}
+	ret = ib_post_send(i_cm_id->qp, &reg_wr.wr, NULL);
 	if (unlikely(ret)) {
 		/* Failure here can be because of -ENOMEM as well */
 		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
-- 
2.34.1

