From: ira.weiny@intel.com
Subject: [PATCH v3 10/23] staging/rdma/hfi1: Fix port bounce issues with 0.22
 DC firmware
Date: Mon, 26 Oct 2015 10:28:36 -0400
Message-ID: <1445869729-7507-11-git-send-email-ira.weiny@intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, Easwar Hariharan <easwar.hariharan@intel.com>, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan@intel.com>

The DC firmware overwrites the enable_lane_tx register and does not update it
on a host request to go to Poll. This causes an infinite loop through the LNI
state machine if a link width downgrade occurs. This patch re-sets the
enable_lane_tx register to all 4 lanes.

Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 1a6dd877c8d8..8b8b7ee4200d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5417,6 +5417,8 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 		if (ppd->link_speed_enabled & OPA_LINK_SPEED_12_5G)
 			ppd->local_tx_rate |= 1;
 	}
+
+	enable_lane_tx = 0xF; /* enable all four lanes */
 	ret = write_tx_settings(dd, enable_lane_tx, tx_polarity_inversion,
 		     rx_polarity_inversion, ppd->local_tx_rate);
 	if (ret != HCMD_SUCCESS)
-- 
1.8.2
