From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH for v3.14 1/5] IB/ehca: returns an error on ib_copy_to_udata() failure
Date: Mon, 10 Mar 2014 23:06:25 +0100
Message-ID: <a74f09417f54a40f12475b65b29094173424ff8d.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Julia Lawall <julia.lawall@lip6.fr>, cocci@systeme.lip6.fr, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In case of error when writing to userspace, function
ehca_create_cq() do not set an error code before
following its error path.

This patch set error code to -EFAULT when ib_copy_to_udata()
fail.

This was caught when using spatch (aka. coccinelle)
to rewrite call to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr
Cc: stable@vger.kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 212150c25ea0..8cc837537768 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -283,6 +283,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
+			cq = ERR_PTR(-EFAULT);
 			goto create_cq_exit4;
 		}
 	}
-- 
1.8.5.3
