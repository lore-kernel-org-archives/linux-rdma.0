From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Fix error return code in c4iw_rdev_open()
Date: Thu, 8 Dec 2016 10:05:07 -0500
Message-ID: <795074fd-0788-e896-0847-9ec5387d7f47@redhat.com>
References: <1474072897-30502-1-git-send-email-weiyj.lk@gmail.com>
 <50446B79-8354-435D-AA7D-1084D6E52200@ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hk9s2A7AokLier5gCaEf2ORoiujpVrVMr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50446B79-8354-435D-AA7D-1084D6E52200-/Yg/VP3ZvrM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hk9s2A7AokLier5gCaEf2ORoiujpVrVMr
Content-Type: multipart/mixed; boundary="pWrv0QGciAEPgIBfRHEcBCBkkOhmkl0MF";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <795074fd-0788-e896-0847-9ec5387d7f47-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Fix error return code in c4iw_rdev_open()
References: <1474072897-30502-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 <50446B79-8354-435D-AA7D-1084D6E52200-/Yg/VP3ZvrM@public.gmane.org>
In-Reply-To: <50446B79-8354-435D-AA7D-1084D6E52200-/Yg/VP3ZvrM@public.gmane.org>

--pWrv0QGciAEPgIBfRHEcBCBkkOhmkl0MF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/16/2016 11:20 PM, Steve Wise wrote:
>=20
>> On Sep 16, 2016, at 7:41 PM, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Fix to return error code -ENOMEM from the __get_free_page() error
>> handling case instead of 0, as done elsewhere in this function.
>>
>> Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixe=
s")
>> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--pWrv0QGciAEPgIBfRHEcBCBkkOhmkl0MF--

--hk9s2A7AokLier5gCaEf2ORoiujpVrVMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYSXajAAoJELgmozMOVy/d0PUQAIX7IBnzGxx9FDyXg1sv6qBy
H1tQCV7mL5/dwPCw4MdSiBAcEUoAj99NvBSKmSUw+Wol96T7qjEQjHc5dn7HX673
QFIiEzTT2t9W3ig20hYpuR5Pkj6V6gn6gIsduun1M0+hH+dlMJOapX6QvMJ61cbl
6r0ggJXgymwJZrTY7lTLVms5Dq4mPhW1w7E6XUH0ZdSV3e9Iy5x/yU+niJJkkBH0
QsRIl5beXaIzFiqeCjZTT+vz8srQZXngzPC27o1wwZ1HXddVJA/qdbU8QfjKwNcg
UK0JwPzZrejAuMXnyxjaBjBGukXUpzSgp2rc+Yno+5QTZRfauoJJ/rhcjpR7mfHy
5cyeuPIop9WjBSDxrjGC8a5NlSn/IPMFEvKVsMT3BednxLMhYcuRtF+7XxsrLVnX
Q/qQgeo5XccagKvwfCdJZmulOhRZ1b/VFxpeejMm/IkNTUd3wKFqmbyvPRfphoVb
oqPNLfALkk8+B9ooF59v8Tk/jLFuj77TLWApNGb86QWXcFBo6MXgSJsuf7QupPQB
tH3Kwc+3/jhiVMX30XdY6TSu4rq7K/2rg0in5kdPq654bavJbmGz/BYBKw/1ZmGE
QP3Xna6zhdy3psiDpabhbolwb+E8Z34dD4uukqAI1JTqXakY2ptQmdKyYSeZhs+Z
sv1tNU/h/wy8X/ufxTIx
=+Hsj
-----END PGP SIGNATURE-----

--hk9s2A7AokLier5gCaEf2ORoiujpVrVMr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
