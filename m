From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 v2] qedr: batch of fixes for 4.10
Date: Thu, 26 Jan 2017 10:29:32 -0500
Message-ID: <e64f4dad-c880-57ec-4cee-096d6e6e34d7@redhat.com>
References: <1485258703-11949-1-git-send-email-Ram.Amrani@cavium.com>
 <1485291005.43764.67.camel@redhat.com>
 <SN1PR07MB22072B698D0B19AD7FE7865EF8770@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HflshG4USx01RGJuU0AdF4Li5Sc4rg2KD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB22072B698D0B19AD7FE7865EF8770-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HflshG4USx01RGJuU0AdF4Li5Sc4rg2KD
Content-Type: multipart/mixed; boundary="vwFIBvvil1QVUD7lrRexsIU2GIBdIC78p";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <e64f4dad-c880-57ec-4cee-096d6e6e34d7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 v2] qedr: batch of fixes for 4.10
References: <1485258703-11949-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <1485291005.43764.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <SN1PR07MB22072B698D0B19AD7FE7865EF8770-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <SN1PR07MB22072B698D0B19AD7FE7865EF8770-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--vwFIBvvil1QVUD7lrRexsIU2GIBdIC78p
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 1/26/2017 8:44 AM, Amrani, Ram wrote:
>> I took these, but I would like to point out a couple things.  First,
>> the commit messages could use some work.  I fixed a number of them up.=

>>  Also, a fix to formatting isn't really an -rc fix.  I took it, but
>> next time let's be more selective on our submission please.
>>
>=20
> Thanks.
> I have reviewed your changes for next time. I understood all but these:=

>=20
> I thought that introducing formatting fixes and making functions static=
 are
> simplifying and risk free operations that are acceptable.

Yes and no.  They are risk free, but they also provide 0 benefit to the
actual running of the kernel.  Therefore, to reduce churn during -rc
cycle kernels, you would normally not submit them.  You would hold on to
them until the next merge window.

> I now understand,
> and correct me if I'm wrong, that only if it's important fix it should =
be introduced.

Correct.

> Sometimes I see IB/vendor and sometimes RDMA/vendor. When to use each?

I'm trying to transition people over to using RDMA/* as much as possible
because the stack is much more than just IB these days.  But if someone
sends me patches that have IB/ as the prefix, I don't go in and modify
every subject line.  So, when I modified your subject lines, I used
RDMA, the IB subject lines you see in my current queue are from other
people.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--vwFIBvvil1QVUD7lrRexsIU2GIBdIC78p--

--HflshG4USx01RGJuU0AdF4Li5Sc4rg2KD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYihXcAAoJELgmozMOVy/du5YQAKqKG0cXnctSVmK7FTLVzWOY
wqk4q0uk8oQl2PRS8jt7JgChnurWurctl+YgipuTf9XIrsCdiDEAhFhJO5rZGsMW
QSI2+RUHDH1zX2zWYnPtPTiXYqKhy2dyV5XJ2bNbdGFrpIBnW+E+ql3ERnnzvXMF
coCfQzzmlZ7Y8CN/Fb1FlH8ok6SgK/VNfMOIfpkQxJUBSSg3IzVUSiANpps62R2t
frm7YSuiVAwH3Catho0yCZrawKnll034ajp5ZmmsytosdcjNhJCCxDifu+CbVzm3
31eB5HQBszWt8ZYUpBtsvBE9CJwAcLYMw/kqHY6DLWGwiutzNF37f7KfjkMb/BHJ
MpP7in1Qc9oAy0eeUA1u19HsGSW0LjXIl1Lw0JaJKDq357kRVUmo8GbdKOJVS3m7
bKrYdMfRJ0lGNIbTeq5gRPe82hBb15JfGKsE+WrY5U93D4AU3s9NkUJNfY6o3FIC
iMyyTVn3bDBYoT5NBd+9eMfZcjEL9FKJaX2IeVSHphCrT8M0pMwA8t8uTbMCgBvW
sPnCoqvyJzJnLrj3qZaYMQlRPUsUfmb3m7AE+uE9O7lSTV17TpBkgUW1BPDrKusr
o3odNT3bjBEPGXkSTiwiPMIQJ5JlHAZZrJanHIf1oj7+pFpBCfXkdkRPw6UOisQR
7RN3fhczN/jIiLrrm+/f
=Qxyw
-----END PGP SIGNATURE-----

--HflshG4USx01RGJuU0AdF4Li5Sc4rg2KD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
