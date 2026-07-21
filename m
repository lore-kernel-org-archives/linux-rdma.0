Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960F400DE8;
	Tue, 21 Jul 2026 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784646011; cv=none; b=lcF36BFwMxxtL7s73OP5qZ0y3ja5R3Ouftaom8QmVl3j9yn0ZMLe1QTuQvjoKBQKNudtFSsHc4rbe+vY8sfahrDFwS4WMlxZWBP8Kz1iue0obtbYYHPp7b/YhoQlVhqEghlAnjlI08XFa+NfRCULY5JmeqdvtapSFZ1sN7BL8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784646011; c=relaxed/simple;
	bh=r9UYPatv6skLLRFDeo7SoqTiK3GppharIlTNsuhGi5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MO3mEPchxJ8Y+rNvBSEfq0Pp311rRfrsirh0hmBnCTmkKkagPdg0x2YAxWzG7gKBYx55brfA7X/daoTMXX6F9/VXR6X893f10JSid04pw/HjykDh5284is5CNZNzk6NKre2HPLEVrF68icRQ10ckE5nXn/9rdjS22Iq4/SlRtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1RWUFKf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1RWUFKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2701F000E9;
	Tue, 21 Jul 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784646009;
	bh=QhjO4MUBUxBh+gBOxm277NyOJD7wDouDLOhda8YuBM4=;
	h=From:To:Cc:Subject:Date;
	b=I1RWUFKf9XW4I/EWAvkkhWQ5UtBDUqpUNvArXnVtZUGkOsrIBBR2BJAtMk3ohst7a
	 trPcC/fIq2G84xCjkzj0N4SaM+aXcv4ldg3DaZNzJDbgpu5KevPpxlNmfc80H5l0RM
	 Ba80BCpe8rtvo2syiv/wfW+UvLl3WwcIaPDZO/rHGJTIVEZmd6xTyRermZzM5lXnUO
	 ZZS4tTNHsaXEic6mKCVMrCnWljrIXjVToKWxJFd04r9KN4gTIy8AZvw0LkP6ZwfBEV
	 FrLyaQOZCfsMWWm3FpvfqEu2pbGDzITepxcsU4lPdTANluyWaPfVATH0N0vItv14Aj
	 NFX7nojix7IgA==
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Shiraz Saleem <shirazsaleem@microsoft.com>
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: drain QP references after partial table insertion
Date: Tue, 21 Jul 2026 18:00:01 +0300
Message-ID: <20260721-if-mana-table-store-qp-qids-partiall-v1-1-8fb3d2d2b559@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260721-if-mana-table-store-qp-qids-partiall-afa14f023261
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

mana_table_store_ud_qp() publishes a QP at its send-queue id before
inserting the receive-queue id, dropping the XArray lock between the two
xa_insert_irq() calls. A concurrent completion handler can look up the QP
and take a transient reference. When the second insertion fails, the
rollback erased only the send-queue entry and returned, leaving both the
initial table reference and the transient reference outstanding while RDMA
core frees the QP, causing a use-after-free.

Drain the reference as normal destruction does: drop the initial reference
and wait for qp->free, releasing the QP only after every concurrent lookup
returns its reference.

Fixes: 8001e9257eca ("RDMA/mana_ib: extend mana QP table")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Konstantin,

I saw this in one of the Sashiko runs, and I believe the AI is
correct. The reference can be acquired through the
GDMA_EQE_RNIC_QP_FATAL event.

Thanks
---
 drivers/infiniband/hw/mana/qp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index b5ff07e34eb7..c52f3ec14032 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -472,6 +472,12 @@ static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp
 	xa_erase_irq(&mdev->qp_table_wq, qp->ibqp.qp_num);
 }
 
+static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
+{
+	mana_put_qp_ref(qp);
+	wait_for_completion(&qp->free);
+}
+
 static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *qp)
 {
 	u32 qids = qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id | MANA_SENDQ_MASK;
@@ -490,6 +496,7 @@ static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct mana_ib_qp *q
 
 remove_sq:
 	xa_erase_irq(&mdev->qp_table_wq, qids);
+	mana_table_drain_qp_ref(qp);
 	return err;
 }
 
@@ -537,8 +544,7 @@ static void mana_table_remove_qp(struct mana_ib_dev *mdev,
 			  qp->ibqp.qp_type);
 		return;
 	}
-	mana_put_qp_ref(qp);
-	wait_for_completion(&qp->free);
+	mana_table_drain_qp_ref(qp);
 }
 
 static int mana_ib_create_rc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,

---
base-commit: 74f49255492a62658f36bf2578d7916f1c6ffad1
change-id: 20260721-if-mana-table-store-qp-qids-partiall-afa14f023261

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

