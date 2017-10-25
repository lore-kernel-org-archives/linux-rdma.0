From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core 1/3] ibacm: acm_util.c: Better log message when
 ioctl fails in acm_if_iter_sys
Date: Wed, 25 Oct 2017 09:41:49 -0400
Message-ID: <6dc90dcf-d6df-dffd-5c07-728ebdae249f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


RETURN VALUE for ioctl says:
On error, -1 is returned, and errno is set appropriately.

Rather than log the return value, use the string for errno.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm/src/acm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/src/acm_util.c b/ibacm/src/acm_util.c
index aca042d..b50fd74 100644
--- a/ibacm/src/acm_util.c
+++ b/ibacm/src/acm_util.c
@@ -152,7 +152,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 
 	ret = ioctl(s, SIOCGIFCONF, ifc);
 	if (ret < 0) {
-		acm_log(0, "ioctl ifconf error %d\n", ret);
+		acm_log(0, "ioctl ifconf error: %s\n", strerror(errno));
 		goto out2;
 	}
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
