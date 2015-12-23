From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ocrdma failure in 4.4.0-rc5
Date: Wed, 23 Dec 2015 12:59:04 -0500
Message-ID: <567AE0E8.70107@redhat.com>
References: <5675BA00.5060101@redhat.com>
 <CANjDDBiJAyfS7wFr9yYs7fAnn1-h9t1JH9s1LDf-Q8RYk=Ayyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WMTxriBfPdhgAnKQETbFnD7RnE98nJGaj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBiJAyfS7wFr9yYs7fAnn1-h9t1JH9s1LDf-Q8RYk=Ayyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WMTxriBfPdhgAnKQETbFnD7RnE98nJGaj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/20/2015 11:29 PM, Devesh Sharma wrote:
> Hi Dough,
>=20
> Thanks for your note.
>=20
> We will root cause the issue asap and get back to you with the fix.

Ping.  Any update?

> -Regards
> Devesh
>=20
> On Sun, Dec 20, 2015 at 1:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> Hi Devesh,
>>
>> Testing 4.4.0-rc5, the ocrdma driver is failing for me (100% reliably)=
=2E
>>  If you have vlans off of the main device, this is what I get from the=

>> Fedora rawhide 4.4.0-rc5 kernel:
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--WMTxriBfPdhgAnKQETbFnD7RnE98nJGaj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeuDoAAoJELgmozMOVy/d/EcQAME37PmSzR/En2rJRKPjvHJo
yAF1Xdgb7o+Zict6muyM+zYnXVIPovMRt/9PmRVDJ7rfoNNRZZIer1b70KbBowhL
zBHuYt2G8iuywt/5MeZDIWzgxArF71XBxereBVb/bkCy4ggbUDyCJmavaeqyEknW
DvY3lsMX84zWsf0xq3RSegkU7U8YIsxkA05MeN2a7dkBfgeEjUgn6MuYwXd8PQQD
+shOAN8OL/iDKde7beeN+73hZ2CTm9ABJ0dUTVQJvsg4d3XzF8ZPMLHkg/tCtMr7
Q/faQM+63NBYdNE9yxMRKQYawE4epYyyIV+WyzwxrtBnmyhMuReWC4ilx5xuEPXo
zYlntf4dbK3zMML17DcOA6GXVgUPsvQ9w8AJX9hoQIInloGUDM/BCu5oSMDCSqKS
b71EIZQjztbOYXk/qlyY9CHHTPTVzcnUM91+Vghowz3bnLWWlyZ7BaiRrJT9YX6o
bKzJ45KjHJahVTfU2TAEl5dpFvyiwx0HV2ibSZ3045VYYGmyBgdi5XihrXZl9wUv
fx6kXVQqEG0ayFx27h+5PIpxfFaMhM20s7yukMdOryOJM4BVQQB7X2ErPJuxueA0
7S2W2zoPIb9IDznqssk7ClG/Emqh4hv3jcAHqLS8MBqPEcaxKY+VA6hEUYPoV8uZ
eqwFP3qZ2T+CxWaO0s//
=ANRV
-----END PGP SIGNATURE-----

--WMTxriBfPdhgAnKQETbFnD7RnE98nJGaj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
