From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 5/6] ibtracert.c: Uninitialized variable
Date: Wed, 12 Jun 2013 09:55:48 -0400
Message-ID: <51B87DE4.3040707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Reading from uninitialized variable

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibtracert.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/src/ibtracert.c b/src/ibtracert.c
index cc0ac98..9699ccc 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -250,6 +250,13 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
 	int maxhops = MAXHOPS;
 	int portnum, outport;
 
+	memset(&fromnode,0,sizeof(Node));
+	memset(&tonode,0,sizeof(Node));
+	memset(&nextnode,0,sizeof(Node));
+	memset(&fromport,0,sizeof(Port));
+	memset(&toport,0,sizeof(Port));
+	memset(&nextport,0,sizeof(Port));
+
 	DEBUG("from %s", portid2str(from));
 
 	if (get_node(&fromnode, &fromport, from) < 0 ||
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
