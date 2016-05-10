From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 1/4] IB/core: Introduce capabilitymask2 field in ClassPortInfo mad
Date: Tue, 10 May 2016 17:56:45 +0300
Message-ID: <1462892208-6140-2-git-send-email-erezsh@mellanox.com>
References: <1462892208-6140-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462892208-6140-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Change struct ib_class_port_info to conform to IB Spec 1.3
That in order to get specific capability mask from ClassPortInfo mad.

>From the IB Spec, ClassPortInfo section:
        "CapabilityMask2 Bits 0-26: Additional class-specific capabilities...
         RespTimeValue the rest 5 bits"

The new struct now has one field for capabilitymask2 (previously was the
reserved field) and the resp_time field.

And it fixes up qib and srpt, use of the field repurposed to be used as
capabilitymask2:
IB/qib: Change pma_get_classportinfo
IB/srpt: Adjust the use of ib_class_port_info

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_mad.c   | 6 ++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c | 5 ++++-
 include/rdma/ib_mad.h                 | 4 ++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 0bd1837..c5d029d 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1158,6 +1158,7 @@ static int pma_get_classportinfo(struct ib_pma_mad *pmp,
 	struct ib_class_port_info *p =
 		(struct ib_class_port_info *)pmp->data;
 	struct qib_devdata *dd = dd_from_ibdev(ibdev);
+	char *p_cap_mask2;
 
 	memset(pmp->data, 0, sizeof(pmp->data));
 
@@ -1172,11 +1173,12 @@ static int pma_get_classportinfo(struct ib_pma_mad *pmp,
 	 * Set the most significant bit of CM2 to indicate support for
 	 * congestion statistics
 	 */
-	p->reserved[0] = dd->psxmitwait_supported << 7;
+	p_cap_mask2 = (char *)&p->cap_mask2_resp_time;
+	p_cap_mask2[0] = dd->psxmitwait_supported << 7;
 	/*
 	 * Expected response time is 4.096 usec. * 2^18 == 1.073741824 sec.
 	 */
-	p->resp_time_value = 18;
+	p_cap_mask2[3] = 18;
 
 	return reply((struct ib_smp *) pmp);
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8b42401..cf7868e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -249,12 +249,15 @@ static void srpt_set_ioc(u8 *c_list, u32 slot, u8 value)
 static void srpt_get_class_port_info(struct ib_dm_mad *mad)
 {
 	struct ib_class_port_info *cif;
+	char *p_cap_mask2;
 
 	cif = (struct ib_class_port_info *)mad->data;
 	memset(cif, 0, sizeof(*cif));
 	cif->base_version = 1;
 	cif->class_version = 1;
-	cif->resp_time_value = 20;
+
+	p_cap_mask2 = (char *)&cif->cap_mask2_resp_time;
+	p_cap_mask2[3] = 20;
 
 	mad->mad_hdr.status = 0;
 }
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 37dd534c..2aaf1cb 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -243,8 +243,8 @@ struct ib_class_port_info {
 	u8			base_version;
 	u8			class_version;
 	__be16			capability_mask;
-	u8			reserved[3];
-	u8			resp_time_value;
+	  /* 27 bits for cap_mask2, 5 bits for resp_time */
+	__be32			cap_mask2_resp_time;
 	u8			redirect_gid[16];
 	__be32			redirect_tcslfl;
 	__be16			redirect_lid;
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
