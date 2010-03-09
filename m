From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: infiniband-diags/ibstat.c: print link layer for RoCEE support
Date: Tue, 09 Mar 2010 12:41:15 +0200
Message-ID: <4B9625CB.5040700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 infiniband-diags/src/ibstat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/src/ibstat.c b/infiniband-diags/src/ibstat.c
index 987bf2b..c44d8c4 100644
--- a/infiniband-diags/src/ibstat.c
+++ b/infiniband-diags/src/ibstat.c
@@ -124,6 +124,7 @@ static int port_dump(umad_port_t * port, int alone)
 	printf("%sCapability mask: 0x%08x\n", pre, ntohl(port->capmask));
 	printf("%sPort GUID: 0x%016llx\n", pre,
 	       (long long unsigned)ntohll(port->port_guid));
+	printf("%sLink layer: %s\n", pre, port->link_layer);
 	return 0;
 }

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
