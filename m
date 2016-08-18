From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 22/23] multicast_resources: use strncpy() to prevent overflow possibility
Date: Thu, 18 Aug 2016 13:32:17 -0400
Message-ID: <1471541538-20270-23-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/multicast_resources.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/multicast_resources.c b/src/multicast_resources.c
index 3a8edba..f5e4bea 100755
--- a/src/multicast_resources.c
+++ b/src/multicast_resources.c
@@ -160,7 +160,7 @@ void set_multicast_gid(struct mcast_parameters *params,uint32_t qp_num,int is_cl
 		}
 		pstr += term - pstr + 1;
 
-		strcpy(tmp, pstr);
+		strncpy(tmp, pstr, sizeof(tmp) - 1);
 		mcg_gid[15] = (unsigned char)strtoll(tmp, NULL, 0);
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
