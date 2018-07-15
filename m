From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx5: avoid binding a new mpi unit to the same
 devices repeatedly
Date: Sun, 15 Jul 2018 09:04:13 +0300
Message-ID: <20180715060413.GB3152@mtr-leonro.mtl.com>
References: <20180713235021.18141-1-qing.huang@oracle.com>
 <CAJ3xEMi5zF83aA_SWfYT+JtWGGhqRhLyTKe-qYwevSBLuiK=cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMi5zF83aA_SWfYT+JtWGGhqRhLyTKe-qYwevSBLuiK=cA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Daniel Jurgens <danielj@mellanox.com>, Linux Kernel <linux-kernel@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, gerald.gibson@oracle.com, Qing Huang <qing.huang@oracle.com>
List-Id: linux-rdma@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 14, 2018 at 06:57:01PM +0300, Or Gerlitz wrote:
> On Sat, Jul 14, 2018 at 2:50 AM, Qing Huang <qing.huang@oracle.com> wrote:
> > When a CX5 device is configured in dual-port RoCE mode, after creating
> > many VFs against port 1, creating the same number of VFs against port 2
> > will flood kernel/syslog with something like
> > "mlx5_*:mlx5_ib_bind_slave_port:4266:(pid 5269): port 2 already
> > affiliated."
> >
> > So basically, when traversing mlx5_ib_dev_list, mlx5_ib_add_slave_port()
> > shouldn't repeatedly attempt to bind the new mpi data unit to every device
> > on the list until it finds an unbound device.
>
> Daniel,
>
> What is mpi data unit?

Or,

"mpi" is multi-port information needed for multi-port IB devices
resource sharing.

In simple words, "mpi" holds mapping information between
affiliated ports (master vs. slave) and IB device which it is connected.

Most probably, "mpi data unit" was meant "mpi struct" by Qing.

BTW, Daniel is OOO till 7-23.

Thanks

>
> Or.
>
> >
> > Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
> > Signed-off-by: Qing Huang <qing.huang@oracle.com>
> > ---
> >  drivers/infiniband/hw/mlx5/main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index b3ba9a2..1ddd1d3 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -6068,7 +6068,8 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num)
> >
> >         mutex_lock(&mlx5_ib_multiport_mutex);
> >         list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
> > -               if (dev->sys_image_guid == mpi->sys_image_guid)
> > +               if (dev->sys_image_guid == mpi->sys_image_guid &&
> > +                   !dev->port[mlx5_core_native_port_num(mdev) - 1].mp.mpi)
> >                         bound = mlx5_ib_bind_slave_port(dev, mpi);
> >
> >                 if (bound) {
> > --
> > 2.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbSuPdAAoJEORje4g2clinNSsP/Rt0jglILNvL/VB9eMbAGJEb
+RfVjfxIzuCQOKCGCtcGjWp4GHXcpdUQRzPiqm/NwZ7evq/jJBd9z98PKmYdGySF
JtDpuCg8xiN8dFau/rSBkWcQL9MgBBfUBi3QFs1ptdh4cQ5eaNLyZDdm/SS+3Iyw
7TYq5PTVHh2ZUHsTciUMTwMCZjoU5umPzvmliVgrEgseHqkp2fYTRYxj9nYA9lAV
yoMN82mgvVdF8kNlW2iKxC8hBMqmU6pxhfY56tszMr8laq+LGKzvWCzolBfeKcP7
jozVL4bVfMix8sjHRQ7BW9KsYVIl4kv3K2Y2E1Ma8sThRho/5s5ExkGd8L7Fvw1F
VBLM4sI6CSAn2IzqeAV5EkS86NAFjjKYivaWWUQ1B+KRetdSD5cJ27sLcB26vFpJ
0fJvzc6YLfAIosll5M7i/4q7MVbGHXZi6ladMtxs4Ysmw4VvvuHz4Z4BU/szrX8d
tWBRa6l1jpBLipP5MYZIVYEgL2C4w551vQGB5jFfQuBdJsPdLs2CI6x9OzL5Oavu
/gvsAjNN9vLzVr51CqR4YhbbCMhuIiIKbv9c+YpQ8BEYUohOdjoAMKra7pcyFepT
69/c24L07KHOzG48juX4dZExA2i8QRc5531EkpOvWMlvFgiunhRTa6Ah9vy+etUE
aYN7fryest4z2xBVtzMq
=JzvT
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
