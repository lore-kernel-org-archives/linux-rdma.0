From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/mlx4: Fix parameter checking in
 create_cq
Date: Fri, 11 May 2012 10:15:16 +0200
Message-ID: <20120511101516.2d4b9274@b012350-ux>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
	<1336681689-16668-4-git-send-email-ogerlitz@mellanox.com>
	<20120511091008.40d1dc3d@b012350-ux>
	<CAJZOPZLYp87tgMOBmaJGA4VqdH_t6=jAVr1o=Q7RJuVYZNethw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLYp87tgMOBmaJGA4VqdH_t6=jAVr1o=Q7RJuVYZNethw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 11 May 2012 10:39:12 +0300
Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> > > @@ -172,6 +172,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_dev=
ice
> > > *ibdev, int entries, int vector
> > > =C2=A0 =C2=A0 =C2=A0 struct mlx4_uar *uar;
> > > =C2=A0 =C2=A0 =C2=A0 int err;
> > >
> > > + =C2=A0 =C2=A0 entries =C2=A0 =C2=A0 =C2=A0=3D roundup_pow_of_tw=
o(entries + 1);
> > > =C2=A0 =C2=A0 =C2=A0 if (entries < 1 || entries > dev->dev->caps.=
max_cqes)
> >
> > =C2=A0Is the first check still needed here then?
>=20
> not really, good catch - unless we need to protect here from negative
> values coming
> e.g from user space, I'll look this up,  thanks
>=20
> Or.
>=20
> Or.


  A small test shows that for n < 2, we have roundup_pow_of_two(n) =3D=3D=
 1. But
this is with the current implementation and on x86_64, so maybe on othe=
r
architectures the test may still be needed after all.


  S=C3=A9bastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
