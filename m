From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags/libibnetdisc: Removed trivial comments
Date: Wed, 14 Oct 2009 09:44:35 +0530
Message-ID: <829ded920910132114v24498fdfjbdcf17d92363adb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

infiniband-diags/libibnetdisc/: Removed trivial comments.

Signed-off-by: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 97e369c..ef8aa6a 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -94,9 +94,6 @@ static int get_port_info(struct ibmad_port *ibmad_port,
 	return 0;
 }

-/*
- * Returns -1 if error.
- */
 static int query_node_info(struct ibmad_port *ibmad_port,
 			   ibnd_fabric_t * fabric, ibnd_node_t * node,
 			   ib_portid_t * portid)
@@ -113,9 +110,6 @@ static int query_node_info(struct ibmad_port *ibmad_port,
 	return (0);
 }

-/*
- * Returns 0 if non switch node is found, 1 if switch is found, -1 if error.
- */
 static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 		      ibnd_node_t * node, ibnd_port_t * port,
 		      ib_portid_t * portid)
-- 
1.6.4


-- 
Keshetti Mahesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
