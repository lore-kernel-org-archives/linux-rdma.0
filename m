From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 infiniband-diags] smpdump.c: Print number of bytes returned
 by umad_recv
Date: Wed, 7 Feb 2018 12:05:40 -0500
Message-ID: <c0e1648e-06cc-9c79-05f7-4fc06dd3617a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


when debug is set

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change from v1:
Only print when debug is set

 src/smpdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/smpdump.c b/src/smpdump.c
index bc8559a..efc522f 100644
--- a/src/smpdump.c
+++ b/src/smpdump.c
@@ -281,6 +281,9 @@ int main(int argc, char *argv[])
 	if (umad_recv(portid, umad, &length, -1) != mad_agent)
 		IBPANIC("recv error: %s", strerror(errno));
 
+	if (ibdebug)
+		fprintf(stdout, "%d bytes received\n", length);
+
 	if (!dump_char) {
 		xdump(stdout, 0, smp->data, 64);
 		if (smp->status)
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
