From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 3/4] IB/hfi1: Fix context recovery when PBC has an
 UnsupportedVL
Date: Thu, 20 Sep 2018 12:44:34 -0700
Message-ID: <20180920194429.7072.53594.stgit@scvm10.sc.intel.com>
References: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180920193538.7072.71796.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Lukasz Odzioba <lukasz.odzioa@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

If a packet stream uses an UnsupportedVL (virtual lane), the send
engine will not send the packet, and it will not indicate that an
error has occurred.  This will cause the packet stream to block.

HFI has 8 virtual lanes available for packet streams.  Each lane can
be enabled or disabled using the UnsupportedVL mask.  If a lane is
disabled, adding a packet to the send context must be disallowed.

The current mask for determining unsupported VLs defaults to 0 (allow
all).  This is incorrect.  Only the VLs that are defined should be
allowed.

Determine which VLs are disabled (mtu == 0), and set the appropriate
unsupported bit in the mask.  The correct mask will allow the send
engine to error on the invalid VL, and error recovery will work
correctly.

Cc: <stable@vger.kernel.org> # 4.9.x+
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Lukasz Odzioba <lukasz.odzioa@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/pio.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index c2c1cba..cd962c9 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -86,6 +86,7 @@ void pio_send_control(struct hfi1_devdata *dd, int op)
 	unsigned long flags;
 	int write = 1;	/* write sendctrl back */
 	int flush = 0;	/* re-read sendctrl to make sure it is flushed */
+	int i;
 
 	spin_lock_irqsave(&dd->sendctrl_lock, flags);
 
@@ -95,9 +96,13 @@ void pio_send_control(struct hfi1_devdata *dd, int op)
 		reg |= SEND_CTRL_SEND_ENABLE_SMASK;
 	/* Fall through */
 	case PSC_DATA_VL_ENABLE:
+		mask = 0;
+		for (i = 0; i < ARRAY_SIZE(dd->vld); i++)
+			if (!dd->vld[i].mtu)
+				mask |= BIT_ULL(i);
 		/* Disallow sending on VLs not enabled */
-		mask = (((~0ull) << num_vls) & SEND_CTRL_UNSUPPORTED_VL_MASK) <<
-				SEND_CTRL_UNSUPPORTED_VL_SHIFT;
+		mask = (mask & SEND_CTRL_UNSUPPORTED_VL_MASK) <<
+			SEND_CTRL_UNSUPPORTED_VL_SHIFT;
 		reg = (reg & ~SEND_CTRL_UNSUPPORTED_VL_SMASK) | mask;
 		break;
 	case PSC_GLOBAL_DISABLE:
