From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/opa_vnic: Use GFP_ATOMIC while sending trap
Date: Wed, 14 Jun 2017 12:34:41 -0700
Message-ID: <1497468882-19161-2-git-send-email-niranjana.vishwanathapura@intel.com>
References: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497468882-19161-1-git-send-email-niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pass GFP_ATOMIC flag to ib_create_send_mad() while sending trap as it
can be triggered from the atomic context.

Fix the following trace with debug kernel.

BUG: sleeping function called from invalid context at mm/slab.h:432
in_atomic(): 1, irqs_disabled(): 0, pid: 1771, name: NetworkManager
Call Trace:
 dump_stack+0x63/0x90
 ___might_sleep+0xda/0x130
 __might_sleep+0x4a/0x90
 __kmalloc+0x19e/0x220
 ? ib_create_send_mad+0xea/0x390 [ib_core]
 ib_create_send_mad+0xea/0x390 [ib_core]
 opa_vnic_vema_send_trap+0x17b/0x460 [opa_vnic]
 opa_vnic_vema_report_event+0x57/0x80 [opa_vnic]
 opa_vnic_mac_send_event+0xaa/0xf0 [opa_vnic]
 opa_vnic_set_rx_mode+0x17/0x30 [opa_vnic]
 __dev_set_rx_mode+0x52/0x90
 dev_set_rx_mode+0x26/0x40
 __dev_open+0xe8/0x140

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 875694f..cf768dd 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -794,7 +794,7 @@ void opa_vnic_vema_send_trap(struct opa_vnic_adapter *adapter,
 
 	send_buf = ib_create_send_mad(port->mad_agent, 1, pkey_idx, 0,
 				      IB_MGMT_VENDOR_HDR, IB_MGMT_MAD_DATA,
-				      GFP_KERNEL, OPA_MGMT_BASE_VERSION);
+				      GFP_ATOMIC, OPA_MGMT_BASE_VERSION);
 	if (IS_ERR(send_buf)) {
 		c_err("%s:Couldn't allocate send buf\n", __func__);
 		goto err_sndbuf;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
