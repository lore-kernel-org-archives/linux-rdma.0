From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Fri, 24 Jun 2016 17:27:05 -0400
Message-ID: <7665ed74-224f-96c3-838f-d0428d01ad71@redhat.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
 <c233fabc-7779-db30-b983-13cf61094716@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0651CA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H0Ji5I7V4jHLkQoGMgHBWkT6rON8xSxdD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0651CA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H0Ji5I7V4jHLkQoGMgHBWkT6rON8xSxdD
Content-Type: multipart/mixed; boundary="A8HWbqL3FEK25AwVSSjno3IqC6SLsTUiP"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <7665ed74-224f-96c3-838f-d0428d01ad71-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 00/29] Soft RoCE driver
References: <1466084751-29901-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <c233fabc-7779-db30-b983-13cf61094716-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0651CA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0651CA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>

--A8HWbqL3FEK25AwVSSjno3IqC6SLsTUiP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/24/2016 1:11 PM, Hefty, Sean wrote:
>> I've pulled v2 into my tree for 4.8.  Please make any remaining fixes
>> between now and then incremental patches.  Although I've pulled this
>> in,
>> I want to remove the FMR interface prior to submission to Linus, so
>> please prioritize getting the driver updated in that regard.
>=20
> If we're going to accept another software implementation of the IB tran=
sport, what was the point of rdmav?  There's seriously no code that can b=
e shared here?
>=20

I had my doubts from the beginning that they were very shareable, but
regardless, rdmavt helps to make sure that you don't have the same bug
in two places as much as possible even when not used by rxe.  In the
past there were plenty of times when ipath/qib had to both have
identical fixes.  The most recent write security issue being a perfect
example.  As much as possible rdmavt helps to eliminate that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--A8HWbqL3FEK25AwVSSjno3IqC6SLsTUiP--

--H0Ji5I7V4jHLkQoGMgHBWkT6rON8xSxdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbaWpAAoJELgmozMOVy/dT6YP+wWLpH9y/PtrsNoFSzMU9s8d
WiplMGmxToTel0tcjY+SdjBRwoC5dSYHHPoMPvJM2TyLeaKSOLvKlCrxYdPANl6p
OU3AZE2ywxwWEJkzFv0LC3NKUBTBB0XmCLF/KNh9RS6L7Pjc8TH4/1bfQU7Zs606
zuwOMqvhwt0FthiV7h/1EqTb+wX/ClfGgcIzK+G/LyMzVofd4+xzu6QqjnfTrji/
KCHyGZ3q9oHF3eOb5WX7rwONzkJpYbcj3FIMnB9tWPrvmmRf7rOuzwBSR1f/3rPZ
MR0hqrkWw8sViwQiDFwqc+wC3937Pyvl8ukgUlZ9luaZcsD4O8C8BM8+pvYcb1RR
pN+YCt0SSjw6TQaUnVEXWU8Zi1H9f335Qqb26uaWgljemw2cl5nWiZBKEhTBb28S
4Zg0ZKQfzX6ByMvukcRI/+O9jT9h0OxUCw75WM10G7ZVNKYNJBEpZ/ZmVu7LrdQN
skSZVQck+EMTE4ZI8Vtq1dVWVlVzlJNhRmM7iZRpvx47DAkk1fkRjnigRooU58ty
1xruUGT0r/6xXwD6sJfhdzlLNkmqMke/MjKpLWnjw6JfC5VkWiDO9UDQxWPhSH85
H4Zcim21fcRUDODXyqDc/Pu0WRGau2TmZ5tsZeZhkv2SVwdD/x9o6hctIytOQXEy
iNrADosrUQsYwzEepMPW
=6NqN
-----END PGP SIGNATURE-----

--H0Ji5I7V4jHLkQoGMgHBWkT6rON8xSxdD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
