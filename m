From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
Date: Fri, 21 Oct 2016 15:03:23 -0400
Message-ID: <9745f6c7-8d09-8bed-d04c-78f610330ead@redhat.com>
References: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
 <20161021180523.GA554@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5McfmDijQXchDWs7SIw9flHbQGUTsIeVp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021180523.GA554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5McfmDijQXchDWs7SIw9flHbQGUTsIeVp
Content-Type: multipart/mixed; boundary="gfl1xWVl4RW720HqRh6NoScOu5TWwcPE4";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <9745f6c7-8d09-8bed-d04c-78f610330ead-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
References: <20161021172728.27367.86783.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20161021180523.GA554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161021180523.GA554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--gfl1xWVl4RW720HqRh6NoScOu5TWwcPE4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2016 2:05 PM, Jason Gunthorpe wrote:
> On Fri, Oct 21, 2016 at 10:27:28AM -0700, Dennis Dalessandro wrote:
>> The build script does not use the variable it sets up for cmake. Fix i=
t
>> so it does.
>=20
> Yep, my bad. I put this with the other minor fixes that came by
> lately:
>=20
> https://github.com/linux-rdma/rdma-core/pull/25
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

According to github, this change broke the travis CI build on your pull
request when the previous patches all worked.  However, travis is down
right now, so I suspect this didn't *actually* break it, that the travis
CI was down anyway and github logged a failure.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--gfl1xWVl4RW720HqRh6NoScOu5TWwcPE4--

--5McfmDijQXchDWs7SIw9flHbQGUTsIeVp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYCmaDAAoJELgmozMOVy/d5/oQALPfvowUkyI9k5/wdi3ylYP/
2WAxU1HIvDIkN8AV2vLXD0g4xA2B077UdX+3e6YGWZ4Y/HFfcC5ymABqGQT1ucUF
Hn9RUVvoHWd4b8OVxIWQyXi2D4UHMKMe664P4vKfD7HB4cjuzx1+jstYVnnTBfBb
QdfX/GpP5oz5vKSiKF3z0l4n1gHyNgPL1Ja0JOkU9UCyHmBWh/DEsNSW78w1lqp7
QHX4mEDgRXMqbZz8Wp2EiUIV/ZAoSiUyACLu9whkNADU+/7YI5PqKRlCs4G+qbJF
rIJepPsUaMtpqrLq/PkIRRyQdZTdMBjnI4ni1o08nPu7tPreSRMw/8d7U4T2wCYG
aBGZ8oSHoJPpxWxDOKt+RGnM8KyDqvnMuUjfRJLzgwyh2hEYPVjW7baW5rtvY0f/
eOrb5TJID+ydgvnQB4UcanyjEXd0LV9zFV73mbicoP2yA48GyBW85WqL/hkhbnC8
aEU/XQcylS5kTyaFUqrDe9k38nQqC3LGa0nv+bMJKCmOQRJvO4Mm82RcRCtv59L8
juviFWw/Xc/YSMbFDYHwe1aBf2xcdCYyHNVbEcTt3pYdBulOeKf+uuyFHJsZ3kCf
hcG5xyMJaUt7TbwElHUUmCqKdLGOfnvzvY2exciz/fBxRr7/hSNtoLeTKhJbGWFt
ZHarsB0hWBNDPVoGySZN
=lRMc
-----END PGP SIGNATURE-----

--5McfmDijQXchDWs7SIw9flHbQGUTsIeVp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
