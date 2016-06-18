From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/hfi1,qib,rdmavt: Fixes for 4.7 rc
Date: Fri, 17 Jun 2016 20:11:16 -0400
Message-ID: <d0c3831c-c6b1-a285-254e-ffb6a70bb3f0@redhat.com>
References: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QpO7AFKkMFq1Qpt5L9Fg1L3BkddWQONug"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QpO7AFKkMFq1Qpt5L9Fg1L3BkddWQONug
Content-Type: multipart/mixed; boundary="HQgg7o2GDtcJEL6qWhEDtmQw560eNNjwn"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <d0c3831c-c6b1-a285-254e-ffb6a70bb3f0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/hfi1,qib,rdmavt: Fixes for 4.7 rc
References: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--HQgg7o2GDtcJEL6qWhEDtmQw560eNNjwn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/9/2016 10:51 AM, Dennis Dalessandro wrote:
> Doug, here are some fixes which we would like to land in 4.7 RC. These =
are
> bug fixes. Some more serious than others.
>=20
> Patches apply on your k.o/for-4.7-rc tree.
>=20
> Patches can also be viewed in my repo and have passed 0day builds:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Brian Welty (2):
>       IB/rdmavt: Correct required callback functions for MODIFY_QP
>       IB/rdmavt: Correct warning during QPN allocation
>=20
> Ira Weiny (2):
>       IB/hfi1: Prevent context loss
>       IB/qib: Prevent context loss
>=20
> Jubin John (2):
>       IB/hfi1: Fix credit return threshold adjustment
>       IB/hfi1: Increase packet egress timeout
>=20
> Sebastian Sanchez (2):
>       IB/hfi1: Remove FULL_MGMT_P_KEY from pkey table at link up
>       IB/hfi1: Send a pkey change event on driver pkey update
>=20
> Tadeusz Struk (2):
>       IB/hfi1: Fix potential NULL ptr dereference
>       IB/hfi1: Fix potential buffer overflow
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c        |   28 ++++++++++++++++++++--=
------
>  drivers/infiniband/hw/hfi1/file_ops.c    |    3 +++
>  drivers/infiniband/hw/hfi1/init.c        |    2 +-
>  drivers/infiniband/hw/hfi1/mad.c         |   19 ++++++++++++-------
>  drivers/infiniband/hw/hfi1/mad.h         |    2 ++
>  drivers/infiniband/hw/hfi1/pio.c         |   26 ++++++++++++++++++++++=
+---
>  drivers/infiniband/hw/hfi1/qsfp.c        |    3 ++-
>  drivers/infiniband/hw/qib/qib_file_ops.c |    5 +++++
>  drivers/infiniband/sw/rdmavt/qp.c        |    4 ++--
>  drivers/infiniband/sw/rdmavt/vt.c        |    4 +---
>  10 files changed, 71 insertions(+), 25 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--HQgg7o2GDtcJEL6qWhEDtmQw560eNNjwn--

--QpO7AFKkMFq1Qpt5L9Fg1L3BkddWQONug
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXZJGkAAoJELgmozMOVy/dkz8QAJ1LiEUQ5owPx0OF3/whGTTL
s+VCAI+s5LV4l3+Y6rXe702iYZIBUwprVgXB3HtJWt6oqCsuID9ifRaARxmbR+CJ
+TXgvqQEzEY8MlGJpgFw6qh6EF47YDDz+eMNX89pKl6mD+m2zXulNTSAnRG802ja
+rRN56i9JwPQeJLcoGRnvD7D6QD5B70soV11Cnj5N8sN7OSc6MX0ofrLRv8dBdC8
MkEmqj7hwppaWfzGCsd/qU9B5A9uNZIs/USozYHHqKwg074rmtc6iwueU4ba0vzZ
wkvs8UwJAQbYIyf15lMXz01DrDuUKrhdjfFF+r3sP2Y23WT5YdE/YXDcGuj1ruMA
q0IFCTpmIOvWAQJYPs3jRMZpjHLvQlTYJ8o5QxQYVJ81SQX08JSB7wdCpuCuDwFf
C2qUeaTXYTWm3mhAcm7dkBCJhZxtoXf01tiUpXv/TUW77FJTIrZYAFO054yovNM9
UqYe7OdvUDQfkiAeeM6VpfFZ2azeKLibZFtPmqSXLP/ghp5sLRkR8hYLUdQSwoNf
vTMUFQx/ZO55FW+cdtcMW3RIfmlvdq+nc+XHK/Y9PZE4EfocDECJ5Ej0EcHdETKZ
p/fuhHOZKzYfti3pPXUuOEjcpTu1kj/m7jJwzzt7g+Eu4qTAj1fK8Ke6uOXWqqxv
pel6n/FoHvKf9MFEfSvx
=W4nV
-----END PGP SIGNATURE-----

--QpO7AFKkMFq1Qpt5L9Fg1L3BkddWQONug--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
