From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] ibstat.c: fix core dump if wrong port phys state is
	reported
Date: Mon, 4 Oct 2010 12:16:43 +0200
Message-ID: <4CA9A98B.80605@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 infiniband-diags/src/ibstat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibstat.c b/infiniband-diags/src/ibstat.c
index f655a13..f51d17b 100644
--- a/infiniband-diags/src/ibstat.c
+++ b/infiniband-diags/src/ibstat.c
@@ -114,7 +114,7 @@ static int port_dump(umad_port_t * port, int alone)
 	       (unsigned)port->state <=
 	       4 ? port_state_str[port->state] : "???");
 	printf("%sPhysical state: %s\n", pre,
-	       (unsigned)port->state <=
+	       (unsigned)port->phys_state <=
 	       7 ? port_phy_state_str[port->phys_state] : "???");
 	printf("%sRate: %d\n", pre, port->rate);
 	printf("%sBase lid: %d\n", pre, port->base_lid);
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
