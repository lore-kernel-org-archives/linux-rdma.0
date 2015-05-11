From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1] iw_cxgb4: Remove negative advice dmesg warnings
Date: Mon, 11 May 2015 16:25:13 -0400
Message-ID: <1431375913.2407.524.camel@redhat.com>
References: <1431389346-27880-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-N2uP507EOAlZW5iULn03"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431389346-27880-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-N2uP507EOAlZW5iULn03
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 05:39 +0530, Hariprasad Shenai wrote:
> Remove these log messages in favor of per-endpoint counters as well as
> device-global counters that can be inspected via debugfs.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c       | 27 ++++++++++++++++++---------
>  drivers/infiniband/hw/cxgb4/device.c   |  7 +++++++
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  7 +++++++
>  3 files changed, 32 insertions(+), 9 deletions(-)

This patch has already been accepted into Linus' kernel.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-N2uP507EOAlZW5iULn03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVURApAAoJELgmozMOVy/deacP/iqY5rCmmoOws0Ef/L0izwpj
lp4qUHOTqS0ka4aONU2nGKKPKs1sU43UWJ7UNTCpJ20lB2zLDwcCVXBZ/lzJs+E8
ia8lYcBz067+ZluKpeFlQ8vKJoNOWseSQMd3mH6/AKADepRcMdef1WRtfX5eTgqT
A5AoP/6p0x2DVsn7WKV8l3iBUWLDR2bg5OZ5nXIp01i72v5yITPDPSwe6vDGf9Bw
4h58VKcp9Nsw92J6UvVI7x1nagxAUedGm+3iAOMupuRuvaTJmIWa+KXsUy/LCyQ/
lMOqgCckQHan0IzO8P9j3DtKGHqhv5hwx/ok4ED4XZKh7k8Y1jVItlPSW5Cy+rF1
J4h5anPDNDQVySnkKsSgEa/1YdGu0SN69LmO7CsqS99EngeqN69lNjuik/jB1nQL
9819RAeMuA+y/pKPYcueMwN2JUbW4n2TBLtuKJTonIw/m3WyXUUjTTHzf+QB4os3
BF4HtGyyRr5WY2g8EO4FspuJ/CYPo/xzKWTwJ6+IckJrJ5mjn3Hu2/A+V1rgVAn9
gVu/8YaEsSUa0dTkKPLJCgWLSD0ANFKzXz+XMg+QlMDu8Ecm8MEKaCuBhtQorl/4
3MEnmqoDeUb8GPmUhAqBVIExqavOq5+w1pzEfgG4YJPAkw19O3WdtHo7Rs9dhCwK
AI9HUzVGHxnM1BbsA57w
=C8ro
-----END PGP SIGNATURE-----

--=-N2uP507EOAlZW5iULn03--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
