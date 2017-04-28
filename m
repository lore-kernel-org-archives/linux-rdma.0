From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 13/19] IB/hfi1: Cache neighbor secure data after link up
Date: Fri, 28 Apr 2017 10:40:13 -0700
Message-ID: <20170428174012.23960.49815.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428173443.23960.32602.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Secure data is transferred across the link during verify
cap. This includes Neighbor Guid, Type, and Port Number.
This transfer is not guaranteed to complete until the 8051
firmware has completed processing of the state_complete
frame. Move the consumption of this data from verify cap
handling to link up handling to ensure the data is finalized.

Additionally, do not notify the SM that the link is up until
after this data is actually available.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   27 +--------------------------
 drivers/infiniband/hw/hfi1/hfi.h  |   11 ++++++++++-
 drivers/infiniband/hw/hfi1/intr.c |   27 ++++++++++++++++-----------
 3 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0fec6be..1ce560e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7288,15 +7288,6 @@ void handle_verify_cap(struct work_struct *work)
 	lcb_shutdown(dd, 0);
 	adjust_lcb_for_fpga_serdes(dd);
 
-	/*
-	 * These are now valid:
-	 *	remote VerifyCap fields in the general LNI config
-	 *	CSR DC8051_STS_REMOTE_GUID
-	 *	CSR DC8051_STS_REMOTE_NODE_TYPE
-	 *	CSR DC8051_STS_REMOTE_FM_SECURITY
-	 *	CSR DC8051_STS_REMOTE_PORT_NO
-	 */
-
 	read_vc_remote_phy(dd, &power_management, &continious);
 	read_vc_remote_fabric(dd, &vau, &z, &vcu, &vl15buf,
 			      &partner_supported_crc);
@@ -7427,20 +7418,6 @@ void handle_verify_cap(struct work_struct *work)
 	write_csr(dd, DC_LCB_ERR_EN, 0); /* mask LCB errors */
 	set_8051_lcb_access(dd);
 
-	ppd->neighbor_guid =
-		read_csr(dd, DC_DC8051_STS_REMOTE_GUID);
-	ppd->neighbor_port_number = read_csr(dd, DC_DC8051_STS_REMOTE_PORT_NO) &
-					DC_DC8051_STS_REMOTE_PORT_NO_VAL_SMASK;
-	ppd->neighbor_type =
-		read_csr(dd, DC_DC8051_STS_REMOTE_NODE_TYPE) &
-		DC_DC8051_STS_REMOTE_NODE_TYPE_VAL_MASK;
-	ppd->neighbor_fm_security =
-		read_csr(dd, DC_DC8051_STS_REMOTE_FM_SECURITY) &
-		DC_DC8051_STS_LOCAL_FM_SECURITY_DISABLED_MASK;
-	dd_dev_info(dd,
-		    "Neighbor Guid: %llx Neighbor type %d MgmtAllowed %d FM security bypass %d\n",
-		    ppd->neighbor_guid, ppd->neighbor_type,
-		    ppd->mgmt_allowed, ppd->neighbor_fm_security);
 	if (ppd->mgmt_allowed)
 		add_full_mgmt_pkey(ppd);
 
@@ -10497,11 +10474,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			goto unexpected;
 		}
 
-		ppd->host_link_state = HLS_UP_INIT;
 		ret = wait_logical_linkstate(ppd, IB_PORT_INIT, 1000);
 		if (ret) {
-			/* logical state didn't change, stay at going_up */
-			ppd->host_link_state = HLS_GOING_UP;
 			dd_dev_err(dd,
 				   "%s: logical state did not change to INIT\n",
 				   __func__);
@@ -10515,6 +10489,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			add_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
 
 			handle_linkup_change(dd, 1);
+			ppd->host_link_state = HLS_UP_INIT;
 		}
 		break;
 	case HLS_UP_ARMED:
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index c6b6853..fec6eb6 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1256,7 +1256,16 @@ void hfi1_init_pportdata(struct pci_dev *, struct hfi1_pportdata *,
 /* return the driver's idea of the logical OPA port state */
 static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 {
-	return ppd->lstate; /* use the cached value */
+	/*
+	 * The driver does some processing from the time the logical
+	 * link state is at INIT to the time the SM can be notified
+	 * as such. Return IB_PORT_DOWN until the software state
+	 * is ready.
+	 */
+	if (ppd->lstate == IB_PORT_INIT && !(ppd->host_link_state & HLS_UP))
+		return IB_PORT_DOWN;
+	else
+		return ppd->lstate;
 }
 
 void receive_interrupt_work(struct work_struct *work);
diff --git a/drivers/infiniband/hw/hfi1/intr.c b/drivers/infiniband/hw/hfi1/intr.c
index 65348d1..232014d 100644
--- a/drivers/infiniband/hw/hfi1/intr.c
+++ b/drivers/infiniband/hw/hfi1/intr.c
@@ -131,19 +131,24 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		if (quick_linkup || dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 			set_up_vl15(dd, dd->vau, dd->vl15_init);
 			assign_remote_cm_au_table(dd, dd->vcu);
-			ppd->neighbor_guid =
-				read_csr(dd, DC_DC8051_STS_REMOTE_GUID);
-			ppd->neighbor_type =
-				read_csr(dd, DC_DC8051_STS_REMOTE_NODE_TYPE) &
-					DC_DC8051_STS_REMOTE_NODE_TYPE_VAL_MASK;
-			ppd->neighbor_port_number =
-				read_csr(dd, DC_DC8051_STS_REMOTE_PORT_NO) &
-					 DC_DC8051_STS_REMOTE_PORT_NO_VAL_SMASK;
-			dd_dev_info(dd, "Neighbor GUID: %llx Neighbor type %d\n",
-				    ppd->neighbor_guid,
-				    ppd->neighbor_type);
 		}
 
+		ppd->neighbor_guid =
+			read_csr(dd, DC_DC8051_STS_REMOTE_GUID);
+		ppd->neighbor_type =
+			read_csr(dd, DC_DC8051_STS_REMOTE_NODE_TYPE) &
+				 DC_DC8051_STS_REMOTE_NODE_TYPE_VAL_MASK;
+		ppd->neighbor_port_number =
+			read_csr(dd, DC_DC8051_STS_REMOTE_PORT_NO) &
+				 DC_DC8051_STS_REMOTE_PORT_NO_VAL_SMASK;
+		ppd->neighbor_fm_security =
+			read_csr(dd, DC_DC8051_STS_REMOTE_FM_SECURITY) &
+				 DC_DC8051_STS_LOCAL_FM_SECURITY_DISABLED_MASK;
+		dd_dev_info(dd,
+			    "Neighbor Guid %llx, Type %d, Port Num %d\n",
+			    ppd->neighbor_guid, ppd->neighbor_type,
+			    ppd->neighbor_port_number);
+
 		/* physical link went up */
 		ppd->linkup = 1;
 		ppd->offline_disabled_reason =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
