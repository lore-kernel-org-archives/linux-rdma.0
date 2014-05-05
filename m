From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 4/4] RDMA/cxgb4: add missing padding at end of struct c4iw_alloc_ucontext_resp
Date: Mon,  5 May 2014 19:35:26 +0200
Message-ID: <b08b42d735d0a9d573ed09f9a30338686a802da0.1399309513.git.ydroneaud@opteya.com>
References: <cover.1399309513.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399309513.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not required on
i386.

So for most ABI struct c4iw_alloc_ucontext_resp get implicitly padded
to be aligned on a 8 bytes multiple, while for i386, such padding
is not added.

Tool pahole could be used to find such implicit padding:

  $ pahole --anon_include \
           --nested_anon_include \
           --recursive \
           --class_name c4iw_alloc_ucontext_resp \
           drivers/infiniband/hw/cxgb4/iw_cxgb4.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt   2014-03-28 11:43:05.547432195 +0100
  --- obj-x86_64/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt 2014-03-28 10:55:10.990133017 +0100
  @@ -2,9 +2,8 @@ struct c4iw_alloc_ucontext_resp {
          __u64                      status_page_key;      /*     0     8 */
          __u32                      status_page_size;     /*     8     4 */

  -       /* size: 12, cachelines: 1, members: 2 */
  -       /* last cacheline: 12 bytes */
  +       /* size: 16, cachelines: 1, members: 2 */
  +       /* padding: 4 */
  +       /* last cacheline: 16 bytes */
   };

This ABI disagreement will make an x86_64 kernel try to write
past the buffer provided by an i386 binary.

When boundary check will be implemented, the x86_64 kernel will
refuse to write past the i386 userspace provided buffer
and the uverbs will fail.

If the structure lay in memory on a page boundary and next page
is not mapped, ib_copy_to_udata() will fail and the uverb
will fail.

Additionally, as reported by Dan Carpenter, without the implicit
padding being properly cleared, an information leak would take
place in most architectures.

This patch adds an explicit padding to struct c4iw_alloc_ucontext_resp,
and, like 92b0ca7cb149 ('IB/mlx5: Fix stack info leak in
mlx5_ib_alloc_ucontext()'), makes function c4iw_alloc_ucontext()
not writting this padding field to userspace. This way, x86_64 kernel
will be able to write struct c4iw_alloc_ucontext_resp as expected by
unpatched and patched i386 libcxgb4.

Link: http://marc.info/?i=cover.1399309513.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://marc.info/?i=1395848977.3297.15.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org
Link: http://marc.info/?i=20140328082428.GH25192@mwanda
Fixes: 05eb23893c2c ('cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes')
Reported-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 5 +++--
 drivers/infiniband/hw/cxgb4/user.h     | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index a94a3e12c349..c777e22bd8d5 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -122,7 +122,7 @@ static struct ib_ucontext *c4iw_alloc_ucontext(struct ib_device *ibdev,
 	INIT_LIST_HEAD(&context->mmaps);
 	spin_lock_init(&context->mmap_lock);
 
-	if (udata->outlen < sizeof(uresp)) {
+	if (udata->outlen < sizeof(uresp) - sizeof(uresp.reserved)) {
 		if (!warned++)
 			pr_err(MOD "Warning - downlevel libcxgb4 (non-fatal), device status page disabled.");
 		rhp->rdev.flags |= T4_STATUS_PAGE_DISABLED;
@@ -140,7 +140,8 @@ static struct ib_ucontext *c4iw_alloc_ucontext(struct ib_device *ibdev,
 		context->key += PAGE_SIZE;
 		spin_unlock(&context->mmap_lock);
 
-		ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		ret = ib_copy_to_udata(udata, &uresp,
+				       sizeof(uresp) - sizeof(uresp.reserved));
 		if (ret)
 			goto err_mm;
 
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
index 9b7534b5f07d..cbd0ce170728 100644
--- a/drivers/infiniband/hw/cxgb4/user.h
+++ b/drivers/infiniband/hw/cxgb4/user.h
@@ -75,5 +75,6 @@ struct c4iw_create_qp_resp {
 struct c4iw_alloc_ucontext_resp {
 	__u64 status_page_key;
 	__u32 status_page_size;
+	__u32 reserved; /* explicit padding (optional for i386) */
 };
 #endif
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
