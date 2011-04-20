From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH] do not use the dimn_ports_file if not using dor
	routing
Date: Wed, 20 Apr 2011 11:02:13 -0700
Message-ID: <1303322533.21002.121.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kwkVUQL/4MLRGmRzzo0s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-kwkVUQL/4MLRGmRzzo0s
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Do not use the dimn_ports_file if not using dor routing. If the
dimn_ports_file is specified, it currently will be utilized regardless
of the routing algorithm actually being used.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-kwkVUQL/4MLRGmRzzo0s
Content-Disposition: attachment; filename*0=0001-do-not-use-the-dimn_ports_file-if-not-using-dor-rout.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-do-not-use-the-dimn_ports_file-if-not-using-dor-rout.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 20 Apr 2011 10:56:33 -0700
Subject: [PATCH] do not use the dimn_ports_file if not using dor routing.
	If the dimn_ports_file is specified, it currently will be utilized
	regardless of the routing algorithm actually being used.
Message-Id: <1303322470.21002.120.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_switch.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 9785a9d..47325b6 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -344,7 +344,11 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 
 	/* port number starts with one and num_ports is 1 + num phys ports */
 	for (i = start_from; i < start_from + num_ports; i++) {
-		port_num = osm_switch_get_dimn_port(p_sw, i % num_ports);
+		if (dor)
+			port_num = osm_switch_get_dimn_port(p_sw, i % num_ports);
+		else
+			port_num = i % num_ports;
+
 		if (!port_num ||
 		    osm_switch_get_hop_count(p_sw, base_lid, port_num) !=
 		    least_hops)
-- 
1.7.1


--=-kwkVUQL/4MLRGmRzzo0s--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
