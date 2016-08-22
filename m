From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 11/15] Remove the ChangeLog files
Date: Mon, 22 Aug 2016 12:13:34 -0600
Message-ID: <1471889618-1605-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These are either empty, an old copy of 'git log' or some very
old logs.

New stuff uses git, the changelog is in git, no need to keep these.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/ChangeLog   |  791 -----------------------------------
 libcxgb4/ChangeLog   | 1133 --------------------------------------------------
 libibcm/ChangeLog    |    0
 libibumad/ChangeLog  |   94 -----
 libibverbs/ChangeLog |  583 --------------------------
 libmthca/ChangeLog   |  378 -----------------
 librdmacm/ChangeLog  |    0
 librxe/ChangeLog     |    0
 8 files changed, 2979 deletions(-)
 delete mode 100644 libcxgb3/ChangeLog
 delete mode 100644 libcxgb4/ChangeLog
 delete mode 100644 libibcm/ChangeLog
 delete mode 100644 libibumad/ChangeLog
 delete mode 100644 libibverbs/ChangeLog
 delete mode 100644 libmthca/ChangeLog
 delete mode 100644 librdmacm/ChangeLog
 delete mode 100644 librxe/ChangeLog

diff --git a/libcxgb3/ChangeLog b/libcxgb3/ChangeLog
deleted file mode 100644
index 6e3de6058a0f..000000000000
diff --git a/libcxgb4/ChangeLog b/libcxgb4/ChangeLog
deleted file mode 100644
index c472b6d49436..000000000000
diff --git a/libibcm/ChangeLog b/libibcm/ChangeLog
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/libibumad/ChangeLog b/libibumad/ChangeLog
deleted file mode 100644
index f394ef8c89a9..000000000000
diff --git a/libibverbs/ChangeLog b/libibverbs/ChangeLog
deleted file mode 100644
index 27ee956ddac8..000000000000
diff --git a/libmthca/ChangeLog b/libmthca/ChangeLog
deleted file mode 100644
index 015ed3881f05..000000000000
diff --git a/librdmacm/ChangeLog b/librdmacm/ChangeLog
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/librxe/ChangeLog b/librxe/ChangeLog
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
