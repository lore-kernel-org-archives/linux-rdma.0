From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for 3.2] rdma/cm: Verify private data length
Date: Tue, 6 Dec 2011 21:17:11 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325653882@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

private_data_len is defined as a u8.  If the user specifies a large
private_data size (> 220 bytes), we will calculate a total length that
exceeds 255, resulting in private_data_len wrapping back to 0.  This
can lead to overwriting random kernel memory.  Avoid this by verifying
that the resulting size fits into a u8.

Problem reported by B. Thery, OFA bug 2335.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Please consider queuing for 3.2 if it's not too late.  This bug has been
around for a while though, so hitting 3.3 is fine.

 drivers/infiniband/core/cma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index c3a0c62..fdd8ef8 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2513,6 +2513,9 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 
 	req.private_data_len = sizeof(struct cma_hdr) +
 			       conn_param->private_data_len;
+	if (req.private_data_len < conn_param->private_data_len)
+		return -EINVAL;
+
 	req.private_data = kzalloc(req.private_data_len, GFP_ATOMIC);
 	if (!req.private_data)
 		return -ENOMEM;
@@ -2562,6 +2565,9 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv->id.ps);
 	req.private_data_len = offset + conn_param->private_data_len;
+	if (req.private_data_len < conn_param->private_data_len)
+		return -EINVAL;
+
 	private_data = kzalloc(req.private_data_len, GFP_ATOMIC);
 	if (!private_data)
 		return -ENOMEM;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
