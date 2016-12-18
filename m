From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
Date: Sun, 18 Dec 2016 13:39:57 -0500
Message-ID: <6efbf7d3-234f-fe63-3ff0-942ce9571029@redhat.com>
References: <811914f1-3bcc-a0a4-e20a-86e8b5853ac7@acm.org>
 <CAG9sBKPu=R7ZeRnFD+-8jpiyVDok_MogzSF3H7mpgVZGZ9jX0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Srd1xIsgiOp0f1jLBvF2SxGaiUE3T3bIF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPu=R7ZeRnFD+-8jpiyVDok_MogzSF3H7mpgVZGZ9jX0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Srd1xIsgiOp0f1jLBvF2SxGaiUE3T3bIF
Content-Type: multipart/mixed; boundary="7ENbNSJRCC6fBnB4v6VwLV82ukEubJmpS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <6efbf7d3-234f-fe63-3ff0-942ce9571029-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
References: <811914f1-3bcc-a0a4-e20a-86e8b5853ac7-HInyCGIudOg@public.gmane.org>
 <CAG9sBKPu=R7ZeRnFD+-8jpiyVDok_MogzSF3H7mpgVZGZ9jX0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAG9sBKPu=R7ZeRnFD+-8jpiyVDok_MogzSF3H7mpgVZGZ9jX0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--7ENbNSJRCC6fBnB4v6VwLV82ukEubJmpS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/18/2016 2:10 AM, Moni Shoua wrote:
> On Fri, Dec 16, 2016 at 3:39 PM, Bart Van Assche
> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello Moni,
>>
>> Commit 7b85627b9f02 ("IB/cma: IBoE (RoCE) IP-based GID addressing") in=
troduced code that
>> dereferences an RCU pointer without using rcu_read_lock(). Can you che=
ck whether the patch
>> below is the correct way to fix this?
>>
>> Thanks,
>>
>> Bart.
>=20
> Hi Bart
> Fix looks good. Thanks
>=20
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Bart, can you please resend this patch with a proper commit message and
a SOB tag?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--7ENbNSJRCC6fBnB4v6VwLV82ukEubJmpS--

--Srd1xIsgiOp0f1jLBvF2SxGaiUE3T3bIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYVtf9AAoJELgmozMOVy/d4eoQALICMphJ5vJEeqo77n5cJn/Y
6b6xkE+lQm5Iwzz1e5/D99w419weAFelc7rappIEKaAM6YrBqT5C7oY102xaxYP9
cLBN2BEyV4DrJC9gmO6o/brmDuLdBvRcFVWzhUjgNStDsWXeycodMxBn9jMWVbQy
+TiIEPqFBub8dYv6GAxBLtvpu3SpFsY7Rj19vrCAyC7w4v4EpmqCwbscjXwCHWS2
l7iiEENLZLyEiWO8wTNTowW/BaGVNXfgi4t8AWo2eptKH5BBQ0nqcMCSryFq2co7
DJqUpF34yvrYY2hvS529Z6NZ944h0B1ESiz0MXM4kh4gn7ZX4Hk3Lg3OgA0o9Q/R
q242xSQZS2oc0nrtarFb6w0xPcTDEB95LpAxSJlwoF/C/Z7b03oLX/dLkH0S62fc
C3jStJ+1vgCXC3HAVaUti87Hv50bPLx8OeFvT6vNHwTc7P/NVaGJKYDNiWSmRISx
/0f4w9Enf+ACBfUrf93nnjf/mkcdw/KYwm2o79viQnw3Bt8VMLEYCrdrqPBhULbU
6vudPrXy0Ur/u3cYsE3EyQhqOQvsY6vxtG25hvrJA6ChbsvSRJQwc5XlzU3CYzPC
F5J6RE1KFpQX+tDrEnEAMgvc3uOIgYIe11b+vlLPlqx+HJJO4K+8YoiW7qn1Ri4N
EJ8Gui7uIiTy+nD8jR+B
=2Enw
-----END PGP SIGNATURE-----

--Srd1xIsgiOp0f1jLBvF2SxGaiUE3T3bIF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
