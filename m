From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] [for-3.2] rdma/ucm: Removed checks for unsigned value <
 0
Date: Wed, 7 Sep 2011 23:28:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5A0D1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cmd is unsigned, no need to check for < 0.  Found by
code inspection.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c         |    2 +-
 drivers/infiniband/core/ucma.c        |    2 +-
 drivers/infiniband/core/user_mad.c    |    5 ++---
 drivers/infiniband/core/uverbs_main.c |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 08f948d..b8a0b4a 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1122,7 +1122,7 @@ static ssize_t ib_ucm_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
+	if (hdr.cmd >= ARRAY_SIZE(ucm_cmd_table))
 		return -EINVAL;
 
 	if (hdr.in + sizeof(hdr) > len)
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 71be5ee..b3f3ddd 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1270,7 +1270,7 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
-	if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
+	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 		return -EINVAL;
 
 	if (hdr.in + sizeof(hdr) > len)
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 8d261b6..07db229 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -458,8 +458,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		goto err;
 	}
 
-	if (packet->mad.hdr.id < 0 ||
-	    packet->mad.hdr.id >= IB_UMAD_MAX_AGENTS) {
+	if (packet->mad.hdr.id >= IB_UMAD_MAX_AGENTS) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -703,7 +702,7 @@ static int ib_umad_unreg_agent(struct ib_umad_file *file, u32 __user *arg)
 	mutex_lock(&file->port->file_mutex);
 	mutex_lock(&file->mutex);
 
-	if (id < 0 || id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
+	if (id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 56898b6..7c30e1e 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -557,8 +557,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (hdr.in_words * 4 != count)
 		return -EINVAL;
 
-	if (hdr.command < 0				||
-	    hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
+	if (hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
 	    !uverbs_cmd_table[hdr.command])
 		return -EINVAL;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
