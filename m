From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 10/10] IB/core: Expose ioctl interface through experimental Kconfig
Date: Wed, 19 Apr 2017 18:20:25 +0300
Message-ID: <1492615225-55118-11-git-send-email-matanb@mellanox.com>
References: <1492615225-55118-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492615225-55118-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add CONFIG_INFINIBAND_EXP_USER_ACCESS that enables the ioctl
interface. This interface is experimental and is subject to change.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            | 7 +++++++
 drivers/infiniband/core/uverbs.h      | 2 ++
 drivers/infiniband/core/uverbs_main.c | 6 ++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 66f8602..cabbb11 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -34,6 +34,13 @@ config INFINIBAND_USER_ACCESS
 	  libibverbs, libibcm and a hardware driver library from
 	  <http://www.openfabrics.org/git/>.
 
+config INFINIBAND_EXP_USER_ACCESS
+	bool "Allow experimental support for Infiniband ABI"
+	depends on INFINIBAND_USER_ACCESS
+	---help---
+	  IOCTL based ABI support for Infiniband. This allows userspace
+	  to invoke the experimental IOCTL based ABI.
+
 config INFINIBAND_USER_MEM
 	bool
 	depends on INFINIBAND_USER_ACCESS != n
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ef37a16..2d1330f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -225,6 +225,8 @@ void uverbs_copy_query_dev_fields(struct ib_device *ib_dev,
 void ib_uverbs_detach_umcast(struct ib_qp *qp,
 			     struct ib_uqp_object *uobj);
 
+long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
 struct ib_uverbs_flow_spec {
 	union {
 		union {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 44c4d92..99e70cb 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -950,6 +950,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+#if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
+	.unlocked_ioctl = ib_uverbs_ioctl,
+#endif
 };
 
 static const struct file_operations uverbs_mmap_fops = {
@@ -959,6 +962,9 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close,
 	.llseek	 = no_llseek,
+#if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
+	.unlocked_ioctl = ib_uverbs_ioctl,
+#endif
 };
 
 static struct ib_client uverbs_client = {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
