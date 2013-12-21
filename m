From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next V1] IB/usnic: Fix userspace/kernel ABI alignment
 discrepancy
Date: Sat, 21 Dec 2013 02:05:38 +0000
Message-ID: <BB49315F-37F6-4B91-9374-E7C886DA2B3D@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <07A74FAB6EFB4244A37E0D101E5239DD-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change from V0:
Make reserved field 9 bytes instead of 8 bytes.

This patch depends on http://www.spinics.net/lists/linux-rdma/msg18193.html.

Change the type of the reserve field to u32 from u64 in
usnic_ib_create_qp_resp bc u64 will align differently for
32 and 64 bit archs.  And reserve even more space for future
expansion.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
drivers/infiniband/hw/usnic/usnic_abi.h | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
index 730a371..6c56fbf 100644
--- a/drivers/infiniband/hw/usnic/usnic_abi.h
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -21,7 +21,7 @@
#define USNIC_ABI_H

/* ABI between userspace and kernel */
-#define USNIC_UVERBS_ABI_VERSION	3
+#define USNIC_UVERBS_ABI_VERSION	4

#define USNIC_QP_GRP_MAX_WQS		8
#define USNIC_QP_GRP_MAX_RQS		8
@@ -67,7 +67,7 @@ struct usnic_ib_create_qp_resp {
	u32				rq_idx[USNIC_QP_GRP_MAX_RQS];
	u32				cq_idx[USNIC_QP_GRP_MAX_CQS];
	u32				transport;
-	u64				reserved;
+	u32				reserved[9];
};

#endif /* USNIC_ABI_H */
------
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
