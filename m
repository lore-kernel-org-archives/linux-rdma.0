From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma
 tree
Date: Fri, 27 Jul 2018 13:45:24 +1000
Message-ID: <20180727134524.366e9425@canb.auug.org.au>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
        <20180727132847.2be8563b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//JysvMrjrjYAf5O1w89sKoR"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727132847.2be8563b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Parav Pandit <parav@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--Sig_//JysvMrjrjYAf5O1w89sKoR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 27 Jul 2018 13:28:47 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I applied this merge fix patch:

The final conflict resolution actually looks like this:

(the rdma tree changes to net/smc/smc_core.c are dropped)

c1d4bb2af93573ee4a21538a1a97b568a2344499
diff --cc net/smc/smc_ib.c
index 74f29f814ec1,2cc64bc8ae20..debc6e44f738
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@@ -144,6 -142,93 +143,95 @@@ out
  	return rc;
  }
 =20
+ static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
+ {
 -	struct ib_gid_attr gattr;
 -	union ib_gid gid;
 -	int rc;
++	const struct ib_gid_attr *gattr;
++	int rc =3D 0;
+=20
 -	rc =3D ib_query_gid(smcibdev->ibdev, ibport, 0, &gid, &gattr);
 -	if (rc || !gattr.ndev)
 -		return -ENODEV;
++	gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, 0);
++	if (IS_ERR(gattr))
++		return PTR_ERR(gattr);
++	if (!gattr->ndev) {
++		rc =3D -ENODEV;
++		goto done;
++	}
+=20
 -	memcpy(smcibdev->mac[ibport - 1], gattr.ndev->dev_addr, ETH_ALEN);
 -	dev_put(gattr.ndev);
 -	return 0;
++	memcpy(smcibdev->mac[ibport - 1], gattr->ndev->dev_addr, ETH_ALEN);
++done:
++	rdma_put_gid_attr(gattr);
++	return rc;
+ }
+=20
+ /* Create an identifier unique for this instance of SMC-R.
+  * The MAC-address of the first active registered IB device
+  * plus a random 2-byte number is used to create this identifier.
+  * This name is delivered to the peer during connection initialization.
+  */
+ static inline void smc_ib_define_local_systemid(struct smc_ib_device *smc=
ibdev,
+ 						u8 ibport)
+ {
+ 	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
+ 	       sizeof(smcibdev->mac[ibport - 1]));
+ 	get_random_bytes(&local_systemid[0], 2);
+ }
+=20
+ bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport)
+ {
+ 	return smcibdev->pattr[ibport - 1].state =3D=3D IB_PORT_ACTIVE;
+ }
+=20
+ /* determine the gid for an ib-device port and vlan id */
+ int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
+ 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index)
+ {
 -	struct ib_gid_attr gattr;
 -	union ib_gid _gid;
++	const struct ib_gid_attr *gattr;
+ 	int i;
+=20
+ 	for (i =3D 0; i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
 -		memset(&_gid, 0, SMC_GID_SIZE);
 -		memset(&gattr, 0, sizeof(gattr));
 -		if (ib_query_gid(smcibdev->ibdev, ibport, i, &_gid, &gattr))
++		gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
++		if (IS_ERR(gattr))
+ 			continue;
 -		if (!gattr.ndev)
++		if (!gattr->ndev)
+ 			continue;
 -		if (((!vlan_id && !is_vlan_dev(gattr.ndev)) ||
 -		     (vlan_id && is_vlan_dev(gattr.ndev) &&
 -		      vlan_dev_vlan_id(gattr.ndev) =3D=3D vlan_id)) &&
 -		    gattr.gid_type =3D=3D IB_GID_TYPE_IB) {
++		if (((!vlan_id && !is_vlan_dev(gattr->ndev)) ||
++		     (vlan_id && is_vlan_dev(gattr->ndev) &&
++		      vlan_dev_vlan_id(gattr->ndev) =3D=3D vlan_id)) &&
++		    gattr->gid_type =3D=3D IB_GID_TYPE_IB) {
+ 			if (gid)
 -				memcpy(gid, &_gid, SMC_GID_SIZE);
++				memcpy(gid, &gattr->gid, SMC_GID_SIZE);
+ 			if (sgid_index)
+ 				*sgid_index =3D i;
 -			dev_put(gattr.ndev);
++			rdma_put_gid_attr(gattr);
+ 			return 0;
+ 		}
 -		dev_put(gattr.ndev);
++		rdma_put_gid_attr(gattr);
+ 	}
+ 	return -ENODEV;
+ }
+=20
+ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 i=
bport)
+ {
+ 	int rc;
+=20
+ 	memset(&smcibdev->pattr[ibport - 1], 0,
+ 	       sizeof(smcibdev->pattr[ibport - 1]));
+ 	rc =3D ib_query_port(smcibdev->ibdev, ibport,
+ 			   &smcibdev->pattr[ibport - 1]);
+ 	if (rc)
+ 		goto out;
+ 	/* the SMC protocol requires specification of the RoCE MAC address */
+ 	rc =3D smc_ib_fill_mac(smcibdev, ibport);
+ 	if (rc)
+ 		goto out;
+ 	if (!strncmp(local_systemid, SMC_LOCAL_SYSTEMID_RESET,
+ 		     sizeof(local_systemid)) &&
+ 	    smc_ib_port_active(smcibdev, ibport))
+ 		/* create unique system identifier */
+ 		smc_ib_define_local_systemid(smcibdev, ibport);
+ out:
+ 	return rc;
+ }
+=20
  /* process context wrapper for might_sleep smc_ib_remember_port_attr */
  static void smc_ib_port_event_work(struct work_struct *work)
  {

--=20
Cheers,
Stephen Rothwell

--Sig_//JysvMrjrjYAf5O1w89sKoR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltalVQACgkQAVBC80lX
0GxPMQf/UnQUGwWvvUmQorXHjtr+gZQhUyGOaJUY2QKO22tm72NN09qYxzcgjKjc
TTj4eV1dcRLaBH84ybJo55MWpdogI3/vAl3xPeZGw3SsgEQotZ7Q94mzehTCaiDu
StsEVeuB7w8dBIPHK3vI+ODLCoaJe79b8JZHPiHbJzjYKo0p29dfOJ+u2Dm8/UZJ
ufz9rQXUiQkstF6uD3rfuTy6CNg8IXPsyQAuvzvrpPI8UWJeH3EWAzE1wMLxJhgp
jVAIDe3dR1jGHg4FnnpzH7H3nVFjtqwOTln/pu7zey1Z7RxN0xowH+u/VE730f0G
nqHA2DHEjq3bXcE/gUJByh5nlzk3wg==
=gm3y
-----END PGP SIGNATURE-----

--Sig_//JysvMrjrjYAf5O1w89sKoR--
