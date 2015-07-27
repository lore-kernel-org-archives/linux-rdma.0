From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND 4/4] RDMA/Core: remove rdma_cap_read_multi_sge() helper
Date: Mon, 27 Jul 2015 18:10:18 -0500
Message-ID: <20150727231017.10102.20864.stgit@build2.ogc.int>
References: <20150727230906.10102.88491.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727230906.10102.88491.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This functionality already exists via the max_sge_rd
device capability.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 include/rdma/ib_verbs.h |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e..7448a27 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2071,34 +2071,6 @@ static inline bool rdma_cap_eth_ah(const struct ib_device *device, u8 port_num)
 }
 
 /**
- * rdma_cap_read_multi_sge - Check if the port of device has the capability
- * RDMA Read Multiple Scatter-Gather Entries.
- * @device: Device to check
- * @port_num: Port number to check
- *
- * iWARP has a restriction that RDMA READ requests may only have a single
- * Scatter/Gather Entry (SGE) in the work request.
- *
- * NOTE: although the linux kernel currently assumes all devices are either
- * single SGE RDMA READ devices or identical SGE maximums for RDMA READs and
- * WRITEs, according to Tom Talpey, this is not accurate.  There are some
- * devices out there that support more than a single SGE on RDMA READ
- * requests, but do not support the same number of SGEs as they do on
- * RDMA WRITE requests.  The linux kernel would need rearchitecting to
- * support these imbalanced READ/WRITE SGEs allowed devices.  So, for now,
- * suffice with either the device supports the same READ/WRITE SGEs, or
- * it only gets one READ sge.
- *
- * Return: true for any device that allows more than one SGE in RDMA READ
- * requests.
- */
-static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
-					   u8 port_num)
-{
-	return !(device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP);
-}
-
-/**
  * rdma_max_mad_size - Return the max MAD size required by this RDMA Port.
  *
  * @device: Device

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
