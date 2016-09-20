From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 12/16] Remove the ChangeLog files
Date: Tue, 20 Sep 2016 16:10:21 -0600
Message-ID: <1474409425-15769-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These are either empty, an old copy of 'git log' or some very
old logs.

New stuff uses git, the changelog is in git, no need to keep these.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/ChangeLog                   |    0
 iwpmd/ChangeLog                   |  276 ---------
 libcxgb3/ChangeLog                |  791 --------------------------
 libcxgb4/ChangeLog                | 1133 -------------------------------------
 libhfi1verbs/add_fedora_entry.sh  |   18 -
 libhfi1verbs/fedora_changelog.txt |    2 -
 libibcm/ChangeLog                 |    0
 libibumad/ChangeLog               |   94 ---
 libibverbs/ChangeLog              |  583 -------------------
 libmthca/ChangeLog                |  378 -------------
 librdmacm/ChangeLog               |    0
 librxe/ChangeLog                  |    0
 srp_daemon/ChangeLog              |   66 ---
 srp_daemon/NEWS                   |    1 -
 14 files changed, 3342 deletions(-)
 delete mode 100644 ibacm/ChangeLog
 delete mode 100644 iwpmd/ChangeLog
 delete mode 100644 libcxgb3/ChangeLog
 delete mode 100644 libcxgb4/ChangeLog
 delete mode 100644 libhfi1verbs/add_fedora_entry.sh
 delete mode 100644 libhfi1verbs/fedora_changelog.txt
 delete mode 100644 libibcm/ChangeLog
 delete mode 100644 libibumad/ChangeLog
 delete mode 100644 libibverbs/ChangeLog
 delete mode 100644 libmthca/ChangeLog
 delete mode 100644 librdmacm/ChangeLog
 delete mode 100644 librxe/ChangeLog
 delete mode 100644 srp_daemon/ChangeLog
 delete mode 100644 srp_daemon/NEWS

diff --git a/ibacm/ChangeLog b/ibacm/ChangeLog
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/iwpmd/ChangeLog b/iwpmd/ChangeLog
deleted file mode 100644
index 6fb7da23afd1..000000000000
diff --git a/libcxgb3/ChangeLog b/libcxgb3/ChangeLog
deleted file mode 100644
index 6e3de6058a0f..000000000000
diff --git a/libcxgb4/ChangeLog b/libcxgb4/ChangeLog
deleted file mode 100644
index c472b6d49436..000000000000
diff --git a/libhfi1verbs/add_fedora_entry.sh b/libhfi1verbs/add_fedora_entry.sh
deleted file mode 100644
index 5e103b41750e..000000000000
diff --git a/libhfi1verbs/fedora_changelog.txt b/libhfi1verbs/fedora_changelog.txt
deleted file mode 100644
index fb59bc65b06e..000000000000
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
diff --git a/srp_daemon/ChangeLog b/srp_daemon/ChangeLog
deleted file mode 100644
index a9f21c92fdc1..000000000000
diff --git a/srp_daemon/NEWS b/srp_daemon/NEWS
deleted file mode 100644
index 30463b9c4124..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
