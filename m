From: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] infiniband: replace strict_strtoul() with kstrtoul()
Date: Fri, 19 Jul 2013 16:15:12 +0900
Message-ID: <001301ce844f$b5e52820$21af7860$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 653ac6b..9245fe4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3678,10 +3678,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &val);
+	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("strict_strtoul() failed with ret: %d\n", ret);
-		return -EINVAL;
+		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		return ret;
 	}
 	if (val > MAX_SRPT_RDMA_SIZE) {
 		pr_err("val: %lu exceeds MAX_SRPT_RDMA_SIZE: %d\n", val,
@@ -3718,10 +3718,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &val);
+	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("strict_strtoul() failed with ret: %d\n", ret);
-		return -EINVAL;
+		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		return ret;
 	}
 	if (val > MAX_SRPT_RSP_SIZE) {
 		pr_err("val: %lu exceeds MAX_SRPT_RSP_SIZE: %d\n", val,
@@ -3758,10 +3758,10 @@ static ssize_t srpt_tpg_attrib_store_srp_sq_size(
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(page, 0, &val);
+	ret = kstrtoul(page, 0, &val);
 	if (ret < 0) {
-		pr_err("strict_strtoul() failed with ret: %d\n", ret);
-		return -EINVAL;
+		pr_err("kstrtoul() failed with ret: %d\n", ret);
+		return ret;
 	}
 	if (val > MAX_SRPT_SRQ_SIZE) {
 		pr_err("val: %lu exceeds MAX_SRPT_SRQ_SIZE: %d\n", val,
@@ -3805,10 +3805,10 @@ static ssize_t srpt_tpg_store_enable(
 	unsigned long tmp;
         int ret;
 
-	ret = strict_strtoul(page, 0, &tmp);
+	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
 		printk(KERN_ERR "Unable to extract srpt_tpg_store_enable\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
