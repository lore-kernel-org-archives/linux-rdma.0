From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH krping 1/2] Fixes and changes to support latest kernels
Date: Wed, 11 Sep 2013 17:20:23 +0300
Message-ID: <1378909224-27399-2-git-send-email-ogerlitz@mellanox.com>
References: <1378909224-27399-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378909224-27399-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow to build on latest upstream kernels

Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 krping.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/krping.c b/krping.c
index 67381af..59900ab 100644
--- a/krping.c
+++ b/krping.c
@@ -45,8 +45,9 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/time.h>
+#include <linux/random.h>
 #include <linux/sched.h>
-#include <asm/system.h>
+#include <linux/proc_fs.h>
 
 #include <asm/atomic.h>
 #include <asm/pci.h>
@@ -542,7 +543,7 @@ static void krping_setup_wr(struct krping_cb *cb)
 	case MW:
 		cb->bind_attr.wr_id = 0xabbaabba;
 		cb->bind_attr.send_flags = 0; /* unsignaled */
-		cb->bind_attr.length = cb->size;
+		cb->bind_attr.bind_info.length = cb->size;
 		break;
 	default:
 		break;
@@ -644,7 +645,7 @@ static int krping_setup_buffers(struct krping_cb *cb)
 				cb->page_list, cb->page_list_len);
 			break;
 		case MW:
-			cb->mw = ib_alloc_mw(cb->pd);
+			cb->mw = ib_alloc_mw(cb->pd, 1);
 			if (IS_ERR(cb->mw)) {
 				DEBUG_LOG(PFX "recv_buf alloc_mw failed\n");
 				ret = PTR_ERR(cb->mw);
@@ -913,15 +914,15 @@ static u32 krping_rdma_rkey(struct krping_cb *cb, u64 buf, int post_inv)
 		 * Update the MW with new buf info.
 		 */
 		if (buf == (u64)cb->start_dma_addr) {
-			cb->bind_attr.mw_access_flags = IB_ACCESS_REMOTE_READ;
-			cb->bind_attr.mr = cb->start_mr;
+			cb->bind_attr.bind_info.mw_access_flags = IB_ACCESS_REMOTE_READ;
+			cb->bind_attr.bind_info.mr = cb->start_mr;
 		} else {
-			cb->bind_attr.mw_access_flags = IB_ACCESS_REMOTE_WRITE;
-			cb->bind_attr.mr = cb->rdma_mr;
+			cb->bind_attr.bind_info.mw_access_flags = IB_ACCESS_REMOTE_WRITE;
+			cb->bind_attr.bind_info.mr = cb->rdma_mr;
 		}
-		cb->bind_attr.addr = buf;
+		cb->bind_attr.bind_info.addr = buf;
 		DEBUG_LOG(PFX "binding mw rkey 0x%x to buf %llx mr rkey 0x%x\n",
-			cb->mw->rkey, buf, cb->bind_attr.mr->rkey);
+			cb->mw->rkey, buf, cb->bind_attr.bind_info.mr->rkey);
 		ret = ib_bind_mw(cb->qp, cb->mw, &cb->bind_attr);
 		if (ret) {
 			printk(KERN_ERR PFX "bind mw error %d\n", ret);
@@ -1962,7 +1963,7 @@ static void krping_fr_test(struct krping_cb *cb)
 			ib_update_fast_reg_key(mr, ++key);
 			fr.wr.fast_reg.rkey = mr->rkey;
 			inv.ex.invalidate_rkey = mr->rkey;
-			size = random32() % cb->size;
+			size = prandom_u32() % cb->size;
 			if (size == 0)
 				size = cb->size;
 			plen = (((size - 1) & PAGE_MASK) + PAGE_SIZE) >> PAGE_SHIFT;
@@ -2294,7 +2295,7 @@ int krping_doit(char *cmd)
 		goto out;
 	}
 
-	cb->cm_id = rdma_create_id(krping_cma_event_handler, cb, RDMA_PS_TCP);
+	cb->cm_id = rdma_create_id(krping_cma_event_handler, cb, RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cb->cm_id)) {
 		ret = PTR_ERR(cb->cm_id);
 		printk(KERN_ERR PFX "rdma_create_id error %d\n", ret);
@@ -2389,16 +2390,20 @@ static int krping_write_proc(struct file *file, const char *buffer,
 		return (int) count;
 }
 
+struct file_operations krping_ops = {
+	.owner = THIS_MODULE,
+	.read = krping_read_proc,
+	.write = krping_write_proc
+};
+
 static int __init krping_init(void)
 {
 	DEBUG_LOG("krping_init\n");
-	krping_proc = create_proc_entry("krping", 0666, NULL);
+	krping_proc = proc_create("krping", 0666, NULL, &krping_ops);
 	if (krping_proc == NULL) {
 		printk(KERN_ERR PFX "cannot create /proc/krping\n");
 		return -ENOMEM;
 	}
-	krping_proc->read_proc = krping_read_proc;
-	krping_proc->write_proc = krping_write_proc;
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
