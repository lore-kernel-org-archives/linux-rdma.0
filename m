From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 8/8] acm.c: In acm_join_group, no need to set qkey in
 umad addr to send to SA
Date: Tue, 06 Aug 2013 07:45:43 -0400
Message-ID: <5200E1E7.4070907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 83c6b70..30129f7 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1524,7 +1524,6 @@ static void acm_join_group(struct acm_ep *ep, union ibv_gid *port_gid,
 
 	port = ep->port;
 	umad->addr.qpn = htonl(port->sa_dest.remote_qpn);
-	umad->addr.qkey = htonl(ACM_QKEY);
 	umad->addr.pkey_index = port->default_pkey_ix;
 	umad->addr.lid = htons(port->sa_dest.av.dlid);
 	umad->addr.sl = port->sa_dest.av.sl;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
