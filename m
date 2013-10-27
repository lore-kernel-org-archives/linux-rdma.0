From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Sun, 27 Oct 2013 22:26:41 +0000
Message-ID: <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
	 <1382912049.30941.5.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yvBhL6H7kiF9CEsJJ4Ad"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382912049.30941.5.camel@joe-AO722>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-yvBhL6H7kiF9CEsJJ4Ad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-10-27 at 15:14 -0700, Joe Perches wrote:
> On Sun, 2013-10-27 at 22:02 +0000, Ben Hutchings wrote:
> > On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> > > On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > > > Physical addresses may be wider than virtual addresses (e.g. on i38=
6
> > > > with PAE) and must not be formatted with %p.
> > >=20
> > > %pa works.  %pa also prefixes with 0x.
> >=20
> > Only as long as pci_resource_start() happens to be an lvalue.  I'd
> > rather not introduce that assumption.
>=20
> pci_resource_start returns a resource_size_t which is a phys_addr_t.
>=20
> Changing that from an lvalue would cause a _lot_ of breakage.

I don't think so.  This doesn't find anything:
    git grep '&[ (]*pci_resource_start'

and I was able to build drivers/{net,pci,scsi}/ successfully with
pci_resource_start() changed to an inline function.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-yvBhL6H7kiF9CEsJJ4Ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2TIee/yOyVhhEJAQp7AQ//WEmqg3V78tJmR4AfgXvQ7gp/h3C48O5z
xNje9Ou7CQf6nv8wB1bw8ynRQX6AKFr1zfkTw4TbjHPEo+JvA+6dKdSUiEdj00gE
4SUTEKTVQj+nUV8qqKbMpq3smB1b5zRbq20PzIsAQIawe+P7i1d7s+OUn2uXSxkU
RJzaVhZCuPAl7mGZhALWHM1olEQCN7gAQVBgJvj2+66w1NUeaTemUXyReTFt1j1K
oB9N21uWpEbwh0cKsl9ce5Yg8TaC4OfaLBK27xZWGn3PdW5X6iLPWhY0ADVJtNTD
hfOoXn1hY29AovhUqf7M8fRyv08k+4CEd1wJXyZmi3+/k6Wii81kbIhpjuRHq4VH
TaPIvUogeDRTyFLiXTaS7sywNWnAMwYJOHR/Do7pHzlf54qer5Q+C//3y1Tx7ESK
BFr23uJQvanJs8KbBw7AjThzI0bp3Kw7f3vsA4bP1oYSKWXIXX5O1VNYB8SvJLVl
6fTap3RT93pQ5NcCpf5mRGe7h3x1ifF6muekLpOhsRxEu0Qo1btiBkbhc1kg4/OK
iZNnQ/8gC7PngkCcYtf7cRVkE+BjUkpMTQBw3ujIs7TrmXRL+H3mTxnN4YlQDyot
d86ZzYjd+qIRiO7162MvUax2Ky2cELlSblo7Z4kHrf0Zn/mtNUadUkA7CS4v2F/U
2d6CbKjXOUE=
=qmAJ
-----END PGP SIGNATURE-----

--=-yvBhL6H7kiF9CEsJJ4Ad--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
