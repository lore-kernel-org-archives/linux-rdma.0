From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] debian/copyright: Add copyright information
Date: Thu, 5 Jan 2017 08:14:36 +0200
Message-ID: <20170105061436.GW12077@mtr-leonro.local>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-4-leon@kernel.org>
 <20161229152537.GB30742@obsidianresearch.com>
 <20170101075433.GR26885@mtr-leonro.local>
 <20170102221123.GA10226@obsidianresearch.com>
 <20170104075516.GJ12077@mtr-leonro.local>
 <20170104224227.GA15569@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mvuFargmsA+C2jC8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170104224227.GA15569-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mvuFargmsA+C2jC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 04, 2017 at 03:42:27PM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 04, 2017 at 09:55:16AM +0200, Leon Romanovsky wrote:
> > On Mon, Jan 02, 2017 at 03:11:23PM -0700, Jason Gunthorpe wrote:
> > > On Sun, Jan 01, 2017 at 09:54:33AM +0200, Leon Romanovsky wrote:
> > >
> > > > > > +License: GPL-2+ or BSD
> > > > >
> > > > > I think this should just be 'BSD', same with all the 'or' stanzas.
> > > >
> > > > I'm not a lawyer and in the rdma-core.spec it is "or".
> > >
> > > The or is fine in other places, but this exact place is before the
> > > license text itself. The license text stanzas should not have 'or'
> >
> > Pushed again, together with general cleanup of that license file.
>
> I added a few notes on mistakes on github - this seems too haphazard
> to me, I'd rather see a script produce it by inspecting the source
> files. :\

First version was produced by such script and following changes were
my manual cleanup of mess from it.

>
> This format of Debian's is truly painful to produce correctly.
>
> Jason

--mvuFargmsA+C2jC8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlht5EsACgkQ5GN7iDZy
WKfZsg//VQEM8j463vMRVs4iT3ITGO+Nk1sChxk0oQG5qB6NjHFdVYU+FS4rj53v
8/bc+FTF4/DmOJGve+SAl2JENyg8Oi9+lXPauYROlVMyAG/hxHe2tr01R/bVWvyP
ygf23Nw6LmRf5I9709zWStndHiP3CCXVzdjTOX1Q1HUM8ifwA+M2tKJpCX4FtCTZ
Q2lmCnSLhU7wzzPK0VoCjTGCHXlAkhX2ym8jrKSqq2qLHpitJl8riZ7tQS+2A7UZ
n7q4Pd5QifG0wlqAeKdYf0ZrE/QarkGYTUrFiCMhjeHEHPrXE+Yn1xW/Qz1b8zf3
6p+dyzAAZz6LytOtkDODTVY8hx1j8juTCdRE6ddfyefqzwF66LsDjfayYzd0hxYT
kW0dAYvmaKp6ateAND5kOQ/FyRETbPCyCr6cxHEZeD3j2h9IcTG4jR3L+k3uYF+K
6kFmbjNXsbWsogH/Xfp955njSmVrd2BUaXjBqKedr7jslLHUIM+qKlIkfX6QZtaF
rq+7WoSGXe+eKAGmXGDgSZl0dK4V9AZZIMBcPMQQHJ7ox7vNmiTuFfGz3MTVLX+k
tvy5Nk7hMy7+a65UleWfzgdvruzb0nnIu90C1oYN40G/rSFl/yJa7X2raEkkCMRH
YREd3zbNvq/wod0rgXo6D1GZ7urgt/5sHEykTPIoX6pC7tZu/24=
=36M+
-----END PGP SIGNATURE-----

--mvuFargmsA+C2jC8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
