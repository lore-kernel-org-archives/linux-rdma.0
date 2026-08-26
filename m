Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 5E65B3B059C
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 07:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787729560; cv=none; b=vGoZ2mpPy4z3pj46Oe8r5LMksIc5iiX5jUbFHG2sxwxScPSyUGT6HCdgn8n1Q7ZMQ+ROlM3UNORYtB0SBrKbR5CYEV+LVkAaVMZ8XiYPPizVO2lD9L0Y5X5wEFVZd9OBczQyojkp2nQcJq0wASuvpZlzNf3xInJP2DemtgvwPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787729560; c=relaxed/simple;
	bh=cpWgN+5qNsJ9I26UEW52j+l/sZk42tyG0W1nTusqDaI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W9fUUAjFelg05cBxOGPIkzFyfkgFZO+oWBTbZH6lxULUB0CjwYCORZf54El+cWW1YRb3Nxy9I1y930AyEee8ig8P/vsuvl47g7L6o3HigDoWfIpSaB+iuU+wxa5ECSCFbbLufMPMgPuHpFcsZZDKQa7g/1zbcj1tqFekrmAFzlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=Cpp00MMu; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="Cpp00MMu"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Michael Bommarito
	<michael.bommarito@gmail.com>, Kees Cook <kees@kernel.org>, Daniel Jurgens
	<danielj@mellanox.com>, Doug Ledford <dledford@redhat.com>, Paul Moore
	<paul@paul-moore.com>, <linux-rdma@vger.kernel.org>
Subject: [PATCH] RDMA/mad: Fix receive buffer leak when PKey enforcement fails
Date: Wed, 26 Aug 2026 15:32:16 +0800
Message-ID: <20260826073216.2367-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc14.internal.baidu.com (172.31.4.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1787729545;
	bh=xO2ug/IKX8m+ZXwloLUHSVP68fNywlrCPMOh8q0KmeY=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=Cpp00MMuvlCoRFD7ze7WPtNCySm0pd+oJF5yJvltGg1cTvGQarIjg/gdSiA+2BNbI
	 6AZC+VOYmNC5T2in+72V4+Cv2CoWtDqrRyni16eGPQtFShpXpo9JeY7y+OUG6Gl5rp
	 xYPWlvIuLiOrFDopRZq9iDkveCl4FemGCQZ33w9cRBFNYTAPj+zLPNz+GiPQCdakLr
	 PgbcG1nAaWO3HkhWDgjABMYIdWvozPocOSypN/ANi4jGzfgl13OhmkCifvHF0PDNnT
	 6bKcr4ORAcc8nEL5gizBVucFxyndpwpHPAdux4pPXHT8QPbOzKhao33jwF9waX+KzV
	 1j8u1o09bL44w==

From: Li RongQing <lirongqing@baidu.com>

ib_mad_complete_recv() initializes mad_recv_wc->rmpp_list and then runs
ib_mad_enforce_security() before linking recv_buf onto that list.  On
failure it calls ib_free_recv_mad(), which only walks rmpp_list and frees
the ib_mad_private of every buffer found there.  As the list is still
empty at that point, nothing is freed at all.

The caller cannot clean up either: ib_mad_recv_done() sets recv to NULL
right after ib_mad_complete_recv() returns, assuming the MAD layer took
ownership of the buffer.  Every MAD that fails the PKey check therefore
leaks one ib_mad_private (about 300 bytes per IB port MAD, ~2K for OPA),
and a remote node can trigger this repeatedly by sending MADs with a
wrong PKey.

Link recv_buf onto rmpp_list right after the list is initialized, so the
error path has something to free.

Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e0b3b36..3c91f00 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2059,6 +2059,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	int ret;
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
+	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
+
 	ret = ib_mad_enforce_security(mad_agent_priv,
 				      mad_recv_wc->wc->pkey_index);
 	if (ret) {
@@ -2067,7 +2069,6 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 		return;
 	}
 
-	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
 	if (is_kernel_rmpp_data_response(mad_agent_priv, mad_recv_wc)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-- 
2.9.4

