From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_sminfo_rcv.c: removing unused variable
Date: Tue, 7 Sep 2010 17:56:35 +0300
Message-ID: <4C8652A3.90809@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Removing variable that was never used outside
CL_ASSERT() statement.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sminfo_rcv.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_sminfo_rcv.c b/opensm/opensm/osm_sminfo_rcv.c
index e9394d7..b6bc558 100644
--- a/opensm/opensm/osm_sminfo_rcv.c
+++ b/opensm/opensm/osm_sminfo_rcv.c
@@ -78,7 +78,6 @@ static void smi_rcv_process_get_request(IN osm_sm_t * sm,
 					IN const osm_madw_t * p_madw)
 {
 	uint8_t payload[IB_SMP_DATA_SIZE];
-	ib_smp_t *p_smp;
 	ib_sm_info_t *p_smi = (ib_sm_info_t *) payload;
 	ib_api_status_t status;
 	ib_sm_info_t *p_remote_smi;
@@ -90,9 +89,7 @@ static void smi_rcv_process_get_request(IN osm_sm_t * sm,
 	/* No real need to grab the lock for this function. */
 	memset(payload, 0, sizeof(payload));

-	p_smp = osm_madw_get_smp_ptr(p_madw);
-
-	CL_ASSERT(p_smp->method == IB_MAD_METHOD_GET);
+	CL_ASSERT(osm_madw_get_smp_ptr(p_madw)->method == IB_MAD_METHOD_GET);

 	p_smi->guid = sm->p_subn->sm_port_guid;
 	p_smi->act_count = cl_hton32(sm->p_subn->p_osm->stats.qp0_mads_sent);
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
