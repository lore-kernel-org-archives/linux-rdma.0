From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibqueryerrors: Fix crash when no SM is running
Date: Sun, 26 Apr 2015 12:40:10 -0400
Message-ID: <553D14EA.3080703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 21 Apr 2015 17:12:05 +0300

Handle sa_get_handle error in path_record_query

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibqueryerrors.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 8fbb9d1..97a555d 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -326,7 +326,9 @@ static int path_record_query(ib_gid_t sgid,uint64_t dguid)
      uint8_t reversible = 0;
      struct sa_handle * h;
 
-     h = sa_get_handle();
+     if (!(h = sa_get_handle()))
+	return -1;
+
      ibd_timeout = DEFAULT_HALF_WORLD_PR_TIMEOUT;
      memset(&pr, 0, sizeof(pr));
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
