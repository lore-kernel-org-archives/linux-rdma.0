From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv4 TRIVIAL] IB/core: Documentation fix to the snoop handler in
 the MAD header file
Date: Tue, 5 Jan 2016 13:52:55 -0500
Message-ID: <568C1107.2060203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In ib_mad.h, ib_mad_snoop_handler uses send_buf rather than send_wr

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v3:
Fixed title to not include function name

Change since v2:
Changed title to use "higher" language

Change since v1:
Fixed typo in patch description

diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index ec9b44d..2b3573d 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -424,11 +424,11 @@ typedef void (*ib_mad_send_handler)(struct ib_mad_agent *mad_agent,
 /**
  * ib_mad_snoop_handler - Callback handler for snooping sent MADs.
  * @mad_agent: MAD agent that snooped the MAD.
- * @send_wr: Work request information on the sent MAD.
+ * @send_buf: send MAD data buffer.
  * @mad_send_wc: Work completion information on the sent MAD.  Valid
  *   only for snooping that occurs on a send completion.
  *
- * Clients snooping MADs should not modify data referenced by the @send_wr
+ * Clients snooping MADs should not modify data referenced by the @send_buf
  * or @mad_send_wc.
  */
 typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
