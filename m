From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] infiniband-diags/ibqueryerrors: Properly exit and clean
 up resources when node info query fails
Date: Tue, 3 Nov 2009 20:22:47 -0800
Message-ID: <20091103202247.901acbda.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 20:17:14 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Properly exit and clean up resources when node info query fails


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 43698d2..8305e5d 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -559,8 +559,10 @@ int main(int argc, char **argv)
 		uint8_t ni[IB_SMP_DATA_SIZE];
 
 		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
-				   ibd_timeout, ibmad_port))
-			return -1;
+				   ibd_timeout, ibmad_port)) {
+			rc = -1;
+			goto destroy_fabric;
+		}
 		mad_decode_field(ni, IB_NODE_GUID_F, &(node_guid));
 
 		node = ibnd_find_node_guid(fabric, node_guid);
@@ -571,6 +573,7 @@ int main(int argc, char **argv)
 	} else
 		ibnd_iter_nodes(fabric, print_node, NULL);
 
+destroy_fabric:
 	ibnd_destroy_fabric(fabric);
 
 close_port:
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
