From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] RDMA/qedr: Add iWARP support for QL4xxxx
Date: Mon, 21 Aug 2017 19:23:33 -0400
Message-ID: <fd72775d-be4b-8504-917d-eb21eecb71c1@redhat.com>
References: <1501069317-16601-1-git-send-email-Michal.Kalderon@cavium.com>
 <1503073970.2598.24.camel@redhat.com>
 <DM2PR0701MB1392B1F6FB49D027801AFC6788870@DM2PR0701MB1392.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XJapde4BfsbNvoCfP9db7WTvbF1ASGDhc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM2PR0701MB1392B1F6FB49D027801AFC6788870-v3byQ3tR4i+0eoJk1DrUDU5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XJapde4BfsbNvoCfP9db7WTvbF1ASGDhc
Content-Type: multipart/mixed; boundary="NWbmjilIaH164putbF8CGxOvCAmvlsMnU";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Message-ID: <fd72775d-be4b-8504-917d-eb21eecb71c1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] RDMA/qedr: Add iWARP support for QL4xxxx
References: <1501069317-16601-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <1503073970.2598.24.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <DM2PR0701MB1392B1F6FB49D027801AFC6788870-v3byQ3tR4i+0eoJk1DrUDU5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
In-Reply-To: <DM2PR0701MB1392B1F6FB49D027801AFC6788870-v3byQ3tR4i+0eoJk1DrUDU5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>

--NWbmjilIaH164putbF8CGxOvCAmvlsMnU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/2017 10:29 AM, Kalderon, Michal wrote:
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>> Sent: Friday, August 18, 2017 7:33 PM
>>
>> On Wed, 2017-07-26 at 14:41 +0300, Michal Kalderon wrote:
>>> Hi Doug,
>>>
>>> This patch series adds iWARP support to our QL4xxxx networking
>>> adapters.
>>>
>>> The first 6 patches of this series were previously sent as an RFC
>>> (patches 13-18): https://www.spinics.net/lists/linux-rdma/msg51416.ht=

>>> ml
>>> The qed part of the RFC has already been accepted as part of 4.13:
>>> https://www.spinics.net/lists/netdev/msg443224.html
>>>
>>> Changes from RFC:
>>> -----------------
>>> * Functions rdma_protocol_iwarp/roce, are used instead of
>>> IS_IWARP/IS_ROCE macros when differentiating flows after device
>>> registration.
>>> Pointed out by Leon
>>> * Additional patch is added for user space iWARP support.
>>> * Additional maintainer added for qedr for MAINTAINERS.
>>>
>>> This series was tested and built against:
>>> git://github.com/dledford/linux.git, branch: k.o/for-next
>>>
>>> Michal Kalderon (8):
>>>   RDMA/qedr: Add additional maintainer to MAINTAINERS file
>>>   RDMA/qedr: Rename the qedr_cm file as a preparation for iWARP
>>> support
>>>   RDMA/qedr: Add support for registering an iWARP device
>>>   RDMA/qedr: Add iWARP support in existing verbs
>>>   RDMA/qedr: Add support for read with invalidate, supported in iWARP=

