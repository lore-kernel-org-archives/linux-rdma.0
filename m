Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939BB3A7D7A;
	Sun, 12 Jul 2026 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783858673; cv=pass; b=U+HSRhniS9UtCJsb2TFTvX3pCVMnpI0mCQ21q2g9OmgvTJ0CIoBC0U2Q3Xwfi40OX1efhumuoH1J31P++6aaioZ0WQ4oxg5FhrobGdhfth9HdyWraafG7JxPpyPrEsCg12HiAuj0FZNBfiSkmYVjgk7QCZq9hzM8tXGxuQLWLAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783858673; c=relaxed/simple;
	bh=LuZt66/niURGnUozTDgZQU9JB9x9lxh5hJacGvaxOg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gjg4miO6bUuO3/Ou+txP9pdOpH9q0d4IgvXTjDkX6Tq0+T3kVgJfzaIDeSIjCa6z4AUY8k4x6Uk6hLxK1NslZrTdwMAGRzMEs1iHEdW1UFqj0jCTutfYkc24D9UaPz7AD5TjIN3zQTMQo/f8vIKjbR32GW9X0edG8B6c4BfkqIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=px5An4Du; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="px5An4Du"
ARC-Seal: i=1; a=rsa-sha256; t=1783858649; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Ec9GqiqME1QYw7I1Tx0a5VeU3vqaGiHatxXnSoEduob9/uolQfmYPdPsJQmuJa0H/y6UEgOOsb+mYtOueWhQ8dMVwEthfMXk9diwiE9q3HloDB4NrhsVkKwDpKOIG19iO5/JCvVmaNEox3jK43CAawwQShuCnO1iYiC4g8VxJ4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783858649; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=U6l+rRYsV3mI4tqEstfT5GdNdRDGbxg4jSljpGwXo6I=; 
	b=llVsQ2NTTha0d8d0jcwDe2ntBUHi994syVtzoF2QMdOnZ5s8dXXNaIKnzJvQC7L10eRkm4wxqHijpCnYjsADsPkhRXrcOl+gRFavEEdmumOx7L3AMZQ4X5EWOmKNrhLvaY2qz2nRmIWioT3HFRUB3KAKfC9gLjiD7HAO16LUQX0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783858649;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=U6l+rRYsV3mI4tqEstfT5GdNdRDGbxg4jSljpGwXo6I=;
	b=px5An4Du8mqRO15lDyyDIZkeYEHVPpWz2q5ifPVSRd23Ejre5adqQTzE684dh96v
	Bw8qJzKfm95GOAGIoNSAyK3R5oEr2uCPDEZtJthw9zqYITT5uPswf4SxFv4QDOaAHS6
	S7WjxJYCeY8pYuYVg33+lSGt3/26obx8H/lgeBXE=
Received: by mx.zoho.eu with SMTPS id 1783858645296328.49876750386557;
	Sun, 12 Jul 2026 14:17:25 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: yanjun.zhu@linux.dev,
	zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] RDMA/rxe: fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp
Date: Sun, 12 Jul 2026 14:17:20 +0200
Message-ID: <20260712121720.78001-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

rxe_qp_from_attr() handles IB_QP_MAX_DEST_RD_ATOMIC outside the
IB_QP_STATE path, so it holds no state_lock and runs while the responder
task rxe_receiver() (recv_task on rxe_wq) is live. A modify_qp() setting
only that attribute calls free_rd_atomic_resources() then
alloc_rd_atomic_resources(), swapping qp->resp.resources[] while
rxe_prepare_res()/find_resource() walk it; free_rd_atomic_resources()
also leaves the cached pointer qp->resp.res dangling. A local
unprivileged user can race the free/realloc into a use-after-free in
rxe_receiver() (local DoS).

Drain recv_task around the swap with rxe_disable_task()/rxe_enable_task(),
as rxe_qp_reset() already does when tearing this array down, re-enabling
only after alloc_rd_atomic_resources() succeeds so the responder never
resumes against a NULL qp->resp.resources on the ENOMEM path. Also clear
qp->resp.res in free_rd_atomic_resources(), like the rxe_resp.c
completion paths.

Reproduced under KASAN; the slab-use-after-free in rxe_receiver() is gone.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
v3: rewrite the commit message to describe the rxe_qp_from_attr() -> free/alloc_rd_atomic_resources() vs rxe_receiver() call flow directly and terse per Leon's review; resend as a standalone patch (not in-reply-to the previous series). No code change from v2; carries Zhu Yanjun's Reviewed-by.
 drivers/infiniband/sw/rxe/rxe_qp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f3dff1aea96a..61cbf05fbf58 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -172,6 +172,7 @@ static void free_rd_atomic_resources(struct rxe_qp *qp)
 		}
 		kfree(qp->resp.resources);
 		qp->resp.resources = NULL;
+		qp->resp.res = NULL;
 	}
 }
 
@@ -709,11 +710,23 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 
 		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
 
+		/*
+		 * Not gated by IB_QP_STATE, so the responder task is live.
+		 * Quiesce recv_task like rxe_qp_reset() before swapping the
+		 * rd_atomic array, so rxe_receiver() cannot race the free/
+		 * realloc.
+		 */
+		rxe_disable_task(&qp->recv_task);
 		free_rd_atomic_resources(qp);
-
 		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
+		/*
+		 * On ENOMEM leave recv_task quiesced: qp->resp.resources is
+		 * NULL and rxe_prepare_res()/find_resource() would deref it.
+		 * Re-enable only after a fresh array is installed.
+		 */
 		if (err)
 			return err;
+		rxe_enable_task(&qp->recv_task);
 	}
 
 	if (mask & IB_QP_EN_SQD_ASYNC_NOTIFY)
-- 
2.50.1 (Apple Git-155)

