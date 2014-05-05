From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCHv1 3/4] RDMA/cxgb4: add missing padding at end of struct c4iw_create_cq_resp
Date: Mon,  5 May 2014 19:33:23 +0200
Message-ID: <3fd6186b9729d69a3d8431bb5e0461eee1515484.1399309513.git.ydroneaud@opteya.com>
References: <cover.1399309513.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1399309513.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1399309513.git.ydroneaud@opteya.com>
References: <cover.1399309513.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not required on
i386.

So for most ABI struct c4iw_create_cq_resp get implicitly padded
to be aligned on a 8 bytes multiple, while for i386, such padding
is not added.

Tool pahole could be used to find such implicit padding:

  $ pahole --anon_include \
           --nested_anon_include \
           --recursive \
           --class_name c4iw_create_cq_resp \
           drivers/infiniband/hw/cxgb4/iw_cxgb4.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt   2014-03-28 11:43:05.547432195 +0100
  --- obj-x86_64/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt 2014-03-28 10:55:10.990133017 +0100
  @@ -14,9 +13,8 @@ struct c4iw_create_cq_resp {
          __u32                      size;                 /*    28     4 */
          __u32                      qid_mask;             /*    32     4 */

  -       /* size: 36, cachelines: 1, members: 6 */
  -       /* last cacheline: 36 bytes */
  +       /* size: 40, cachelines: 1, members: 6 */
  +       /* padding: 4 */
  +       /* last cacheline: 40 bytes */
   };

This ABI disagreement will make an x86_64 kernel try to write past
the buffer provided by an i386 binary.

When boundary check will be implemented, the x86_64 kernel will
refuse to write past the i386 userspace provided buffer
and the uverbs will fail.

If the structure lay in memory on a page boundary and next page
is not mapped, ib_copy_to_udata() will fail and the uverbs
will fail.

This patch adds an explicit padding at end of structure
c4iw_create_cq_resp, and, like 92b0ca7cb149 ('IB/mlx5: Fix stack
info leak in mlx5_ib_alloc_ucontext()'), makes function c4iw_create_cq()
not writting this padding field to userspace. This way, x86_64 kernel
will be able to write struct c4iw_create_cq_resp as expected by unpatched
and patched i386 libcxgb4.

Link: http://marc.info/?i=cover.1399309513.git.ydroneaud@opteya.com
Cc: stable@vger.kernel.org
Fixes: cfdda9d764362 ('RDMA/cxgb4: Add driver for Chelsio T4 RNIC')
Fixes: e24a72a3302a6 ('RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()')
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/cxgb4/cq.c   | 4 ++--
 drivers/infiniband/hw/cxgb4/user.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index cfaa56ada189..7151a02b4ebb 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -940,7 +940,6 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		if (!mm2)
 			goto err4;
 
-		memset(&uresp, 0, sizeof(uresp));
 		uresp.qid_mask = rhp->rdev.cqmask;
 		uresp.cqid = chp->cq.cqid;
 		uresp.size = chp->cq.size;
@@ -951,7 +950,8 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		uresp.gts_key = ucontext->key;
 		ucontext->key += PAGE_SIZE;
 		spin_unlock(&ucontext->mmap_lock);
-		ret = ib_copy_to_udata(udata, &uresp, sizeof uresp);
+		ret = ib_copy_to_udata(udata, &uresp,
+				       sizeof(uresp) - sizeof(uresp.reserved));
 		if (ret)
 			goto err5;
 
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
index 11ccd276e5d9..9b7534b5f07d 100644
--- a/drivers/infiniband/hw/cxgb4/user.h
+++ b/drivers/infiniband/hw/cxgb4/user.h
@@ -48,6 +48,7 @@ struct c4iw_create_cq_resp {
 	__u32 cqid;
 	__u32 size;
 	__u32 qid_mask;
+	__u32 reserved; /* explicit padding (optional for i386) */
 };
 
 
-- 
1.9.0
