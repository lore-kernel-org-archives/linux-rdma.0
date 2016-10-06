From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 04/17] Remove missed auto* related files
Date: Thu,  6 Oct 2016 14:51:30 -0600
Message-ID: <1475787103-13283-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 366e8dfbd17e ("Remove the auto* based build systems")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/src/.dirstamp     |  0
 libibumad/gen_chlog.sh  | 67 -------------------------------------------------
 libibumad/libibumad.ver |  9 -------
 3 files changed, 76 deletions(-)
 delete mode 100644 iwpmd/src/.dirstamp
 delete mode 100755 libibumad/gen_chlog.sh
 delete mode 100644 libibumad/libibumad.ver

diff --git a/iwpmd/src/.dirstamp b/iwpmd/src/.dirstamp
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/libibumad/gen_chlog.sh b/libibumad/gen_chlog.sh
deleted file mode 100755
index 34dfa24d8db1..000000000000
diff --git a/libibumad/libibumad.ver b/libibumad/libibumad.ver
deleted file mode 100644
index f2f713f42092..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
