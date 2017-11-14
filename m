From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 10:05:50 +0200
Message-ID: <20171114080550.GR18825@mtr-leonro.local>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="82sSsPTX2JCK/L1V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113192432.GL6918-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--82sSsPTX2JCK/L1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 13, 2017 at 12:24:32PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 13, 2017 at 04:40:24PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > CMA statistics were exposed to users through netlink interface long time
> > ago, but it wasn't exposed using netlink extensibility approach. The
> > current implementation was based on struct and not attributes.
> >
> > Let's remove it, before anyone is actually start to use it and prevents us
> > to write it properly.
>
> You should describe why you think it is safe to remove a uAPI from the
> kernel in the commit message.. When was it introduced? Why was a uAPI
> added with no users??

I didn't want to invest time before I actually see that it is possible.
The purpose of this RFC is to hear feedback and see if anyone cares enough
about that code.

The code was introduced a long time ago [1] as an attempt to provide
netstat-like information. It had simple demo application, which didn't
work for me, before I started to refactor ib_netlink.

Also latest fixes from Parav in the actual callback implementation support
my feelings that the kernel part is broken too.

Is it enough to proceed with the submission of actual patch?

Thanks

>
> Jason

--82sSsPTX2JCK/L1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKo94ACgkQ5GN7iDZy
WKctkg//XOEZO4oSPCxpBTQ1XhRCNJ9Dfb0Pc6fTBo7Aw3myo8Y13H9nO8CjI3Uf
WNpqBGP/PnrD0lK8IyUhaSr16bx5SVyDrsQgb0MX11QULIYqak+LiywctjIi8img
q+p4JAWqKzIQje/UmC9BGkS+4WMLG4Akw5at9Z1KxhAU+NNI+HttfdGwNFff2LvT
qVEUFKoQ71IRKDfGvMB7eR6EwZVzgNGHJx5eUYHfEAq8WTx198yCf/Vgg+dJrwBw
Hstzh/ayVS/cC1Nh39PoC1gHz24krmKTeOFInnHECzcuS5zey9mZoKeMypo4vU3r
Jf+LeUCE8E1nOsmmhz1WpXza2zkzoFg/jzT1PgJs4SGo1rbQtQpiryfgQb5yY+Wu
ucKmLZXfkQlOGcVTgRCekETRIODsUKxw4YKm5PE3DfKyPU/tDc3dciLCZMMg6ChH
Z860Ym43CyCDlNuBAY0+UEIAOAfdxBsYEZuQ8ZcI2fWIkLFEwRo6cexQBIwUxdee
kZXtgi1EPPt0nF937BiXitqIGo/EsDN5QHHdsd/YjGdZILJxKTxBE48OskQHtQwF
XJWNYMxXIXQNe0mNP+AR7L89ek6b3H22uY8/PWlstuX+tJc6DBwY82VLXngyfbzE
frQ07rw/0um/bKVNZGdn//YfWG1TXFkSOBJRv5C3mowPgEjT1ng=
=5EIo
-----END PGP SIGNATURE-----

--82sSsPTX2JCK/L1V--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
