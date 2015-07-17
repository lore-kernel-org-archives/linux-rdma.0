From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RESEND PATCH v2 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
Date: Fri, 17 Jul 2015 14:07:24 -0700
Message-ID: <1437167245-28273-2-git-send-email-mcgrof@do-not-panic.com>
References: <1437167245-28273-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437167245-28273-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@elte.hu
Cc: bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com, dledford@redhat.com, dan.j.williams@intel.com, benh@kernel.crashing.org, luto@amacapital.net, julia.lawall@lip6.fr, jkosina@suse.cz, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

WARN() may confuse users, fix that. ipath_init_one() is part the
device's probe so this would only be triggered if a corresponding
device was found.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 2d7e503d13cb..871dbe56216a 100644
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
