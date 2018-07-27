From: Parav Pandit <parav@mellanox.com>
Subject: RE: linux-next: manual merge of the net-next tree with the rdma tree
Date: Fri, 27 Jul 2018 05:03:10 +0000
Message-ID: <VI1PR0502MB3008C7EE53D450B68FB212E3D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
        <20180727132847.2be8563b@canb.auug.org.au>
 <20180727134524.366e9425@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727134524.366e9425@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jason Gunthorpe <jgg@mellanox.com>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-owner@vger.kernel.org>
> On Behalf Of Stephen Rothwell
> Sent: Thursday, July 26, 2018 10:45 PM
> To: Jason Gunthorpe <jgg@mellanox.com>
> Cc: David Miller <davem@davemloft.net>; Networking
> <netdev@vger.kernel.org>; Doug Ledford <dledford@redhat.com>; Linux-Next
> Mailing List <linux-next@vger.kernel.org>; Linux Kernel Mailing List <lin=
ux-
> kernel@vger.kernel.org>; Parav Pandit <parav@mellanox.com>; Ursula Braun
> <ubraun@linux.ibm.com>; Leon Romanovsky <leonro@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: linux-next: manual merge of the net-next tree with the rdma =
tree
>=20
> Hi all,
>=20
> On Fri, 27 Jul 2018 13:28:47 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
>
> wrote:
> >
> > I applied this merge fix patch:
>=20
> The final conflict resolution actually looks like this:
>=20
> (the rdma tree changes to net/smc/smc_core.c are dropped)
>=20
> c1d4bb2af93573ee4a21538a1a97b568a2344499
> diff --cc net/smc/smc_ib.c
> index 74f29f814ec1,2cc64bc8ae20..debc6e44f738
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@@ -144,6 -142,93 +143,95 @@@ out
>   	return rc;
>   }
>=20
> + static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
> + {
>  -	struct ib_gid_attr gattr;
>  -	union ib_gid gid;
>  -	int rc;
> ++	const struct ib_gid_attr *gattr;
> ++	int rc =3D 0;
> +
>  -	rc =3D ib_query_gid(smcibdev->ibdev, ibport, 0, &gid, &gattr);
>  -	if (rc || !gattr.ndev)
>  -		return -ENODEV;
> ++	gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, 0);
> ++	if (IS_ERR(gattr))
> ++		return PTR_ERR(gattr);
> ++	if (!gattr->ndev) {
> ++		rc =3D -ENODEV;
> ++		goto done;
> ++	}
> +
>  -	memcpy(smcibdev->mac[ibport - 1], gattr.ndev->dev_addr, ETH_ALEN);
>  -	dev_put(gattr.ndev);
>  -	return 0;
> ++	memcpy(smcibdev->mac[ibport - 1], gattr->ndev->dev_addr,
> ETH_ALEN);
> ++done:
> ++	rdma_put_gid_attr(gattr);
> ++	return rc;
> + }
> +
> + /* Create an identifier unique for this instance of SMC-R.
> +  * The MAC-address of the first active registered IB device
> +  * plus a random 2-byte number is used to create this identifier.
> +  * This name is delivered to the peer during connection initialization.
> +  */
> + static inline void smc_ib_define_local_systemid(struct smc_ib_device
> *smcibdev,
> + 						u8 ibport)
> + {
> + 	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
> + 	       sizeof(smcibdev->mac[ibport - 1]));
> + 	get_random_bytes(&local_systemid[0], 2); }
> +
> + bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport) {
> + 	return smcibdev->pattr[ibport - 1].state =3D=3D IB_PORT_ACTIVE; }
> +
> + /* determine the gid for an ib-device port and vlan id */ int
> + smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
> + 			 unsigned short vlan_id, u8 gid[], u8 *sgid_index) {
>  -	struct ib_gid_attr gattr;
>  -	union ib_gid _gid;
> ++	const struct ib_gid_attr *gattr;
> + 	int i;
> +
> + 	for (i =3D 0; i < smcibdev->pattr[ibport - 1].gid_tbl_len; i++) {
>  -		memset(&_gid, 0, SMC_GID_SIZE);
>  -		memset(&gattr, 0, sizeof(gattr));
>  -		if (ib_query_gid(smcibdev->ibdev, ibport, i, &_gid, &gattr))
> ++		gattr =3D rdma_get_gid_attr(smcibdev->ibdev, ibport, i);
> ++		if (IS_ERR(gattr))
> + 			continue;
>  -		if (!gattr.ndev)
> ++		if (!gattr->ndev)
> + 			continue;
Seeing this updated patch, so for completeness same reply as the previous e=
mail.

If (!gattr->ndev) {
	rdma_put_gid_attr(gattr);
	continue;
}
Rest changes above and below looks fine to me.
Thanks for doing it, I am not part of netdev mailing list so didn't see the=
 compile error until this patch came up.

>  -		if (((!vlan_id && !is_vlan_dev(gattr.ndev)) ||
>  -		     (vlan_id && is_vlan_dev(gattr.ndev) &&
>  -		      vlan_dev_vlan_id(gattr.ndev) =3D=3D vlan_id)) &&
>  -		    gattr.gid_type =3D=3D IB_GID_TYPE_IB) {
> ++		if (((!vlan_id && !is_vlan_dev(gattr->ndev)) ||
> ++		     (vlan_id && is_vlan_dev(gattr->ndev) &&
> ++		      vlan_dev_vlan_id(gattr->ndev) =3D=3D vlan_id)) &&
> ++		    gattr->gid_type =3D=3D IB_GID_TYPE_IB) {
> + 			if (gid)
>  -				memcpy(gid, &_gid, SMC_GID_SIZE);
> ++				memcpy(gid, &gattr->gid, SMC_GID_SIZE);
> + 			if (sgid_index)
> + 				*sgid_index =3D i;
>  -			dev_put(gattr.ndev);
> ++			rdma_put_gid_attr(gattr);
> + 			return 0;
> + 		}
>  -		dev_put(gattr.ndev);
> ++		rdma_put_gid_attr(gattr);
> + 	}
> + 	return -ENODEV;
> + }
> +
> + static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev,
> + u8 ibport) {
> + 	int rc;
> +
> + 	memset(&smcibdev->pattr[ibport - 1], 0,
> + 	       sizeof(smcibdev->pattr[ibport - 1]));
> + 	rc =3D ib_query_port(smcibdev->ibdev, ibport,
> + 			   &smcibdev->pattr[ibport - 1]);
> + 	if (rc)
> + 		goto out;
> + 	/* the SMC protocol requires specification of the RoCE MAC address */
> + 	rc =3D smc_ib_fill_mac(smcibdev, ibport);
> + 	if (rc)
> + 		goto out;
> + 	if (!strncmp(local_systemid, SMC_LOCAL_SYSTEMID_RESET,
> + 		     sizeof(local_systemid)) &&
> + 	    smc_ib_port_active(smcibdev, ibport))
> + 		/* create unique system identifier */
> + 		smc_ib_define_local_systemid(smcibdev, ibport);
> + out:
> + 	return rc;
> + }
> +
>   /* process context wrapper for might_sleep smc_ib_remember_port_attr */
>   static void smc_ib_port_event_work(struct work_struct *work)
>   {
>=20
> --
> Cheers,
> Stephen Rothwell
