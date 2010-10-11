From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: osm_vl15intf.c: fixing use-after-free coredump
Date: Mon, 11 Oct 2010 13:04:22 +0200
Message-ID: <4CB2EF36.2040209@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

p_madw is freed if responce is not expected.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_vl15intf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index bb2c0c6..c845597 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -57,13 +57,14 @@
 static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 {
 	ib_api_status_t status;
+	boolean_t resp_expected = p_madw->resp_expected;

 	/*
 	   Non-response-expected mads are not throttled on the wire
 	   since we can have no confirmation that they arrived
 	   at their destination.
 	 */
-	if (p_madw->resp_expected == TRUE)
+	if (resp_expected)
 		/*
 		   Note that other threads may not see the response MAD
 		   arrive before send() even returns.
@@ -103,7 +104,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	   qp0_mads_outstanding will be decremented by send error callback
 	   (called by osm_vendor_send() */
 	cl_atomic_dec(&p_vl->p_stats->qp0_mads_sent);
-	if (!p_madw->resp_expected)
+	if (!resp_expected)
 		cl_atomic_dec(&p_vl->p_stats->qp0_unicasts_sent);
 }

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
