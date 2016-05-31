From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.18-4.2] ipath: Restrict use of the write() interface
Date: Tue, 31 May 2016 03:33:00 +0100
Message-ID: <20160531023300.GH7555@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ed/6oDxOLijJh8b0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit e6bd18f57aad ("IB/security: Restrict use of the write()
interface") fixed a security problem with various write()
implementations in the Infiniband subsystem.  In older kernel versions
the ipath_write() function has the same problem and needs the same
restriction.  (The ipath driver has been completely removed upstream.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV0z33Oe/yOyVhhEJAQrrIQ//cUHgM3/EdxsvmZSDceGqRbKlMcxQf7Z8
e+KUE9bJTTtECH4AP4vT6FTDWuOF2eiVv0EZFokf1KTAOclTraqZwc7oh2icZhEt
U9ljfBk0+opUYcdENBZVFqT4ZZJgvW/O/MRuqXeAQKJB4+CUgMFSXgyv7s6cJlgL
+QfXevQDKmoslFz4cyCI00t9x3uCS6YIErX45rlTQL1aorcAI3E0zytx34oqPgCI
Mt+U5VxzuWhRHT70k6BmE/hFTfhWXOEDLqvMfnFJs8V0uOM1kU9K4rE5qxHhqETb
hkdZYQUXHfo9Woq+D+OFuuTPUWBWCAOdaQEs1GDWMlvLwaEQS1USxhU1z7ffbREN
RzhfAWAa7O22V3NoKxT99NXqhnRYgo3g3HQ2iwF77hb6V9PkM4z+ltY44kTR76If
s7Kmca7Nv6RgZzw7xRUhG93INYz4zfiIKkcg5PL+292BRIxcem/I4arqeqXAjhEF
O/GJU5BMWU22yVdO2Pcx9+uRbp8duwy4iKLythLzT4h5AeJkHY4zdvrD312NBlCL
AsXgtv3JGozRADXLfi5YfbVnATbaLvEMvYXbmXoq7CoeTszi8bU0b2pMX7nAsyhm
nPBq2eWZ/1U0xMlROw9rbcsf8LWJvq4pP8IzyPl4bhHyo8k6kw4vx5ItnfcC1RNf
1CHDdnMWyAo=
=lfiK
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--
