From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm/perfmgr: fix endian conversion of PortCounters
Date: Tue, 24 Jul 2012 22:49:17 -0700
Message-ID: <20120724224917.09f38bb5c449404718238c11@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr_db.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index a472287..17e839b 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -769,15 +769,14 @@ perfmgr_db_fill_err_read(ib_port_counters_t * wire_read,
 			 perfmgr_db_err_reading_t * reading)
 {
 	reading->symbol_err_cnt = cl_ntoh16(wire_read->symbol_err_cnt);
-	reading->link_err_recover = cl_ntoh16(wire_read->link_err_recover);
+	reading->link_err_recover = wire_read->link_err_recover;
 	reading->link_downed = wire_read->link_downed;
-	reading->rcv_err = wire_read->rcv_err;
+	reading->rcv_err = cl_ntoh16(wire_read->rcv_err);
 	reading->rcv_rem_phys_err = cl_ntoh16(wire_read->rcv_rem_phys_err);
 	reading->rcv_switch_relay_err =
 	    cl_ntoh16(wire_read->rcv_switch_relay_err);
 	reading->xmit_discards = cl_ntoh16(wire_read->xmit_discards);
-	reading->xmit_constraint_err =
-	    cl_ntoh16(wire_read->xmit_constraint_err);
+	reading->xmit_constraint_err = wire_read->xmit_constraint_err;
 	reading->rcv_constraint_err = wire_read->rcv_constraint_err;
 	reading->link_integrity =
 	    PC_LINK_INT(wire_read->link_int_buffer_overrun);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
