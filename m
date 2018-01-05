From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/11] IB/hfi1, rdmavt, qib: Driver updates for
 12/18/2017
Date: Fri, 05 Jan 2018 13:36:54 -0500
Message-ID: <1515177414.3403.30.camel@redhat.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gtoaOwcI2ZG5gh0Luqm1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219034753.2126.78386.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-gtoaOwcI2ZG5gh0Luqm1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-12-18 at 19:56 -0800, Dennis Dalessandro wrote:
> Hi Jason and Doug,
>=20
> Here is another set of patches to land fdor 4.16. Just driver changes and=
 a
> small change for the MAINTIANERS file. We are getting rid of that ipath e=
mail
> and ensuring Mike and I both receive direct mails for all our drivers ins=
tead.
>=20
> https://github.com/ddalessa/kernel/tree/for-4.16
>=20
> ---
>=20
> Dennis Dalessandro (2):
>       IB/hfi1: Check return value of strchr before using it
>       rdma: Update maintainer contact for Intel RDMA drivers
>=20
> Kaike Wan (2):
>       IB/rdmavt: No need to cancel RNRNAK retry timer when it is running
>       IB/rdmavt: Add trace for RNRNAK timer
>=20
> Michael J. Ruhl (3):
>       IB/{rdmavt,hfi1,qib}: Self determine driver name
>       IB/{rdmavt,hfi1,qib}: Remove get_card_name() downcall
>       IB/{hfi1,qib}: Fix a concurrency issue with device name in logging
>=20
> Mike Marciniszyn (2):
>       IB/rdmavt: Use correct numa node for SRQ allocation
>       IB/rdmavt: Allocate CQ memory on the correct node
>=20
> Patel Jay P (1):
>       IB/hfi1: Destroy link_wq workqueue after free_irq()
>=20
> Sebastian Sanchez (1):
>       IB/hfi1: Fix infinite loop in 8051 command error path
>=20
>=20
>  MAINTAINERS                             |    4 +
>  drivers/infiniband/hw/hfi1/chip.c       |   98 +++++++++++++------------=
------
>  drivers/infiniband/hw/hfi1/chip.h       |    2 -
>  drivers/infiniband/hw/hfi1/driver.c     |   16 -----
>  drivers/infiniband/hw/hfi1/firmware.c   |   64 +++++---------------
>  drivers/infiniband/hw/hfi1/hfi.h        |   27 +++++----
>  drivers/infiniband/hw/hfi1/init.c       |   33 ++++++++--
>  drivers/infiniband/hw/hfi1/verbs.c      |   10 ++-
>  drivers/infiniband/hw/qib/qib.h         |    8 +--
>  drivers/infiniband/hw/qib/qib_driver.c  |   16 -----
>  drivers/infiniband/hw/qib/qib_eeprom.c  |    3 -
>  drivers/infiniband/hw/qib/qib_init.c    |    2 +
>  drivers/infiniband/hw/qib/qib_verbs.c   |    2 -
>  drivers/infiniband/sw/rdmavt/cq.c       |   10 ++-
>  drivers/infiniband/sw/rdmavt/qp.c       |    9 +--
>  drivers/infiniband/sw/rdmavt/srq.c      |   16 +++--
>  drivers/infiniband/sw/rdmavt/trace.h    |    4 +
>  drivers/infiniband/sw/rdmavt/trace_qp.h |   42 +++++++++++++
>  drivers/infiniband/sw/rdmavt/vt.c       |    1=20
>  drivers/infiniband/sw/rdmavt/vt.h       |    6 +-
>  include/rdma/rdma_vt.h                  |   31 ++++++++--
>  21 files changed, 204 insertions(+), 200 deletions(-)

Hi Denny,

I went through this series.  Patch 1 had already been dropped.  I
dropped patch 2 as deferred in lieu of a better patch.  Jason had
already taken patch 9.  Patch 8 was the only one with outstanding
comments, and it was just a formatting issue.  So, I took patches 3-8
and 10-11, fixed up the formatting in patch 7 myself, and these are now
applied.  Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-gtoaOwcI2ZG5gh0Luqm1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPxcYACgkQuCajMw5X
L90MnxAArLZjK5yXfFvdcyfZ/86oDoR/uMAk1bcmNQH7YKZVZPA88H7GWiRCW2lD
qGJVLrx/oSdSo4oiUQRk+WkZSbm9xKkeCUubSmqi8yBlxnsO2bmhmyE19t6Th1Kf
GIlXINLcQ9mqkJ3x+tW396AUP8tFjwMEUxpgyS8dDcoXk/WiEGKWuRhpf1EZVJhw
io4HorrdZwo5JXm1q8oeItWHN9pkjBWO3zpRzeBNepI+RFTC+YmkjvYvxScFuPqM
Q0MH57GA4S06ibLXiHvIvLmStZ95aASMuVyx7QofN2rA21a1pGFsDdz1hypEnzpi
I+fXeUJbi3AxweakOLOcWp1Jjpwz2WDK77jWCGrX9ZaA19++Eo0qyYb7WtkuKOpk
gnA4KAQLkibBItX+a3zRWvpORkugIIgOechQfnP1WTB6aV7IETRgfBEgVvOWnptI
0dpPs+7dtyzMuoagFFIBzv1si10/trKl1CO1J/AYHc7ozDKS3fD5eTcbEzWXU96U
PjS4dwnqc9ueCcB+1rSoi5rpVMAaG8fiIxHR+9V1xjKYstNa1v+RJS7vt1R8k8ux
OS9yfB4gebe8NyOEitlBcS64QBF7DxzZdevqDhsTaMFDrdhgvwEc3w/y/F+UJwDo
TERE74J5i1A/d/h2D9O5fM4co6uT+AF8hkhIzRvylF9amHbQnOA=
=YB5k
-----END PGP SIGNATURE-----

--=-gtoaOwcI2ZG5gh0Luqm1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
