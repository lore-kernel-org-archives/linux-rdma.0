From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Wed, 15 Aug 2018 16:50:21 -0600
Message-ID: <20180815225021.GB31799@ziepe.ca>
References: <20180814223303.83556-1-seth.howell@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180814223303.83556-1-seth.howell@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Howell <seth.howell@intel.com>
Cc: benjamin.walker@intel.com, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Moni Shoua <monis@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 14, 2018 at 03:33:02PM -0700, Seth Howell wrote:
> By making this enum accessible to the userspace API, we can avoid
> conflicts between the kernel-space ib_wr_opcode and the user-space
> ibv_wr_opcode enums.
> 
> When using the rxe software driver interface between kernel and user
> space, the enum value IBV_WR_SEND_WITH_INV was being improperly
> translated to IB_WR_READ_WITH_INV causing the userspace application to
> fail.
> 
> Signed-off-by: Seth Howell <seth.howell@intel.com>
>  include/rdma/ib_verbs.h           | 31 -------------------------------
>  include/uapi/rdma/ib_user_verbs.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 31 deletions(-)

I've looked at this for a bit now, and I think we should just do the
below and not change userspace:

>From e3c1b1b81373601fa6cbad2ba5fadd2c8cfdfaed Mon Sep 17 00:00:00 2001
From: Seth Howell <seth.howell@intel.com>
Date: Tue, 14 Aug 2018 15:33:02 -0700
Subject: [PATCH] IB/rxe: Revise the ib_wr_opcode enum

This enum has become part of the uABI, as both RXE and the
ib_uverbs_post_send() command expect userspace to supply values from this
enum. So it should be properly placed in include/uapi/rdma.

In userspace this enum is called 'enum ibv_wr_opcode' as part of
libibverbs.h. That enum defines different values for IB_WR_LOCAL_INV,
IB_WR_SEND_WITH_INV, and IB_WR_LSO. These were introduced (incorrectly, it
turns out) into libiberbs in 2015.

The kernel has changed its mind on the numbering for several of the IB_WC
values over the years, but has remained stable on IB_WR_LOCAL_INV and
below.

Based on this we can conclude that there is no real user space user of the
values beyond IB_WR_ATOMIC_FETCH_AND_ADD, as they have never worked via
rdma-core. This is confirmed by inspection, only rxe uses the kernel enum
and implements the latter operations. rxe has clearly never worked with
these attributes from userspace. Other drivers that support these opcodes
implement the functionality without calling out to the kernel.

To make IB_WR_SEND_WITH_INV and related work for RXE in userspace we
choose to renumber the IB_WR enum in the kernel to match the uABI that
userspace has bee using since before Soft RoCE was merged. This is an
overall simpler configuration for the whole software stack, and obviously
can't break anything existing.

Reported-by: Seth Howell <seth.howell@intel.com>
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 include/rdma/ib_verbs.h           | 34 ++++++++++++++++++-------------
 include/uapi/rdma/ib_user_verbs.h | 20 +++++++++++++++++-
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5d404c20b49f27..5e51ea9832a0c8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1278,21 +1278,27 @@ struct ib_qp_attr {
 };
 
 enum ib_wr_opcode {
-	IB_WR_RDMA_WRITE,
-	IB_WR_RDMA_WRITE_WITH_IMM,
-	IB_WR_SEND,
-	IB_WR_SEND_WITH_IMM,
-	IB_WR_RDMA_READ,
-	IB_WR_ATOMIC_CMP_AND_SWP,
-	IB_WR_ATOMIC_FETCH_AND_ADD,
-	IB_WR_LSO,
-	IB_WR_SEND_WITH_INV,
-	IB_WR_RDMA_READ_WITH_INV,
-	IB_WR_LOCAL_INV,
-	IB_WR_REG_MR,
-	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
-	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+	/* These are shared with userspace */
+	IB_WR_RDMA_WRITE = IB_UVERBS_WR_RDMA_WRITE,
+	IB_WR_RDMA_WRITE_WITH_IMM = IB_UVERBS_WR_RDMA_WRITE_WITH_IMM,
+	IB_WR_SEND = IB_UVERBS_WR_SEND,
+	IB_WR_SEND_WITH_IMM = IB_UVERBS_WR_SEND_WITH_IMM,
+	IB_WR_RDMA_READ = IB_UVERBS_WR_RDMA_READ,
+	IB_WR_ATOMIC_CMP_AND_SWP = IB_UVERBS_WR_ATOMIC_CMP_AND_SWP,
+	IB_WR_ATOMIC_FETCH_AND_ADD = IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD,
+	IB_WR_LSO = IB_UVERBS_WR_TSO,
+	IB_WR_SEND_WITH_INV = IB_UVERBS_WR_SEND_WITH_INV,
+	IB_WR_RDMA_READ_WITH_INV = IB_UVERBS_WR_RDMA_READ_WITH_INV,
+	IB_WR_LOCAL_INV = IB_UVERBS_WR_LOCAL_INV,
+	IB_WR_MASKED_ATOMIC_CMP_AND_SWP =
+		IB_UVERBS_WR_MASKED_ATOMIC_CMP_AND_SWP,
+	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD =
+		IB_UVERBS_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+
+	/* These are kernel only and can not be issued by userspace */
+	IB_WR_REG_MR = 0x20,
 	IB_WR_REG_SIG_MR,
+
 	/* reserve values for low level drivers' internal use.
 	 * These values will not be used at all in the ib core layer.
 	 */
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 25a16760de2ad1..1254b51a551a1c 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -763,10 +763,28 @@ struct ib_uverbs_sge {
 	__u32 lkey;
 };
 
+enum ib_uverbs_wr_opcode {
+	IB_UVERBS_WR_RDMA_WRITE = 0,
+	IB_UVERBS_WR_RDMA_WRITE_WITH_IMM = 1,
+	IB_UVERBS_WR_SEND = 2,
+	IB_UVERBS_WR_SEND_WITH_IMM = 3,
+	IB_UVERBS_WR_RDMA_READ = 4,
+	IB_UVERBS_WR_ATOMIC_CMP_AND_SWP = 5,
+	IB_UVERBS_WR_ATOMIC_FETCH_AND_ADD = 6,
+	IB_UVERBS_WR_LOCAL_INV = 7,
+	IB_UVERBS_WR_BIND_MW = 8,
+	IB_UVERBS_WR_SEND_WITH_INV = 9,
+	IB_UVERBS_WR_TSO = 10,
+	IB_UVERBS_WR_RDMA_READ_WITH_INV = 11,
+	IB_UVERBS_WR_MASKED_ATOMIC_CMP_AND_SWP = 12,
+	IB_UVERBS_WR_MASKED_ATOMIC_FETCH_AND_ADD = 13,
+	/* Review enum ib_wr_opcode before modifying this */
+};
+
 struct ib_uverbs_send_wr {
 	__aligned_u64 wr_id;
 	__u32 num_sge;
-	__u32 opcode;
+	__u32 opcode;		/* see enum ib_uverbs_wr_opcode */
 	__u32 send_flags;
 	union {
 		__be32 imm_data;
-- 
2.18.0
