From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: opensm/main.c: foce stdout to be line-buffered
Date: Wed, 03 Mar 2010 10:26:46 +0200
Message-ID: <4B8E1D46.4090106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When stdout is assigned to a terminal, it is line-buffered.
But when opensm's stdout is redirected to a file, stdout
becomes block-buffered, which means that '\n' won't cause
the buffer to be flushed.

Forcing stdout to always be line-buffered.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index f9a33af..5ea65dd 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -613,6 +613,9 @@ int main(int argc, char *argv[])
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};

+	/* force stdout to be line-buffered */
+	setlinebuf(stdout);
+
 	/* Make sure that the opensm and complib were compiled using
 	   same modes (debug/free) */
 	if (osm_is_debug() != cl_is_debug()) {
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
