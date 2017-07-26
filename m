From: Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [PATCH] RDMA/uverbs: Fix the check for port number
Date: Wed, 26 Jul 2017 11:14:46 -0500
Message-ID: <1501085686-12916-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: mustafa.ismail@intel.com, e1000-rdma@lists.sourceforge.net, chien.tin.tung@intel.com, shiraz.saleem@intel.com, "# v4 . 2-v4 . 9" <stable@vger.kernel.org>, security@kernel.org, Doug Ledford <dledford@redhat.com>, Steve Wise <swise@opengridcomputing.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

The port number is only valid if IB_QP_PORT is set in the mask.
So only check port number if it is valid to prevent modify_qp
from failing due to an invalid port number.

Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
Cc: <stable@vger.kernel.org> # v4.2-v4.9
Cc: <security@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>

Upstream commit 5a7a88f1b488("Fix the check for port number")
Modified from upstream commit: helper function rdma_is_port_valid does not
exist in these kernel versions.
---
 drivers/infiniband/core/uverbs_cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 01e3a37..d118ffe 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2342,8 +2342,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	if (cmd.port_num < rdma_start_port(ib_dev) ||
-	    cmd.port_num > rdma_end_port(ib_dev))
+	if ((cmd.attr_mask & IB_QP_PORT) &&
+	    (cmd.port_num < rdma_start_port(ib_dev) ||
+	     cmd.port_num > rdma_end_port(ib_dev)))
 		return -EINVAL;
 
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
-- 
1.8.3.1
