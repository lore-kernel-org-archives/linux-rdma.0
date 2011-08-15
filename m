From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] librdmacm: Fix resource leak in error flow
Date: Mon, 15 Aug 2011 14:36:04 +0300
Message-ID: <201108151436.05171.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Prevent resource leak by destroying the event channel before returning from
function in an error flow.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

diff --git a/src/cma.c b/src/cma.c
index bad1ba3..1367779 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -2122,8 +2122,11 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	cmd->fd = id->channel->fd;
 
 	ret = write(channel->fd, msg, size);
-	if (ret != size)
+	if (ret != size) {
+		if (sync)
+			rdma_destroy_event_channel(channel);
 		return (ret >= 0) ? ERR(ENODATA) : -1;
+	}
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
