From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to
 connected
Date: Mon, 08 Jun 2015 17:04:42 -0400
Message-ID: <1433797482.90034.2.camel@redhat.com>
References: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
	 <20150608164224.GA2499@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-DfefRr7x1hXNWyW6QXP1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608164224.GA2499-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-DfefRr7x1hXNWyW6QXP1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-06-08 at 10:42 -0600, Jason Gunthorpe wrote:
> On Sun, Jun 07, 2015 at 01:36:11PM +0300, Erez Shitrit wrote:
> >=20
> > When switching between modes (datagram / connected) change the MTU
> > accordingly.
> > datagram mode up to 4K, connected mode up to (64K - 0x10).
>=20
> Is this a bug fix (describe the user visible impact)? Should it go to
> -stable? Add a Fixes: line?

I'm not sure I would call it a bug.  Setting the MTU to max
automatically is a policy decision more than anything else.  Currently,
you have to enable connected mode, then set the MTU.  Both initscripts
and NetworkManager do this for you on Red Hat, so the user sees no
difference here.  I can't speak to other OSes.  I'm OK with setting
connected mode MTU to max by default once we get the scatter/gather
support for IPoIB added.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-DfefRr7x1hXNWyW6QXP1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVdgNqAAoJELgmozMOVy/d3ucP/0pHsyP0P+xpYvIUBsR6OPdY
ecmCxO3BHABWWnTX3Rfqp89sF37smAOdBlj+Gqo2DqTfCRLQxCeXJWy4NCET/scL
FPM/MS5YJGvl9JtgT/mgEv0l+u12OkKv7kHaq7ZtPLyoC4Zc9L6hduVxUva9ag0c
cCplB9yL/Vej2cdTZm1Z5mvVZL3Ftq3kft4+aFIBdVg5WLcHeCNdq008l4LsGGR8
++WbVvinMNvRXfJoqrkZD1iJXZcufbYeeyuGpBy510nY5ogRUchi8zB8bp5qk+Aw
SnD0j9BMi8mQiWLanFg1CQPaiRaDR34P/JsM2O/fD29yCxWd11ADce6tNIVOJ0OE
mmmYnNZg9EMvPwM0XfIp1hvIM9Xz3eEOhHb8LxdF5x5rJ6aYsospgNAU9kES+d2L
UTl2c65+GTfgkmakJHuVirCyNfov3pmVOmeZiMjQpRUu5IxVz7jkGQZ+Bs7PZNHq
04fXStpgIouXZfl86k7P0Nd1msMMCyzWg0CqOaEJI7M/dLJQjb4pP/aP8T6HWQZX
Z/v6h8wl9VlXhHLZv97Yup7HHmdXlgzk65RwHOmg/7Kb4aaiZJytpnqncmCbFHDz
zcoLO74Mo/4bsjogx4PCVIBAGIzYPsjJp2VALiMblZfGMzzk6opcPaWpOUOSZNNu
8atEQ+bCzm0WGp2/sBrX
=KJqF
-----END PGP SIGNATURE-----

--=-DfefRr7x1hXNWyW6QXP1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
