Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E358013B293;
	Fri, 26 Jun 2026 01:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782439176; cv=none; b=XZzWvvMuyfPMCS8/QGXDYi8kdoPN2iu3tCRAa8b8yeEbPIj2s5Vktzo0sh5gnrQr5CUFCfspWUGTjiX41J7K1Zq94BSAIylAyBK7yv+G7HQaD0Ax3uxPKzmS9nJuhkDCMLmZqhfhS1Fwdjj8/Uyzj0J5W1kuUG8ohZH7Ued4u+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782439176; c=relaxed/simple;
	bh=QU4VQ1NI2vmvU3yni1jO0ItWKCzbj6dXF9gr1V43mNw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=HtPOd+VsoxbGSHGwroWRxt0g/ES790Oe/7hQruJ6jEX2O2UnHQOGjGs9JGvjrYNkVEwtGkBSyTBuwhWdypPz1phuvi5vXyhv+CEF1uNFajFgoqNQbw+D7Is4cQIjwqXQ1BIaghnFYHFR2+2NlFobKRitTxpPn8K+AU6ZDLt15DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ZDwKBhex; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ZDwKBhex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782439165; bh=gHs8BzXaityAs9x7go1yQ94PsWKxnAwQ7y1DYOue/hk=;
	h=From:To:Cc:Subject:Date;
	b=ZDwKBhexiFVGM/bGMG+0hJlDkl2UUmNCvjRiJVB5CBecJZTUJJA5dVPJVTWAHT9t5
	 9Bv1G8aIxT8tQSelv5+i5yP99yk+ShRimCAJMrMcJaHzH2LOKHE8VwihYl9hX1hFCV
	 IZG4zUeSsdj1IupCOQwtvnoQZ7PYD66ctYrqUQJo=
Received: from localhost.localdomain ([140.207.156.139])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id ED7088BC; Fri, 26 Jun 2026 09:59:23 +0800
X-QQ-mid: xmsmtpt1782439163tgj8a2orl
Message-ID: <tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com>
X-QQ-XMAILINFO: MWBbVm9/0ltknOqqYzp4/8SXEi0plpZfft52ZJqeYX4a8SUzzAIt2YaMaygDZQ
	 vFhtLDA2k6lP9cQ2PyiGTTNhGZUTYgLzAHqJqY7nVkRBtBWYL8UA+0s82O4+u0/HahDe5rqjmR7w
	 QjlhBeh9nlsqCAJ92G15LCqEMO0eNPaAVJ7LumeVl30+XaHEzVrrzv/8VqzhqNX8BqSnCUd7jMrw
	 doxMppRThF7slR7Emr6XGf/Ew6EEgm4C4YhEWFV3hExVhyV44WXgCjHHXxI5A6QslyxJcSAA8YPe
	 vPGG/P/8ZTOsxdBOd++XFJIByV7zq25mbU5uc6uEjLLGjbptqyXo/r3jI/coD9lIuVUFmAUUvZ6t
	 uKhmxe9Rbvizi8pPZ/RBJlXhc1tVDgXS5WoXWIIyJtSHa7ll+pyC5IROpkGweitthKTfilLJ5QK5
	 W4zCS/yT7VDUoJzc+bupVkslSiuZ7noXt1M6XdZw2qiFO8HFntflRNEDtN9srx+fIG/0u4x9LBqD
	 G78F4yD1fY8onQZUNUJNBjV2ORMHIaAqHyVgkDoPOezSuCmhBqsOIKCmP5/G9agA5S1UCo0mERHf
	 ppmDoo5WHF8z203XAWadrR5OEtZ0u7uZuFcKTLB/35m1cLMvLe2ZuliRFQlcTxevNXl/h6qDO6Y4
	 zYcPcPzXfTgCqe8qMrJ2NKkBlrRRO9jZI6ADPX17KPtj96cF4MCa3Sfv9wf7XH3SK+tz2rrVmtC4
	 NaV7FJodqKMPHR/77jR2x7vxP6BGG0nOWmAeolzVDntTJDd366pWivanj+H2ePYnE6AOHSZQwb2Z
	 4a4BXKvoz6Eh5IdK5MGJFZpjDl/+VueGWqe5/uJl10Td2uH/E73kSgzcgflNzAK0eX5RamQ4e4px
	 K5XOs1s10Bw6HbckhHAcDq5nVLjeWOPtrgEnYRTZ5rSeCCpUp6S4Xt0PQBaWmPqHOXw1AKREFc4k
	 8WvxClYNMiEgBxEWI7TpukJkXyw9Nyv7Cm1W4XrDuPfevWoPeQRKT03m6BvMcoXs2xTvya263DfQ
	 axJDGb+q3MmtExtpkxYk44dfgI+cFvWeBmY/vBmTL3cRViXjsC63PsKw0StIKxWRf6NFf/BzKfsx
	 RqjjcDcrwNyHGwaXQ+RUxRzERQAA==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Zhiwei Zhang <202275009@qq.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiwei Zhang <202275009@qq.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v2] RDMA/rxe: Check PDs for memory window binds
Date: Fri, 26 Jun 2026 09:59:20 +0800
X-OQ-MSGID: <20260626015920.48132-1-202275009@qq.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IBTA Software Transport Verbs specification requires the QP,
Memory Window and Memory Region for a Bind Memory Window operation
to belong to the same HCA and protection domain.

rxe only checked the QP and MW protection domain for type 2 MWs.
Move the QP/MW PD check to the common bind path and also reject
binding an MW to an MR from a different PD.

Invalid bind requests continue to fail with IB_WC_MW_BIND_ERR.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 379e65bfcd49..bddb7a257831 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -72,13 +72,6 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			return -EINVAL;
 		}
 
-		/* C10-72 */
-		if (unlikely(qp->pd != to_rpd(mw->ibmw.pd))) {
-			rxe_dbg_mw(mw,
-				"attempt to bind type 2 MW with qp with different PD\n");
-			return -EINVAL;
-		}
-
 		/* o10-37.2.40 */
 		if (unlikely(!mr || wqe->wr.wr.mw.length == 0)) {
 			rxe_dbg_mw(mw,
@@ -87,10 +80,21 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		}
 	}
 
-	/* remaining checks only apply to a nonzero MR */
+	/* C10-72 */
+	if (unlikely(qp->pd != rxe_mw_pd(mw))) {
+		rxe_dbg_mw(mw, "attempt to bind MW with qp with different PD\n");
+		return -EINVAL;
+	}
+
 	if (!mr)
 		return 0;
 
+	/* remaining checks only apply to a nonzero MR */
+	if (unlikely(qp->pd != mr_pd(mr))) {
+		rxe_dbg_mw(mw, "attempt to bind MW/QP to MR with different PD\n");
+		return -EINVAL;
+	}
+
 	if (unlikely(mr->access & IB_ZERO_BASED)) {
 		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
 		return -EINVAL;
-- 
2.51.0

