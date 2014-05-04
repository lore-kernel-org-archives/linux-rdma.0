From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 2/4] RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_srq
Date: Sun,  4 May 2014 23:21:14 +0200
Message-ID: <160c8353b2ae45be0eb516c638fe58c74ac9d0cb.1399216475.git.ydroneaud@opteya.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1399216475.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1399216475.git.ydroneaud@opteya.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Eli Cohen <eli@mellanox.com>, Roland Dreier <roland@kernel.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not required on
i386.

So for most ABI struct mlx5_ib_create_srq get implicitly padded
to be aligned on a 8 bytes multiple, while for i386, such padding
is not added.

Tool pahole could be used to find such implicit padding:

  $ pahole --anon_include \
           --nested_anon_include \
           --recursive \
           --class_name mlx5_ib_create_srq \
           drivers/infiniband/hw/mlx5/mlx5_ib.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt    2014-03-28 11:43:07.386413682 +0100
  --- obj-x86_64/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt  2014-03-27 13:06:17.788472721 +0100
  @@ -69,7 +68,6 @@ struct mlx5_ib_create_srq {
          __u64                      db_addr;              /*     8     8 */
          __u32                      flags;                /*    16     4 */

  -       /* size: 20, cachelines: 1, members: 3 */
  -       /* last cacheline: 20 bytes */
  +       /* size: 24, cachelines: 1, members: 3 */
  +       /* padding: 4 */
  +       /* last cacheline: 24 bytes */
   };

ABI disagreement will make an x86_64 kernel try to read past
the buffer provided by an i386 binary.

When boundary check will be implemented, the x86_64 kernel will
refuse to read past the i386 userspace provided buffer and the
uverb will fail.

Anyway, if the structure lay in memory on a page boundary and
next page is not mapped, ib_copy_from_udata() will fail and the
uverb will fail.

This patch makes create_srq_user() takes care of the input
data size to handle the case where no padding was provided.

This way, x86_64 kernel will be able to handle struct mlx5_ib_create_srq
as sent by unpatched and patched i386 libmlx5.

Link: http://marc.info/?i=cover.1399216475.git.ydroneaud@opteya.com
Cc: stable@vger.kernel.org
Fixes: e126ba97dba9e ('mlx5: Add driver for Mellanox Connect-IB adapter')
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/mlx5/srq.c  | 18 +++++++++++++++---
 drivers/infiniband/hw/mlx5/user.h |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 210b3eaf188a..38ca52181eb6 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/srq.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 
 #include "mlx5_ib.h"
 #include "user.h"
@@ -84,10 +85,21 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	int ncont;
 	u32 offset;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
-		mlx5_ib_dbg(dev, "failed copy udata\n");
-		return -EFAULT;
+	if (udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) < sizeof(ucmd)) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd) - sizeof(ucmd.reserved))) {
+			mlx5_ib_dbg(dev, "failed copy udata\n");
+			return -EFAULT;
+		}
+	} else {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
+			mlx5_ib_dbg(dev, "failed copy udata\n");
+			return -EFAULT;
+		}
+
+		if (ucmd.reserved != 0)
+			return -EINVAL;
 	}
+
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
 	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index d44ecd2c2faf..d0ba264ac1ed 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -110,6 +110,7 @@ struct mlx5_ib_create_srq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	flags;
+	__u32	reserved; /* explicit padding (optional on i386) */
 };
 
 struct mlx5_ib_create_srq_resp {
-- 
1.9.0
