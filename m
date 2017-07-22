From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/core: Namespace is a mandatory input
 parameter for address resolution
Date: Sat, 22 Jul 2017 13:05:35 -0400
Message-ID: <f7cb98bc-60e9-bfd4-749f-1102a45eb63b@redhat.com>
References: <20170523074845.10845-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ahs3a6MjKPWFDofRSKLHAWMLRMGkak6rq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523074845.10845-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ahs3a6MjKPWFDofRSKLHAWMLRMGkak6rq
Content-Type: multipart/mixed; boundary="TB9rDaLwE2BPbXLwiQwfu9CeukSSLc6ic";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <f7cb98bc-60e9-bfd4-749f-1102a45eb63b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/core: Namespace is a mandatory input
 parameter for address resolution
References: <20170523074845.10845-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170523074845.10845-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--TB9rDaLwE2BPbXLwiQwfu9CeukSSLc6ic
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/23/2017 3:48 AM, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> In function addr_resolve() the namespace is a required input parameter
> and not an output. It is passed later for searching the routing table
> and device addresses. Also, it shouldn't be copied back to the caller.
>=20
> Fixes: 565edd1d5555 ('IB/addr: Pass network namespace as a parameter')
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.3+
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This series has been accepted into 4.13-rc, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--TB9rDaLwE2BPbXLwiQwfu9CeukSSLc6ic--

--ahs3a6MjKPWFDofRSKLHAWMLRMGkak6rq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4XqAAoJELgmozMOVy/dr9gP/RZJYd+c2xT783s3hE7tsW53
t55DDFffzC317uJ4TPAJO4uYMW1ZbUFgpmlZOOs1gU3HP7XuO/QD7DANxOzsW+X9
dO2LrZ8ZHq+dPkSn7DLvLC7qv0TdhDNjKkmziwYVUeban9Q2Q3lTNsMpoNKHQ7LK
UNe7cOr2XPMaUly2iwCZhfV3UP2y8nbc3PE6WAcFKheMLvPhxtKzaKjeb2hvfsCo
hRdVTKg9F67pmFdMIGEw05nmi2YX9n7Jma+ipBVqfWyKsvEy6JhUdUpwR1WpucgS
UbHuZn84sLySccSgPywI9/rx0v1g7MXpsUtsUvaT/TgkWcMeuR5w9+8lBfqDS23e
peWMKi+HelKTTK7sMWWVX2/0d1H0kZLsSui1j4lrOsbT+8CKcv5+ZZcTFdh3+ybU
y9H3M+S4lXihgukY2qfIob4eUiv8GZQJhxL2Is4y+wOHJqpIQ54CifYScsM3mrYG
olLlEx5UHv5KIHPQyZreb63pMDRkWGD6b84WExecw3Xj/mwst7fQ3YYvL1MMkmh3
oRWi9W6kknIWCmES5cFbm9goM84/0rKUSuipf8yNoSlZ5PKzxFTuAsBpXAJxY2vr
YtBIDeAFI08rTsf6XqmEiEchkPi8IqavgZjK9/Nt+nhzPUnHisvJYkk+anybBjyI
T+IcX7mkz6H2zPtEcPnC
=YFG2
-----END PGP SIGNATURE-----

--ahs3a6MjKPWFDofRSKLHAWMLRMGkak6rq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
