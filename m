From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH 4.4] ipath: Restrict use of the write() interface
Date: Tue, 31 May 2016 03:33:57 +0100
Message-ID: <20160531023356.GI7555@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit e6bd18f57aad ("IB/security: Restrict use of the write()
interface") fixed a security problem with various write()
implementations in the Infiniband subsystem.  In older kernel versions
the ipath_write() function has the same problem and needs the same
restriction.  (The ipath driver has been completely removed upstream.)

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
--- a/drivers/staging/rdma/ipath/ipath_file_ops.c
+++ b/drivers/staging/rdma/ipath/ipath_file_ops.c
@@ -45,6 +45,8 @@
 #include <linux/uio.h>
 #include <asm/pgtable.h>
=20
+#include <rdma/ib.h>
+
 #include "ipath_kernel.h"
 #include "ipath_common.h"
 #include "ipath_user_sdma.h"
@@ -2243,6 +2245,9 @@ static ssize_t ipath_write(struct file *
 	ssize_t ret =3D 0;
 	void *dest;
=20
+	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
+		return -EACCES;
+
 	if (count < sizeof(cmd.type)) {
 		ret =3D -EINVAL;
 		goto bail;

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV0z4FOe/yOyVhhEJAQraKw//ZTYGahxp/UDg5oB5g9OYwJ5n4oHqt0bx
l0M9EkCrcyDifFsdPQsYvHdpGaqfyI5L7KBgE5UdQ1+oEspIZMEHZxEdmf/XK8uo
Ffqdt8MaMLCELDFDkpKq0+DxNJx/q9LG5GLyroqwVYjK4w5HkkLK1DK5p5qN84y9
p6nh5IXCAex2bGs5H2VHUREdo2UAtOmoPoet/Mm4DLaaNSjSTwof5IXfs5xdWLxG
XLfJTmwXNne5PYgXhOetxJI/hxsLpR4ven0GHZmkkAKKzRZDoDpmZKZQTYdPr0kM
p1T9x1GPEqJsTMHl76HbkroUlAcwudTMiX2B0P2X/YW9XYNedHZ3ijFUg2Wvvpw/
c/i+Ru9k2ZtRMS/TR65RTOccsi+cvt4T+d9jTeOSC3oIrr7bvBrQfNiAKqtxB+Uo
xdfvb7m5Me7EgbaufRbElOJeI3xo4hJ2irBkLYTIU/o44K4BUbVcX+VvZp542qvH
SJZf8QcRlGm5+b66HR7XOVldP1TJYpf1NjSWJl84Dcf9gDV4CkdxF8O+30m+eDYh
7Dd+dp54Ft7UyiRoGmBmD7NZg71V+K+MvTjzGB+Xolfd8S+DefO4fGk9k3YD8RnZ
D4VPuX67svVlKcgbM9+AVUFDasQlIyXAbzsJXBmpzsQ2Vln52t7iCHg4eO9t/+HU
+RXpwaxCXgY=
=pdDl
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
