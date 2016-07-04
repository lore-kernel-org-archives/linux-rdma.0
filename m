From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join
 flags
Date: Mon, 4 Jul 2016 07:51:11 +0300
Message-ID: <20160704045111.GA5289@leon.nu>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org>
 <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 03, 2016 at 04:46:23PM +0300, Or Gerlitz wrote:
> On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
>=20
> >  drivers/infiniband/core/cma.c    | 98 ++++++++++++++++++++++++++++++++=
+++++---
> >  drivers/infiniband/core/ucma.c   | 18 ++++++--
> >  include/rdma/ib_sa.h             |  5 ++
> >  include/rdma/rdma_cm.h           |  4 +-
> >  include/uapi/rdma/rdma_user_cm.h |  9 +++-
> >  5 files changed, 122 insertions(+), 12 deletions(-)
>=20
>=20
> For the ease/robustness of review for UAPI changes, we have a long
> time common practice
> to break things like this one to IB core kernel only patch, and one
> that deals the user-space

Or,
You are right, this practice exists and we are following it as much as it m=
akes sense.
This specific case doesn't need to be separated, because it introduces one =
logical
change and separate patches will be useless as standalone patches.

All properties which we are looking in the patch (correct logic, bisectable,
buildable and easy reviewable) exist in this patch.

> facing things (e.g here ucma.c and rdma_user_cm.h), please do that.

We will be happy to hear other feedback as well.

Thanks.

>=20
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXees/AAoJEORje4g2clinBuUQAITD8AzctywWikpRDzob/Srd
6J/NuCWdKcgAz3msahLh0+ds39fImRdI3dDFwfdAY7XirMe0ymKzeVbF+JgOIfvU
TOpSj1NIwlWaD87FJQJLrRnPVP0ojr5IpmedLtZSYDW5vPJyLCBkGNbksgTxWI8I
SQkXqWXSC0Tu9HQlJv/VNqxKRTfLwtUUCQJN0yrLWNdN9v8qGa/ypKK1wWL6p4iS
x4PwRujPHMKnMPMSn9d3QvudHjq9HZpOTKyHUNGv8VzJuH6I57lgex7cz/MZQkbr
/Rg/O5jWNe0RII7ZH7QPwLuWKpECr4XXOyVPV5nRMNKH4A0Vbr30nsgoN6QdeTKC
d11Ufyojor86lnGUZ8kWlj0cBOhtVY1ioJxk1gqSVqKaRCdtxcvOLrTua6C/X//p
ZjkKP3QlFQPJkzMvvOEH6cLEG2gpRdZ6ARsbN5y4/OY+gGHgyRQQiYKfhufH764s
W2YpvWsYKhwwI54KazLAeTOWX44p3k7z2CDSzGFOayOA+xz82hTfG4MEmmVsauLF
OdtBTRwoJ+b1Zk4cmJAWGwpGp2JdRDlZB0cVpPrqK9Hp+xuH/o/+5EAypQ+qVmul
UiHo9YKEmt9KJrYwL30gVBcfwNqkKSMJE0e52rirpl3mrtjAafTRAa9gYKO5Sfm5
U7XtkfUMOJhen+++Fxid
=Yx5Y
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
