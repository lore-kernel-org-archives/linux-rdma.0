From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cma: Allow port reuse for rdma_id
Date: Thu, 5 Jan 2017 21:33:02 +0200
Message-ID: <20170105193302.GF15685@mtr-leonro.local>
References: <20170105141636.23284-1-leon@kernel.org>
 <20170105141636.23284-2-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0D7F68@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0D7F68-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2017 at 06:40:04PM +0000, Hefty, Sean wrote:
> > From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When allocating a port number for binding to a rdma_id, assuming the
> > allocation is not for a specific port, the rule is to allow only ports
> > that were not in use before by any other rdma_id.
> >
> > This condition is too strong to achieve the goal of a unique 5 tuple
> > rdma_id. Instead, we can compare current rdma_id with other rdma_id for
> > difference in one of destination port, source address and destination
> > address to allow port reuse.
> >
> > Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks Sean for your prompt response.
I truly appreciate it.

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhun20ACgkQ5GN7iDZy
WKcTnw/9E/p+A96N0HQa7W9ne5FBoVO3r+i1gc7+yAJxeYAXACuRVHxs+oUqBVAq
mW/akuKBsglUXg/uoq/v70iriOsPZqcRv3GYpobmuhtq/oqvwJVMlYz2OKVeFXsB
L4lu05Tr+K3l8du43HwWLF5P56H5VQob7c/kTXb3tT3Veeo6W6NkdDbBs5wOCAfz
d6oDISAlEQHj5M+9CcHoRpec+bqIoHqoAintCqXQPQxPYRexr8J5DjgCsUbvpkiS
NmhJSBqDYWl8Fr7GvK2aYdv98ECwR8Wx8BlaXQmC828U7Dxjn3iA+z8082Z5OPWu
hk1eIs9EUVcM9HV0BceZvczxgjBKc+vDqRTuXARjkiZTU60l7Ci3BMFSol/MtJLj
r1nn1jnjYl76WtQDnS0FuV5J9InSWUvj5zPZ+nkYqUxkn/DX93GvdOr2YBhF9kXY
EbdLpu2FrS1IcQL/mW26HtVVx3XTlnK2y4gGGh7DZxcVXPRVjJGICz70NDloKmWu
9jckuqj07HqCd1JTQjiRAcEQN4aypmLvb2C0FQv0kwHyrUk4Ytj78Ou1mrSWc4Te
+a2Q5DXmkt/ZN+oQZqv9nF2F5xItXOzkYi8IQ/NcamQhadyJY9f+tAEM+XvWRwZr
lBw48f2h4vLtoedeHvNrzmHm9komi7iSbZ0Rii55PnS+V4EZwnA=
=DZX2
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
