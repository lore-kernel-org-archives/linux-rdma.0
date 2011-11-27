From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 16/62] infiniband: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:56 +0800
Message-ID: <1322371662-26166-17-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index fb88d68..2033a92 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -73,11 +73,11 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
-			from = kmap_atomic(sg_page(sg), KM_USER0);
+			from = kmap_atomic(sg_page(sg));
 			memcpy(p,
 			       from + sg->offset,
 			       sg->length);
-			kunmap_atomic(from, KM_USER0);
+			kunmap_atomic(from);
 			p += sg->length;
 		}
 	}
@@ -133,11 +133,11 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
-			to = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+			to = kmap_atomic(sg_page(sg));
 			memcpy(to + sg->offset,
 			       p,
 			       sg->length);
-			kunmap_atomic(to, KM_SOFTIRQ0);
+			kunmap_atomic(to);
 			p += sg->length;
 		}
 	}
-- 
1.7.4.4