>>>   RDMA/qedr: Add iWARP connection management qp related callbacks
>>>   RDMA/qedr: Add iWARP connection management functions
>>>   RDMA/qedr: Add support for iWARP in user space
>>>
>>>  MAINTAINERS                                        |   1 +
>>>  drivers/infiniband/hw/qedr/Makefile                |   2 +-
>>>  drivers/infiniband/hw/qedr/main.c                  | 105 ++-
>>>  drivers/infiniband/hw/qedr/qedr.h                  |  31 +-
>>>  drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |   6 +-
>>>  drivers/infiniband/hw/qedr/qedr_iw_cm.c            | 746
>>> +++++++++++++++++++++
>>>  drivers/infiniband/hw/qedr/qedr_iw_cm.h            |  49 ++
>>>  .../hw/qedr/{qedr_cm.c =3D> qedr_roce_cm.c}          |   2 +-
>>>  .../hw/qedr/{qedr_cm.h =3D> qedr_roce_cm.h}          |   0
>>>  drivers/infiniband/hw/qedr/verbs.c                 | 350 +++++++---
>>>  drivers/infiniband/hw/qedr/verbs.h                 |   2 +
>>>  11 files changed, 1203 insertions(+), 91 deletions(-)  create mode
>>> 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.c
>>>  create mode 100644 drivers/infiniband/hw/qedr/qedr_iw_cm.h
>>>  rename drivers/infiniband/hw/qedr/{qedr_cm.c =3D> qedr_roce_cm.c}
>>> (99%)
>>>  rename drivers/infiniband/hw/qedr/{qedr_cm.h =3D> qedr_roce_cm.h}
>>> (100%)
>>
>> I've pulled this into a branch and pushed that branch to github.  It's=
 the qedr
>> branch.  There was some fuzz in taking the patches just due to code fl=
oat
>> since you posted this.  Please review my branch and make sure the fina=
l
>> result is to your satisfaction.
>=20
> Thanks Doug! I looked at k.o/for-next-merged branch ( didn't see a qedr=
 branch )=20
> Qedr Files in this branch look good and as expected.

Yeah.  That happens.  I had them in their own qedr branch, but when I
merged it to net-next-based, it was a straight fast-forward so no merge
commit was generated.  Then when I deleted the qedr branch, it's as
though it never existed.

> Could you please clarify which kernel version the  for-next-merged bran=
ch is intended for ? 4.14?

It is intended for 4.15.  I have it as an early check on the future
submission.

> I have additional iWARP patches for net-next, would like to know which =
kernel version to aim them for so that they
> Don't make it in before this patch series.=20

Understood.  Think of anything based on net-next as a for-next-next
branch.  When I open for-next in the next submission cycle, I'll
ultimately create a branch on -rc2 of the next kernel, and merge this
branch in.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--NWbmjilIaH164putbF8CGxOvCAmvlsMnU--

--XJapde4BfsbNvoCfP9db7WTvbF1ASGDhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZm2t1AAoJELgmozMOVy/dbDwP/2fw5N8me8GyYkOOr6zPpMQw
5qXs+9XjcPnMulGo7L9fTBQiy1jV1cWjJQOO081yYPRVusuOkM/ZJipdTQ2da29f
aSUKBluVVl5QeDMgP/4cuKslGqJOmAJF+ZDwjKp1m/mGcDllODCX0qoijPMplhLh
oyPL0WIBcTQ3tPWmeskqX+0g8m7lcdVTBTL3HNSzysphGkdhkZ9+XgdNnmgfgWjU
OupVukJlPQGr3MsDOGvVXz4uLGfHPpzb4jQjK5IvqfAZV+r1r39OYF4S/yCTz4af
6M0t38ih0xaJ6uoSZWqON+dWHEp8R/xbCG8J+tG19BEP9QF72whDzxDpSnD2Q1qz
ej6CV13QuleHWiJLR4o7yuz70HrU6HhrQRs0cJAwWloGjc3qGzWpm0x4w8jJmU59
HbBSTUpqZEndV8QvNbCbY7DK7dhhgUNQ/v7VnC25YZpt/BtJACN0PQrQOGDme/5b
3nqmVn8nVqUOYer0IPMuPYTMJ6jy0zHBH3qtMcruMsb4BoqVILu3goqRK6jLbCyU
fNQpAoCbiz5mwp/E5U9sprRrCpNVnAjnJ5as+bSEC35nIQelPLNcnK6wobhO32/L
yL67zst9JlCbqj2khhoBHPVqr+sdVhkhjulSdlYs+X+ChyF1q0Ht+LEoh98UU1QF
D36c1FEDmNJcqFF4UiIu
=3As4
-----END PGP SIGNATURE-----

--XJapde4BfsbNvoCfP9db7WTvbF1ASGDhc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
