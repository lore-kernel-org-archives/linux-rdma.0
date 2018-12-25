From: Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [EXT] [PATCH] infiniband/qedr: Potential null ptr dereference of
 qp
Date: Tue, 25 Dec 2018 13:13:35 +0000
Message-ID: <BLUPR18MB013099199B96DDC73099D0E5A1B40@BLUPR18MB0130.namprd18.prod.outlook.com>
References: <20181224182445.21256-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181224182445.21256-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: "kjlu@umn.edu" <kjlu@umn.edu>, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> From: Aditya Pakki <pakki001@umn.edu>
> Sent: Monday, December 24, 2018 8:25 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> External Email
>=20
> idr_find() may fail and return a NULL pointer. The fix checks the return =
value
> of the function and returns an error in case of NULL.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> index 505fa3648762..93b16237b767 100644
> --- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> @@ -492,6 +492,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct
> iw_cm_conn_param *conn_param)
>         int i;
>=20
>         qp =3D idr_find(&dev->qpidr.idr, conn_param->qpn);
> +       if (unlikely(!qp))
> +               return -EINVAL;
>=20
>         laddr =3D (struct sockaddr_in *)&cm_id->m_local_addr;
>         raddr =3D (struct sockaddr_in *)&cm_id->m_remote_addr;
> --
> 2.17.1

Thanks,

Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
