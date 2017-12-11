From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 2/2] smpdump.c: Print number of bytes
 returned by umad_recv
Date: Mon, 11 Dec 2017 09:57:23 -0500
Message-ID: <499f1d77-7da6-2c00-e826-bf4d0809f48a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/smpdump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/smpdump.c b/src/smpdump.c
index bc8559a..bb304d4 100644
--- a/src/smpdump.c
+++ b/src/smpdump.c
@@ -281,6 +281,8 @@ int main(int argc, char *argv[])
 	if (umad_recv(portid, umad, &length, -1) != mad_agent)
 		IBPANIC("recv error: %s", strerror(errno));
 
+	printf("%d bytes received\n", length);
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
