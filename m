From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/qib: Fix M_Key field in SubnGet and SubnGetResp MADs
Date: Fri, 04 Mar 2011 13:53:17 -0500
Message-ID: <20110304185317.3967.81450.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Set the M_Key field in SubnGet and SugnGetResp MADs based
on correctly interpreting the protection level specified
in the M_KeyProtBits field.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 7c44726..13a0c12 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -464,8 +464,9 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	memset(smp->data, 0, sizeof(smp->data));
 
 	/* Only return the mkey if the protection field allows it. */
-	if (smp->method == IB_MGMT_METHOD_SET || ibp->mkey == smp->mkey ||
-	    ibp->mkeyprot == 0)
+	if (!(smp->method == IB_MGMT_METHOD_GET &&
+	      ibp->mkey != smp->mkey &&
+	      ibp->mkeyprot == 1))
 		pip->mkey = ibp->mkey;
 	pip->gid_prefix = ibp->gid_prefix;
 	lid = ppd->lid;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
