From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Tue, 1 Aug 2017 09:24:01 +0300
Message-ID: <20170801062401.GI13672@mtr-leonro.local>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
 <20170731164705.GB28204@obsidianresearch.com>
 <20170731165453.GD13672@mtr-leonro.local>
 <20170731170018.GA19061@obsidianresearch.com>
 <20170731170804.GE13672@mtr-leonro.local>
 <20170731172436.GA19375@obsidianresearch.com>
 <20170731173813.GH13672@mtr-leonro.local>
 <20170731174312.GA20133@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2nmUZS6EBFTGcnEV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731174312.GA20133-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2nmUZS6EBFTGcnEV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 11:43:12AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 31, 2017 at 08:38:13PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 31, 2017 at 11:24:36AM -0600, Jason Gunthorpe wrote:
> > > On Mon, Jul 31, 2017 at 08:08:04PM +0300, Leon Romanovsky wrote:
> > > > On Mon, Jul 31, 2017 at 11:00:18AM -0600, Jason Gunthorpe wrote:
> > > > > On Mon, Jul 31, 2017 at 07:54:53PM +0300, Leon Romanovsky wrote:
> > > > > > I want to take RDMA one step more,
> > > > > > https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
> > > > > >
> > > > > > I called the topic name "persistent", but the right name is "predictable".
> > > > >
> > > > > Once renaming is possible then having udev rework the names isn't a
> > > > > big step anymore.
> > > >
> > > > You need predictable starting point to perform automatic rename,
> > > > currently neither index, neither names are not.
> > >
> > > udev has all the information needed to produce the naming pattern in
> > > the link above.
> > >
> > > You'd end up with names like rdmap3s1f1 for instance.
> >
> > I'm not so convinced that udev scripts digging into various outputs
> > (lspci, e.t.c.) are better solution than kernel handles everything
> > exactly as netdev.
>
> I'm confused. You linked to PredictableNetworkInterfaceNames, which is
> entirely implemented by udev.

I linked to that article to save copy/paste of advantages of such scheme.

>
> The only kernel support for netdev is the ability to rename netdevs,
> everything else is done in userspace, by udev on modern systems.

I planned to take a deep look on the gaps prior to LPC, but in meanwhile, you
are right and it is done in udev since 197.

>
> The sooner we get the same kernel API for RDMA the better, I'd run it
> over rdma netlink I think.

Nice, I found who will present it :) Can you prepare short topic about it?

>
> Jason

--2nmUZS6EBFTGcnEV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAHoAACgkQ5GN7iDZy
WKdMgw//dwZUvaoNZ4JZBREeABfe2NgVav7j95kct+5ibqX5rIgdKr5gZhinFDnL
S+h/8vsMUZ85QjIL5vR/d6fPVXxVIVPAoHAAyVeLBoF7d/ze/AKicbCma5yXj9Pj
DQGjYvb9/X4+m/EWhS1QW0ZRoaaJh7QuajVDCnFif8loHSKOSKrWbnNbdrYBsMGm
jblNpGT7DpPbeGXnExzLAp0sXULy50rBwxzJiNXzgPJ//8MdafXoXrncandzCKEy
Z9ufeOUoOJKnz+bnsaPgqmk7X3Zut7N+yJsYwxd5/t/sQYN8O5EaULbt6fFlDZs6
al/FBwt5mgvAlhqnAVPDm3IeCY4BZUv/cUxUViQ0x7LAcjJmN8wEfhk4fAXAAWhB
jHNWJjkyT+3SasITUgQJrODZrZwbiyIU0arQstmkEFK/klBXG5e0/G+xEU1zWfa3
GpGUlj0qtRhII1Puls+UFlqmklfVGj6VC5/9bZz05N1zmnWNbCypU2xEQGxeMcsD
P6vPiXt0U43KepV/FGwgIusYHsPJvLWLdfPaI1nUVj7YfismTeBGW1U8dSCaIbW/
zcxESzSNkdAXZabkBtrqOua8w0JVh0JWN+p1vl4fIJ8vs5JaCkMu/AOZtc3nhPAI
rcTFmo1VT7ziNmfV/VEWd1KQhZ3Ggn4G1pXi66b+iCWAWhz91OM=
=uHJO
-----END PGP SIGNATURE-----

--2nmUZS6EBFTGcnEV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
