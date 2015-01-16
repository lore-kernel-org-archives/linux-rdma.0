From: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Subject: [PATCH] ib_srpt: wait_for_completion_timeout does not return negativ status
Date: Fri, 16 Jan 2015 12:20:17 +0100
Message-ID: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
---

Patch is against 3.19.0-rc3 -next-20150109

Patch was compiletested only with x86_64_defconfig +
CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m

 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index eb694dd..4e58c76 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	spin_unlock_irq(&sdev->spinlock);
 
 	res = wait_for_completion_timeout(&release_done, 60 * HZ);
-	WARN_ON(res <= 0);
+	WARN_ON(res == 0);
 }
 
 /**
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
