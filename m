From: Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] sdp: Prevent kernel crash if device init fails (plus bonus fix)
Date: Mon, 22 Feb 2010 18:06:56 +0100
Message-ID: <201002221806.56390.fenkes@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OF-EWG <ewg@l>
Cc: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If sdp_add_device() fails, there is no client data stored in the IB device,
leading to a kernel crash when a connection is being established. Fix this
by rejecting connections when the device is not initialized.

Also, fix a bad goto target in an error case early in sdp_init_qp().

Signed-off-by: Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
---
 kernel_patches/fixes/sdp-0001-fix-error-path.patch |   38 ++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 kernel_patches/fixes/sdp-0001-fix-error-path.patch

diff --git a/kernel_patches/fixes/sdp-0001-fix-error-path.patch b/kernel_patches/fixes/sdp-0001-fix-error-path.patch
new file mode 100644
index 0000000..5a5f784
--- /dev/null
+++ b/kernel_patches/fixes/sdp-0001-fix-error-path.patch
@@ -0,0 +1,38 @@
+[PATCH] sdp: Prevent kernel crash if device init fails (plus bonus fix)
+
+If sdp_add_device() fails, there is no client data stored in the IB device,
+leading to a kernel crash when a connection is being established. Fix this
+by rejecting connections when the device is not initialized.
+
+Also, fix a bad goto target in an error case early in sdp_init_qp().
+
+Signed-off-by: Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
+
+---
+
+ sdp_cma.c |    7 ++++++-
+ 1 file changed, 6 insertions(+), 1 deletion(-)
+
+diff -urp a/drivers/infiniband/ulp/sdp/sdp_cma.c b/drivers/infiniband/ulp/sdp/sdp_cma.c
+--- a/drivers/infiniband/ulp/sdp/sdp_cma.c	2010-02-19 15:39:32.000000000 +0100
++++ b/drivers/infiniband/ulp/sdp/sdp_cma.c	2010-02-19 15:38:13.000000000 +0100
+@@ -94,13 +94,18 @@ static int sdp_init_qp(struct sock *sk, 
+ 		sdp_warn(sk, "recv sge's. capability: %d needed: %ld\n",
+ 			sdp_sk(sk)->max_sge, SDP_MAX_RECV_SKB_FRAGS + 1);
+ 		rc = -ENOMEM;
+-		goto err_tx;
++		goto err_rx;
+ 	}
+ 
+ 	qp_init_attr.cap.max_send_sge = sdp_sk(sk)->max_sge;
+ 	sdp_dbg(sk, "Setting max send sge to: %d\n", sdp_sk(sk)->max_sge);
+ 		
+ 	sdp_sk(sk)->sdp_dev = ib_get_client_data(device, &sdp_client);
++	if (!sdp_sk(sk)->sdp_dev) {
++		sdp_warn(sk, "SDP not available on device %s", device->name);
++		rc = -ENODEV;
++		goto err_rx;
++	}
+ 
+ 	rc = sdp_rx_ring_create(sdp_sk(sk), device);
+ 	if (rc)
-- 
1.7.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
