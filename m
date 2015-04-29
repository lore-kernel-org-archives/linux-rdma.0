From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibmad] portid.c: Preserve routepath string in str2drpath
Date: Wed, 29 Apr 2015 07:12:07 -0400
Message-ID: <5540BC87.3020903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 28 Apr 2015 18:35:28 +0300

In str2drpath, preserve routepath string rather than
modifying it.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/portid.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/src/portid.c b/src/portid.c
index ceb685e..40754fe 100644
--- a/src/portid.c
+++ b/src/portid.c
@@ -82,11 +82,18 @@ char *portid2str(ib_portid_t * portid)
 
 int str2drpath(ib_dr_path_t * path, char *routepath, int drslid, int drdlid)
 {
-	char *s, *str = routepath;
+	char *s, *str;
+	char *tmp;
 
 	path->cnt = -1;
 
+	if (!routepath || !(tmp = strdup(routepath)))
+		goto Exit;
+
 	DEBUG("DR str: %s", routepath);
+
+	str = tmp;
+
 	while (str && *str) {
 		if ((s = strchr(str, ',')))
 			*s = 0;
@@ -95,7 +102,9 @@ int str2drpath(ib_dr_path_t * path, char *routepath, int drslid, int drdlid)
 			break;
 		str = s + 1;
 	}
+	free(tmp);
 
+Exit:
 	path->drdlid = drdlid ? drdlid : 0xffff;
 	path->drslid = drslid ? drslid : 0xffff;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
