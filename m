Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365253;
	b=sxLaoztmHye8TxNeJdeuwxg2WfYiKh6dmRUTESZtwRxJpb3gCh1mr5vbZfp5VdZnJMxK
	 dVzB7ddtvJ9hSz1+WiyrJTlRMVJYnyjEflaDlp9ds52jRylWG1KWFf270cUxFcNDQhOHG
	 UXuCDbx94FSOm5b1j5MXaGjtE4GCf1za8eyM7xxZlbQiSwucnQapiImkY952MeB1fivVC
	 Tt73h7M5Af6u+0Y3lCDdk0zOSyimyYZqB2Ll+tnlwk9tAJJ0Dap2yqIU0JmGh1DEsFOHD
	 DAiPOLmkBAgdzPK0NxFwH8AaTzevhOpgIolWbyIz7U81xepcNGCrKvyLfnzBvSkbsYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365253;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fIuiVCUHxl2Eudk/vFqsLhUw1TqhLYjmMIeDDZ7K1fQ=;
	b=lxqrHubK4lHkdAdv6Ba1x9Rqi/fSJrWOKs3p9NB0uKibNiBJiIDVztotY6oX/BR6A1IR
	 Fyobi61CMmRYa79sPZc1vrwVC7nFF5nnEAFnwe7nSteqa9R93mqQ9Xf2kJh28p4roGuKm
	 MunIQFKGttcSPyZjqSsPoNYJ87Pr65hmah9xExf3zeEJUoBr3aO5Nm4ld+AFpRK3SrSpN
	 9/4/G/IcuUqEQyGLOwaE20yDdzKiVBohTf+Zm2EfDDhc2Y91u+FW1auhgxlOh51lo0AzE
	 1t08idNnR8QQ//fHbGDKWT420rLJRMNIRDbrF9bIvoEp95YE+a8XHpow2iSUQCNHNkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=QDYwvL6t;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C81606A336;
	Fri, 30 Oct 2026 13:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3C81606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=QDYwvL6t
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id E547520B7170; Fri, 30 Oct 2026 06:00:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E547520B7170
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793365238;
	bh=fIuiVCUHxl2Eudk/vFqsLhUw1TqhLYjmMIeDDZ7K1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDYwvL6tKN3Pp9PYKTRvpPJaTFXncyenMkZPcEHAbzT955/KkrF7jZhAL3ceFtBKr
	 zPwF/02c55lsPruix+jrK5fnT0oS9Mi5wrmjYv654y2a9aK+4dFPlPw4ga0LFUVct6
	 fAa/TquQChT7CxCZWnaiTFub7MznqJLXL2/eOUTc=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v6 10/10] RDMA/mana_ib: Drain kernel receive and send queues
Date: Fri, 30 Oct 2026 06:00:38 -0700
Message-ID: <20261030130038.4040789-11-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
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
