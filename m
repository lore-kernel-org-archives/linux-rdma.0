From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Date: Wed, 18 Feb 2015 11:29:08 +1100
Message-ID: <20150218112908.5e2eaee5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+_HUx/IaOn1=g3rrc5A=6Cp"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Moni Shoua <monis@mellanox.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

--Sig_/+_HUx/IaOn1=g3rrc5A=6Cp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/hw/mlx4/main.c between commit 146d6e19832a
("IB/mlx4: Create mirror flows in port aggregation mode") from Linus'
tree and commit e9a7faf11af9 ("IB/mlx4: Fix wrong usage of IPv4
protocol for multicast attach/detach") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/mlx4/main.c
index eb8e215f1613,0b280b1c98df..000000000000
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@@ -1266,12 -1219,10 +1266,11 @@@ static int mlx4_ib_mcg_attach(struct ib
  {
  	int err;
  	struct mlx4_ib_dev *mdev =3D to_mdev(ibqp->device);
 +	struct mlx4_dev	*dev =3D mdev->dev;
  	struct mlx4_ib_qp *mqp =3D to_mqp(ibqp);
 -	u64 reg_id;
  	struct mlx4_ib_steering *ib_steering =3D NULL;
- 	enum mlx4_protocol prot =3D (gid->raw[1] =3D=3D 0x0e) ?
- 		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
+ 	enum mlx4_protocol prot =3D MLX4_PROT_IB_IPV6;
 +	struct mlx4_flow_reg_id	reg_id;
 =20
  	if (mdev->dev->caps.steering_mode =3D=3D
  	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
@@@ -1283,21 -1234,12 +1282,23 @@@
  	err =3D mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, mqp->port,
  				    !!(mqp->flags &
  				       MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
 -				    prot, &reg_id);
 +				    prot, &reg_id.id);
- 	if (err)
+ 	if (err) {
+ 		pr_err("multicast attach op failed, err %d\n", err);
  		goto err_malloc;
+ 	}
 =20
 +	reg_id.mirror =3D 0;
 +	if (mlx4_is_bonded(dev)) {
 +		err =3D mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw,
 +					    (mqp->port =3D=3D 1) ? 2 : 1,
 +					    !!(mqp->flags &
 +					    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
 +					    prot, &reg_id.mirror);
 +		if (err)
 +			goto err_add;
 +	}
 +
  	err =3D add_gid_entry(ibqp, gid);
  	if (err)
  		goto err_add;
@@@ -1347,10 -1285,8 +1348,9 @@@ static int mlx4_ib_mcg_detach(struct ib
  	struct mlx4_ib_qp *mqp =3D to_mqp(ibqp);
  	struct net_device *ndev;
  	struct mlx4_ib_gid_entry *ge;
 -	u64 reg_id =3D 0;
 +	struct mlx4_flow_reg_id reg_id =3D {0, 0};
 +
- 	enum mlx4_protocol prot =3D (gid->raw[1] =3D=3D 0x0e) ?
- 		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
+ 	enum mlx4_protocol prot =3D  MLX4_PROT_IB_IPV6;
 =20
  	if (mdev->dev->caps.steering_mode =3D=3D
  	    MLX4_STEERING_MODE_DEVICE_MANAGED) {

--Sig_/+_HUx/IaOn1=g3rrc5A=6Cp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU49zbAAoJEMDTa8Ir7ZwVVH4P/0Gq9r4ddJCBnanSPeGjNG0F
TJQdE82nrsFL62/qGvboTIbixUXKZB1bWsopR6RRIZySLSH0zbz3ecpTJ9TM3NDZ
lW9ZBWC+EOmCRS6bW6jxgQMX0QRKkRylGi4qoPBRvFoQmgOyR7ttG70IVFRXP2qk
iwXp2+ApDpgViDUF7kTJ/9KHBi0ANWa6G1tKp/iz69RKjPBd8pFil5jITjWFMaca
Zm64goh1kWeubeuyQD0Co91JIuIJtnwdvrodoI3qKFzU/3zwpcxvzZzZHrFq5MT4
Cs7fDIat2tYGmvzhY2N2YcpwJM3JStVMiotFoTV21XFXb0F7Goh4FG6LSl4X9TOS
OpVbvtivecIGIxdV+uCb6z83eeoS8JNg2V6uWyPCCExtXrsMut/PK8VldUdaNqI3
82dIi4x/sXj5pdJRE4y6haUOkAIW3K4IiLGQhs3OzhgGE9yqsyhF3oO/uGs0U7os
q43BQhDmFVYWv6ckqnoQ4j4Z1lu8ME5Wcbyz7E+Rh7yMKwjOFoin8olW6XlizmhK
CVbAjwZSm2o3kcaXB5nUFKr5kCqQkkBcUqnHW65PbUQ6lEdzZSOW8+0UTdWv5Mmi
D6B84Z0ewrqhcDOs84hsR0/lcAuNua1yovRqM7x4o5gbxU8+TONE7rVna4MXk5m3
2P8M9BeP5nckGJEElYEe
=GEsT
-----END PGP SIGNATURE-----

--Sig_/+_HUx/IaOn1=g3rrc5A=6Cp--
