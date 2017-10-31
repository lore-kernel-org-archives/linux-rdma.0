From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Computer issues...
Date: Tue, 31 Oct 2017 10:32:03 -0400
Message-ID: <36640bfe-850b-a857-1cc9-58939ac50946@redhat.com>
References: <CA+mK3=-v-nMb-cRO2hGEmirxbNnRuW-OZWGC8d+sUoTcxKmt7w@mail.gmail.com>
 <1509363152.2295.5.camel@redhat.com>
 <5b0fbfd7-6747-da76-91a9-3fa4dc173bb0@redhat.com>
 <d6ab43f7-9698-7164-441b-02c1f5560abd@redhat.com>
 <CAKkHt7W_Cv_qGRs_R3zn6_PaXd7xAE0+D_Qghn7KUq+bzRHHjg@mail.gmail.com>
 <f3a0d17b-1a5c-b97c-e544-5b4524e71424@redhat.com>
 <783cf656-3cd7-c40d-48cf-a749f022a161@redhat.com>
 <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="pV16iJw9VqHpIKxmdS3PNOWHFkr7jt65S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pV16iJw9VqHpIKxmdS3PNOWHFkr7jt65S
Content-Type: multipart/mixed; boundary="n5tCj5R2A2e8NBiCap7McAVfono4KOVPE";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <36640bfe-850b-a857-1cc9-58939ac50946-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Computer issues...
References: <CA+mK3=-v-nMb-cRO2hGEmirxbNnRuW-OZWGC8d+sUoTcxKmt7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1509363152.2295.5.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <5b0fbfd7-6747-da76-91a9-3fa4dc173bb0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <d6ab43f7-9698-7164-441b-02c1f5560abd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAKkHt7W_Cv_qGRs_R3zn6_PaXd7xAE0+D_Qghn7KUq+bzRHHjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <f3a0d17b-1a5c-b97c-e544-5b4524e71424-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <783cf656-3cd7-c40d-48cf-a749f022a161-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--n5tCj5R2A2e8NBiCap7McAVfono4KOVPE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

My primary computer had a sudden failure yesterday. I was working, I
turned around to grab something, and the whole thing just powered down
while I was looking away. I tried everything to power it back up, but
nothing worked.  However, it wasn't *completely* dead because two LEDs
on the motherboard came on, just nothing else. So, I started to pull it
apart and do some investigation. I pulled another power supply and
plugged just the motherboard into it, and viola, it came up. So, I guess
the 12v rail on my other power supply died. I went to Best Buy to buy a
new power supply (the one I tested with really wasn't big enough for
this machine), bring it back home, and got to work replacing the entire
power supply.

I happen to always buy fully modular power supplies if I can, so I was
in the process of swapping things out, and I didn't realize I had
plugged a Corsair modular SATA power cable in the SATA connector on the
new power supply and ran it to the bank of 4 SSDs I have in my main
computer.  Until I powered the new EVGA power supply and immediately
heard some odd crackling followed by the unmistakable smell of magic
smoke (quite strong I might add).  So, moral of this story is, while the
EVGA and Corsair modular connectors for SATA power cables use identical
physical connectors and will happily plug in on each other's power
supplies, how they wire them up most definitely is *not* identical, and
all four SSDs that were plugged into that modular SATA power cable are
now toast.  This includes my primary workstation and all data that was
on it.  Fortunately, I keep backups and what not, but I am currently
sending this email from my laptop and I will likely loose the next day
to two days to the task of reinstalling from scratch, then restoring
from backup (even as I write this, my laptop is writing a Fedora 27 Beta
USB boot key).  Joy!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D




--n5tCj5R2A2e8NBiCap7McAVfono4KOVPE--

--pV16iJw9VqHpIKxmdS3PNOWHFkr7jt65S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZ+IljAAoJELgmozMOVy/d/FsP/08HKDeh2e8VddYVREnXRoNY
I62LpiDWLzhktXQXgE68uMnfK3OZHXgn0xLGP6stSFxwuNd1rtKfolU0qooIv+cS
52hAx9rHGBcbdaUpY3fbD+6/2nlN1L6F7MKaa50cHSEUaTMfX9n9vfwXTt85KLo0
p1hEaUu2SrHwq7qVahItLV+oAAkQ1/S8kh1FGJSZW3XFlBhs8tsnWe59nSMO899D
p9DkBpN+4LRui34EJCpOzdSqF9kq0m3VTy7xgI9W/CUjCtH3BixbHJMOKNL95XW+
MwhZWszjfMygnGUh1V7xdQpppJ5KEuutZM9Qdzj9IlAduL1uj2SNYNjjMUIb1oXL
Zqsik0p9cm/5kCK6bt+e2atzejaCdPqsfQ+6AXkHh3Isy9mN5DUtZT6+FOU8F0+p
dtjC31bP98S/9WWFbFZnn07FwqcV7p4XTUNSM+D2QlY9n7ePdwNAmV00zQpGHiQd
XBVI6QbeD1HCOI7FQJlKEkjJJMqD5QPnq/5pMLR1JRGGeKC66zODdb5fE6TARSYZ
qmrdF26iEukoieTvctrmLEaW0bgLymZhZZJR2dItB9wSH/J5w+0bip2vdpWPRbuK
OT68U1Utt7xEv9RHEj5lkaLktf5AIFIPIEGLgjWw01NqGGp43nzTT4daKfeLgWeY
lvtRRjcWkpAigHO3WKfD
=mCf/
-----END PGP SIGNATURE-----

--pV16iJw9VqHpIKxmdS3PNOWHFkr7jt65S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
