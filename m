From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v5 5/6] IB/ipath: add counting for MTRR
Date: Thu, 30 Apr 2015 13:25:19 -0700
Message-ID: <1430425520-22275-6-git-send-email-mcgrof@do-not-panic.com>
References: <1430425520-22275-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430425520-22275-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bp@suse.de, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, daniel.vetter@intel.com, airlied@linux.ie
Cc: dledford@redhat.com, awalls@md.metrocast.net, syrjala@sci.fi, luto@amacapital.net, mst@redhat.com, cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Suresh Siddha <sbsiddha@gmail.com>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, infinipath@intel.com, linux-rdma@vger.kernel.org, linux-fbdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

There is no good reason not to, we eventually delete it as well.

Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: infinipath@intel.com
Cc: linux-rdma@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 4ad0b93..70c1f3a 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -127,7 +127,7 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 			   "(addr %llx, len=0x%llx)\n",
 			   (unsigned long long) pioaddr,
 			   (unsigned long long) piolen);
-		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
+		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
 		if (cookie < 0) {
 			{
 				dev_info(&dd->pcidev->dev,
-- 
2.3.2.209.gd67f9d5.dirty
