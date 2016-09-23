From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH infiniband-diags] ibportstate: Fixed peer port probing when using DR routing
Date: Fri, 23 Sep 2016 08:42:59 +0200
Message-ID: <430aa17fd12cdcfd735b4215938dc4279e33572d.1474612678.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

When querying a remote port using ibportportstate, queries to the peer port
would result in timeouts. The reason for this is that the DR path (or partial
DR path was not correctly constructed.

Signed-off-by: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 src/ibportstate.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/src/ibportstate.c b/src/ibportstate.c
index cb47aa9..cd0f680 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -1,6 +1,8 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2011, 2015, Oracle and/or its affiliates. All rights reserved.
+ *
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -655,15 +657,31 @@ int main(int argc, char **argv)
 
 			/* Setup portid for peer port */
 			memcpy(&peerportid, &portid, sizeof(peerportid));
-			peerportid.drpath.cnt = 1;
-			peerportid.drpath.p[1] = (uint8_t) portnum;
-
-			/* Set DrSLID to local lid */
-			if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
-						&selfport, 0) < 0)
-				IBEXIT("could not resolve self");
-			peerportid.drpath.drslid = (uint16_t) selfportid.lid;
-			peerportid.drpath.drdlid = 0xffff;
+			if (portid.lid == 0) {
+				peerportid.drpath.cnt = portid.drpath.cnt + 1;
+				if (peerportid.drpath.cnt == IB_SUBNET_PATH_HOPS_MAX) {
+					exit(0);
+				}
+				peerportid.drpath.p[peerportid.drpath.cnt] = (uint8_t) portnum;
+			} else {
+				/* Set DrSLID to local lid */
+				if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
+						       ibd_dest_type, ibd_sm_id, srcport) < 0)
+					IBEXIT("could not resolve self");
+
+				peerportid.drpath.cnt = 1;
+				peerportid.drpath.p[1] = (uint8_t) portnum;
+
+
+				/* Use partial LID routing if remote switch */
+				if ((portid.lid == selfportid.lid)) {
+					peerportid.drpath.drslid = 0xffff;
+					peerportid.drpath.drdlid = 0xffff;
+				} else {
+					peerportid.drpath.drslid = selfportid.lid;
+					peerportid.drpath.drdlid = 0xffff;
+				}
+			}
 
 			/* Get peer port NodeInfo to obtain peer port number */
 			is_peer_switch = get_node_info(&peerportid, data);

base-commit: 2937cf99350a2e423b705e8b8dd10499796a7b41
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
