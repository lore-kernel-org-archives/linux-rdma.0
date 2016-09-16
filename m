From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/13] IB/rdmavt/qib/hfi1/core: First round for
 4.9
Date: Fri, 16 Sep 2016 14:32:25 -0400
Message-ID: <ebebc615-6b72-c9f7-5e58-14a12c767cab@redhat.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rkrFGVofnAJNNTho5s5XmmfMumrxXi4ji"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rkrFGVofnAJNNTho5s5XmmfMumrxXi4ji
Content-Type: multipart/mixed; boundary="QE4rNk340tVui885X3cvrI7PFCd61cLEo";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt
 <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <ebebc615-6b72-c9f7-5e58-14a12c767cab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/13] IB/rdmavt/qib/hfi1/core: First round for
 4.9
References: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--QE4rNk340tVui885X3cvrI7PFCd61cLEo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/6/2016 7:33 AM, Dennis Dalessandro wrote:
> Doug,
>=20
> Here are a handful of fixes that we didn't think were fitting for the R=
C release
> so we are submitting these for 4.9. Note there is a change to the core =
here but
> it is pretty harmless. There are also some improvements to rdmavt.
>=20
> This applies on the last set of fixes I sent out for RC and can be seen=
 in my
> git tree:
>=20
> https://github.com/ddalessa/kernel/tree/for-4.9
>=20
> ---
>=20
> Dean Luick (1):
>       IB/hfi1: Move serdes tune inside link start function
>=20
> Harish Chegondi (1):
>       IB/hfi1: Fix the count of user packets submitted to an SDMA engin=
e
>=20
> Mike Marciniszyn (9):
>       IB/rdmavt: Add functions to get and release QP references
>       IB/rdmavt,IB/qib,IB/hfi1: Use new QP put get routines
>       IB/core: Add ib headers for general use
>       IB/qib,IB/hfi: Use core common header file
>       IB/rdmavt: Correct sparse annotation
>       IB/hfi1: Move iowait_init() to priv allocate
>       IB/rdmavt: Move reset calldown to reset path
>       IB/rdmavt: Add qp init function
>       IB/rdmavt,IB/hfi1: Add lockdep asserts for lock debug
>=20
> Tadeusz Struk (1):
>       IB/hfi1: Fix locking scheme for affinity settings
>=20
> Tymoteusz Kielan (1):
>       IB/hfi1: Fix user-space buffers mapping with IOMMU enabled
>=20
>=20
>  drivers/infiniband/hw/hfi1/affinity.c     |   91 ++++++++-------
>  drivers/infiniband/hw/hfi1/affinity.h     |    3=20
>  drivers/infiniband/hw/hfi1/chip.c         |   40 +++----
>  drivers/infiniband/hw/hfi1/chip.h         |    2=20
>  drivers/infiniband/hw/hfi1/common.h       |    8 -
>  drivers/infiniband/hw/hfi1/driver.c       |   35 +++---
>  drivers/infiniband/hw/hfi1/file_ops.c     |   41 +++++--
>  drivers/infiniband/hw/hfi1/hfi.h          |   17 +--
>  drivers/infiniband/hw/hfi1/init.c         |   44 ++++---
>  drivers/infiniband/hw/hfi1/mad.c          |    1=20
>  drivers/infiniband/hw/hfi1/pio.c          |   20 ++-
>  drivers/infiniband/hw/hfi1/pio.h          |    2=20
>  drivers/infiniband/hw/hfi1/qp.c           |   33 +++--
>  drivers/infiniband/hw/hfi1/rc.c           |  113 ++++++++++--------
>  drivers/infiniband/hw/hfi1/ruc.c          |    4 -
>  drivers/infiniband/hw/hfi1/sdma.c         |   24 ++--
>  drivers/infiniband/hw/hfi1/sdma.h         |    3=20
>  drivers/infiniband/hw/hfi1/trace.c        |   27 +---
>  drivers/infiniband/hw/hfi1/trace_ctxts.h  |   13 +-
>  drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   14 +-
>  drivers/infiniband/hw/hfi1/trace_rx.h     |    4 -
>  drivers/infiniband/hw/hfi1/uc.c           |    6 -
>  drivers/infiniband/hw/hfi1/ud.c           |   12 +-
>  drivers/infiniband/hw/hfi1/user_sdma.c    |   31 ++---
>  drivers/infiniband/hw/hfi1/verbs.c        |   18 +--
>  drivers/infiniband/hw/hfi1/verbs.h        |   90 +--------------
>  drivers/infiniband/hw/hfi1/verbs_txreq.c  |    2=20
>  drivers/infiniband/hw/qib/qib.h           |    1=20
>  drivers/infiniband/hw/qib/qib_driver.c    |    7 -
>  drivers/infiniband/hw/qib/qib_iba7322.c   |    2=20
>  drivers/infiniband/hw/qib/qib_rc.c        |   73 +++++-------
>  drivers/infiniband/hw/qib/qib_ruc.c       |    4 -
>  drivers/infiniband/hw/qib/qib_uc.c        |    6 -
>  drivers/infiniband/hw/qib/qib_ud.c        |    6 -
>  drivers/infiniband/hw/qib/qib_verbs.c     |   14 +-
>  drivers/infiniband/hw/qib/qib_verbs.h     |   94 ++-------------
>  drivers/infiniband/sw/rdmavt/qp.c         |  117 +++++++++++--------
>  include/rdma/ib_hdrs.h                    |  178 +++++++++++++++++++++=
++++++++
>  include/rdma/rdmavt_qp.h                  |   19 +++
>  39 files changed, 643 insertions(+), 576 deletions(-)
>  create mode 100644 include/rdma/ib_hdrs.h
>=20
> --
> -Denny
>=20

