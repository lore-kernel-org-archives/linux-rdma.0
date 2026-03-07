Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05CE3290B0;
	Sat,  7 Mar 2026 01:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772848056; cv=none; b=gWL8W4XgJkjXJi7F0bMYNla4sJPIIXHfQ0Wltav39XUgS8VSo3FpQG9b4A85xW5GZktuwRvGxGnvUSvu+Yt5cceTt3q/A77gJYImomjA5KWeHoo1euUNjoKV2OtiDy6sFUROhUF5eg/KwW4Lmmr61g3lsRH1sIAfhSbWAUpSReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772848056; c=relaxed/simple;
	bh=kAYvOIBdnFKV0F/GO32JrSE3ZWQIK08o0IJ+mNwitP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfG6jndpqOzA+/mezdcRUAWZSzqQT6+U0RabgB/314m4c99zRoPk6QNgw/1qYOp+VCHiyflSRfJ1IPuuZpL84dcVySArED7whr/DIf5ZN3A70zNY/06jHyhRnTFuQSk1r2IY2HAVvPAJoBDj8RUvIfX+DG0Q8LwoJFF+MTxBDxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C7B1920B6F02; Fri,  6 Mar 2026 17:47:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7B1920B6F02
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>
Cc: Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 3/8] RDMA/mana_ib: Track CQ per ucontext
Date: Fri,  6 Mar 2026 17:47:17 -0800
Message-ID: <20260307014723.556523-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260307014723.556523-1-longli@microsoft.com>
References: <20260307014723.556523-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add per-ucontext list tracking for CQ objects. Each CQ is added to
the ucontext's cq_list on creation and removed on destruction. This
enables iterating over all CQs belonging to a ucontext for service
reset cleanup.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c      | 19 +++++++++++++++++++
 drivers/infiniband/hw/mana/main.c    |  1 +
 drivers/infiniband/hw/mana/mana_ib.h |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index b2749f971cd0..89cf60987ff5 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -95,6 +95,16 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	INIT_LIST_HEAD(&cq->list_send_qp);
 	INIT_LIST_HEAD(&cq->list_recv_qp);
 
+	INIT_LIST_HEAD(&cq->ucontext_list);
+	if (udata) {
+		struct mana_ib_ucontext *mana_ucontext =
+			rdma_udata_to_drv_context(udata,
+				struct mana_ib_ucontext, ibucontext);
+		mutex_lock(&mana_ucontext->lock);
+		list_add_tail(&cq->ucontext_list, &mana_ucontext->cq_list);
+		mutex_unlock(&mana_ucontext->lock);
+	}
+
 	return 0;
 
 err_remove_cq_cb:
@@ -115,6 +125,15 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 
+	if (udata) {
+		struct mana_ib_ucontext *mana_ucontext =
+			rdma_udata_to_drv_context(udata,
+				struct mana_ib_ucontext, ibucontext);
+		mutex_lock(&mana_ucontext->lock);
+		list_del_init(&cq->ucontext_list);
+		mutex_unlock(&mana_ucontext->lock);
+	}
+
 	mana_ib_remove_cq_cb(mdev, cq);
 
 	/* Ignore return code as there is not much we can do about it.
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 62d89ca06ba1..214c1d4e1548 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -243,6 +243,7 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 
 	mutex_init(&ucontext->lock);
 	INIT_LIST_HEAD(&ucontext->pd_list);
+	INIT_LIST_HEAD(&ucontext->cq_list);
 
 	mutex_lock(&mdev->ucontext_lock);
 	list_add_tail(&ucontext->dev_list, &mdev->ucontext_list);
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 6dba08bccc18..8d3edf7ba335 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -150,6 +150,7 @@ struct mana_ib_cq {
 	int cqe;
 	u32 comp_vector;
 	mana_handle_t  cq_handle;
+	struct list_head ucontext_list;
 };
 
 enum mana_rc_queue_type {
@@ -205,6 +206,7 @@ struct mana_ib_ucontext {
 	/* Protects resource lists below */
 	struct mutex lock;
 	struct list_head pd_list;
+	struct list_head cq_list;
 };
 
 struct mana_ib_rwq_ind_table {
-- 
2.43.0

