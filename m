From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 2/2] osm_sa_service_record.c: Improve locking
Date: Wed, 26 Mar 2014 14:50:50 -0400
Message-ID: <5333218A.3050108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 25 Mar 2014 12:01:56 +0200

Read lock should be sufficient when treating GET method.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_service_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 61c5892..cce0ad5 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -454,7 +454,7 @@ static void sr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	CL_ASSERT(p_madw);
 
 	/* Grab the lock */
-	cl_plock_excl_acquire(sa->p_lock);
+	cl_plock_acquire(sa->p_lock);
 
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
