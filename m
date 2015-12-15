From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change sendq threshold size
Date: Tue, 15 Dec 2015 12:36:02 -0500
Message-ID: <56704F82.6060405@redhat.com>
References: <1447700076-795-1-git-send-email-yuval.shaia@oracle.com>
 <CAAk-MO_AjkaktRRXEPWSGTqf6t2F_0xS8OFVh_8PN4tyYRMZSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hod3t3osGBRhuA2R6IrbavvbFgBbhwKca"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO_AjkaktRRXEPWSGTqf6t2F_0xS8OFVh_8PN4tyYRMZSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hod3t3osGBRhuA2R6IrbavvbFgBbhwKca
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/17/2015 01:45 AM, Erez Shitrit wrote:
> On Mon, Nov 16, 2015 at 8:54 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> w=
rote:
>> Expecting half of the queue to be empty before reopening netif_queue s=
eems
>> too high.
>> With this fix threshold will be 90%.
>=20
> Is this backed by tests? why not 75% or 25%?

Much like Erez, I suspect this is a bad change.  Unless there are
performance numbers to show that under heavy usage this is actually a
positive change, I'm not inclined to take it.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hod3t3osGBRhuA2R6IrbavvbFgBbhwKca
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCAAGBQJWcE+CAAoJELgmozMOVy/dKZwP92HkvxUK8dbXKLDUEg8Jl71g
w5lNmTazkQa/+obe8+3l3+ks6L3WtEtTroM088mHO6xWfFM01ujuhJ12EBhYbfwW
stKfrZ5Abd5gFgrVyHrRvxGumHyFhEG8mRIfudSaS9OHo2Zx/+sRbcyn5860xqcE
UqrIKNUIRbasQwQrfmxT+uBldoxupo7d1jsjKXAXOO19RpLiVKZAaxiZTvEe09bu
hrAdlQoIUdV6V1Vpzzf6RegrAOGpskZ8/yTQCS0EztVMLQHuv3Sm2hDRO5ku87bG
2EvBGUJVOkt1rbAob23JIfUK7vHoa94p/HISJ+i4z1bGFCRTcS2pw5q8Z7Hoeszm
ZPzXHgCNUiLc53H6thd6zUTOCkKshO74CwcNBF58OK73UnQ51avnvniCQjaiZiaB
Cn0vfh9H+Y3loVBWPzVX2/SvCnG9TpJ7plN7hP6ysrp48Dkd5Xwd8b5muOdNivQz
YIGg98zVN6AFWJ6FBZEBshJkXRJT113JnXAkx3atSoIid2tv3smuqrrWITqIzyKX
L7KctJXgL0TFWOgtqeNppd4TeX35fP/nyiVrqjK9IwFaEy0Ocms7qeRxZYTCrsJX
+jQVQEfMVGyTq6t433qqQwKjKqFImfwtiUwUw3jv5sFoiR3n1J7Ku5dzr1RRa5Sb
03Hmhu53nE+maNxD5tU=
=RVG/
-----END PGP SIGNATURE-----

--hod3t3osGBRhuA2R6IrbavvbFgBbhwKca--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
