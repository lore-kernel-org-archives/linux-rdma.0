From: Doug Ledford <dledford@redhat.com>
Subject: [PATCH] RDMA/uverbs: Check port number supplied by user verbs cmds
Date: Fri,  7 Jul 2017 11:36:59 -0400
Message-ID: <23a56bbd03a2b5b585e2de35b1fc6f8bac53aa9a.1499441641.git.dledford@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, stable@vger.kernel.org, security@kernel.org, Yevgeny Kliteynik <kliteyn@mellanox.com>, Tziporet Koren <tziporet@mellanox.com>, Alex Polak <alexpo@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

Upstream commit id in the rdma.git tree: 5ecce4c9b17b

The ib_uverbs_create_ah() ind ib_uverbs_modify_qp() calls receive
the port number from user input as part of its attributes and assumes
it is valid. Down on the stack, that parameter is used to access kernel
data structures.  If the value is invalid, the kernel accesses memory
it should not.  To prevent this, verify the port number before using it.

BUG: KASAN: use-after-free in ib_uverbs_create_ah+0x6d5/0x7b0
Read of size 4 at addr ffff880018d67ab8 by task syz-executor/313

BUG: KASAN: slab-out-of-bounds in modify_qp.isra.4+0x19d0/0x1ef0
Read of size 4 at addr ffff88006c40ec58 by task syz-executor/819

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Cc: <stable@vger.kernel.org> # v4.2-v4.9
Cc: <security@kernel.org>
Cc: Yevgeny Kliteynik <kliteyn@mellanox.com>
Cc: Tziporet Koren <tziporet@mellanox.com>
Cc: Alex Polak <alexpo@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---

Modified from upstream commit: helper function rdma_is_port_valid does not
exist in these kernel versions, so use manual comparisons instead.

 drivers/infiniband/core/uverbs_cmd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a2285..01e3a37b0aef 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2342,6 +2342,10 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	if (cmd.port_num < rdma_start_port(ib_dev) ||
+	    cmd.port_num > rdma_end_port(ib_dev))
+		return -EINVAL;
+
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
 		   out_len);
 
@@ -2882,6 +2886,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	if (cmd.attr.port_num < rdma_start_port(ib_dev) ||
+	    cmd.attr.port_num > rdma_end_port(ib_dev))
+		return -EINVAL;
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
-- 
2.13.0
