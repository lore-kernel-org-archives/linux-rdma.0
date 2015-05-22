From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 7/7] dapl dtest: add logging of provider private data size with -v
Date: Fri, 22 May 2015 12:22:47 -0700
Message-ID: <1432322567-9349-7-git-send-email-arlin.r.davis@intel.com>
References: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432322567-9349-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dtest/dtest.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/test/dtest/dtest.c b/test/dtest/dtest.c
index c9e58ec..bd30207 100755
--- a/test/dtest/dtest.c
+++ b/test/dtest/dtest.c
@@ -710,7 +710,7 @@ int main(int argc, char **argv)
 
 	/* Provider specific attributes */
 	for (i=0; i<pr_attr.num_provider_specific_attr; i++) {
-		LOGPRINTF("%d Provider_attr[%d] %s = %s \n",
+		LOGPRINTF("%d provider_specific_attr[%d] %s = %s \n",
 			  getpid(), i,
 			  pr_attr.provider_specific_attr[i].name,
 			  pr_attr.provider_specific_attr[i].value);
@@ -718,6 +718,8 @@ int main(int argc, char **argv)
 		    !strcmp(pr_attr.provider_specific_attr[i].value,"TRUE") && !write_only)
 			rdma_read = 1;
 	}
+	LOGPRINTF("%d provider_attr->max_private_data_size = %d\n",
+		   getpid(), pr_attr.max_private_data_size);
 
 	/* Create Protection Zone */
 	start = get_time();
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
