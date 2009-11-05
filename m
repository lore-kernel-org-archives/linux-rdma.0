From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdisc.h: Clarify "ports" member of
 ibnd_node_t with more descriptive comment
Date: Thu, 5 Nov 2009 11:29:56 -0800
Message-ID: <20091105112956.914e4c8a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 17:03:15 -0800
Subject: [PATCH] infiniband-diags/ibnetdisc.h: Clarify "ports" member of ibnd_node_t with more descriptive comment


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index bb5df02..2b4afea 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -66,9 +66,14 @@ typedef struct ibnd_node {
 
 	char nodedesc[IB_SMP_DATA_SIZE];
 
-	struct ibnd_port **ports;	/* in order array of port pointers
-					   the size of this array is info.numports + 1
-					   items MAY BE NULL!  (ie 0 == switches only) */
+	struct ibnd_port **ports;	/* array of ports, indexed by port number
+					   ports[1] == port 1,
+					   ports[2] == port 2,
+					   etc...
+					   Any port in the array MAY BE NULL!
+					   Most notable is non-switches have no
+					   port 0 therefore node.ports[0] == NULL
+					   for those nodes */
 
 	/* chassis info */
 	struct ibnd_node *next_chassis_node;	/* next node in ibnd_chassis_t->nodes */
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
