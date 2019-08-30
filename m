Return-Path: <SRS0=Um1x=W2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F8BC3A5A4
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Aug 2019 08:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CE322CE3
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Aug 2019 08:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567152985;
	bh=rEND5SkuCqmXYjnTKhLFZvZOQSPi6mrthbmEc2BEmr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Cgt0CcvhqBnYJMQKK9nYPW5LQmsGTRPYwq7+xWq4dLhwsblkuU/2EGD65+l4Xifa7
	 Ui4zbzM9m36Yloko0muVYg5ReSriqIcZ2eSlQBupvcoKFXjb2ar6i0VJDrAbkaJa7n
	 Snqq2ogW4nsv7qynO2uVeQtOLygVOOwv4DLtuGeQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfH3IQY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3IQY (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 30 Aug 2019 04:16:24 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69202173E;
        Fri, 30 Aug 2019 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567152983;
        bh=rEND5SkuCqmXYjnTKhLFZvZOQSPi6mrthbmEc2BEmr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw3WWDra0lxwIc5YSSzwVIwUIY1qCIASB09hbYUmL0JA0wyngmw2/HNerNgUbZzSF
         1xbUQ/kCP7sTBAX7Q0mnGEkxesNHElJRjXEA7FpdxKNskOWUHlA37yqmq4Uaq9UeGH
         Bezct8FgDWyfvEc6/krvWHAkpHeZRAb3RY8GDLsc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>
Subject: [PATCH rdma-next v1 1/4] IB/mlx5: Introduce ODP diagnostic counters
Date:   Fri, 30 Aug 2019 11:16:09 +0300
Message-Id: <20190830081612.2611-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190830081612.2611-1-leon@kernel.org>
References: <20190830081612.2611-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Introduce ODP diagnostic counters and count the following
per MR within IB/mlx5 driver:
 1) Page faults:
	Total number of faulted pages.
 2) Page invalidations:
	Total number of pages invalidated by the OS during all
	invalidation events. The translations can be no longer
	valid due to either non-present pages or mapping changes.
 3) Prefetched pages:
	When prefetching a page, page fault is generated
	in order to bring the page to the main memory.
	The prefetched pages counter will be updated
	during a page fault flow only if it was derived
	from prefetching operation.

Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 18 ++++++++++++++++++
 include/rdma/ib_umem_odp.h       | 14 ++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 905936423a03..b7c8a49ac753 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -287,6 +287,10 @@ void mlx5_ib_invalidate_range(struct ib_umem_odp *umem_odp, unsigned long start,
 
 	ib_umem_odp_unmap_dma_pages(umem_odp, start, end);
 
+	/* Count page invalidations */
+	ib_update_odp_stats(umem_odp, invalidations,
+			    ib_umem_odp_num_pages(umem_odp));
+
 	if (unlikely(!umem_odp->npages && mr->parent &&
 		     !umem_odp->dying)) {
 		WRITE_ONCE(umem_odp->dying, 1);
@@ -801,6 +805,20 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		if (ret < 0)
 			goto srcu_unlock;
 
+		/*
+		 * When prefetching a page, page fault is generated
+		 * in order to bring the page to the main memory.
+		 * In the current flow, page faults are being counted.
+		 * Prefetched pages counter will be updated as well
+		 * only if the current page fault flow was derived
+		 * from prefetching flow.
+		 */
+		ib_update_odp_stats(to_ib_umem_odp(mr->umem), faults, ret);
+
+		if (prefetch)
+			ib_update_odp_stats(to_ib_umem_odp(mr->umem),
+					    prefetched, ret);
+
 		npages += ret;
 		ret = 0;
 		break;
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index b37c674b7fe6..3359e34516da 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -37,6 +37,12 @@
 #include <rdma/ib_verbs.h>
 #include <linux/interval_tree.h>
 
+struct ib_odp_counters {
+	atomic64_t faults;
+	atomic64_t invalidations;
+	atomic64_t prefetched;
+};
+
 struct ib_umem_odp {
 	struct ib_umem umem;
 	struct ib_ucontext_per_mm *per_mm;
@@ -62,6 +68,11 @@ struct ib_umem_odp {
 	struct mutex		umem_mutex;
 	void			*private; /* for the HW driver to use. */
 
+	/*
+	 * ODP diagnostic counters.
+	 */
+	struct ib_odp_counters odp_stats;
+
 	int notifiers_seq;
 	int notifiers_count;
 	int npages;
@@ -106,6 +117,9 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
 	       umem_odp->page_shift;
 }
 
+#define ib_update_odp_stats(umem_odp, counter_name, value)		    \
+	atomic64_add(value, &(umem_odp->odp_stats.counter_name))
+
 /*
  * The lower 2 bits of the DMA address signal the R/W permissions for
  * the entry. To upgrade the permissions, provide the appropriate
-- 
2.20.1

