From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 14/16] ibacm: Remove windows support files
Date: Tue, 20 Sep 2016 16:10:23 -0600
Message-ID: <1474409425-15769-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Building these is no longer supported.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/dirs                               |  1 -
 ibacm/windows/acm_windows.c              | 33 -----------
 ibacm/windows/acme/SOURCES               | 36 ------------
 ibacm/windows/acme/makefile              |  7 ---
 ibacm/windows/acme_windows.c             | 96 --------------------------------
 ibacm/windows/dirs                       |  1 -
 ibacm/windows/libacm_windows.c           | 52 -----------------
 ibacm/windows/library/Sources            | 32 -----------
 ibacm/windows/library/libacm.rc          | 46 ---------------
 ibacm/windows/library/libacm_export.def  | 34 -----------
 ibacm/windows/library/libacm_exports.src | 12 ----
 ibacm/windows/library/makefile           |  7 ---
 ibacm/windows/osd.h                      | 91 ------------------------------
 ibacm/windows/service/Sources            | 31 -----------
 ibacm/windows/service/makefile           |  7 ---
 15 files changed, 486 deletions(-)
 delete mode 100644 ibacm/dirs
 delete mode 100644 ibacm/windows/acm_windows.c
 delete mode 100644 ibacm/windows/acme/SOURCES
 delete mode 100644 ibacm/windows/acme/makefile
 delete mode 100644 ibacm/windows/acme_windows.c
 delete mode 100644 ibacm/windows/dirs
 delete mode 100644 ibacm/windows/libacm_windows.c
 delete mode 100644 ibacm/windows/library/Sources
 delete mode 100644 ibacm/windows/library/libacm.rc
 delete mode 100644 ibacm/windows/library/libacm_export.def
 delete mode 100644 ibacm/windows/library/libacm_exports.src
 delete mode 100644 ibacm/windows/library/makefile
 delete mode 100644 ibacm/windows/osd.h
 delete mode 100644 ibacm/windows/service/Sources
 delete mode 100644 ibacm/windows/service/makefile

diff --git a/ibacm/dirs b/ibacm/dirs
deleted file mode 100644
index a03d51e2819b..000000000000
diff --git a/ibacm/windows/acm_windows.c b/ibacm/windows/acm_windows.c
deleted file mode 100644
index 60fa9c4ddb0f..000000000000
diff --git a/ibacm/windows/acme/SOURCES b/ibacm/windows/acme/SOURCES
deleted file mode 100644
index 896a03cf2074..000000000000
diff --git a/ibacm/windows/acme/makefile b/ibacm/windows/acme/makefile
deleted file mode 100644
index a0c062738d0f..000000000000
diff --git a/ibacm/windows/acme_windows.c b/ibacm/windows/acme_windows.c
deleted file mode 100644
index 8b2397e2029c..000000000000
diff --git a/ibacm/windows/dirs b/ibacm/windows/dirs
deleted file mode 100644
index e2b4f83e0d7e..000000000000
diff --git a/ibacm/windows/libacm_windows.c b/ibacm/windows/libacm_windows.c
deleted file mode 100644
index 983f3cb5c1cb..000000000000
diff --git a/ibacm/windows/library/Sources b/ibacm/windows/library/Sources
deleted file mode 100644
index 1384ebbdea22..000000000000
diff --git a/ibacm/windows/library/libacm.rc b/ibacm/windows/library/libacm.rc
deleted file mode 100644
index 6e9e2d9bab51..000000000000
diff --git a/ibacm/windows/library/libacm_export.def b/ibacm/windows/library/libacm_export.def
deleted file mode 100644
index d3b4fc3084c3..000000000000
diff --git a/ibacm/windows/library/libacm_exports.src b/ibacm/windows/library/libacm_exports.src
deleted file mode 100644
index edf39344b900..000000000000
diff --git a/ibacm/windows/library/makefile b/ibacm/windows/library/makefile
deleted file mode 100644
index a0c062738d0f..000000000000
diff --git a/ibacm/windows/osd.h b/ibacm/windows/osd.h
deleted file mode 100644
index 2ca2c52c215e..000000000000
diff --git a/ibacm/windows/service/Sources b/ibacm/windows/service/Sources
deleted file mode 100644
index 803d4d968614..000000000000
diff --git a/ibacm/windows/service/makefile b/ibacm/windows/service/makefile
deleted file mode 100644
index a0c062738d0f..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
