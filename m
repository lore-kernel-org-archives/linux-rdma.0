From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ib_create_qp failing
Date: Wed, 31 Jan 2018 15:58:15 +0200
Message-ID: <20180131135815.GA2055@mtr-leonro.local>
References: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558@notes.na.collabserv.com>
 <AM4PR0501MB27239EF18E2C07A64B045674D4E50@AM4PR0501MB2723.eurprd05.prod.outlook.com>
 <OF09394B7D.58CD59F8-ONC2258224.006BDAF8-C2258224.006F854D@notes.na.collabserv.com>
 <fd693fbd-1387-0298-49d0-035e224f07d8@mellanox.com>
 <OF85410752.DF2BA5BF-ONC2258225.002CFF83-C2258225.002EB65B@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uFO8jlCBh1yRPqfb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF85410752.DF2BA5BF-ONC2258225.002CFF83-C2258225.002EB65B-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joel Nider <JOELN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uFO8jlCBh1yRPqfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 10:30:13AM +0200, Joel Nider wrote:
> Hi Mark,
>
> Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote on 29/01/2018 22:47:04:
>
> > > I am using ConnectX5 EN with special firmware (I just mention it so
> you
> > > know, but I'm pretty sure that's not the problem).  I have used
> dynamic
> > > debug - it shows me that the call is failing like this:
> > >
> > > mlx5_core 0000:01:00.0: mlx5_cmd_check:714:(pid 120772):
> CREATE_QP(0x500)
> > > op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x48b5c0)
> >
> > The syndrome means: "create_qp: invalid service type for RoCE"
> > what QP type are you trying to create and with what parameters?
>
> I'm trying to create an RC connection - here is an outline of my code:
> In module_init(): ib_register_client() -> registers callback
> on_device_add()
> On_device_add(): I only have one device (mlx5_0) and I save the ib_device*
> to a linked list
> From sysfs, a user writes the name (string) of the device to use - this
> starts the setup procedure
> ib_register_event_handler(rpf_ib_qp_event_handler)
> ib_query_port(dev, 1) -> state=4 max_mtu=4096 active_mtu=1024 gid_len=256
> caps=0x4010000
> ib_create_cq() -> rx completion queue
> ib_create_cq() -> tx completion queue
> ib_alloc_pd() -> the protection domain
> ib_create_qp() with:
>
>         struct ib_qp_init_attr qp_attr = {
>                 .event_handler = rpf_ib_qp_event_handler,
>                 .qp_context = res,
>                 .send_cq = res->tx_cq,
>                 .recv_cq = res->rx_cq,
>                 .srq = NULL,
>                 .cap = {
>                         .max_send_wr = 16,
>                         .max_recv_wr = 48,
>                         .max_send_sge = 2,
>                         .max_recv_sge = 1,
>                 },
>                 .sq_sig_type = IB_SIGNAL_REQ_WR,
>                 .qp_type = IB_QPT_RC,
>         };
>
> Fails with the code I mentioned earlier.  This used to fail even earlier
> until I discovered that ib_query_port() has some interesting side effects,
> and is mandatory. Maybe there is some other function that I need to call
> to set up some state first?

We strongly recommend you to contact the customer support
representative, because you are getting FW error from custom FW.

Thanks

--uFO8jlCBh1yRPqfb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxy3cACgkQ5GN7iDZy
WKdVpxAAt434dRKhj4PymwSDegh1kzpE95pdaM5iMjWdCDW3znDWRmVhf3McFyW7
kK5jPJ3OL/WfqDzfB4ZCtJDp3Auk+c9hkqc6SqSRtyR4f1dcRMqoYUSbIPvBFjrA
lKGcQAxaM3iY0PQsX0OuVIBrgT0NR2cCuFx7cVbqJWa3vWf7TLrDBUTxRC2dFmaB
7pbZCzZ4qo7SQqEJIenAO1GgQ7odOwLXvrsisuP4KoDy0z6f6NhHtqz5FJzlVf71
4kN+u7TYYs8hZKziFo8t2cP0qw5arYv5W2Z60vtC5MDj+P104GONrgFZu0/oVfOJ
6XNFF3JR3IxWnrkRlmdoFlxmcnRgzoTB6RayezdeaRtav/AAxNG/6znoKdlhO56y
MQXJJ30HQxgQxeCc+JWhqG1ADjy3WVwRo1ovOy6CCUU5JkbBzaecKc1/tdFnbY/y
pRK0YhngX/+TmrhSSW9cNjXajGIB+RMtFf/pIFkimeqOsXVJZ3j5VBer5w9fOn5M
vYKp0s1i9+aIag7H3Ad2qpiP5+pcCR6ZZdbJYBxFRno+WanlyPvPwbcXI36LseHc
//6p9Ic1l2QcJ06UCzUOPJu0FN53a6E3J6QGAp2+AnVTcC5Wv+AIBOfdxBqr02u3
Q+izTHJnUvi+mjH5/cr47xB8sdFPPYUORRV4937aPD4W9LW9BXY=
=s/ge
-----END PGP SIGNATURE-----

--uFO8jlCBh1yRPqfb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
