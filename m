From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
Date: Thu, 22 Dec 2016 13:15:55 -0500
Message-ID: <74c5651b-4125-0a7a-3184-d510814cdc0d@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221220840.36268-6-jarod@redhat.com>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3@redhat.com>
 <20161222173302.GA29518@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9VuA46aLorcuL2oV0aEGNuMO1opMojWPd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222173302.GA29518-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9VuA46aLorcuL2oV0aEGNuMO1opMojWPd
Content-Type: multipart/mixed; boundary="iuA3KAPh4xkEwlEBkJf4jlCqpLEgfsdg4";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <74c5651b-4125-0a7a-3184-d510814cdc0d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
References: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161221220840.36268-6-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222173302.GA29518-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222173302.GA29518-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--iuA3KAPh4xkEwlEBkJf4jlCqpLEgfsdg4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 12:33 PM, Jason Gunthorpe wrote:
> On Thu, Dec 22, 2016 at 02:17:52AM -0500, Jarod Wilson wrote:
>>> %files -n librdmacm
>>> %{_libdir}/librdmacm*.so.*
>>> -%{_libdir}/rsocket/*.so.*
>>> +%dir %{_libdir}/rsocket
>>> +%{_libdir}/rsocket/*.so
>>
>> Minor error here, should be rsocket/*.so* to pick up the symlinks too,=
 at
>> least until they get neutered.

I hand fixed this when taking the original series BTW...

> FWIW, it would also be appropriate to put the LDPRELOAD library into
> librdmacm-utils..

I'm pretty sure the Fedora standards would want it in librsocket and not
in a -utils package.  The -utils package should be executables and not
libraries.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--iuA3KAPh4xkEwlEBkJf4jlCqpLEgfsdg4--

--9VuA46aLorcuL2oV0aEGNuMO1opMojWPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXBhbAAoJELgmozMOVy/d/tIP/A/dDhD1WO6RPJxoWD+IqSeZ
DkcyZcqbl3yVf1IWWlhuW910YKm03pN+FLtJo3HQJfAqXu9hXwUCnMSNJWIis+1/
E5ufK5Hu7xMwvYT7oAL+XYxS5Jsb0sH64CbYac7aqA9q/cXWZfx8B24+CYrM7ZdY
bsJ9jM6LlyaNgCSNb0hfla1cpPVSTsFO1zB3dkXBA1zmQoz5WjiibLZ0BZIPVra0
cQySVc2u1zWNeG3R67vzM77yOsn2X5TTm7yy1EyhFuRmKndZfKV3gs+GnwTWELX6
UtSFcsUl7XlTb4rLvA0lhiVvTpa78DN7bTidlv6Y5OauiYvJifitTC6VE0lWlK7J
iDv2yFrWnq7yaHbEFEEPPGAFEckamp+hD9a49v1mvPtkVzSWY+Ml+jFbkd4VR6QQ
GTnVR3dcF6euZvMHfIabpZRzyNMEnP4fO1lEWnfkHhrQPmKyUsR9ENCxwcC8F7Ki
p1Ail56GsMZgr6Ao1g4jhazn4dka2PWAgU9ZkMwiLi71e6gz8RTKn1G3U4Hke5i+
Cs1ZK1e+apAbcRw04DhF/n5DnpqCffKRo1iAqeAGepkPhtkPwE2UOAJfiwl/hIYS
mR7EVJg2WY8cgHa03bxQfiSObiH3MBa49fAbDwxMfwnXRySrkGxTphIH0giDD2pv
vbWLQr/spab19xntWHch
=gaQN
-----END PGP SIGNATURE-----

--9VuA46aLorcuL2oV0aEGNuMO1opMojWPd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
