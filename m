From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ibacm: Close MAD port when umad_register fails
Date: Tue, 19 Sep 2017 00:51:58 +0300
Message-ID: <20170918215158.27597-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cleanup of the open port is needed when program fails to register MAD
port.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 ibacm/src/acm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index aba0deaa..0c0da7e9 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2418,8 +2418,10 @@ acm_open_port(struct acmc_port *port, struct acmc_device *dev, uint8_t port_num)
 
 	port->mad_agentid = umad_register(port->mad_portid,
 					  IB_MGMT_CLASS_SA, 1, 1, NULL);
-	if (port->mad_agentid < 0)
+	if (port->mad_agentid < 0) {
+		umad_close_port(port->mad_portid);
 		acm_log(0, "ERROR - unable to register MAD client\n");
+	}
 
 	port->prov = NULL;
 	port->state = IBV_PORT_DOWN;
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
