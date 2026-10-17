Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9064741A57D;
	Sat, 17 Oct 2026 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219463; cv=none; b=ZREYrjOz0QQ49zG96I/Oah9hZIidSm50l9UxAfBVMUkAoACJjEtAHTf5vTajGOcXjVoZQAwI1Ws+ektqXNpLgWcGwyGkSnjcU0sldaRCqA0mi/ES3DLYxR83SqQ0LXRyMQ3FL6nve7TJhAxLzCdzgw87NZt9HnbW7SroTXFfhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219463; c=relaxed/simple;
	bh=GCeihHL5pzSBRCyTblX4z+6bZvqBNXbS2LnqjhOaf7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIzUkBbInEwGu5c0DJZW4QcHkWltOlIJlkkCd56PmkxwgBkTLTyFLrBt6gkdE2qdbOjJ3WzZEFi+4BmPjQjRE2WXp29CUQe+JPoAMVlH/PQA6gDMDv10rV6ooGbPftiPdy5qYa390PJmorNCJvzcDLuMoD8YYSldSTxGt1riU6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NstfyvV0; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NstfyvV0"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id B1C3620B7178; Fri, 16 Oct 2026 23:44:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B1C3620B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792219453;
	bh=fIuiVCUHxl2Eudk/vFqsLhUw1TqhLYjmMIeDDZ7K1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NstfyvV06EiNeJc6KBFXCeBFzHdpeTo8IhGNElbooILa+K3Ou08X6VdLDUjiR2wgm
	 lZ5W5l0hBovLGz9MXt5RdgaAdLMHQE1cz4yPd202gVmxR68wOqyXXAsOoXTbY+e/UZ
	 k2NBmYvLWejGDKQlgipJ2FoqWm1OC2kaNFVjsRO4=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 10/10] RDMA/mana_ib: Drain kernel receive and send queues
Date: Fri, 16 Oct 2026 23:44:13 -0700
Message-ID: <20261017064413.995985-11-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement the core drain callbacks by moving the QP to ERR, posting a
completion-bearing marker, and waiting until that marker is flushed.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
v2:
- Limit the drain callbacks to RC QPs.
- Skip completion callbacks for IB_POLL_DIRECT and retain direct polling.

 drivers/infiniband/hw/mana/device.c  |   2 +
 drivers/infiniband/hw/mana/mana_ib.h |   2 +
 drivers/infiniband/hw/mana/qp.c      | 103 +++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index cdaada7f6e8a..07c7fe678ff7 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -38,6 +38,8 @@ static const struct ib_device_ops mana_ib_dev_ops = {
 	.destroy_rwq_ind_table = mana_ib_destroy_rwq_ind_table,
 	.destroy_wq = mana_ib_destroy_wq,
 	.disassociate_ucontext = mana_ib_disassociate_ucontext,
+	.drain_rq = mana_ib_drain_rq,
+	.drain_sq = mana_ib_drain_sq,
 	.get_dma_mr = mana_ib_get_dma_mr,
 	.get_link_layer = mana_ib_get_link_layer,
 	.get_port_immutable = mana_ib_get_port_immutable,
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 3a6a4ad8e641..d810080d2baf 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -1060,6 +1060,8 @@ int mana_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr);
 
+void mana_ib_drain_sq(struct ib_qp *ibqp);
+void mana_ib_drain_rq(struct ib_qp *ibqp);
 void mana_drain_gsi_sqs(struct mana_ib_dev *mdev);
 int mana_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 519a161b994d..0dc7deb81921 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -1380,3 +1380,106 @@ int mana_ib_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	return -ENOENT;
 }
+
+struct mana_ib_drain_cqe {
+	struct ib_cqe cqe;
+	struct completion done;
+};
+
+static void mana_ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct mana_ib_drain_cqe *cqe = container_of(wc->wr_cqe,
+						     struct mana_ib_drain_cqe,
+						     cqe);
+	complete(&cqe->done);
+}
+
+void mana_ib_drain_sq(struct ib_qp *ibqp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct mana_ib_drain_cqe sdrain;
+	struct ib_rdma_wr swr = {
+		.wr = {
+			.next = NULL,
+			.wr_cqe = &sdrain.cqe,
+			.opcode = IB_WR_SEND,
+		},
+	};
+	const struct ib_send_wr *bad_swr;
+	struct ib_cq *cq = ibqp->send_cq;
+	int ret;
+
+	if (ibqp->qp_type != IB_QPT_RC) {
+		ibdev_err(ibqp->device, "SQ drain is only supported for RC QPs (type %u)\n",
+			  ibqp->qp_type);
+		return;
+	}
+
+	ret = ib_modify_qp(ibqp, &attr, IB_QP_STATE);
+	if (ret) {
+		ibdev_err(ibqp->device, "Failed to drain SQ: modify QP returned %d\n", ret);
+		return;
+	}
+
+	sdrain.cqe.done = mana_ib_drain_qp_done;
+	init_completion(&sdrain.done);
+
+	ret = ib_post_send(ibqp, &swr.wr, &bad_swr);
+	if (ret) {
+		ibdev_err(ibqp->device, "Failed to post SQ drain WR: %d\n", ret);
+		return;
+	}
+
+	if (cq->poll_ctx != IB_POLL_DIRECT && cq->comp_handler)
+		cq->comp_handler(cq, cq->cq_context);
+
+	if (cq->poll_ctx == IB_POLL_DIRECT) {
+		while (!wait_for_completion_timeout(&sdrain.done, HZ / 10))
+			ib_process_cq_direct(cq, -1);
+	} else {
+		wait_for_completion(&sdrain.done);
+	}
+}
+
+void mana_ib_drain_rq(struct ib_qp *ibqp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct mana_ib_drain_cqe rdrain;
+	struct ib_recv_wr rwr = {
+		.next = NULL,
+		.wr_cqe = &rdrain.cqe,
+	};
+	struct ib_cq *cq = ibqp->recv_cq;
+	int ret;
+
+	if (ibqp->qp_type != IB_QPT_RC) {
+		ibdev_err(ibqp->device, "RQ drain is only supported for RC QPs (type %u)\n",
+			  ibqp->qp_type);
+		return;
+	}
+
+	ret = ib_modify_qp(ibqp, &attr, IB_QP_STATE);
+	if (ret) {
+		ibdev_err(ibqp->device, "Failed to drain RQ: modify QP returned %d\n", ret);
+		return;
+	}
+
+	rdrain.cqe.done = mana_ib_drain_qp_done;
+	init_completion(&rdrain.done);
+
+	ret = ib_post_recv(ibqp, &rwr, NULL);
+	if (ret) {
+		ibdev_err(ibqp->device, "Failed to post RQ drain WR: %d\n", ret);
+		return;
+	}
+
+	if (cq->poll_ctx != IB_POLL_DIRECT && cq->comp_handler)
+		cq->comp_handler(cq, cq->cq_context);
+
+	if (cq->poll_ctx == IB_POLL_DIRECT) {
+		while (!wait_for_completion_timeout(&rdrain.done, HZ / 10))
+			ib_process_cq_direct(cq, -1);
+	} else {
+		wait_for_completion(&rdrain.done);
+	}
+}
-- 
2.43.0
