From: "Amrani, Ram" <Ram.Amrani@cavium.com>
Subject: RE: [PATCH] infiniband: hw: qedr: add null check before pointer
 dereference
Date: Tue, 23 May 2017 15:09:36 +0000
Message-ID: <BN3PR07MB25780CAE98AD16793C6DB2D3F8F90@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20170522183015.GA22310@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170522183015.GA22310@embeddedgus>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Add null check before dereferencing pointer sgid_attr.ndev
> inside function rdma_vlan_dev_vlan_id().
>=20
> Addresses-Coverity-ID: 1373979
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw=
/qedr/qedr_cm.c
> index 3d7705c..d86dbe8 100644
> --- a/drivers/infiniband/hw/qedr/qedr_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_cm.c
> @@ -270,11 +270,13 @@ static inline int qedr_gsi_build_header(struct qedr=
_dev *dev,
>  		return rc;
>  	}
>=20
> -	vlan_id =3D rdma_vlan_dev_vlan_id(sgid_attr.ndev);
> -	if (vlan_id < VLAN_CFI_MASK)
> -		has_vlan =3D true;
> -	if (sgid_attr.ndev)
> +	if (sgid_attr.ndev) {
> +		vlan_id =3D rdma_vlan_dev_vlan_id(sgid_attr.ndev);
> +		if (vlan_id < VLAN_CFI_MASK)
> +			has_vlan =3D true;
> +
>  		dev_put(sgid_attr.ndev);
> +	}
>=20
>  	if (!memcmp(&sgid, &zgid, sizeof(sgid))) {
>  		DP_ERR(dev, "gsi post send: GID not found GID index %d\n",
> --
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks.

Acked-by: Ram Amrani <Ram.Amrani@cavium.com>
