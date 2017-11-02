From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful
 container
Date: Thu, 2 Nov 2017 19:32:55 +0200
Message-ID: <20171102173255.GC16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-6-leon@kernel.org>
 <20171102170554.GO18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LgjTlQw5wen6foCl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102170554.GO18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LgjTlQw5wen6foCl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 11:05:54AM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 06:55:56PM +0200, Leon Romanovsky wrote:
> > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This will be compiled with GCC 7 coming with Ubuntu Artful
>
> Hurm. This point of this is to test the latest gcc, not just the GCC
> in a distro.
>
> We should be testing gcc-8 here, but it isn't available for
> trusty right now. :(
>
> Then the lines:
>
>       - ubuntu-toolchain-r-test
>
> and
>
>       - gcc-7
>
> Should be removed from the .travis.yml as well in this patch.

lib32gcc-7-dev depends on gcc-7 and it depends on
ubuntu-toolchain-r-test.

Thanks



>
> Jason

--LgjTlQw5wen6foCl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7VscACgkQ5GN7iDZy
WKdxiw/+PiMeFOezHoDgOB/6Y1P2Q5v1tzB1OuZpedSJdlCoYzj+OdgbD1bhh0f4
TV27na461KjScIJoh5h4/UvtY0hDDKsxOs8Kps7rJO/8Xf+TIT1LA+XMyqHF/BWL
/iOF9f/jTmW4bl1uZY9mYn8iWQig0M+mz4QvOEpnAsS3hkOscx4ONqPQfRdMbhCO
+ZIH+9raYUYd0+AE+hofYgTj38QkekYjStpsceHJLJpbI/XTXNG6OKmc9xjV/2Ko
8eK8kJvM7GZ5l3GE8aNq96zI6ilk4+mtJDzkfgw4hSQhbh5sixwtlWYDUWBAoPWI
ychqlnYcQXwOo+baOoRGzv5P0E8OLgc33DXKiAeIK7jDCEOLxMk38xpZy/3lyrwP
SSPtZDPDYIK6XLIDO66jj0sNe8GBbHT8GiAMS5W93LKHURvdX0bd7JAQhfrpY467
MjYtQwifmfFEJKYZAH9F7G9cOBhJAI3EzwDFu5OUpM5Uwxthywab7HJJAr/rJfAK
f6E34qiUGAK+gFayGNRyzS6W8hq0fys7TjIvtKjYayUO2Qp/Yyrl9R/szlRMrSQW
R6KkT1W9PSfIS2ngv0oC4rXtR0eOoyumPnay2myH769qycBK74uR4ZpHwHNKwy7p
y2wLsEfHl8LVdE7/+7Lh+Q2ko3uJ746fY6SV22sEkdLuxw8AAeg=
=ZSxe
-----END PGP SIGNATURE-----

--LgjTlQw5wen6foCl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
