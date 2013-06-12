From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 1/6] ibtracert.c: fix resource leak
Date: Wed, 12 Jun 2013 09:55:26 -0400
Message-ID: <51B87DCE.4000708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Call return without freeing the buffer.

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibtracert.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/ibtracert.c b/src/ibtracert.c
index 5800e40..cc0ac98 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -567,13 +567,15 @@ static Node *find_mcpath(ib_portid_t * from, int mlid)
 					if (from->drpath.cnt > 0)
 						path->drpath.cnt--;
 				} else {
-					if (!(port = calloc(1, sizeof(Port))))
+					if (!(port = calloc(1, sizeof(Port)))) {
 						IBERROR("out of memory");
-
+						return 0;
+					}
 					if (get_port(port, i, path) < 0) {
 						IBWARN
 						    ("can't reach node %s port %d",
 						     portid2str(path), i);
+						free(port);
 						return 0;
 					}
 
@@ -585,8 +587,10 @@ static Node *find_mcpath(ib_portid_t * from, int mlid)
 					link_port(port, node);
 #endif
 
-					if (extend_dpath(&path->drpath, i) < 0)
+					if (extend_dpath(&path->drpath, i) < 0) {
+						free(port);
 						return 0;
+					}
 				}
 
 				if (!(remotenode = calloc(1, sizeof(Node))))
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
