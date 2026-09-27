Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368B12DECA1
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 07:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790495171; cv=none; b=W2ebU8flcyo0yuBVj1GGcrDck8Lxjm8UZptPFtTREKRRMqpX9oFhXG+fIR990BarBBbHzGCMZZsp2A/v3vyDz3nYUIpMQFLtDPlX7X5w8PxrlMZNLoHvvb9rbK8Z8o/EpwpEBllMWA6OWEmcq40zsnEp4RBXafq9rnbxdpmU07I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790495171; c=relaxed/simple;
	bh=RGhJnf5GbbdO545DxKKBzB6+35VcnLhNLOUQSqAUEl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uxcmhD+uybsxgVBkZtD6SSJH/a6/QDe29ptTgA8dcersIaFooEmcYy2yLITh1sKzTCsjes1dpz1Pa0Bm7TM0kOv2zsl/hVn4PL729ku9+aINR39ztC28umKz0tiaynCEi8tMhLXxJJiWOTfMMvA6l85xpySeYsDCIloADa7k4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2FK8QLV; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2FK8QLV"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-144fa6e60bcso79178c88.0
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 00:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790495169; x=1791099969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XIpYdnljm+rKdqL8zP6PbZGg5j820vV/IvXVHPJ2WOA=;
        b=h2FK8QLVwACU5o/ZNPTaVM4zpfnJPHq0ujCxHqI9ZIeLYN6T7vHzQXYHbOcrX1AYP0
         fSszXplsQOGFg2rt9dpRt86mZmTibxeiPqsr611VfOmsifCbFsaV7YrPWhNgr9Im6fON
         bfyKEIYzzBEwuVDxvFJnENRBgC+H+2tWpW4xYlazWb+SzqLjxA4kpbdmJHSeBfZNxMYn
         oTakB3p8OnZWTAAAAHqgJSQyqglk19R8wT+91sUckFJYOXqeJveZ6RUgmgdbT2sDLjhl
         1fa5P5qvmwr5jCt+qulAHSEmYifbuOywhlW46fl9ZbeGV7q5xcZGT/0qQ4W8lnC7NTRr
         jVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790495169; x=1791099969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XIpYdnljm+rKdqL8zP6PbZGg5j820vV/IvXVHPJ2WOA=;
        b=vp5+s/mfE8qFuzAyruzs/D/5mdxPkqLo6pem6y0btvtK2B6vD3hzzRSun8qAepMaNk
         +9tuvS2MgEGvVwmNwNfHnIFbGatbSRNP8suW9AdIgNrCGm8dlt804YJaB8IjVSOh0Ag2
         X6Yppvlh1MxMfVbi99dDnV0ouYAmg7BWYDJEPNYg11mCiOXbnzTDL7O2pSkmixWvzlV0
         optcOBTkaJYplJzkHWBIM+HcMg54Zwvo2IpDcxBFllxVi77oXVHHxJKV2b9JIoeYoLUz
         NUclq6rcSzS7GIMxMll/F1LMsVokhyh6/yjfI3DtsxhhQ54MQMBahn8Pr/1Y93zmgojj
         D5Kw==
X-Gm-Message-State: AFuF++kv+KGpdpTyyGODB0oKWzQx00udKKqlbLqv1fxRzT4XhJIsUQK/
	AZgcUWGhU1D1I398FeSayNO5czQQ5JtpLyDvzRVUsxRahxUbvC28aK/C
X-Gm-Gg: AYBFou0o3F7RYgNyCV36z1FCc0kVbZYtClDFVKoihO1o2IWOhkyI9wlh0gYjDUXqRGG
	d+KH9bFyXHBWQNwBksh5RLrx7Tg97NZ5ZZ21qmsku6z8XUFdw5lVT2+g481r9GcoQe2KXKZP3Oy
	NjrnmLPLRsofRvLMLrzTyJ+dJY3gcynGEuao2697121K/UQZWgZJKf+Bg3alg6dh66TQ+baZ2NE
	lHTC12jDqRVCRdoG9Iuqt4IgQ2TwATguxubYGXh4bZPxHnl5O3ByUAxjiOG5c0sBlGWPImeTToS
	OA6DHynHvmuDGln0LrBoT/zaoWDzAWvlMPMTSFJibCyQTZPFGELYX2ISAtVeAPyDDJ32jReT/jG
	yGFauWZ3cr5VQL2NjPAGCxWfoDzHGzHSMBN70oP/EmfTSzg5fQT4pBjor0VFQ52Fn5I0yDOEfjh
	QPHDwsScUBv66a+t34hXPuagumDtQ5YZMQb8C4WZNV8BLvaPHFEFsyUyRvdjtD59yBYjwZ42xGL
	rA1rhGxqbjuK5jU/5q6mG/BrbnqEm/P3kcm1xaj2KduEkXFqT+kLxY4GxE7ZKe6BuiblE8=
