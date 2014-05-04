From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_cq
Date: Sun,  4 May 2014 23:21:13 +0200
Message-ID: <4e6cffd2c4526d7f95c8e2e18601a131f4ad931e.1399216475.git.ydroneaud@opteya.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not required on
i386.

So for most ABI struct mlx5_ib_create_cq get padded to be aligned
on a 8 bytes multiple, while for i386, such padding is not added.

Tool pahole could be used to find such implicit padding:

  $ pahole --anon_include \
  	 --nested_anon_include \
  	 --recursive \
  	 --class_name mlx5_ib_create_cq \
  	 drivers/infiniband/hw/mlx5/mlx5_ib.o

Then, structure layout can be compared between i386 and x86_64:

  +++ obj-i386/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt    2014-03-28 11:43:07.386413682 +0100
  --- obj-x86_64/drivers/infiniband/hw/mlx5/mlx5_ib.o.pahole.txt  2014-03-27 13:06:17.788472721 +0100
  @@ -34,9 +34,8 @@ struct mlx5_ib_create_cq {
          __u64                      db_addr;              /*     8     8 */
          __u32                      cqe_size;             /*    16     4 */

  -       /* size: 20, cachelines: 1, members: 3 */
  -       /* last cacheline: 20 bytes */
  +       /* size: 24, cachelines: 1, members: 3 */
  +       /* padding: 4 */
  +       /* last cacheline: 24 bytes */
   };

This ABI disagreement will make an x86_64 kernel try to read
past the buffer provided by an i386 binary.

When boundary check will be implemented, a x86_64 kernel will
refuse to read past the i386 userspace provided buffer
and the uverb will fail.

Anyway, if the structure lay in memory on a page boundary and
next page is not mapped, ib_copy_from_udata() will fail when
trying to read the 4 bytes of padding and the uverb will fail.

This patch makes create_cq_user() takes care of the input
data size to handle the case where no padding is provided.

This way, x86_64 kernel will be able to handle struct mlx5_ib_create_cq
as sent by unpatched and patched i386 libmlx5.

Link: http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: e126ba97dba9e ('mlx5: Add driver for Mellanox Connect-IB adapter')
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c   | 13 +++++++++++--
 drivers/infiniband/hw/mlx5/user.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 62bb6b49dc1d..5996132e799d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -32,6 +32,7 @@
 
 #include <linux/kref.h>
 #include <rdma/ib_umem.h>
+#include <rdma/ib_user_verbs.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -607,8 +608,16 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	int ncont;
 	int err;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
-		return -EFAULT;
+	if (udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) < sizeof(ucmd)) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd) - sizeof(ucmd.reserved)))
+			return -EFAULT;
+	} else {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
+			return -EFAULT;
+
+		if (ucmd.reserved != 0)
+			return -EINVAL;
+	}
 
 	if (ucmd.cqe_size != 64 && ucmd.cqe_size != 128)
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 0f4f8e42a17f..d44ecd2c2faf 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -91,6 +91,7 @@ struct mlx5_ib_create_cq {
 	__u64	buf_addr;
 	__u64	db_addr;
 	__u32	cqe_size;
+	__u32	reserved; /* explicit padding (optional on i386) */
 };
 
 struct mlx5_ib_create_cq_resp {
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
