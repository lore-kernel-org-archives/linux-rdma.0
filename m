From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/4 infiniband-diags] ibqueryerrors: improve code related
 to DR option
Date: Sun, 26 Apr 2015 15:33:57 -0400
Message-ID: <553D3DA5.4060102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 26 Apr 2015 18:26:16 +0300

The call to ibnd_find_port_dr() is removed
as couple of lines after that the port is overridden by result of
ibnd_find_port_guid()

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibqueryerrors.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 80436d3..398e2a7 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -1087,7 +1087,7 @@ int main(int argc, char **argv)
 			fprintf(stderr, "Failed to find node: %s\n",
 				port_guid_str);
 	} else if (dr_path) {
-		ibnd_port_t *port = ibnd_find_port_dr(fabric, dr_path);
+		ibnd_port_t *port;
 		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
 			   ibd_timeout, ibmad_port)) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
