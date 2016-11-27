From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/10] IB: Add protocol for USNIC
Date: Sun, 27 Nov 2016 16:51:30 +0200
Message-ID: <1480258296-27032-5-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add protocol definition for the proprietary the USNIC driver, to be
used in downstream patches that query supported qp types.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 1 +
 include/rdma/ib_verbs.h                     | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 0a89a95..dde0b23 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -325,6 +325,7 @@ static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
 	if (err)
 		return err;
 
+	immutable->core_cap_flags = RDMA_CORE_PORT_USNIC;
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0cb3194..485b725 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -486,6 +486,7 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 #define RDMA_CORE_CAP_PROT_IWARP        0x00400000
 #define RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP 0x00800000
 #define RDMA_CORE_CAP_PROT_RAW_PACKET   0x01000000
+#define RDMA_CORE_CAP_PROT_USNIC        0x02000000
 
 #define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
 					| RDMA_CORE_CAP_IB_MAD \
@@ -511,6 +512,8 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 
 #define RDMA_CORE_PORT_RAW_PACKET	(RDMA_CORE_CAP_PROT_RAW_PACKET)
 
+#define RDMA_CORE_PORT_USNIC		(RDMA_CORE_CAP_PROT_USNIC)
+
 struct ib_port_attr {
 	u64			subnet_prefix;
 	enum ib_port_state	state;
@@ -2294,6 +2297,11 @@ static inline bool rdma_protocol_raw_packet(const struct ib_device *device, u8 p
 	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_RAW_PACKET;
 }
 
+static inline bool rdma_protocol_usnic(const struct ib_device *device, u8 port_num)
+{
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_USNIC;
+}
+
 /**
  * rdma_cap_ib_mad - Check if the port of a device supports Infiniband
  * Management Datagrams.
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
