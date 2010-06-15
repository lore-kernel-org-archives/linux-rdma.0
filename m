From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest.c: fix bug in getting attr offset
Date: Tue, 15 Jun 2010 11:33:41 +0300
Message-ID: <4C173AE5.6030207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix bug that was introduced by commit 4fd4ca306f93376963725285f3bf7c87a76055b0

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osmtest/osmtest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index abdfa7e..7412ce7 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -563,7 +563,7 @@ osmtest_get_all_recs(IN osmtest_t * const p_osmt,

 	p_context->p_osmt = p_osmt;
 	user.attr_id = attr_id;
-	user.attr_offset = ib_get_attr_offset((uint16_t) (attr_size >> 3));
+	user.attr_offset = ib_get_attr_offset((uint16_t) attr_size);

 	req.query_type = OSMV_QUERY_USER_DEFINED;
 	req.timeout_ms = p_osmt->opt.transaction_timeout;
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
