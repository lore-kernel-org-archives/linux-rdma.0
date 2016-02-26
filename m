From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] iw_cxgb3: support for iWARP port mapping
Date: Fri, 26 Feb 2016 09:18:04 -0600
Message-ID: <1456499885-8044-6-git-send-email-faisal.latif@intel.com>
References: <1456499885-8044-1-git-send-email-faisal.latif@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456499885-8044-1-git-send-email-faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Now with the new iWARP port mapping service in the iwcm, it is
trivial to add cxgb3 support.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index f504ba7..d403231 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1877,7 +1877,7 @@ err:
 static int is_loopback_dst(struct iw_cm_id *cm_id)
 {
 	struct net_device *dev;
-	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
 
 	dev = ip_dev_find(&init_net, raddr->sin_addr.s_addr);
 	if (!dev)
@@ -1892,10 +1892,10 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct iwch_ep *ep;
 	struct rtable *rt;
 	int err = 0;
-	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
-	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
 
-	if (cm_id->remote_addr.ss_family != PF_INET) {
+	if (cm_id->m_remote_addr.ss_family != PF_INET) {
 		err = -ENOSYS;
 		goto out;
 	}
@@ -1961,9 +1961,9 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	state_set(&ep->com, CONNECTING);
 	ep->tos = IPTOS_LOWDELAY;
-	memcpy(&ep->com.local_addr, &cm_id->local_addr,
+	memcpy(&ep->com.local_addr, &cm_id->m_local_addr,
 	       sizeof(ep->com.local_addr));
-	memcpy(&ep->com.remote_addr, &cm_id->remote_addr,
+	memcpy(&ep->com.remote_addr, &cm_id->m_remote_addr,
 	       sizeof(ep->com.remote_addr));
 
 	/* send connect request to rnic */
@@ -1992,7 +1992,7 @@ int iwch_create_listen(struct iw_cm_id *cm_id, int backlog)
 
 	might_sleep();
 
-	if (cm_id->local_addr.ss_family != PF_INET) {
+	if (cm_id->m_local_addr.ss_family != PF_INET) {
 		err = -ENOSYS;
 		goto fail1;
 	}
@@ -2008,7 +2008,7 @@ int iwch_create_listen(struct iw_cm_id *cm_id, int backlog)
 	cm_id->add_ref(cm_id);
 	ep->com.cm_id = cm_id;
 	ep->backlog = backlog;
-	memcpy(&ep->com.local_addr, &cm_id->local_addr,
+	memcpy(&ep->com.local_addr, &cm_id->m_local_addr,
 	       sizeof(ep->com.local_addr));
 
 	/*
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
