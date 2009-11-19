From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [PATCH] uDAPL v2 - cma: setup_listener: Cannot assign
 requested address
Date: Wed, 18 Nov 2009 16:22:34 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983619D3FDB@orsmsx506.amr.corp.intel.com>
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
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org



Colliding with RDS port of 18634. rdma_cm can return
either EADDRINUSE or EADDRNOTAVAIL if the bind fails.
Add check for either and return proper DAT_CONN_QUAL_IN_USE.

Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
---
 dapl/openib_cma/cm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 40634b2..c52e716 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -694,7 +694,8 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
 	((struct sockaddr_in *)&addr)->sin_port =3D SID_TO_PORT(ServiceID);
=20
 	if (rdma_bind_addr(conn->cm_id, (struct sockaddr *)&addr)) {
-		if ((errno =3D=3D EBUSY) || (errno =3D=3D EADDRINUSE))
+		if ((errno =3D=3D EBUSY) || (errno =3D=3D EADDRINUSE) ||=20
+		    (errno =3D=3D EADDRNOTAVAIL))
 			dat_status =3D DAT_CONN_QUAL_IN_USE;
 		else
 			dat_status =3D
@@ -717,7 +718,8 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
=20
 	if (rdma_listen(conn->cm_id, 0)) {	/* max cma backlog */
=20
-		if ((errno =3D=3D EBUSY) || (errno =3D=3D EADDRINUSE))
+		if ((errno =3D=3D EBUSY) || (errno =3D=3D EADDRINUSE) ||
+		    (errno =3D=3D EADDRNOTAVAIL))
 			dat_status =3D DAT_CONN_QUAL_IN_USE;
 		else
 			dat_status =3D
--=20
1.5.2.5
