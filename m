From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibacm: properly check return from ibv_open_device
Date: Fri, 21 Mar 2014 07:23:08 -0700
Message-ID: <20140321072308.ed70c376a0708ccb11583a6b@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/acme.c b/src/acme.c
index b122e58..d3d6303 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -353,7 +353,7 @@ static int open_verbs(void)
 
 	for (i = 0; i < dev_cnt; i++) {
 		verbs[i] = ibv_open_device(dev_array[i]);
-		if (!verbs) {
+		if (!verbs[i]) {
 			printf("ibv_open_device - failed to open device\n");
 			ret = -1;
 			goto err2;
-- 
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
