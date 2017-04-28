From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH v2 19/19] IB/hfi1: Use bool in process_ecn
Date: Fri, 28 Apr 2017 10:40:47 -0700
Message-ID: <20170428174047.23960.61709.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The process_ecn intends to return a bool value. However it is doing
so incorrectly by ANDing the fecn mask. The fecn bit is bit 31. Bool is
not a native data type and is up to the compiler to implement how it
sees fit. It is conceivable that this upper bit gets washed out.

Fix by converting to a bool properly.

Cc: stable@vger.kernel.org
Fixes: Commit fd2b562edca6 ("IB/hfi1: Pull FECN/BECN processing to a common place")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/hfi.h |    2 +-
 drivers/infiniband/hw/hfi1/rc.c  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index fec6eb6..51fffdf 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1609,7 +1609,7 @@ static inline bool process_ecn(struct rvt_qp *qp, struct hfi1_packet *pkt,
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	if (unlikely(bth1 & (IB_BECN_SMASK | IB_FECN_SMASK))) {
 		hfi1_process_ecn_slowpath(qp, pkt, do_cnp);
-		return bth1 & IB_FECN_SMASK;
+		return !!(bth1 & IB_FECN_SMASK);
 	}
 	return false;
 }
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index da968b7..9b3333f 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1930,7 +1930,8 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	int diff;
 	struct ib_reth *reth;
 	unsigned long flags;
-	int ret, is_fecn = 0;
+	int ret;
+	bool is_fecn = false;
 	bool copy_last = false;
 	u32 rkey;
 
