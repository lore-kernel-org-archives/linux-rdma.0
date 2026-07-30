Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB9A34CFBA
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415777; cv=none; b=MgVyszMEz0BGiuF+wSPfFZBO0tUGiUQ2vgVhNAOccfwJ3fFINvOoD7y+TKSIuzDA15R9KhDdgQBcvwhTRbOF8E9FVE3b7vrI3pyJfRWj6LfffSyo9Onu6e5IY2BQcA4M+rlvKsMF8enn9onEim6XoxSyR+MMFQVBNLedbJGGre4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415777; c=relaxed/simple;
	bh=1Y3ZQ1TKIJkc4kACuIDhf9ohi4wy16dgGTGE0gJs3MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBp5e5pzUjLw9jz12VxP4okjXeR3lAAOpCt6hw0QpaPtsSTpuA0KgShviSqZAJwMvBgQB6C3c4OA0udZxeNiB2YQO33TTMF4KVos6kgws4cZsb9MviWnEJnlgY0gU8IdPPNNA4rEBgfUnB9e9XDkEbAvCqwh3ksWhHrCB39Sj9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=OqXhjSZ3; arc=none smtp.client-ip=47.90.199.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="OqXhjSZ3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785415757; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Nzr9UP/GTeFxm1RagkGeYMUYi5DBh3HQZDjx3eV+Orw=;
	b=OqXhjSZ3wsBVLDCzNA+kh9SGenFkCGicm36GYZs1/GdHrZb3k8yRMTTqrRkhLH+G/ukbfQm6t0idss7mrKsfUOH0QcJFtgYWKshPD7m3w8BwKHzj8tM0qrC5IKkEROQxZF3ZbrNXLIJ+H3SZvgDHONHTF5lZAMKKR1+9NucBBGU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X85K2xx_1785415438;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X85K2xx_1785415438 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 20:43:58 +0800
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	KaiShen@linux.alibaba.com
Subject: [PATCH 2/2] RDMA/erdma: Hold QP references for AE and CM processing
Date: Thu, 30 Jul 2026 20:43:54 +0800
Message-ID: <20260730124357.12976-2-chengyou@linux.alibaba.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260730124357.12976-1-chengyou@linux.alibaba.com>
References: <20260730124357.12976-1-chengyou@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AE QP fatal events and iWARP CM paths load QPs from dev->qp_xa
and then use or reference them outside the xarray lock.
erdma_destroy_qp() can drop the destroy-path reference and free QP
resources while such a lookup is in flight.

Add erdma_qp_get_by_qpn() to acquire a kref under the xarray
lock with kref_get_unless_zero(). Remove the QP from the xarray
before dropping the destroy-path reference so no new lookup can acquire
it while destruction waits for existing users.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 drivers/infiniband/hw/erdma/erdma_cm.c    |  6 ++----
 drivers/infiniband/hw/erdma/erdma_eq.c    |  3 ++-
 drivers/infiniband/hw/erdma/erdma_verbs.c |  6 +++++-
 drivers/infiniband/hw/erdma/erdma_verbs.h | 15 +++++++++++++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index 5c7d3a8f8038..70c5df566d9d 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -1021,10 +1021,9 @@ int erdma_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (laddr->sa_family != AF_INET || raddr->sa_family != AF_INET)
 		return -EAFNOSUPPORT;
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	ret = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &s);
 	if (ret < 0)
@@ -1154,10 +1153,9 @@ int erdma_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		return -ECONNRESET;
 	}
 
-	qp = find_qp_by_qpn(dev, params->qpn);
+	qp = erdma_qp_get_by_qpn(dev, params->qpn);
 	if (!qp)
 		return -ENOENT;
-	erdma_qp_get(qp);
 
 	down_write(&qp->state_lock);
 	if (qp->attrs.iwarp.state > ERDMA_QPS_IWARP_RTR) {
diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index 96e74fcf417c..d5d1704cb57c 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -65,7 +65,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			erdma_cq_put(cq);
 		} else {
 			qpn = le32_to_cpu(aeqe->event_data0);
-			qp = find_qp_by_qpn(dev, qpn);
+			qp = erdma_qp_get_by_qpn(dev, qpn);
 			if (!qp)
 				continue;
 
@@ -75,6 +75,7 @@ void erdma_aeq_event_handler(struct erdma_dev *dev)
 			if (qp->ibqp.event_handler)
 				qp->ibqp.event_handler(&event,
 						       qp->ibqp.qp_context);
+			erdma_qp_put(qp);
 		}
 	}
 
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 2adcd00c4199..65b1af1e6623 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1369,6 +1369,7 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		udata, struct erdma_ucontext, ibucontext);
 	struct erdma_cmdq_destroy_qp_req req;
 	union erdma_mod_qp_params params;
+	unsigned long flags;
 	int err;
 
 	down_write(&qp->state_lock);
@@ -1396,6 +1397,10 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 				       "failed to destroy QP %u: %d\n",
 				       QP_ID(qp), err);
 
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	__xa_erase(&dev->qp_xa, QP_ID(qp));
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
 	erdma_qp_put(qp);
 	wait_for_completion(&qp->safe_free);
 
@@ -1409,7 +1414,6 @@ int erdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (qp->cep)
 		erdma_cep_put(qp->cep);
-	xa_erase(&dev->qp_xa, QP_ID(qp));
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index 894e080435fb..c73cecf92f61 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -360,6 +360,21 @@ static inline struct erdma_qp *find_qp_by_qpn(struct erdma_dev *dev, int id)
 	return (struct erdma_qp *)xa_load(&dev->qp_xa, id);
 }
 
+static inline struct erdma_qp *erdma_qp_get_by_qpn(struct erdma_dev *dev,
+						   int id)
+{
+	struct erdma_qp *qp;
+	unsigned long flags;
+
+	xa_lock_irqsave(&dev->qp_xa, flags);
+	qp = xa_load(&dev->qp_xa, id);
+	if (qp && !kref_get_unless_zero(&qp->ref))
+		qp = NULL;
+	xa_unlock_irqrestore(&dev->qp_xa, flags);
+
+	return qp;
+}
+
 static inline struct erdma_cq *erdma_cq_get_by_cqn(struct erdma_dev *dev,
 						   int id)
 {
-- 
2.31.1

