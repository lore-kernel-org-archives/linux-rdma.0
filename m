From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/4 infiniband-diags] ibqueryerrors: code improvement
Date: Sun, 26 Apr 2015 15:34:01 -0400
Message-ID: <553D3DA9.1080507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 26 Apr 2015 18:29:31 +0300

goto is performed after IBEXIT call

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibqueryerrors.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 398e2a7..bdae156 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -1011,7 +1011,6 @@ int main(int argc, char **argv)
 	if (resolve_self(ibd_ca, ibd_ca_port, &self_portid, &port, &self_gid.raw) < 0) {
 		mad_rpc_close_port(ibmad_port);
 		IBEXIT("can't resolve self port %s", argv[0]);
-		goto close_port;
 	}
 
 	node_name_map = open_node_name_map(node_name_map_file);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
