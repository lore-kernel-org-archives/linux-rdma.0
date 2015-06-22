From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
Date: Mon, 22 Jun 2015 15:31:57 -0700
Message-ID: <1435012318-381-2-git-send-email-mcgrof@do-not-panic.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435012318-381-1-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bp-l3A5Bk7waGM@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

On built-in kernels this will always splat. Fix that.

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [0-day test robot]
Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 2d7e503..871dbe5 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -31,6 +31,8 @@
  * SOFTWARE.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
@@ -399,8 +401,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u32 bar0 = 0, bar1 = 0;
 
 #ifdef CONFIG_X86_64
-	if (WARN(pat_enabled(),
-		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
+	if (pat_enabled()) {
+		pr_warn("ipath needs PAT disabled, boot with nopat kernel parameter\n");
 		ret = -ENODEV;
 		goto bail;
 	}
-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
