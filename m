From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH for v3.14 2/5] IB/mthca: returns an error on
	ib_copy_to_udata() failure
Date: Mon, 10 Mar 2014 23:06:26 +0100
Message-ID: <014a0e999228bcbefd32667b341a0fc91a8cd3c9.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <cocci-bounces@systeme.lip6.fr>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394485254.git.ydroneaud@opteya.com>
References: <cover.1394485254.git.ydroneaud@opteya.com>
List-Unsubscribe: <https://systeme.lip6.fr/mailman/options/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=unsubscribe>
List-Archive: <https://systeme.lip6.fr/pipermail/cocci>
List-Post: <mailto:cocci@systeme.lip6.fr>
List-Help: <mailto:cocci-request@systeme.lip6.fr?subject=help>
List-Subscribe: <https://systeme.lip6.fr/mailman/listinfo/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=subscribe>
Sender: cocci-bounces@systeme.lip6.fr
Errors-To: cocci-bounces@systeme.lip6.fr
To: Roland Dreier <roland@purestorage.com>, Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, cocci@systeme.lip6.fr, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In case of error when writing to userspace, function
mthca_create_cq() do not set an error code before
following its error path.

This patch set error code to -EFAULT when ib_copy_to_udata()
fail.

This was caught when using spatch (aka. coccinelle)
to rewrite call to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr
Cc: stable@vger.kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 5b71d43bd89c..42dde06fdb91 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -695,6 +695,7 @@ static struct ib_cq *mthca_create_cq(struct ib_device *ibdev, int entries,
 
 	if (context && ib_copy_to_udata(udata, &cq->cqn, sizeof (__u32))) {
 		mthca_free_cq(to_mdev(ibdev), cq);
+		err = -EFAULT;
 		goto err_free;
 	}
 
-- 
1.8.5.3
