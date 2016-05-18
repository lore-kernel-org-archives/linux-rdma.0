From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow steering
Date: Wed, 18 May 2016 14:40:56 -0400
Message-ID: <2cba91dc-3489-0376-fe74-a3fa1c5d63a7@redhat.com>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
 <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
 <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
 <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org>
 <2994c976-8ed1-75f9-7534-2d0e5f5303b8@redhat.com>
 <alpine.DEB.2.20.1605161123170.26453@east.gentwo.org>
 <9fa74108-e2f8-6a42-6d71-bf50b754734d@redhat.com>
 <alpine.DEB.2.20.1605181311460.14296@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1C5ndle4hpdD93K2Kb8mFMgI7F8Mtc6sr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605181311460.14296-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1C5ndle4hpdD93K2Kb8mFMgI7F8Mtc6sr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 02:12 PM, Christoph Lameter wrote:
> On Wed, 18 May 2016, Doug Ledford wrote:
>=20
>>> One can switch the interface into promiscuous mode in addition if one=

>>> wants that. Then you need CAP_NET_ADMIN.
>>
>> I've applied your patch.  I completely reworded the commit message,
>> you'll want to check that it meets your satisfaction before I issue my=

>> pull request.
>=20
> I wish I knew how to view the patch. Its not in the kernel.org git repo=
=2E
> Could you post the patches you edit or provide a link to them. See how
> Andrew Morton does it.
>=20

It's in *my* kernel.org repo.  Where you trying to see it in Linus' repo?=


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--1C5ndle4hpdD93K2Kb8mFMgI7F8Mtc6sr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPLc4AAoJELgmozMOVy/dnNYQAIi1kU/Cfz6r5xs7BOYGt/cM
lQakoj2FeZFMRxRuRdgUDi5dnHdQUl/Epv1Up9IhD69OxsZzVPWUkIixeTIKJtad
7n4sHWIPa0bu3TvEVcY3kf57ALKfaVkWCjjKA8bxKXhPRJbKIa3YJdkXDCBI64wB
fXB2W/CZTKoWpSq0PLNRXc6w3u7klWxsYYT6vRYf4LM2yVPuA9kWc47WcNYnRK4G
mXhk8+UhmeMfEKV1FGeu+suAE5cc0bVIUkgkL1IZV4LB921VCBoqucvpL8ZAFOff
5Hkq/nm2x7yTb1cJWdoLQJB1dr6CNXZwmXjqdohkwqh2Kt+USNgy0i5MBJlQbOfh
M9FsCPSuirCQSfi7q0FETbjBE+X9YAfzn1YmV1hxMmUsQm7Pe79RIcJj5Upx9nCM
EjmDxXu5cFW0oZp6waBZwZFW43AALyWeFWPUTk57qcmWvBnm4mMrie4LYdvqr57V
vsiwm9x6QHg3RH8MAePBAFHjqjp38Aax/scO1IFlf0yswRe4Wc3sdY3TY0nocdi3
9e6+ZeKyrD/Sr0Vx3FjXMrAL9vGS32I1m5laYE00c7mRRkt1g24Tp3ZA9HASCy7K
6ynLbg2wThs9OH9YTzbzicAhNLmP8Cfbu7Y1cioPQi8J8MfM7xcHUua5O+XUV5Gl
o0Mpuu9R1mmptOj4072E
=iW4W
-----END PGP SIGNATURE-----

--1C5ndle4hpdD93K2Kb8mFMgI7F8Mtc6sr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
