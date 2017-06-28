From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] RDMA/netlink: Advertise IB subnet prefix
Date: Wed, 28 Jun 2017 19:21:42 +0300
Message-ID: <20170628162142.GL1248@mtr-leonro.local>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-3-leon@kernel.org>
 <20170628160251.GB14375@obsidianresearch.com>
 <20170628161020.GI1248@mtr-leonro.local>
 <20170628161236.GC28839@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BX5bBAwwbKvz0cyO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628161236.GC28839-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BX5bBAwwbKvz0cyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:12:36AM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 28, 2017 at 07:10:20PM +0300, Leon Romanovsky wrote:
> > > Since the GUID is in host order I recommend making the subnet_prefix
> > > in host order too.
> > >
> > > At the very least, the comments beside anything not in host order
> > > should be 'be64' not u64
> >
> > Those comments represent netlink types. It doesn't have be64.
>
> Then don't send b64 down netlink as a netlink u64 type?

Agree, conversion to u64 is the right way to do.

>
> Jason

--BX5bBAwwbKvz0cyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllT15YACgkQ5GN7iDZy
WKcinxAAmSQQEbIMvRXElVSWkmwvYbKlBJ7TtF0G3+x/DJhRo7zdCpoRYQYhUcUC
r0/3yPh9cPOo1jfjAvZ7tCftyGaeOJTuBYFcoHsFuTYHy2zMqGLD4IhPiIL4a0Tl
oL31cT33yg5TBgiQTGwoy+kiyZOmMxh/OEkY/n9WsAmKL4WEbjJOYLe/SMn8xVhy
/QHcqMeBjt0wIHIAHBHdjTFTZbPH2mp8K28vboUF8OYoX5M0O4TcjTbzcRQ8QJH6
btihgLGiaAaUSsJfNlgOujv7sq/EV/qGbU9FTqdXelB2KhuB6Vg/6Skyl3smpDR1
1IGAwqr6IR8GhFz3qatAHhdldGAAeFzSepRhFdUQmoIfmQDNIOlO0HjKKXLahHj7
ifMwGTJkKU191AAvu0/kusanUzq9l9rq+D49ILTHamEYMTkM0Z3c+k9g4sp+qzEF
gHT63rlrB6ivtHqGbOLrLANZDpSyqdUbY7DUStAs+htjrM93qc6lqyRbk06qPwpD
fqOXFG4FVM3qP0KjOa+Mgq2Rwx/6MPm/YJZq2TL3oDMKEXxydsuEU1QY/k2QTPWX
F8GWS5mkBQOGNyXr90lFPbMlilRnFaqgqngHRY2mMIIPXIy1y+e03GeAV4GJDpNe
N6GO8kQl/XIZNwOI43DScUqrHmgSggEPKIaeLhg/7y0+ToQwCKY=
=Ij/0
-----END PGP SIGNATURE-----

--BX5bBAwwbKvz0cyO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
