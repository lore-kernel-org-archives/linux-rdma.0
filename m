From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/hfi1: For 4.8 rc 5
Date: Fri, 2 Sep 2016 14:33:58 -0400
Message-ID: <8fde07d2-2bdf-f5d7-2599-f13a8d9dd942@redhat.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ruNN59a7gM2bnkHJNPllNH0kJ53N2r2lv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ruNN59a7gM2bnkHJNPllNH0kJ53N2r2lv
Content-Type: multipart/mixed; boundary="XqGSBDxIQT9D5pErwTmCwgqO2Bx3Lv0jS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Message-ID: <8fde07d2-2bdf-f5d7-2599-f13a8d9dd942-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/hfi1: For 4.8 rc 5
References: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--XqGSBDxIQT9D5pErwTmCwgqO2Bx3Lv0jS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/31/2016 10:24 AM, Dennis Dalessandro wrote:
> Hi Doug,
>=20
> Here are five patches which fix bugs that we think would be appropraite=
 for
> the next RC. This should apply cleanly on top of your GitHub 4.8 rc tre=
e.=20
>=20
> Patches can also be seen in my repo and have passed 0day builds at:
> https://github.com/ddalessa/kernel/tree/for-4.8
>=20
> ---
>=20
> Dean Luick (1):
>       IB/hfi1: Add QSFP sanity pre-check
>=20
> Dennis Dalessandro (1):
>       IB/hfi1: Fix AHG KDETH Intr shift
>=20
> Harish Chegondi (1):
>       IB/hfi1: Make n_krcvqs be an unsigned long integer
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Rework debugfs to use SRCU
>=20
> Sebastian Sanchez (1):
>       IB/hfi1: Fix SGE length for misaligned PIO copy
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c      |   92 ++++++++++++++++++++--
>  drivers/infiniband/hw/hfi1/chip.h      |    1=20
>  drivers/infiniband/hw/hfi1/debugfs.c   |  132 +++++++++++++-----------=
--------
>  drivers/infiniband/hw/hfi1/hfi.h       |    4 +
>  drivers/infiniband/hw/hfi1/init.c      |    3 -
>  drivers/infiniband/hw/hfi1/pio_copy.c  |   12 +++
>  drivers/infiniband/hw/hfi1/user_sdma.c |    5 +
>  7 files changed, 155 insertions(+), 94 deletions(-)
>=20
> --
> -Denny
>=20

I ended up taking all 5 patches, but the line count on these is a little
larger than I like to see in this late of an rc.  I can't complain too
much about the QSFP fix as you wrote exactly what I asked for (although
I would have preferred it either in a merge window or earlier rc), but
the RCU locking changes in a later half rc are something I would like to
avoid in the future.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--XqGSBDxIQT9D5pErwTmCwgqO2Bx3Lv0jS--

--ruNN59a7gM2bnkHJNPllNH0kJ53N2r2lv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXycYWAAoJELgmozMOVy/d8sIP/iN+DF2Fg1CSgiY8+mE4qS7R
Tst61TheaYSvXewZlzLnYPuWbXaWk9hHP/adJIh/BUqKZcTBpVjPqhBH5EGVHUTL
zUGOdsjthCbNRxuvmEMxJC8BMu+c/zEFtCXp/0u/BwfSIzMAKGswU2qH4GWbrE0r
Ms8I+o/VOMMl3vLw4sCzCyY3U/cohGI1mvqyeshNT1eA2CJTj60wirlPo3cKLj7a
pSG0bAQoTOa9kUuUEAq1scbalK0eaTOFtSsceQCLYzJ5wzVc7h7GD4rdLhdq3IO0
VRsPAbqqgkfN41QoI62qxe+0teXp6m01Jx7AlH/dyB5SjjD4FIdVfkAHJ4vKPuqV
KXPLsVz7BOo3mzrCwOuOHc5y8bm0hnbkdRh58vV4E+ujPi3rQvVvcbb7LccAy3wx
FhL42ytSfscPyNfhJUQemIvj27T1ngkiVa3nm5+PJdDSlRw/xb0DgSVzpoqj+E6G
OWkJNQvFfH2vMMBQNF81g0lW6g5WIui2L+L4vsHbzP/7xXy7/RkqaRlyGG+vV8W6
S+h0c/3zNxUavnhdstV0+OkWD/bGpqGOT4wQ+8bVoHOl7NOR78r2h/hbn/ruo9kK
gvYzDHHuOw1ShHEvyN+3IL96mPgm+xnZrBuvgG+Yv4q4U906EbKrn8erw+i1l5HF
dqg7hT1g+0333Ou8x83M
=Mc2Z
-----END PGP SIGNATURE-----

--ruNN59a7gM2bnkHJNPllNH0kJ53N2r2lv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
