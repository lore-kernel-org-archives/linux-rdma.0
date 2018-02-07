From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] RDMA: Do not used __packed in uapi headers
Date: Wed, 7 Feb 2018 16:45:51 -0700
Message-ID: <20180207234551.GA14373@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

__packed is not available in linux/types.h, so we cannot use it in
the uapi headers.

The construction struct ABC {} __packed; may still compile even if
__packed is not defined, however it simply creates a variable called
__packed, and doesn't set the alignment.

All these uses of packed are on structs that already have aligned
members.

While use in hfi may indicate the struct itself is unaligned,
the use in ocrdma is on a UHW struct which should never be unaligned,
so just delete it there.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/uapi/rdma/hfi/hfi1_user.h | 6 +++---
 include/uapi/rdma/ocrdma-abi.h    | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/rdma/hfi/hfi1_user.h b/include/uapi/rdma/hfi/hfi1_user.h
index 791bea2f8297b4..43b46bf6f8bb10 100644
--- a/include/uapi/rdma/hfi/hfi1_user.h
+++ b/include/uapi/rdma/hfi/hfi1_user.h
@@ -219,7 +219,7 @@ struct sdma_req_info {
 	 * in charge of managing its own ring.
 	 */
 	__u16 comp_idx;
-} __packed;
+} __attribute__((__packed__));
 
 /*
  * SW KDETH header.
@@ -230,7 +230,7 @@ struct hfi1_kdeth_header {
 	__le16 jkey;
 	__le16 hcrc;
 	__le32 swdata[7];
-} __packed;
+}  __attribute__((__packed__));
 
 /*
  * Structure describing the headers that User space uses. The
@@ -241,7 +241,7 @@ struct hfi1_pkt_header {
 	__be16 lrh[4];
 	__be32 bth[3];
 	struct hfi1_kdeth_header kdeth;
-} __packed;
+}  __attribute__((__packed__));
 
 
 /*
diff --git a/include/uapi/rdma/ocrdma-abi.h b/include/uapi/rdma/ocrdma-abi.h
index ad64a3cea1cdab..07f85c7e313d84 100644
--- a/include/uapi/rdma/ocrdma-abi.h
+++ b/include/uapi/rdma/ocrdma-abi.h
@@ -106,7 +106,7 @@ struct ocrdma_create_qp_ureq {
 	__u32 rsvd1;	/* pad */
 };
 
-struct ocrdma_create_qp_uresp {
+sxtruct ocrdma_create_qp_uresp {
 	__u16 qp_id;
 	__u16 sq_dbid;
 	__u16 rq_dbid;
@@ -127,7 +127,7 @@ struct ocrdma_create_qp_uresp {
 	__u32 db_rq_offset;
 	__u32 db_shift;
 	__u64 rsvd[11];
-} __packed;
+};
 
 struct ocrdma_create_srq_uresp {
 	__u16 rq_dbid;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
