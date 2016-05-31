From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [stable 3.2-3.16] IB/security: Restrict use of the write() interface
Date: Tue, 31 May 2016 03:40:50 +0100
Message-ID: <20160531024050.GL7555@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BjavXC7V3ilNTWHC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BjavXC7V3ilNTWHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This commit should be included in all stable branches:

commit e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Sun Apr 10 19:13:13 2016 -0600

    IB/security: Restrict use of the write() interface

When backporting, please fold the following change to the ipath driver
into the patch.

Ben.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -44,6 +44,8 @@
 #include <linux/cpu.h>
 #include <asm/pgtable.h>
=20
+#include <rdma/ib.h>
+
 #include "ipath_kernel.h"
 #include "ipath_common.h"
 #include "ipath_user_sdma.h"
@@ -2239,6 +2241,9 @@ static ssize_t ipath_write(struct file *
 	ssize_t ret =3D 0;
 	void *dest;
=20
+	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
+		return -EACCES;
+
 	if (count < sizeof(cmd.type)) {
 		ret =3D -EINVAL;
 		goto bail;

--BjavXC7V3ilNTWHC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV0z5see/yOyVhhEJAQpSMA/6Ank/XMtY+z3M9uN3B1eB5/DFoEJzHXV8
kfvO+R6lqZ7RJfG1jzBeRuanie8j+d3Uh1pu6uiPWyyF9YNCIcKsJ4nNNqcgCC7q
/+fcDwyrFBH+QpOEC4zOQXQx3VHjbGCyPrMue0NE65UUXjoXjfTNaezDGkO9NAXz
1yDkfAGf/r82eoYjiTjBAW5mfJbDgVWc5inRpMZOijMkzYbpngbXwwMTOcKgPd+H
zci5pTSHipwi7S64ha6RqBn8a6/veKwm+Bs0gPC6i5kb5BwPlKu1FMeCwBaeFYcg
YY6U7ZSJfJz91IZaDSqux4T7+2LXrtO/XK0onqjjnVJ9kLq1eYtx/W8HMgFdI8AG
5MjBFJnMkOTjpAx3sqs3cUdQ5ZobgiWM2HWknFK8CjEMOjyn+2sMgeKf87okajz9
U2ZH9HOLPTshZ6rvTblxyS2Z19i6rMIMbozpD5h8SrqqhcWhOvnrqFomDY0Viirc
7oUsTMvPfjhGZ4ssndT/rpqKFd+4AmKZh3AQbps6zpKTiACdObKp+CGnsjmXKkJf
S7AEmQZMAwTuafa7D/sS2R2cJVvUI5ed604gbFh/929GygUvtO57k0KVZUlOd8dG
ohl6CuOfcUsO2/67FiBY6jX693YRFJOBDqNY+AvceRVXepKAE0Pvmd8/XZXI/9SN
cbE7oH9WFSg=
=5ojO
-----END PGP SIGNATURE-----

--BjavXC7V3ilNTWHC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
