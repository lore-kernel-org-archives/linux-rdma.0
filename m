From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Fri, 13 Jan 2017 17:08:24 +0200
Message-ID: <20170113150824.GQ20392@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <20170112201622.GA14584@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dT+85zccSFkyJC53"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170112201622.GA14584-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--dT+85zccSFkyJC53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 12, 2017 at 01:16:22PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 09:35:08PM +0200, Leon Romanovsky wrote:
>
> > > > In datagram mode, the IB UD (Unreliable Datagram) transport is used
> > > > so the MTU of the interface is equal to the IB L2 MTU minus the
> > > > IPoIB encapsulation header. Any request to change the MTU value
> > > > above the maximum range will change the MTU to the max allowed, but
> > > > will not show any warning message. An ipoib_warn is issued in such
> > > > cases, letting the user know that even though the value is legal,
> > > > it can't be currently applied.
>
> How does RC mode work then?

RC mode doesn't have limitation on MTU size and it allows messages
larger than IB link-layer MTU.

>
> > Second, I have a different view from you on the issue. User configured
> > some value, which is not correct for IPoIB. In ideal world (without legacy),
> > we were supposed to return error to him with proper message, but in our
> > case (legacy applications) we can't (we tried and it broke some legacy
> > ifcongfig, if I remember well). So it leaves us with one available
> > option is to warn user about improper value.
>
> This is a legitimate configuration though, the user could have a mixed
> MTU fabric and rely on path MTU discovery, so sets the MTU to the
> largest.
>
> AFAIK the way to handle such configurations is with a multicast route that
> has a reduced mtu.

Multicast traffic is sent in datagram mode hence the limit will imply.

Maybe, I went too far by calling it error, but IMHO absence of indication to
user of decreased MTU is not good either.

>
> Jason

--dT+85zccSFkyJC53
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh47WgACgkQ5GN7iDZy
WKeXJw//WxN7xdEIlRqkfo7DNVbVvWZPV7qWBhhu1Ei03NTChJM/zw0KdhBFD5Id
LI4Uhot2+ddUigC4TsuUI+YgFM92lEXw98XrmWY5nnhzRDR5yM4b/Qy0r7F/duMU
l9gV5J9nP5or1DT8Zs0EfHiDAcS0u5TEbDSjo67SXXbTnAnQVxPny3rPfduAH05l
FuEznTnhjzoW8Sz0qdD39ge7AkpRy6BDe6+IOQf27BvynrMZsKEddsZ2o9mq/6K4
e9ST6rrOD8jPy6VzOLtoSL08hQalL6cKtbaGODRdMHeZ8A6OB09ECcXJsfduZNKD
QqgwV3WS6fqzKXoMTtG1rbGyoioJ/UI/4EMif/5LLLbXtNhRlPhBeIaAXGd3PdXa
Ez1zAhRqlMNXyQCNWdmkjhm7h/a15XSy0YD0/NBtcVIyXHbe8WcaidjPmoUIjc9v
Vwr5oQsP3KB1qrX01VcZlSgDcVKmKLO7xg/XUQArtYpABkbhRHNNaOCZQKS7Ekpu
LKAEHMNuxyKIhk2ZLqvLCi3Unp6h/HybE6TRzytdfJhdJR5BdGLRopFtCRN5SDgX
vld3aP/cdKGoWEt4hupUy/8vBv2CdbUsD1qhkYHTZYsmUmL+KlTbj2b6+K3HswHy
bYixunTSEoG4x0QxbZG/FgJ8GcjfMERXzXGevZUDPwi3UhN35jY=
=FMpW
-----END PGP SIGNATURE-----

--dT+85zccSFkyJC53--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
