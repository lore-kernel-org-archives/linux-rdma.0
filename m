From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] osmtest/osmt_slvl_vl_arb.c: handling fopen() failure
Date: Tue, 7 Sep 2010 18:07:13 +0300
Message-ID: <4C865521.4080600@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osmtest/osmt_slvl_vl_arb.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/opensm/osmtest/osmt_slvl_vl_arb.c b/opensm/osmtest/osmt_slvl_vl_arb.c
index d3919fb..d4a08ff 100644
--- a/opensm/osmtest/osmt_slvl_vl_arb.c
+++ b/opensm/osmtest/osmt_slvl_vl_arb.c
@@ -489,6 +489,12 @@ osmt_run_slvl_and_vlarb_records_flow(IN osmtest_t * const p_osmt)
 	OSM_LOG_ENTER(&p_osmt->log);

 	fh = fopen("qos.txt", "w");
+	if (!fh) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0474: "
+			"Failed to open file qos.txt for writing\n");
+		status = IB_ERROR;
+		goto Exit;
+	}

 	/* go over all ports in the subnet */
 	status = osmt_query_all_ports_vl_arb(p_osmt, fh);
@@ -520,7 +526,8 @@ osmt_run_slvl_and_vlarb_records_flow(IN osmtest_t * const p_osmt)
 	}

 Exit:
-	fclose(fh);
+	if (fh)
+		fclose(fh);
 	OSM_LOG_EXIT(&p_osmt->log);
 	return status;
 }
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
