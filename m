Received: from cvsmtppost38.nm.naver.com (cvsmtppost38.nm.naver.com [114.111.35.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBB34EEFD
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 06:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354651; cv=none; b=kbMThKzOVSkcUeDP3hjYmZvSuddobtJ2+uONY9w1DX6hkiHLtuOcws1ByfUOi6GeK/j7nLTCCc2nuLZCPIZ4y0geTcJAuYQDkpgfHBAPWoTZkONi+WrPKOVR4/ZV/1j+gl8n3hyJv9aa98CDRCf7I6/X3MtEevNbCcrptehdj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354651; c=relaxed/simple;
	bh=mTpb8UEuu6X1FFkVBtgYyGgvbUVl1XClBw5qrfK9CU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hezn5X5Rd7bmi1CPmDK5iYV3XOltpoorLGG40fBNmsj5kD8Eam8Qx2gDYXPgZgG9zJt41kkS9G+ucCg39cmCAq9916CUETbqS7gSPzHyCTcfdHPnyF1YH0y5JaX0bsOz2lYOU1tQVeDKTd8Q9tq/rwyCqT2kGO9GyIWCfG1/GDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=ftRL+H0C; arc=none smtp.client-ip=114.111.35.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="ftRL+H0C"
Received: from cvsendbo024.nm ([10.112.24.41])
  by cvsmtppost38.nm.naver.com with ESMTP id 0wrlgQtPSnWOIoiz5Ih1VA
  for <linux-rdma@vger.kernel.org>;
  Wed, 07 Oct 2026 06:30:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791354641; bh=mTpb8UEuu6X1FFkVBtgYyGgvbUVl1XClBw5qrfK9CU0=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=ftRL+H0COMOhX25YvEyqRLmB8h7foA/Qc8OoxkJAxgX1NYHdeIwX7KytCpaiSOh21
	 JqfG2fQ0FaabUo57bamJHaw17EpvCIr0JTTtS+ivQ4UjY0C+hUPU7Kyy532fhW8Ce5
	 OPCb4qJaCE9idLDELG59rU7HzDL9i+ACDhscirFDAy7FgLDSoWPS0THGckKhqGkn7Y
	 0QUN4h19IOBIfpLClTGA/CbWAgDrDYVcqxJCSYsY0krKgzfwe2I0tti5+xelwYveVf
	 G7WmFWhdd90YRllzivOqDW46Lfnkq6O8qmKl4Gq3+78oxg+RAoGjsDlAe3GcTgi0NG
	 5NUnw8xDHR6Vw==
X-Session-ID: w7BqtGPJS4SBQ-1cgwIzEg
X-Works-Send-Opt: OPFwpzGdjHmdKHFOMr39Ko3YKHmdjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: XwbZKqulFqJZ+HmwFAUZ+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp011.nm.naver.com with ESMTP id w7BqtGPJS4SBQ-1cgwIzEg
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 07 Oct 2026 06:30:41 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/rxe: validate receive WQE cursor after snapshot
Date: Wed,  7 Oct 2026 15:30:28 +0900
Message-ID: <20261007063029.26073-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Receive WQEs are held in queues which are writable by userspace.  The
responder bounds num_sge before copying a WQE to its private snapshot, but
does not validate cur_sge.  A non-empty SEND can therefore make copy_data()
select SGE metadata outside the populated receive SGE array.

Validate the immutable snapshot before installing it in the responder.
Require the copied num_sge to match the value used to size the copy and
require cur_sge to name a populated SGE whenever residual data remains.
Apply the same checks to per-QP and shared receive queues.

This was found by source review with AI assistance.  An unprivileged
RXE queue owner reproduced a kernel fault twice with num_sge set to 1,
resid set to 8, and cur_sge set to UINT_MAX.  The fixed kernel rejected
that WQE, while an ordinary eight-byte receive completed successfully.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8f..f059434eead13 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -288,8 +288,15 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	wqe = &qp->resp.srq_wqe.wqe;
+	if (unlikely(wqe->dma.num_sge != num_sge ||
+		     (wqe->dma.resid && wqe->dma.cur_sge >= num_sge))) {
+		spin_unlock_irqrestore(&srq->rq.consumer_lock, flags);
+		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in SRQ entry\n");
+		return RESPST_ERR_MALFORMED_WQE;
+	}
 
-	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
+	qp->resp.wqe = wqe;
 	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
 	count = queue_count(q, QUEUE_TYPE_FROM_CLIENT);
 
@@ -328,8 +335,14 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	wqe = &qp->resp.srq_wqe.wqe;
+	if (unlikely(wqe->dma.num_sge != num_sge ||
+		     (wqe->dma.resid && wqe->dma.cur_sge >= num_sge))) {
+		rxe_dbg_qp(qp, "invalid num_sge/cur_sge in recv WQE\n");
+		return RESPST_ERR_MALFORMED_WQE;
+	}
 
-	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
+	qp->resp.wqe = wqe;
 	return RESPST_CHK_LENGTH;
 }
 
-- 
2.43.0

