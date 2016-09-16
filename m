From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 1/8] ib_mad: incoming sminfo SMPs gets discarded if no process_mad function is registered
Date: Fri, 16 Sep 2016 20:31:12 +0200
Message-ID: <66d69383a3376018d99c025cd188150f6673b209.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Knut Omang <knut.omang@oracle.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <ira.weiny@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Dag Moxnes <dag.moxnes@oracle.com>, Mark Bloch <markb@mellanox.com>, Dean Luick <dean.luick@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Dag Moxnes <dag.moxnes@oracle.com>

The process_mad function is an optional IB driver entry point
allows a driver to intercept or modify MAD traffic.

This fix allows MAD traffic to flow down to the device also
when MAD traffic is completely handled by the device and
no process_mad function is provided.

SIF, the new Oracle Infiniband HCA, is the first HCA
where the device itself makes all decision wrt MAD processing.
Up till now devices either supports MAD, and do then
implement the process_mad entry point, or do not
support MAD at all, and then do not implement process_mad.

SIF introduces a 3rd case: Supports MAD
but do not terminate any MAD requests in the driver.
This case is not handled well by the current code.

The problem is that the handle_outgoing_dr_smp function
has an implicit assumption that some packets are handled
by the process_mad function itself.

There is no way to provide return values from the process_mad
function that ensures that packets are always forwarded to the device,
so the only viable solution without breaking the API
seems to be to not implement process_mad.
---
 drivers/infiniband/core/mad.c | 6 ++++++
 drivers/infiniband/core/smi.h | 6 ++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2d49228..ece33ec 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -813,6 +813,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			goto out;
 	}
 
+	/* If device does not define the optional process_mad function it means that
+	 * everything is handled in hardware:
+	 */
+	if (!device->process_mad)
+		goto out;
+
 	local = kmalloc(sizeof *local, GFP_ATOMIC);
 	if (!local) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
index 33c91c8..16a9f9a 100644
--- a/drivers/infiniband/core/smi.h
+++ b/drivers/infiniband/core/smi.h
@@ -67,8 +67,7 @@ static inline enum smi_action smi_check_local_smp(struct ib_smp *smp,
 {
 	/* C14-9:3 -- We're at the end of the DR segment of path */
 	/* C14-9:4 -- Hop Pointer = Hop Count + 1 -> give to SMA/SM */
-	return ((device->process_mad &&
-		!ib_get_smp_direction(smp) &&
+	return ((!ib_get_smp_direction(smp) &&
 		(smp->hop_ptr == smp->hop_cnt + 1)) ?
 		IB_SMI_HANDLE : IB_SMI_DISCARD);
 }
@@ -82,8 +81,7 @@ static inline enum smi_action smi_check_local_returning_smp(struct ib_smp *smp,
 {
 	/* C14-13:3 -- We're at the end of the DR segment of path */
 	/* C14-13:4 -- Hop Pointer == 0 -> give to SM */
-	return ((device->process_mad &&
-		ib_get_smp_direction(smp) &&
+	return ((ib_get_smp_direction(smp) &&
 		!smp->hop_ptr) ? IB_SMI_HANDLE : IB_SMI_DISCARD);
 }
 
-- 
git-series 0.8.10
