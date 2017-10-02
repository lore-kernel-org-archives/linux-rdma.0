From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/8] IB/hfi1: Fix output trace issues from 16B
 change
Date: Mon, 02 Oct 2017 11:04:11 -0700
Message-ID: <20171002180408.31117.96101.stgit@scvm10.sc.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The 16B changes to the output side of the header trace introduced
two issues:

1. An uninitialized field "l4" for 9B packets

   This field needs to be given a value of 0 for 9B
   packets to insure a correct 9B trace.

   The fix adds a new define to insure that there is a dummy
   default for 9B packets to insure the correct string
   is decoded.

2. Use of entry vs. __entry in field references

Fixes: Commit 863cf89d472f ("IB/hfi1: Add 16B trace support")
Reported-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h          |    1 +
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index cb74ae8..44a2c8f 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -390,6 +390,7 @@ struct hfi1_packet {
 /*
  * OPA 16B L2/L4 Encodings
  */
+#define OPA_16B_L4_9B		0x00
 #define OPA_16B_L2_TYPE		0x02
 #define OPA_16B_L4_IB_LOCAL	0x09
 #define OPA_16B_L4_IB_GLOBAL	0x0A
diff --git a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
index 6dd0d63..fb63127 100644
--- a/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
+++ b/drivers/infiniband/hw/hfi1/trace_ibhdrs.h
@@ -334,7 +334,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 							 &__entry->dlid,
 							 &__entry->slid);
 
-				if (entry->l4 == OPA_16B_L4_IB_LOCAL)
+				if (__entry->l4 == OPA_16B_L4_IB_LOCAL)
 					ohdr = &opah->opah.u.oth;
 				else
 					ohdr = &opah->opah.u.l.oth;
@@ -348,6 +348,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 							 &__entry->psn,
 							 &__entry->qpn);
 			} else {
+				__entry->l4 = OPA_16B_L4_9B;
 				hfi1_trace_parse_9b_hdr(&opah->ibh, sc5,
 							&__entry->lnh,
 							&__entry->lver,
@@ -356,7 +357,7 @@ void hfi1_trace_parse_16b_hdr(struct hfi1_16b_header *hdr,
 							&__entry->len,
 							&__entry->dlid,
 							&__entry->slid);
-				if (entry->lnh == HFI1_LRH_BTH)
+				if (__entry->lnh == HFI1_LRH_BTH)
 					ohdr = &opah->ibh.u.oth;
 				else
 					ohdr = &opah->ibh.u.l.oth;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
