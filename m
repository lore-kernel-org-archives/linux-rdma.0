From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] debian/copyright: Add copyright information
Date: Wed, 4 Jan 2017 09:55:16 +0200
Message-ID: <20170104075516.GJ12077@mtr-leonro.local>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-4-leon@kernel.org>
 <20161229152537.GB30742@obsidianresearch.com>
 <20170101075433.GR26885@mtr-leonro.local>
 <20170102221123.GA10226@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2oox5VnwalALFvA7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170102221123.GA10226-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2oox5VnwalALFvA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2017 at 03:11:23PM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 01, 2017 at 09:54:33AM +0200, Leon Romanovsky wrote:
>
> > > > +License: GPL-2+ or BSD
> > >
> > > I think this should just be 'BSD', same with all the 'or' stanzas.
> >
> > I'm not a lawyer and in the rdma-core.spec it is "or".
>
> The or is fine in other places, but this exact place is before the
> license text itself. The license text stanzas should not have 'or'

Pushed again, together with general cleanup of that license file.

Thanks

>
> Jason

--2oox5VnwalALFvA7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhsqmQACgkQ5GN7iDZy
WKe1PA//XrIg3aZFMsV6QcwZjcsd3uTMRaMkrlzmgL06QqNqZE+JTR5bjO9ZjQZ9
WS65l6QUqr7YVbUk3F2huvl61ljt2eZaz62eLnuxLjcN5iOCeGc80jYNUcCIQCeK
K9tReReAFV4AuT93aawE7Jiyy2MaTvIm2X/uiJHikBuKGhk+EfX/Q4vrBIdA5v/8
3ccAZubaL9Lg2m6Ke/Z606RAz9SYWYzbKAo9L877/3v6tKFvMZ8N/hzFiFC0ULqp
GxHVC54ooCrZsLsA0f7Weu3B1ArVfq60HflB2JrlT5ixJYztcXJ6awd0j5j5mkiS
rQcI/ZtQQE0/fntbOhVT2iEYg61Hk2XsXCxJUCVu9je1xK7r0mnEO2VNJ0CCx4oD
By2tUXo97xkRmpKaEEeG1VlMJEsKX3UCenHiiySIn8bDGCARiBDmXQsdmaJlPWjO
a7aJ0armILOmzvMgO+xxZXfs12PAeRENdIASp99kjE7PtmlRnS6UIpo1V0PvfuKP
cbXA6kYFDP1rtyw7pbiBqTzSK2+rHLc1DMYRDucAQtxC9FBPy0l4NoUe7+Y/MhBx
dCvaFWLCu35Ja1w9c2KpvlikP8aVSeSVB1LRW1WU/XKGG+YWumhl8XzGBzkN3wIR
XDTQpnRHteXMQGu8asXobkmhA36ufjj9ReO/szpY1rcUkg7d1EY=
=tH1h
-----END PGP SIGNATURE-----

--2oox5VnwalALFvA7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
