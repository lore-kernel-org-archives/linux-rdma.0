From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Tue, 6 Feb 2018 10:40:19 +0200
Message-ID: <20180206084019.GL2567@mtr-leonro.local>
References: <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
 <20180204150553.GH27780@mtr-leonro.local>
 <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
 <20180205200020.GH11446@mellanox.com>
 <026201d39ebf$d1f087a0$75d196e0$@opengridcomputing.com>
 <20180205203608.GJ11446@mellanox.com>
 <026a01d39ec3$5cc48270$164d8750$@opengridcomputing.com>
 <20180205211618.GL11446@mellanox.com>
 <026c01d39ece$fd9cf550$f8d6dff0$@opengridcomputing.com>
 <20180205222025.GC10095@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Do4IU1xF/9sod/r6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180205222025.GC10095-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Do4IU1xF/9sod/r6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2018 at 03:20:25PM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 05, 2018 at 04:16:37PM -0600, Steve Wise wrote:
> > >
> > > On Mon, Feb 05, 2018 at 02:53:23PM -0600, Steve Wise wrote:
> > >
> > > > Even if we create a device-unique ID for each restrack object, to make
> > it
> > > > useful to for userspace analysis would require exposing that ID in the
> > > > various user object structures (or via query methods).   EG having
> > > > pd->res_id, cq->res_id, etc...
> > >
> > > As I said, we have that, it is the fd, handle # tuple and most verbs
> > > objects expose the handle # in the user visible part of the object
> > > struct..
> >
> > Can you please show me an example of the handle # for some object like PD or
> > CQ?
>
> From rdma-core verbs.h:
>
> struct ibv_pd {
>         struct ibv_context     *context;
>         uint32_t                handle;
> };
>
> > This doesn't address kernel users' object, though, correct?
>
> Right.
>
> And id'ing a file descriptor gets kinda hard too..

And how should we handle kernel objects?

>
> Jason

--Do4IU1xF/9sod/r6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp5afIACgkQ5GN7iDZy
WKfghg//Y+66HZXmX3SRQF93NZpCKhUwfuBKVcoDXo/iTGrAh5n8GtqocoCTyqzc
UU+pcr34ztZiMCZkq2njCGcaDW5YK5CNKYnLAHkM3cSvChuOd7WXh16a7SFbTxeF
QgPr+5VY3tvm2z+ExQt0A41eVea04mZ8adQ/OFwLV4Oue+GjGfNVNoS0LV2gs3N/
sUCyYdCDsKZH0aYBfuGRvrj+UwH7/UolqXTjeawPD9HhekmtgKddYgmA1V1FRe0+
vPX+wSYturLF5LpL/Jq+Kc1mXCu/Vgg85t3gxwCLPiii26AviZ5EVQIw5MR2Fj2L
tW2VwKcZFqSC1DZqiDFWgf+45UbYb81dDi0tKCl39DJ7y0bVPPB/ixR4/LVAbrQk
BkgOIDa6XDu8iJG2ZsiKyTZV9w/CEk7o9W45Bb8AlfgjSnmGiprQb0f2ibU03tVG
5F7mtd5cgg1Yd1M+LEs4OtXQHHJyyGA3Q0BHARPmfw6VKxbgVlsiwgElWWXCYSKr
LQWd0MgAHEVw0fOv5N0a8e3iWjTd1C06Mtn7cJNa4xL1ic4cTkWazE9AaIBSQWgs
xYwu9EPsJcT/xTyDv0Z9PMjuN/jHaGVrO2iiRdmmdsY2cqCW+jCYsb5kshKBFZPS
xhHm5Yj6jgluymV+neR+Ond4h957Qr4NCeqbyn8o69035Pe7U/8=
=A4zA
-----END PGP SIGNATURE-----

--Do4IU1xF/9sod/r6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