X-Received: by 2002:a05:7022:1504:b0:143:858d:fb0e with SMTP id a92af1059eb24-146caf2aafcmr10000211c88.0.1790495169220;
        Sun, 27 Sep 2026 00:46:09 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145adcc5b00sm17025244c88.15.2026.09.27.00.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 00:46:08 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net/smc: Serialize CLC preparation with link teardown
Date: Sun, 27 Sep 2026 15:46:00 +0800
Message-ID: <20260927074600.3694802-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smcr_clc_prep_confirm_accept() reads the RMB memory region and scatterlist
without holding llc_conf_mutex. The connection's link reference keeps the
link object alive, but does not prevent smcr_link_clear() from unmapping
its buffers and destroying its RDMA resources.

The CLC handshake can load the scatterlist pointer, then an LLC delete-link
worker can acquire llc_conf_mutex for writing and free the scatterlist in
smcr_buf_unmap_link(). When the handshake resumes, sg_dma_address() reads
freed memory. The memory-region rkey read has the same lifetime problem.

KASAN reported:

  BUG: KASAN: slab-use-after-free in smc_clc_send_confirm_accept
  Read of size 8 at addr ffff88810efcdfd0 by task poc/94
  Call Trace:
   smc_clc_send_confirm_accept
   smc_clc_send_confirm
   __smc_connect
   smc_connect
   __sys_connect
  Allocated by task 94:
   __sg_alloc_table
   sg_alloc_table
   smcr_buf_map_link
   __smc_buf_create
   smc_buf_create
   __smc_connect
  Freed by task 11:
   kfree
   sg_free_table
   smcr_buf_unmap_link
   smcr_link_clear
   smc_llc_delete_link_work

Hold llc_conf_mutex for reading while preparing the SMC-R message,
including the QP accesses. Reject unusable or cleared links under the
lock so that teardown completing before preparation is also handled.
Keep activating links valid for first contact and release the lock
before sending over TCP.

Preserve the preparation error in both CLC send wrappers when the TCP
socket has no error recorded. Otherwise the new -ENOLINK return is
converted to success. Existing TCP errors and short-write handling
retain priority.

Fixes: 541afa10c126 ("net/smc: add smcr_port_err() and smcr_link_down() processing")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/smc/smc_clc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 014d527d5462..6b9e64a5b9d0 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1169,14 +1169,21 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 	clc->hdr.version = version;	/* SMC version */
 	if (first_contact)
 		clc->hdr.typev2 |= SMC_FIRST_CONTACT_MASK;
-	if (conn->lgr->is_smcd)
+	if (conn->lgr->is_smcd) {
 		smcd_clc_prep_confirm_accept(conn, clc, first_contact,
 					     version, eid, ini, &fce_len,
 					     &fce_v2x, &trl);
-	else
+	} else {
+		down_read(&conn->lgr->llc_conf_mutex);
+		if (!smc_link_usable(conn->lnk) || conn->lnk->clearing) {
+			up_read(&conn->lgr->llc_conf_mutex);
+			return -ENOLINK;
+		}
 		smcr_clc_prep_confirm_accept(conn, clc, first_contact,
 					     version, eid, ini, &fce_len,
 					     &fce_v2x, &gle, &trl);
+		up_read(&conn->lgr->llc_conf_mutex);
+	}
 	memset(&msg, 0, sizeof(msg));
 	i = 0;
 	vec[i].iov_base = clc;
@@ -1227,7 +1234,7 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 			reason_code = -ENETUNREACH;
 			smc->sk.sk_err = -reason_code;
 		} else {
-			smc->sk.sk_err = smc->clcsock->sk->sk_err;
+			smc->sk.sk_err = smc->clcsock->sk->sk_err ?: -len;
 			reason_code = -smc->sk.sk_err;
 		}
 	}
@@ -1246,7 +1253,8 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	len = smc_clc_send_confirm_accept(new_smc, &aclc, srv_first_contact,
 					  version, negotiated_eid, ini);
 	if (len < ntohs(aclc.hdr.length))
-		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
+		len = len >= 0 ? -EPROTO :
+			-(new_smc->clcsock->sk->sk_err ?: -len);
 
 	return len > 0 ? 0 : len;
 }
-- 
2.43.0

