From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_[mcmember path]_record.c: Optimize clearing
 of SA record items
Date: Wed, 30 Apr 2014 10:34:59 -0400
Message-ID: <53610A13.6010705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |    2 +-
 opensm/osm_sa_path_record.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 85e7681..403387c 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1326,7 +1326,7 @@ static ib_api_status_t mcmr_rcv_new_mcmr(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	memset(p_rec_item, 0, SA_MCM_RESP_SIZE);
+	memset(p_rec_item, 0, sizeof(cl_list_item_t));
 
 	/* HACK: Untrusted requesters should result with 0 Join
 	   State, Port Guid, and Proxy */
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 75b8c02..2aa4248 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1686,7 +1686,7 @@ static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
 			"Unable to allocate path record for MC group\n");
 		return;
 	}
-	memset(pr_item, 0, SA_PR_RESP_SIZE);
+	memset(pr_item, 0, sizeof(cl_list_item_t));
 
 	/* Copy PathRecord request into response */
 	pr_item->resp.path_rec = *pr;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
