From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: remove duplicate code
Date: Sat, 22 Jul 2017 13:22:45 -0400
Message-ID: <b8850d3a-982e-3e06-aafe-58187691e5dc@redhat.com>
References: <20170607204202.GA29640@embeddedgus>
 <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4veCkSOAG9Tk783TjJsu7fbueTV7kXGFP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4veCkSOAG9Tk783TjJsu7fbueTV7kXGFP
Content-Type: multipart/mixed; boundary="XKbwmfX6MsUPHPJjecQ0DkW51xx7Tu1xW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>,
 Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <b8850d3a-982e-3e06-aafe-58187691e5dc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: remove duplicate code
References: <20170607204202.GA29640@embeddedgus>
 <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--XKbwmfX6MsUPHPJjecQ0DkW51xx7Tu1xW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/22/2017 1:20 PM, Doug Ledford wrote:
> On 6/7/2017 4:42 PM, Gustavo A. R. Silva wrote:
>> Remove duplicate code.
>>
>> Addresses-Coverity-ID: 1226951
>> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
>=20
> This patch was accepted into 4.13-rc, thanks.

Correction, this patch is in my queue for my for-next branch, only the
other patch, referenced below, made it into 4.13-rc.

> In addition, I no longer have the original email for another patch of
> yours that was also accepted into 4.13-rc.  You created the patch in a
> thread asking about the argument position for argument usage in
> ib_init_ah_from_wc().  Your comment addition was accepted as well.
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--XKbwmfX6MsUPHPJjecQ0DkW51xx7Tu1xW--

--4veCkSOAG9Tk783TjJsu7fbueTV7kXGFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4nmAAoJELgmozMOVy/dc5sQAJpxQZZyYIK9+rK8xL75Soe8
f6ve0K94Gxw9O1Rke0JERi9gWQZmKemSMZDQCnDgEEJRHGRkK+2/zo1mx05b+ysj
YOvQWPpFibf7VG3tM4yo+JqY8swwJ/ELWdAUJkKkz/2/B2V6TUfEz9VPbvpY7a0d
Ni3FAFo6mNxGOu+DzkA31NJlvJ0WsG44g24e3xU3ToD2/iwz+vjdjrjVpj5gE1ek
oJJYakFf31Ogfz6uAKXWxw9/NeQf4ygrnBdVvN3A7Zthg25s3gJJtMvxBbLe0426
a+Hxp9kQkYo3Vu6hq8h1uhDvzR82nT31KGn8eK0wDedMiCF/Pgcm3RM2MMaIw+Zf
vAXi7IgS5skuC12yHvjGVa9D/Uigby9S5d4GO9wTvCs69fiWJaUHjuHvRc744RMP
PY8WKpn3O/5B0EhTACztR9a588/00O+zHXoqIrV+KJP27hv6DvfwkDppWXfKJjMT
WpgbBFd62aJJ7qAf+12fgt7ntkov4V7Y6aJ6VLIQCuLeKg5mU7TgArc0LUzhkXo3
W5jVPE7OuMTCrmn/vo3AD4PGyWYTzezzaILHY+xkNKxyIaGeqLTUaMfxPIc94dzf
f0kr5v872u3IHE/c80ExgoA6w/AhelslWur4xVoMDKpaL/gQKGUPn/4MQbOaaMnn
BAaROs7iPnRrKsyXl2Oc
=Qbln
-----END PGP SIGNATURE-----

--4veCkSOAG9Tk783TjJsu7fbueTV7kXGFP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
