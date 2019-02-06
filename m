From: jackm <jackm@dev.mellanox.co.il>
Subject: Re: [PATCH] mlx4_ib: Increase the timeout for CM cache
Date: Wed, 6 Feb 2019 20:02:29 +0200
Message-ID: <20190206200229.00002e2f@dev.mellanox.co.il>
References: <20190131170951.178676-1-haakon.bugge@oracle.com>
        <20190205223608.GA23110@ziepe.ca>
        <13750147-482A-4F90-976A-033C52DCF85E@oracle.com>
        <FF460501-80BA-44B9-AD59-84F64A338D67@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FF460501-80BA-44B9-AD59-84F64A338D67@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 6 Feb 2019 16:40:14 +0100
H=E5kon Bugge <haakon.bugge@oracle.com> wrote:

> Jack,
>=20
> A major contributor to the long processing time in the PF driver
> proxying QP1 packets is:
>=20
> create_pv_resources
>    -> ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler, =20
>                                NULL, ctx, cq_size, 0);
>=20
> That is, comp_vector is zero.
>=20
> Due to commit 6ba1eb776461 ("IB/mlx4: Scatter CQs to different EQs"),
> the zero comp_vector has the intent of let the mlx4_core driver
> select the least used vector.
>=20
> But, in mlx4_ib_create_cq(), we have:
>=20
>         pr_info("eq_table: %p\n", dev->eq_table);
>         if (dev->eq_table) {
> 		vector =3D dev->eq_table[mlx4_choose_vector(dev->dev,
> vector, ibdev->num_comp_vectors)];
>         }
>=20
>         cq->vector =3D vector;
>=20
> and dev->eq_table is NULL, so all the CQs for the proxy QPs get
> comp_vector zero.
>=20
> I have to make some reservations, as this analysis is based on uek4,
> but I think the code here is equal upstream, but need to double check.
>=20
>=20
> Thxs, H=E5kon
>=20
Hi Hakon and Jason,
I was ill today (bad cold, took antihistamines all day, which knocked
me out).
I'll get to this tomorrow.

-Jack
