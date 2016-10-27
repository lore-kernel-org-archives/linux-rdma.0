From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [bug report] qedr: Add GSI support
Date: Thu, 27 Oct 2016 07:46:52 +0000
Message-ID: <SN1PR07MB2207892A0E7BF2E6508450E0F8AA0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <20161026132501.GA3628@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161026132501.GA3628-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch 048867793046: "qedr: Add GSI support" from Oct 10, 2016, leads =
to
> the following Smatch complaint:
>=20
> drivers/infiniband/hw/qedr/qedr_cm.c:284 qedr_gsi_build_header()
> 	 warn: variable dereferenced before check 'sgid_attr.ndev' (see line 281=
)
>=20
> drivers/infiniband/hw/qedr/qedr_cm.c
>    280
>    281		vlan_id =3D rdma_vlan_dev_vlan_id(sgid_attr.ndev);
>                                                 ^^^^^^^^^^^^^^ Dereferenc=
e inside function.
>=20
>    282		if (vlan_id < VLAN_CFI_MASK)
>    283			has_vlan =3D true;
>    284		if (sgid_attr.ndev)
>                     ^^^^^^^^^^^^^^
> Check too late.
>=20
>    285			dev_put(sgid_attr.ndev);
>    286

Thanks Dan. I'll fix this.
Ram
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
