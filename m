From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core 2/3] ibacm: In acm.c:acm_open_providers, cosmetic
 change to log message
Date: Wed, 25 Oct 2017 09:42:07 -0400
Message-ID: <e6e224f4-5524-cdec-f08e-5140e058ab6a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for consistency

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm/src/acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index a67001d..3f2d617 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2648,7 +2648,7 @@ static int acm_open_providers(void)
 
 		query = dlsym(handle, "provider_query");
 		if ((err_str = dlerror()) != NULL) {
-			acm_log(0, "Error -provider_query not found in %s (%s)\n",
+			acm_log(0, "Error - provider_query not found in %s (%s)\n",
 				file_name, err_str);
 			dlclose(handle);
 			continue;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
