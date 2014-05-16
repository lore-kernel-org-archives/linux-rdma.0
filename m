From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 6/9] IB/srp: Introduce the 'register_always' kernel module
 parameter
Date: Fri, 16 May 2014 15:48:30 +0200
Message-ID: <5376172E.609@acm.org>
References: <53761628.8030701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53761628.8030701-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a kernel module parameter that enables memory registration also for SG-lists
that can be processed without memory registration. This makes it easier for kernel
developers to test the memory registration code.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c2e0ad3..77ba965 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -66,6 +66,7 @@ static unsigned int srp_sg_tablesize;
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
+static bool register_always;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -87,6 +88,10 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+module_param(register_always, bool, 0444);
+MODULE_PARM_DESC(register_always,
+		 "Use memory registration even for contiguous memory regions");
+
 static struct kernel_param_ops srp_tmo_ops;
 
 static int srp_reconnect_delay = 10;
@@ -956,7 +961,7 @@ static int srp_finish_mapping(struct srp_map_state *state,
 	if (state->npages == 0)
 		return 0;
 
-	if (state->npages == 1)
+	if (state->npages == 1 && !register_always)
 		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
 			     target->rkey);
 	else
@@ -1138,7 +1143,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	fmt = SRP_DATA_DESC_DIRECT;
 	len = sizeof (struct srp_cmd) +	sizeof (struct srp_direct_buf);
 
-	if (count == 1) {
+	if (count == 1 && !register_always) {
 		/*
 		 * The midlayer only generated a single gather/scatter
 		 * entry, or DMA mapping coalesced everything to a
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
