From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix a memory leak in rxe_qp_cleanup()
Date: Sun, 18 Dec 2016 13:36:11 -0500
Message-ID: <70f0e3ac-214a-c076-c264-e5951edf3864@redhat.com>
References: <f38a99cc-5643-f4dc-adfa-b81c67cae4e7@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="81dp20ah2HQEf3L73BpmU7CnbtWI367Am"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f38a99cc-5643-f4dc-adfa-b81c67cae4e7-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--81dp20ah2HQEf3L73BpmU7CnbtWI367Am
Content-Type: multipart/mixed; boundary="7CIvupOifW3ugS3XFvtpLUlrIELD6fBtc";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Message-ID: <70f0e3ac-214a-c076-c264-e5951edf3864-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix a memory leak in rxe_qp_cleanup()
References: <f38a99cc-5643-f4dc-adfa-b81c67cae4e7-HInyCGIudOg@public.gmane.org>
In-Reply-To: <f38a99cc-5643-f4dc-adfa-b81c67cae4e7-HInyCGIudOg@public.gmane.org>

--7CIvupOifW3ugS3XFvtpLUlrIELD6fBtc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/15/2016 11:15 AM, Bart Van Assche wrote:
> From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>=20
> A socket is associated with every QP by the rxe driver but sock_release=
()
> is never called. Add a call to sock_release() in rxe_qp_cleanup().
>=20
> Fixes: commit 8700e3e7c48A5 ("Add Soft RoCE driver")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks, queued for -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--7CIvupOifW3ugS3XFvtpLUlrIELD6fBtc--

--81dp20ah2HQEf3L73BpmU7CnbtWI367Am
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYVtcmAAoJELgmozMOVy/dlpYP/3gYSXBR5PqGqgqt2q7QTCkw
W+Pfc0CZ7Xdyk+z7CNWOAaO1F22ryJ8tGtgGxcZDBKjT0qvTyhOkOsPJdelrtr4l
kInEM+HP4Qy85NswnqWyIcObtRZ3RcvycELOVxZ7jcS+mzZlUyIxUP0G2w0MLRtp
H08CZ9Jzj3LdSY5D2lURlNFPDiAMf9TgX22bv6vD5KOAmpGMfO6+XwlIFxcRKtgn
Zer9lxpxea2IudO9dk2y/kkrfdOQKSZJPqtS7UojLfERq7HMm2nhrBdSmD5YXvHE
Sw8AMSddK0zgb/R1tqvwV89Gw0/56e2X/UuN9Jdtvk+jIs9COfJSSLtHIpXrmC7l
MKZj/GsZJ3z6mwmCWw/PGELHoA5nAUcJ4es5mCriUNKLY0Z/smrWw3Hb7jGWyQBq
DuwF2l2FdmL+W4WmTF7HP/NsueEDzxATIhhg/dyVMT5SlypCROyKK9I8PM7w4OBA
yYPkb802r/OPTgWmYKmIs1hyv4778MoKNOt4/WFK4MSJ2oWDcsMpAzAJYF9CYIEc
S95FFZgfXLp5QaWk38iJ0sCGgxkpOSVVtOHcY3BAtbGdMju5EC4JSPZ+AETV089N
exUsPZCRHqmyzmJGppLV7D13Rb+XjpI1KSfr3oB6ADl/RjcN6xP3nvY1C6qJBvl9
Rln74FX36UlpFnE/awUI
=8Enw
-----END PGP SIGNATURE-----

--81dp20ah2HQEf3L73BpmU7CnbtWI367Am--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
