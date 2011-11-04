From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 3/3] ib_srpt: propagate return value from kstrtoul()
Date: Fri, 4 Nov 2011 21:28:30 +0300
Message-ID: <20111104182830.GI5796@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-4mckEHfoRW3KI0RCH6AXYZqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These days we've renamed strict_strtoul() to kstrtoul().  It has a
couple different error codes it could return.  Smatch complains if
we return -EINVAL instead of using the return value that kstrtoul()
gave us.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f27b8da..04ccc04 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3704,10 +3704,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
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
@@ -3744,10 +3744,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
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
@@ -3784,10 +3784,10 @@ static ssize_t srpt_tpg_attrib_store_srp_sq_size(
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
@@ -3831,10 +3831,10 @@ static ssize_t srpt_tpg_store_enable(
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
