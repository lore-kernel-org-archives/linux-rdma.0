From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 12/33] RDMA/netlink: Rename netlink callback struct
Date: Wed, 9 Aug 2017 13:06:46 -0400
Message-ID: <37e5b607-8663-fa0d-c285-5ba6f5fb3ec7@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1gbW4qRPX3pNuBkeWQ5TBcGow1AXw2SB7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-13-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1gbW4qRPX3pNuBkeWQ5TBcGow1AXw2SB7
Content-Type: multipart/mixed; boundary="EOFRmoF87lePUflt7KDLJ6x4LqXCmf1xW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <37e5b607-8663-fa0d-c285-5ba6f5fb3ec7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v1 12/33] RDMA/netlink: Rename netlink callback struct
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170809160405.25142-13-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-13-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--EOFRmoF87lePUflt7KDLJ6x4LqXCmf1xW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The RDMA netlink client infrastructure was removed and made
> obsolete the old name (ibnl_client_cbs). This patch renames
> to the more appropriate name (rdma_nl_cbs).

Maybe reword to:

The RDMA netlink client infrastructure was removed and made obsolete.
The old infrastructure defined struct ibnl_client_cbs.  Now that all
uses of this have been updated to the new infrastructure, rename the
struct to be compliant with the current stack naming standards: struct
rdma_nl_cbs.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--EOFRmoF87lePUflt7KDLJ6x4LqXCmf1xW--

--1gbW4qRPX3pNuBkeWQ5TBcGow1AXw2SB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0EmAAoJELgmozMOVy/d+HEQAJBU9L7XMJcGRQIpSjkvhUdT
QHHwYQ0gEl/oiXJ5bV6FL5HbwM13tnB8ynhvyYGrAkK5VNhjrQlZO6gRvWCI6AuB
oZQ1Y5wBvC5zN3dr3PzDTxQtfbJC/hon09CPp51kSL31wbyWwlqcyi+ioCIOerCf
9yAanOxJP20OMhJqnPepWk2jghRXYjB1xo+4AWooI0H5svcKs3+hzfD+HLGND335
0qCn6pMxZxfxl2JynO44EQ0jhlNYug/2ksL8FfgDkO7KTpjzMBl4Em5DFFmP+NOI
KdAo4tng6oJgqxmITJoq4pDmqmSsXrGdBiKwn6iFsF48Nvcr8maR9FCktnRDThGv
p+sqpdrWrvBuxkfOGE3FrrKmWRJSHBa4kxUtxCHT9nvVCRf03ByaQgE8M0nfhvNT
HJlsKcYZKMala5uuBOjaKzR0Iltb9rITAoAxeZw8np2x8315A7qj57+iUb92XKS2
R+mROUlOe29TakUXbYqoWg5nUsEp31XyWRuvwOPkDUNWFjZrnG0JDKOInVRb5mGJ
qbOKz/va7TgQh5AJ+3FVMrZW8bgkCGeqg47VyNlwY8Ni8qSjHBHuSSgNEIMhfQX2
2aJPo1EHO8/lXf2RoNL5CdsOy18nuVG4LB4hp8PiUS2dVNKUHHXVtZz8ud7wEYzd
B3nbD2z9F+56me8kl1Nh
=AJzq
-----END PGP SIGNATURE-----

--1gbW4qRPX3pNuBkeWQ5TBcGow1AXw2SB7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
