From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] IB/qib: use rb_entry()
Date: Tue, 20 Dec 2016 22:02:12 +0800
Message-ID: <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
References: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 3e0677c..926f3c8 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -144,8 +144,8 @@ qib_user_sdma_rb_search(struct rb_root *root, pid_t pid)
 	struct rb_node *node = root->rb_node;
 
 	while (node) {
-		sdma_rb_node = container_of(node,
-			struct qib_user_sdma_rb_node, node);
+		sdma_rb_node = rb_entry(node, struct qib_user_sdma_rb_node,
+					node);
 		if (pid < sdma_rb_node->pid)
 			node = node->rb_left;
 		else if (pid > sdma_rb_node->pid)
@@ -164,7 +164,7 @@ qib_user_sdma_rb_insert(struct rb_root *root, struct qib_user_sdma_rb_node *new)
 	struct qib_user_sdma_rb_node *got;
 
 	while (*node) {
-		got = container_of(*node, struct qib_user_sdma_rb_node, node);
+		got = rb_entry(*node, struct qib_user_sdma_rb_node, node);
 		parent = *node;
 		if (new->pid < got->pid)
 			node = &((*node)->rb_left);
-- 
2.9.3
