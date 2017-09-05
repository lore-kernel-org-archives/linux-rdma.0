From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] RDMA/qedr: fix build error without ipv6
Date: Tue,  5 Sep 2017 16:59:20 +0200
Message-ID: <20170905145935.1578698-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When CONFIG_IPV6 disabled, we run into a link error:

drivers/infiniband/hw/qedr/qedr_iw_cm.o: In function `qedr_addr6_resolve.isra.3':
qedr_iw_cm.c:(.text+0x4e0): undefined reference to `ip6_route_output_flags'

The ipv6 handling code is obviously not needed here, so this
adds a compile-time check for the Kconfig symbol in all three
places in the code that decide between ipv4 and ipv6.

We don't have to worry about a link error wtih QEDR=y/IPV6=m, as
that configuration is already prohibited by CONFIG_INFINIBAND
depending on "m || IPV6 != m".

Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management functions")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index fe9b2b6149b0..2950d3f6ecb8 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -98,7 +98,8 @@ qedr_iw_mpa_request(void *context, struct qed_iwarp_cm_event_params *params)
 	event.event = IW_CM_EVENT_CONNECT_REQUEST;
 	event.status = params->status;
 
-	if (params->cm_info->ip_version == QED_TCP_IPV4)
+	if (!IS_ENABLED(CONFIG_IPV6) ||
+	    params->cm_info->ip_version == QED_TCP_IPV4)
 		qedr_fill_sockaddr4(params->cm_info, &event);
 	else
 		qedr_fill_sockaddr6(params->cm_info, &event);
@@ -522,7 +523,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	memset(cm_info->local_ip, 0, sizeof(cm_info->local_ip));
 	memset(cm_info->remote_ip, 0, sizeof(cm_info->remote_ip));
 
-	if (cm_id->remote_addr.ss_family == AF_INET) {
+	if (!IS_ENABLED(CONFIG_IPV6) ||
+	    cm_id->remote_addr.ss_family == AF_INET) {
 		cm_info->ip_version = QED_TCP_IPV4;
 
 		cm_info->remote_ip[0] = ntohl(raddr->sin_addr.s_addr);
@@ -616,7 +618,8 @@ int qedr_iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	iparams.event_cb = qedr_iw_event_handler;
 	iparams.max_backlog = backlog;
 
-	if (cm_id->local_addr.ss_family == AF_INET) {
+	if (!IS_ENABLED(CONFIG_IPV6) ||
+	    cm_id->local_addr.ss_family == AF_INET) {
 		iparams.ip_version = QED_TCP_IPV4;
 		memset(iparams.ip_addr, 0, sizeof(iparams.ip_addr));
 
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
