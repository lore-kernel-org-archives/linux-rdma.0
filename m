From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH for v3.14 5/5] IB/qib: fixup indentation in
	qib_ib_rcv()
Date: Mon, 10 Mar 2014 23:06:29 +0100
Message-ID: <a08e7ae2d1289d8ab028f6cc0909009954a59faf.1394485254.git.ydroneaud@opteya.com>
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
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, infinipath@intel.com, linux-rdma@vger.kernel.org, cocci@systeme.lip6.fr
List-Id: linux-rdma@vger.kernel.org

Commit af061a644a0e4d4778 add some code in qib_ib_rcv() which
trigger a warning from coccicheck (coccinelle/spatch):

$ make C=2 CHECK=scripts/coccicheck drivers/infiniband/hw/qib/

  CHECK   drivers/infiniband/hw/qib/qib_verbs.c
drivers/infiniband/hw/qib/qib_verbs.c:679:5-32: code aligned with following code on line 681
  CC [M]  drivers/infiniband/hw/qib/qib_verbs.o

In fact, according to similar code in qib_kreceive(),
qib_ib_rcv() code is correct but improperly indented.

This patch fix indentation for the misaligned portion.

Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: infinipath@intel.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/hw/qib/qib_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 092b0bb1bb78..b53e0a2dc545 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -678,8 +678,8 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 					&rcd->lookaside_qp->refcount))
 					wake_up(
 					 &rcd->lookaside_qp->wait);
-					rcd->lookaside_qp = NULL;
-				}
+				rcd->lookaside_qp = NULL;
+			}
 		}
 		if (!rcd->lookaside_qp) {
 			qp = qib_lookup_qpn(ibp, qp_num);
-- 
1.8.5.3
