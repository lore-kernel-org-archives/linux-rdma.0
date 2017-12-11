From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 1/2] smpdump.c: Minor fix for when umad_recv
 fails
Date: Mon, 11 Dec 2017 09:57:03 -0500
Message-ID: <bf63fe27-d04e-140c-6ed2-61a7c719d2ee@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


There is no SMP and hence no SMP in this case.
Error displayed should be based on errno.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/smpdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/smpdump.c b/src/smpdump.c
index 6105ec8..bc8559a 100644
--- a/src/smpdump.c
+++ b/src/smpdump.c
@@ -279,7 +279,7 @@ int main(int argc, char *argv[])
 		IBPANIC("send failed");
 
 	if (umad_recv(portid, umad, &length, -1) != mad_agent)
-		IBPANIC("recv error: %s", drmad_status_str(smp));
+		IBPANIC("recv error: %s", strerror(errno));
 
 	if (!dump_char) {
 		xdump(stdout, 0, smp->data, 64);
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
