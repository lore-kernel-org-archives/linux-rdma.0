From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/16] IB/qib: Stricter bounds checking for copy
 and array access
Date: Mon, 21 Aug 2017 18:26:32 -0700
Message-ID: <20170822012631.32701.35310.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822011657.32701.22207.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Added checking on index value of array 'guids' in qib_ruc.c.
Pass in corrrect size of array for memset operation in qib_mad.c.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c |    4 ++--
 drivers/infiniband/hw/qib/qib_ruc.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 549c719..82d9da9 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1573,8 +1573,8 @@ static int pma_get_portcounters_cong(struct ib_pma_mad *pmp,
 	cntrs.port_xmit_packets -= ibp->z_port_xmit_packets;
 	cntrs.port_rcv_packets -= ibp->z_port_rcv_packets;
 
-	memset(pmp->reserved, 0, sizeof(pmp->reserved) +
-	       sizeof(pmp->data));
+	memset(pmp->reserved, 0, sizeof(pmp->reserved));
+	memset(pmp->data, 0, sizeof(pmp->data));
 
 	/*
 	 * Set top 3 bits to indicate interval in picoseconds in
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index e6a42a8..53efbb0 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -645,8 +645,10 @@ u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 	hdr->hop_limit = grh->hop_limit;
 	/* The SGID is 32-bit aligned. */
 	hdr->sgid.global.subnet_prefix = ibp->rvp.gid_prefix;
-	hdr->sgid.global.interface_id = grh->sgid_index ?
-		ibp->guids[grh->sgid_index - 1] : ppd_from_ibp(ibp)->guid;
+	if (!grh->sgid_index)
+		hdr->sgid.global.interface_id = ppd_from_ibp(ibp)->guid;
+	else if (grh->sgid_index < QIB_GUIDS_PER_PORT)
+		hdr->sgid.global.interface_id = ibp->guids[grh->sgid_index - 1];
 	hdr->dgid = grh->dgid;
 
 	/* GRH header size in 32-bit words. */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
