From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/main.c: Change size parameter in setvbuf call from
 0 to BUFSIZ
Date: Mon, 17 Oct 2011 13:34:09 -0400
Message-ID: <4E9C6711.3020704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to eliminate Win8 assert as this is shared code

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index 51c8291..f7a6d83 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -645,7 +645,7 @@ int main(int argc, char *argv[])
 	};
 
 	/* force stdout to be line-buffered */
-	setvbuf(stdout, NULL, _IOLBF, 0);
+	setvbuf(stdout, NULL, _IOLBF, BUFSIZ);
 
 	/* Make sure that the opensm and complib were compiled using
 	   same modes (debug/free) */
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
