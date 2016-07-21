From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V2 1/8] RDMA/core: Export RDMA IOCTL declarations
Date: Thu, 21 Jul 2016 13:49:05 +0300
Message-ID: <20160721104905.GV20674@leon.nu>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-2-git-send-email-matanb@mellanox.com>
 <20160721080719.GB21060@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iJhwK4DKf9Unwzgv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160721080719.GB21060-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--iJhwK4DKf9Unwzgv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2016 at 01:07:19AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 19, 2016 at 06:23:25PM +0300, Matan Barak wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > Place all external RDMA IOCTL declarations into one UAPI exported
> > header file and move all legacy MAD commands to that file.
>=20
> FYI, we also need to have all the structures used for the UAPI in
> a uapi header.  I started on that a while ago, but it needs to be
> resurrected.  Given that you're busy in this area it might be a good
> idea if you pick this work up:
>=20
> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-uapi
>=20
> > +#ifndef RDMA_IOCTL_H
> > +#define RDMA_IOCTL_H
> > +
> > +#include <rdma/rdma_user_ioctl.h>
> > +
> > +#endif /* RDMA_IOCTL_H */
>=20
> What's the point of this wrappers?  Either way no need to include
> guards for a no-op header if it will be kept around for some reason.

I dropped this file, it is not needed.

>=20
> > +/*
> > + * For hfi1 driver
> > + */
> > +#define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
> > +
> > +/* Legacy part
> > + * !!!! NOTE: It uses the same command index as VERBS
> > + */
>=20
> In that case it should be in the same header just to avoid confusion.

I prepared proper series for this stuff and will send next week.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--iJhwK4DKf9Unwzgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXkKihAAoJEORje4g2clinQaIQAK+wu94b4XuS9NOQl/48PlJ0
+FcW6DSwt5sohM/oHfDhsRuCUB0TD5I3gK6v5+d2R+h+RNUiSMTmd74/zIZ59zN8
zEwSD74MtEaSgmD5h47Tg8CX8qfC9U48zTI8DuJR3ZnqAdtTBNGxe/pZFC1wcq5m
g5PaOcANFBRa2cRU+uP05qazNdycvVeAhqu3HIg99lOAoRbLrQC0/BUxrSK4ueWF
DkhP2EZLk9rIT9H4o0RFrh7WuRy3rX8ZDC1tm5P7f8VoOn1oBypCm/8gwjXCS8d8
QiIbM7ju8XkXZ+aOZG1Gc0GHpNLysphj8UBUrO1n82G1+DzaxN9HiLUOwUofaqBy
Z2WKyjd8rFHx3Fdet6bcOPYOHbGghJl/f7UggW41hVWeG2wVmcMpKg2aXaimDUKs
EH1UTOrU6+UY/5HOC52oO5W1eOgElITah/iTHfKmpWmWu8OYf8+3zClanZhFK6c6
K/2PeyxvI5E1sdT9y8EdI5WzlcGn2GpT2aTybj1oQXHA9OFueS73mT2lxAUjZGXO
k8Hs/9vnVM3BacPLxmsExfYy84bUDtdv5VSDdnSRmStJC3cZbGpW6deGpmS45RXs
98tr0Vci8a0m0XClL63mCN7noDCd5VaGrcH9j3X/Ci7apbRjM0YkVgkeSVrvOQSG
YbswTo17pYWI3i0cSXNy
=Yp9m
-----END PGP SIGNATURE-----

--iJhwK4DKf9Unwzgv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
