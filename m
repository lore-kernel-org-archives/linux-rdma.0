From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/hfi1: More fixes for 4.7 rc
Date: Thu, 23 Jun 2016 10:16:49 -0400
Message-ID: <7fb7f1f5-a3f7-5d59-3665-7a50d0c6b021@redhat.com>
References: <20160618021550.31540.57897.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9LQHvxdqmxXEhblUf8iUGohRmoalv5d1t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160618021550.31540.57897.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9LQHvxdqmxXEhblUf8iUGohRmoalv5d1t
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 10:17 PM, Dennis Dalessandro wrote:
> Doug, here are two more RC fixes that we would like to see landed in 4.=
7
> if possible, including one which is marked as stable.
>=20
> Patches apply on your k.o/for-4.7-rc tree ontop of the last batch of RC=
 fixes
> which you just picked up.
>=20
> Patches can also be viewed in my repo and have passed 0day builds:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Ashutosh Dixit (1):
>       IB/hfi1: Don't zero out qp->s_ack_queue in rvt_reset_qp
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Fix deadlock with txreq allocation slow path
>=20
>=20
>  drivers/infiniband/hw/hfi1/verbs_txreq.c |    4 +---
>  drivers/infiniband/hw/hfi1/verbs_txreq.h |    1 +
>  drivers/infiniband/sw/rdmavt/qp.c        |    6 ------
>  3 files changed, 2 insertions(+), 9 deletions(-)
>=20
> --
> -Denny
>=20

Hi Dennis, this series has been applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--9LQHvxdqmxXEhblUf8iUGohRmoalv5d1t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa+9RAAoJELgmozMOVy/dsVYQAIfEm2RvFm3zaPlDjwlbAUeG
o6oUp+SaUw0Zl9BJLIP1oKREskSvduDUNVCc82MULL0SszTH+nd+XhXSuBFwrlSw
m87HrCNw7kqYKK1vBY92Tjiyb4TuZaGTkkviMqMV5htKiUN1RjCuhQS0UNe2EqIU
0pJE+Nie2yho7RsUQ9z1NJY6oDL2TYYVqYh+8C1AxGKypb45BqZfj98g1BpqYkfe
CRT6Kp08aL7xi9sCwJ/7p4rl6jzL7M6Tj3HNRRMYFAm8jX3/X6j4KMT1XgUfgpZ9
eR1KQkQDaLDrKbHWqOTYGmFaaGLcB9W0UgybqoIUJj9FCYa9m22Ce3O3YOgXt7cD
2YdHQbzvVu42teTIoCagaPRcS96rldGpQt+nGZ/Rp71QGDtC0FnTSeCSpZIyUJLG
A4Wj7H0SQnm7V7jxlcc0c5IvAKgjEzuO1a5vqhG3hMYuXX5xSvqgBhRAlQxNFdcf
dp5PnCf9ZK9sotf/qVmpo253pKiRC6SZJSfYcuAF37IBrH5p72DayCyTFAHnJSsy
30peaTmYR63JsYCOK/hL/hOcmF+b/wLn5vysOuQeW5YXb+jttAI8/0ThJvtb5ltc
QIgW3IP6IrBg1fCiQOdosStE2cc/IZvmn2Ox8f8zvIzWPwPpHLF3DpJozgiNCsEW
753XnGX38NYVUEHFfQCU
=DcIB
-----END PGP SIGNATURE-----

--9LQHvxdqmxXEhblUf8iUGohRmoalv5d1t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
