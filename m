From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma
 tree
Date: Fri, 27 Jul 2018 13:28:47 +1000
Message-ID: <20180727132847.2be8563b@canb.auug.org.au>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wCED4/E9j3DQ4JJ4eMc2WQ1"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727024832.GA30023@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Parav Pandit <parav@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--Sig_/wCED4/E9j3DQ4JJ4eMc2WQ1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Thu, 26 Jul 2018 20:48:32 -0600 Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Fri, Jul 27, 2018 at 12:33:01PM +1000, Stephen Rothwell wrote:
>=20
> > I fixed it up (I wasn't sure how to fix this up as so much has changed
> > in the net-next tree and both modified functions had been (re)moved,
> > so I effectively reverted the rdma tree commit) and can carry the fix
> > as necessary.  Please come to some arrangement about this. =20
>=20
> How does that still compile? We removed ib_query_gid() from the rdma
> tree and replaced it with rdma_get_gid_attr()..

Yeah, it doesn't :-(

> I think the merge resolution is going to be a bit nasty to absorb
> that much changing..
>=20
> Perhaps we should add a compatability ib_query_gid back to the RDMA
> tree and then send DaveM a commit to fix SMC and remove it during the
> next cycle? Linus can resolve smc_ib.c by using the net version
>=20
> Does someone else have a better idea?

I applied this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Jul 2018 13:19:31 +1000
Subject: [PATCH] net/smc: fixups for ip_query_gid API removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/smc/smc_ib.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 2cc64bc8ae20..debc6e44f738 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_cache.h>
=20
 #include "smc_pnet.h"
 #include "smc_ib.h"
@@ -144,17 +145,21 @@ int smc_ib_ready_link(struct smc_link *lnk)
=20
 static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
 {
-	struct ib_gid_attr gattr;
-	union ib_gid gid;
-	int rc;
+	const struct ib_gid_attr *gattr;
+	int rc =3D 0;
=20
-	rc =3D ib_query_gid(smcibdev->ibdev, ibport, 0, &gid, &gattr);
-	if (rc || !gattr.ndev)
-		return -ENODEV;
+	gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, 0);
+	if (IS_ERR(gattr))
+		return PTR_ERR(gattr);
+	if (!gattr->ndev) {
+		rc =3D -ENODEV;
+		goto done;
+	}
=20
-	memcpy(smcibdev->mac[ibport - 1], gattr.ndev->dev_addr, ETH_ALEN);
-	dev_put(gattr.ndev);
-	return 0;
+	memcpy(smcibdev->mac[ibport - 1], gattr->ndev->dev_addr, ETH_ALEN);
+done:
+	rdma_put_gid_attr(gattr);
+	return rc;
 }
=20
 /* Create an identifier unique for this instance of SMC-R.
@@ -179,29 +184,27 @@ bool smc_ib_port_active(struct smc_ib_device *smcibde=
v, u8 ibport)
 int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index)
 {
-	struct ib_gid_attr gattr;
-	union ib_gid _gid;
+	const struct ib_gid_attr *gattr;
 	int i;
=20
 	for (i =3D 0; i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
-		memset(&_gid, 0, SMC_GID_SIZE);
-		memset(&gattr, 0, sizeof(gattr));
-		if (ib_query_gid(smcibdev->ibdev, ibport, i, &_gid, &gattr))
+		gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
+		if (IS_ERR(gattr))
 			continue;
-		if (!gattr.ndev)
+		if (!gattr->ndev)
 			continue;
-		if (((!vlan_id && !is_vlan_dev(gattr.ndev)) ||
-		     (vlan_id && is_vlan_dev(gattr.ndev) &&
-		      vlan_dev_vlan_id(gattr.ndev) =3D=3D vlan_id)) &&
-		    gattr.gid_type =3D=3D IB_GID_TYPE_IB) {
+		if (((!vlan_id && !is_vlan_dev(gattr->ndev)) ||
+		     (vlan_id && is_vlan_dev(gattr->ndev) &&
+		      vlan_dev_vlan_id(gattr->ndev) =3D=3D vlan_id)) &&
+		    gattr->gid_type =3D=3D IB_GID_TYPE_IB) {
 			if (gid)
-				memcpy(gid, &_gid, SMC_GID_SIZE);
+				memcpy(gid, &gattr->gid, SMC_GID_SIZE);
 			if (sgid_index)
 				*sgid_index =3D i;
-			dev_put(gattr.ndev);
+			rdma_put_gid_attr(gattr);
 			return 0;
 		}
-		dev_put(gattr.ndev);
+		rdma_put_gid_attr(gattr);
 	}
 	return -ENODEV;
 }
--=20
2.18.0

--=20
Cheers,
Stephen Rothwell

--Sig_/wCED4/E9j3DQ4JJ4eMc2WQ1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltakW8ACgkQAVBC80lX
0Gxk2Qf/dUiJ3dNtaQ8uQBGtAMB83b2EeQvVOvKMxR2TapgPsBfBCBsBlLMqBhER
kE97W/JyovCfzIkpXAjoywWXGmv2893H/LT1e1BfsfGs36v0vPIiF0+9EgfP/E+c
oXcqustzn2jObXJtE/SCwiF/NdFy1l9+4hC+FZ16vEiDVqCfEzuhoN4JRUEwT9bt
iGWeeiejvhGpJF8Wkolg/U4mfkiTiHSDSzvpplSdYTfavvEpQY+hBjNHwNKS+AJT
9aoBxqMz86PzETRJAPH6gG5YFgWqaIFE6PZdSiH9C5gjRpb2ZMBl4DLV2dfe5G/p
8TYaUB9Cz8/7M62NSo9DB9sdCnLtvQ==
=jGEe
-----END PGP SIGNATURE-----

--Sig_/wCED4/E9j3DQ4JJ4eMc2WQ1--
