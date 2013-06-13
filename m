From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: ibstat fix strncpy coverity check and -l
 bug
Date: Wed, 12 Jun 2013 17:03:07 -0700
Message-ID: <20130612170307.8eb7f51c4b68512db703615a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/ibstat.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/src/ibstat.c b/src/ibstat.c
index 665bb0a..1ef27f2 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -314,7 +314,8 @@ int main(int argc, char *argv[])
 		if (i >= n)
 			IBPANIC("'%s' IB device can't be found", argv[0]);
 
-		strncpy(names[i], argv[0], sizeof names[i]);
+		strncpy(names[0], argv[0], sizeof(names[0])-1);
+		names[0][sizeof(names[0])-1] = '\0';
 		n = 1;
 	}
 
@@ -324,12 +325,6 @@ int main(int argc, char *argv[])
 		return 0;
 	}
 
-	if (!list_only && argc) {
-		if (ca_stat(argv[0], dev_port, short_format) < 0)
-			IBPANIC("stat of IB device '%s' failed", argv[0]);
-		return 0;
-	}
-
 	for (i = 0; i < n; i++) {
 		if (list_only)
 			printf("%s\n", names[i]);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