Thanks Denny, I've started an hfi1 branch and these are now in for 4.9.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--QE4rNk340tVui885X3cvrI7PFCd61cLEo--

--rkrFGVofnAJNNTho5s5XmmfMumrxXi4ji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3Dq5AAoJELgmozMOVy/dsHwP+wT4y5cptEumEMFakSAOU9eH
B00rIpPu8CDuNfUoNUwnNmvm/0ghUrWm0gAGsaqpu7qxjaMq+FHDomkUX6/xgWra
GlKL2Z3htrBDtPjimOM+HHnhyJdrN4Zbct5DPOjzG5J0vfAW6akRgcLCwSgS+vE9
xFm4CcmqeLavT9GIxOUo+mdqgvvxL8uk0a/VlYxJ2Zhg99Bdvim71TDMOOCFx7NX
svgWzRzubIcZWhat2skwubeCgEtveqtmrfDRkXIJJaosMugNn3Jngy6WEzOZft0a
vpI4JaIV9I2ar0ViZnjeTBQDG+IqM0SVv/NCZ9LHz105L3q00SNz5mXZ3XZ0chQk
US/BgBz+wi+01FRbv68PQj1oZcMD0+VkDNZN6IHsDSOPwTKcYP6LdlNwpr8lYbYv
KnOuN3b5ktxn0lVY5/KjKhpuZ7hPb4r8LD4V35XhtAPQ8iiTnrkLxrXp3mOzHTN2
NxKRLwGGh4ODMQGAZALo0LqdNIzqpHjvW0DznuONlBW2LBX3vwqQ8QC6bTp90LP9
H/ot1nTwxrirucFH4id7LsAJB3pWWrhyPG8MOc8PePaAK1gqZFJTtw5xTQJv7tcv
PkPkp//fRf2xK4PehttMQkKqCDEFtfVGg0G10eR3s4W9J05MT2ShoboUZLrJh/9S
DU5IEN5o6XHZHKNw0Su8
=9P0s
-----END PGP SIGNATURE-----

--rkrFGVofnAJNNTho5s5XmmfMumrxXi4ji--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
