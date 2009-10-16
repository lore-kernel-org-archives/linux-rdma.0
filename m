From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH 04/11] Trying to deregister the same memory region
 twice leads to an
Date: Fri, 16 Oct 2009 16:48:49 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CB9@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: linux-rdma <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Sean Hefty <sean.hefty@intel.com>
---
 dapl/openib_ucm/device.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index bd31cea..90a044e 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -376,8 +376,8 @@ static void ucm_service_destroy(IN DAPL_HCA *hca)
 	if (tp->mr_sbuf)
 		ibv_dereg_mr(tp->mr_sbuf);
=20
-	if (tp->mr_sbuf)
-		ibv_dereg_mr(tp->mr_sbuf);
+	if (tp->mr_rbuf)
+		ibv_dereg_mr(tp->mr_rbuf);
=20
 	if (tp->qp)
 		ibv_destroy_qp(tp->qp);
--=20
1.5.2.5
