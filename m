From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 15/16] Remove README files in the provider directories
Date: Tue, 20 Sep 2016 16:10:24 -0600
Message-ID: <1474409425-15769-16-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

These were all almost the same and add no real value over the top-level
README.md file.  The only lost information is the exact names of supported
cards for some providers, but that already is information duplicated from
the kernel drivers and bound to get out of sync anyway.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libcxgb3/README      | 19 -----------------
 libcxgb4/README      | 19 -----------------
 libhfi1verbs/README  | 23 --------------------
 libipathverbs/README | 24 ---------------------
 libmlx4/README       | 58 ---------------------------------------------------
 libmlx5/README       | 14 -------------
 libmthca/README      | 59 ----------------------------------------------------
 libocrdma/README     | 19 -----------------
 8 files changed, 235 deletions(-)
 delete mode 100644 libcxgb3/README
 delete mode 100644 libcxgb4/README
 delete mode 100644 libhfi1verbs/README
 delete mode 100644 libipathverbs/README
 delete mode 100644 libmlx4/README
 delete mode 100644 libmlx5/README
 delete mode 100644 libmthca/README
 delete mode 100644 libocrdma/README

diff --git a/libcxgb3/README b/libcxgb3/README
deleted file mode 100644
index 9d0dd49a4b9e..000000000000
diff --git a/libcxgb4/README b/libcxgb4/README
deleted file mode 100644
index a4ee33a2adac..000000000000
diff --git a/libhfi1verbs/README b/libhfi1verbs/README
deleted file mode 100644
index 9b6f81266c6e..000000000000
diff --git a/libipathverbs/README b/libipathverbs/README
deleted file mode 100644
index a05997f79a32..000000000000
diff --git a/libmlx4/README b/libmlx4/README
deleted file mode 100644
index 5c027ef80360..000000000000
diff --git a/libmlx5/README b/libmlx5/README
deleted file mode 100644
index 6c713e630a4f..000000000000
diff --git a/libmthca/README b/libmthca/README
deleted file mode 100644
index 88636f8f6857..000000000000
diff --git a/libocrdma/README b/libocrdma/README
deleted file mode 100644
index 6ae30fe9e920..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
