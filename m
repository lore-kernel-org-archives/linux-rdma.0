Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B8044C658
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835400; cv=none; b=H7Q29pP8WhpliiLYcNLRZrtLUk89sUdxfxeXJFuBte9PXbWORxUyF9jo3pCHS9Gl9x1aJyIrK2H1JFCHTBKbRnQyklNklfiRcYVfjsKZxW4QiLiHXRdcfrumX8yTHejOEZAVAw70RQ/qagl9Poj3q9SW19tWpCfI6yacrD4kfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835400; c=relaxed/simple;
	bh=zb4rhB7Mz3MmEfbG4+wb0PrLh1sJ1yqihfZR2ime010=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S/+Z3NE6/q06Y/7B39/S5jxvOZ/17HSiwfN2ZEH0U/Sww2jrUHtZwRtKqK4JfoNyapqNZDtQcztmhZSIL8vL4hNjOaSDkxM2U6qy/Hs3e4TeLkXL9FLZgjxEjWW2ulPrXtt9naHOtExG/CZ7gXydenYdh8KZdgBjmHYymQHonOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vZcnFhz5; arc=none smtp.client-ip=91.218.175.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vZcnFhz5"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zb4rhB7Mz3MmEfbG4+wb0PrLh1sJ1yqihfZR2ime010=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787835377; v=1; x=1788440177;
 b=vZcnFhz5sNDQ64FraBMEvc1+ZJrnMbMuK8PS6l+p3OKmkFspbRvnXJLPyOvYofCxF2Awrtja
 XRZBHZ0Ggqay7eSDLmuwAqWmlcuaIM46yxDMJNxoF+syFEjlEhVoWnNOCtYUx0HYpkoC1eBaJOC
 dcbisR0lFKEmpb3UozI5fqlQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 9b1669a1a0009215;
	Thu, 27 Aug 2026 12:56:07 +0000
X-Mizu-Trace-ID: 9b1669a1a0009215
X-Migadu-Flow: FLOW_OUT
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: bernard.metzler@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	shuangpeng.kernel@gmail.com
Subject: [PATCH v2] RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept
Date: Thu, 27 Aug 2026 20:55:53 +0800
Message-Id: <20260827125553.12831-1-guoqing.jiang@linux.dev>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to clear cep before release state_lock as siw_qp_llp_close and
siw_qp_modify->siw_qp_llp_close did.

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

Clear qp->cep and drop the association reference taken by siw_cep_get(),
all under the write lock held from the initial down_write(&qp->state_lock).
Thread B therefore sees qp->cep == NULL, skips its own put, and cannot free
the cep before siw_accept() is done with it.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://lore.kernel.org/linux-rdma/d6fbe475-a5c2-f975-99b0-a0bd6b6d10e8@linux.dev/T/#m5876c1ff2de8686a9a1173b8f1aa0ff5363a785c
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
V2: remove redundant code per Bernard's review

 drivers/infiniband/sw/siw/siw_cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 0245b25e7271..ed49818793dd 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1719,9 +1719,12 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 			   SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
 				   SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD |
 				   SIW_QP_ATTR_MPA);
+	if (rv) {
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

