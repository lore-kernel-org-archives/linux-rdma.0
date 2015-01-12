From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_subnet.c: Add more supported device IDs
Date: Mon, 12 Jan 2015 14:07:57 -0500
Message-ID: <54B41B8D.3010703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add support for ConnectX-4.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index ba760ff..3463eca 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1476,7 +1476,7 @@ int is_mlnx_ext_port_info_supported(ib_net16_t devid)
 	devid_ho = cl_ntoh16(devid);
 	if ((devid_ho >= 0xc738 && devid_ho <= 0xc73b) || devid_ho == 0xcb20)
 		return 1;
-	if (devid_ho >= 0x1003 && devid_ho <= 0x1013)
+	if (devid_ho >= 0x1003 && devid_ho <= 0x1016)
 		return 1;
 	return 0;
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
