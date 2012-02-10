From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Avoid filtering lid on SMA portinfo
Date: Fri, 10 Feb 2012 17:03:18 -0500
Message-ID: <20120210220318.22930.77380.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current get portinfo handling filters the lid being
sent, modifying zero to 0xffff.

The causes issues with OpenSM logging excessive warning
messages.

Reviewed-by: Edward Mascarenhas <edward.mascarenhas-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index f06df90..373f8a6 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -447,7 +447,6 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
 	struct ib_port_info *pip = (struct ib_port_info *)smp->data;
-	u16 lid;
 	u8 mtu;
 	int ret;
 	u32 state;
@@ -483,8 +482,7 @@ static int subn_get_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	      ibp->mkeyprot == 1))
 		pip->mkey = ibp->mkey;
 	pip->gid_prefix = ibp->gid_prefix;
-	lid = ppd->lid;
-	pip->lid = lid ? cpu_to_be16(lid) : IB_LID_PERMISSIVE;
+	pip->lid = cpu_to_be16(ppd->lid);
 	pip->sm_lid = cpu_to_be16(ibp->sm_lid);
 	pip->cap_mask = cpu_to_be32(ibp->port_cap_flags);
 	/* pip->diag_code; */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
