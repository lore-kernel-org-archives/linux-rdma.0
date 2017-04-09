From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/20] IB/hfi1: Correct MulticastMask/CollectiveMask info to
 SMA output
Date: Sun, 09 Apr 2017 10:15:44 -0700
Message-ID: <20170409171543.10579.61535.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The FM uses the values of MulticastMask and CollectiveMask to
determine the number of bits for net masks. The current values of
0 and 0 are incorrect.  The values should be 4 and 1.  Updated the
necessary code to reflect the specified values.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/common.h |    9 +++++++++
 drivers/infiniband/hw/hfi1/mad.c    |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
index 1b783bb..804150f 100644
--- a/drivers/infiniband/hw/hfi1/common.h
+++ b/drivers/infiniband/hw/hfi1/common.h
@@ -338,6 +338,15 @@ struct diag_pkt {
 #define HFI1_BECN_MASK 1
 #define HFI1_BECN_SMASK BIT(HFI1_BECN_SHIFT)
 
+/**
+ * 0xF8 - 4 bits of multicast range and 1 bit for collective range
+ * Example: For 24 bit LID space,
+ * Multicast range: 0xF00000 to 0xF7FFFF
+ * Collective range: 0xF80000 to 0xFFFFFE
+ */
+#define HFI1_MCAST_NR 0x4 /* Number of top bits set */
+#define HFI1_COLLECTIVE_NR 0x1 /* Number of bits after MCAST_NR */
+
 #define HFI1_PSM_IOC_BASE_SEQ 0x0
 
 static inline __u64 rhf_to_cpu(const __le32 *rbuf)
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 09cda3c..de34131 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -702,6 +702,11 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	pi->buffer_units = cpu_to_be32(buffer_units);
 
 	pi->opa_cap_mask = cpu_to_be16(OPA_CAP_MASK3_IsSharedSpaceSupported);
+	/* Driver does not support mcast/collective configuration */
+	pi->opa_cap_mask &=
+		cpu_to_be16(~OPA_CAP_MASK3_IsAddrRangeConfigSupported);
+	pi->collectivemask_multicastmask = ((HFI1_COLLECTIVE_NR & 0x7)
+					    << 3 | (HFI1_MCAST_NR & 0x7));
 
 	/* HFI supports a replay buffer 128 LTPs in size */
 	pi->replay_depth.buffer = 0x80;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
