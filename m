From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] infiniband-diags: Eliminate unneeded clean_nodedesc
 calls
Date: Mon, 15 Jul 2013 10:32:40 -0400
Message-ID: <51E40808.4040907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in ibroute and dump_fts
clean_nodedesc is called if needed within remap_node_name

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/dump_fts.c b/src/dump_fts.c
index 89f0dce..5383c9d 100644
--- a/src/dump_fts.c
+++ b/src/dump_fts.c
@@ -154,7 +154,7 @@ void dump_multicast_tables(ibnd_node_t * node, unsigned startlid,
 		endlid = IB_MAX_MCAST_LID;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
 
 	printf("Multicast mlids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
 	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
@@ -289,7 +289,7 @@ int dump_lid(char *str, int str_len, int lid, int valid,
 		*last_port_lid = baselid + (1 << lmc) - 1;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
  
 	rc = snprintf(str, str_len, ": (%s portguid %s: '%s')",
 		      mad_dump_val(IB_NODE_TYPE_F, ntype, sizeof ntype,
@@ -331,7 +331,7 @@ void dump_unicast_tables(ibnd_node_t * node, int startlid, int endlid,
 		endlid = IB_MAX_UCAST_LID;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
 
 	printf("Unicast lids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
 	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
diff --git a/src/ibroute.c b/src/ibroute.c
index d4827c9..350a557 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -178,7 +178,7 @@ char *dump_multicast_tables(ib_portid_t * portid, unsigned startlid,
 		endlid = IB_MAX_MCAST_LID;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
 
 	printf("Multicast mlids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
 	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
@@ -309,7 +309,7 @@ int dump_lid(char *str, int strlen, int lid, int valid)
 		last_port_lid = baselid + (1 << lmc) - 1;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
  
 	rc = snprintf(str, strlen, ": (%s portguid %s: '%s')",
 		      mad_dump_val(IB_NODE_TYPE_F, ntype, sizeof ntype,
@@ -348,7 +348,7 @@ char *dump_unicast_tables(ib_portid_t * portid, int startlid, int endlid)
 		endlid = IB_MAX_UCAST_LID;
 	}
 
-	mapnd = remap_node_name(node_name_map, nodeguid, clean_nodedesc(nd));
+	mapnd = remap_node_name(node_name_map, nodeguid, nd);
 
 	printf("Unicast lids [0x%x-0x%x] of switch %s guid 0x%016" PRIx64
 	       " (%s):\n", startlid, endlid, portid2str(portid), nodeguid,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
