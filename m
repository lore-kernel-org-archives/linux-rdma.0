Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF4145FFCB
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 13:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787663430; cv=none; b=Ncv4KgCWxt6AHAAaSOlXEDdi1dUtO5qB2r+vjJtogYAdMuCN9qOCwgq9YyUBkAIdnrys8lcXM+RCDbvnlnmuDknC9cMZNgw4W7HtoxAjtZCUteag/UhE63VBHClrF6GcpUdFxtdAUjf1NMLdpY7t/2wLcKJAK7R5rHk55i64dsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787663430; c=relaxed/simple;
	bh=FaBBSgLjsz+bldIPQLmqSepVoC8u1Dj6ENkrPVh4moY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IMLzWj/1YrIUrSD6Aak5ZjKtlwBroSwn3RbIWmCEOB/iN9RrIF41a2hZU+GopnQuxzYeJ/M9Gu3MZ+Cybo9AY8a3ymyLbb8GPOYmNoZY7soFQvO7Z/gi00qpLKibfqhnnD/mSgi5BgH+qXZRt/y98Tt42ZYlxQ5cVoe4VXq06nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ln2vXy5h; arc=none smtp.client-ip=95.215.58.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ln2vXy5h"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FaBBSgLjsz+bldIPQLmqSepVoC8u1Dj6ENkrPVh4moY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787663417; v=1; x=1788268217;
 b=ln2vXy5huuPDOTIMJ4XNp8UDQSCqmDIJG37LFZQiV+G5BAGIP4Dfu107zgYh5dzNnrmCD62e
 DAeYpa+xUZgszLL4BEXVdwLXmoB/w78GOlH/fy+C7GQkh6EUJlLSAHjMMi19ewS3q9jgcnA4/CB
 T/GE+POnDwA9jBCqVTEnBvPM=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from pc.lan (123.123.40.40)
	by mta11.migadu.com with ESMTPS id a19674a4a580c3b1;
	Tue, 25 Aug 2026 13:10:07 +0000
X-Mizu-Trace-ID: a19674a4a580c3b1
X-Migadu-Flow: FLOW_OUT
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: bernard.metzler@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	shuangpeng.kernel@gmail.com
Subject: [PATCH] RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept
Date: Tue, 25 Aug 2026 21:09:54 +0800
Message-Id: <20260825130954.27327-1-guoqing.jiang@linux.dev>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to clear qp and cep before release state_lock as siw_qp_llp_close
and siw_qp_modify->siw_qp_llp_close did.

Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
is released before the error path cleanup. A concurrent ibv_modify_qp()
transitioning the QP to ERROR can race in this window:

  siw_accept()                       ibv_modify_qp(ERROR)
  ----------------------             ----------------------
  siw_qp_modify() fails
  up_write(&qp->state_lock)
                                     down_write(&qp->state_lock)
                                     nextstate_from_idle():
				     if (qp->cep)
                                       siw_cep_put(qp->cep) <- frees cep
                                       qp->cep = NULL
  goto error
    cep->qp = NULL                   <- UAF

Clear qp->cep and cep->qp, and drop the association reference taken by
siw_cep_get(), all under the write lock held from the initial
down_write(&qp->state_lock). Thread B therefore sees qp->cep == NULL,
skips its own put, and cannot free the cep before siw_accept() is done
with it.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw_cm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 0245b25e7271..1573f2e888b2 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1719,9 +1719,13 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
 				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
 				   SIW_QP_ATTR_MPA);
+	if (rv) {
+		cep->qp = NULL;
+		qp->cep = NULL;
+		siw_cep_put(cep);
+		goto error_unlock;
+	}
 	up_write(&qp->state_lock);
-	if (rv)
-		goto error;
 
 	siw_dbg_cep(cep, "[QP %u]: send mpa reply, %d byte pdata\n",
 		    qp_id(qp), params->private_data_len);
-- 
2.35.3

