From: Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
Date: Fri, 14 Jul 2017 09:41:30 -0500
Message-ID: <1500043291-19768-2-git-send-email-mustafa.ismail@intel.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, dledford@redhat.com
Cc: swise@opengridcomputing.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, e1000-rdma@lists.sourceforge.net, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

The port number is only valid if IB_QP_PORT is set in the mask.
So only check port number if it is valid to prevent modify_qp from
failing due to an invalid port number.

Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
Cc: <stable@vger.kernel.org> # v2.6.14+
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 8ba9bfb..19de068 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1935,7 +1935,8 @@ static int modify_qp(struct ib_uverbs_file *file,
 		goto out;
 	}
 
-	if (!rdma_is_port_valid(qp->device, cmd->base.port_num)) {
+	if ((cmd->base.attr_mask & IB_QP_PORT) &&
+	    !rdma_is_port_valid(qp->device, cmd->base.port_num)) {
 		ret = -EINVAL;
 		goto release_qp;
 	}
-- 
2.7.4
