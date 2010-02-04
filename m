From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: ucm,scm,cma: destroy verbs completion channels
 created via ia_open or ep_create.
Date: Wed, 3 Feb 2010 16:26:22 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B2E3A67B@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Completion channels are created with ia_open for CNO events and
with ep_create in cases where DAT allows EP(qp) to be created with
no EVD(cq) and IB doesn't. These completion channels need to be
destroyed at close along with a CQ for the "EP without EVD" case.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/device.c |   11 +++++++++++
 dapl/openib_scm/device.c |   10 ++++++++++
 dapl/openib_ucm/device.c |   10 ++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/device.c b/dapl/openib_cma/device.c
index 7ab05aa..12593cf 100644
--- a/dapl/openib_cma/device.c
+++ b/dapl/openib_cma/device.c
@@ -502,6 +502,17 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 		dapl_os_sleep_usec(1000);
 	}
 bail:
+
+	if (hca_ptr->ib_trans.ib_cq)
+		ibv_destroy_comp_channel(hca_ptr->ib_trans.ib_cq);
+
+	if (hca_ptr->ib_trans.ib_cq_empty) {
+		struct ibv_comp_channel *channel;
+		channel = hca_ptr->ib_trans.ib_cq_empty->channel;
+		ibv_destroy_cq(hca_ptr->ib_trans.ib_cq_empty);
+		ibv_destroy_comp_channel(channel);
+	}
+
 	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
 		if (rdma_destroy_id(hca_ptr->ib_trans.cm_id))
 			return (dapl_convert_errno(errno, "ib_close_device"));
diff --git a/dapl/openib_scm/device.c b/dapl/openib_scm/device.c
index 35d4c45..eb87a85 100644
--- a/dapl/openib_scm/device.c
+++ b/dapl/openib_scm/device.c
@@ -504,6 +504,16 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 	}
 
 out:
+	if (hca_ptr->ib_trans.ib_cq)
+		ibv_destroy_comp_channel(hca_ptr->ib_trans.ib_cq);
+
+	if (hca_ptr->ib_trans.ib_cq_empty) {
+		struct ibv_comp_channel *channel;
+		channel = hca_ptr->ib_trans.ib_cq_empty->channel;
+		ibv_destroy_cq(hca_ptr->ib_trans.ib_cq_empty);
+		ibv_destroy_comp_channel(channel);
+	}
+
 	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
 		if (ibv_close_device(hca_ptr->ib_hca_handle))
 			return (dapl_convert_errno(errno, "ib_close_device"));
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index e890eef..1f324b3 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -401,6 +401,16 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 	destroy_os_signal(hca_ptr);
 	ucm_service_destroy(hca_ptr);
 
+	if (hca_ptr->ib_trans.ib_cq)
+		ibv_destroy_comp_channel(hca_ptr->ib_trans.ib_cq);
+
+	if (hca_ptr->ib_trans.ib_cq_empty) {
+		struct ibv_comp_channel *channel;
+		channel = hca_ptr->ib_trans.ib_cq_empty->channel;
+		ibv_destroy_cq(hca_ptr->ib_trans.ib_cq_empty);
+		ibv_destroy_comp_channel(channel);
+	}
+
 	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
 		if (ibv_close_device(hca_ptr->ib_hca_handle))
 			return (dapl_convert_errno(errno, "ib_close_device"));
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
