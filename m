From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix sending out loopback packet on netdev
 interface.
Date: Sat, 1 Oct 2016 19:10:03 -0400
Message-ID: <a9d00766-3815-4cb4-77ae-eaedd6e6cf8a@redhat.com>
References: <1475094282-18352-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tu1r0fDTWBBSsF59tDigX5gR6w1EONLAR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475094282-18352-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tu1r0fDTWBBSsF59tDigX5gR6w1EONLAR
Content-Type: multipart/mixed; boundary="DFMHrfKHSwjsgQwaFQM81gePgQJmwkMIn";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a9d00766-3815-4cb4-77ae-eaedd6e6cf8a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix sending out loopback packet on netdev
 interface.
References: <1475094282-18352-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1475094282-18352-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--DFMHrfKHSwjsgQwaFQM81gePgQJmwkMIn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/2016 4:24 PM, Parav Pandit wrote:
> Bug: prepare4 and prepare6 sets loopback mask in pkt_info structure
> instance of skb.
> While xmit_packet and other requester side functions use
> pkt_info from stack. Due to which loopback mask bit set to wrong
> pkt_info structure. This resuilts into sending out packet to actual
> netdev and loopback functionality is broken.
>=20
> Fix: Similar to other requester side functions, prepare() variants to
> set loopback mask bit on pkt_info structure used by other functions.
> Verified with perftest applications.
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

You're commit message had to be largely rewritten, but the code was appli=
ed.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--DFMHrfKHSwjsgQwaFQM81gePgQJmwkMIn--

--Tu1r0fDTWBBSsF59tDigX5gR6w1EONLAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EJLAAoJELgmozMOVy/d9r0P+wTdK9r6SCdfqb3lKjQlO/MG
wLObQ51pqq6yRdtC7r8RCRuxjBh3M4W2tdPQGsifRM/2Umi/+Ilics0e4VOHRrDu
Z5saBNI6uv/T7heaKGRLZvE9439JZfcz2pO6400jtGHcfruMczFc4me8Sj7hvRBk
TLBTriwaT5DBb/tZo/2cnWc2sQH36MAnIK4znJV9XpLbrk0S/D5rwlZbbo2VGhJK
u4dYg2MZRYokEg+gpZMJ+opov3deJYGzWlMva6LGnKvJwM9o4S6Zu6Bk9+chpNHD
V0hOY/JRjMHI/8raODslFKPA9JXIwTM6fYEWb+8p/SMxTHkqLWecoUPxGmXQD31W
49XUqMTnXMYxTpFiQXz18Gy8qFoyEddzKjFf1RJzQxD0kfOtDJMgS+DvHcDTv0Eu
sRC9wM4UKOmQhU0h95YI5FY6qeOHtRyqnKzQa5La31+iV6V0djBo08ihgeLNo+cA
PKctuUnk4Sbi74d0qPraN6hfy39wseQSJJDv9whl49+P4KzJwjW62TOcUWw7ELNk
uQUxcpbIIxpqiVKewrGe72XkfNawylHj6fR5K0/GWCAhnmWjZHJ8BVFOL758Rqc/
i1rQp7nOEBYD8w6KCgpsNVYAqppo3Hx+Oip8fr2f1toQ4b0j78SzC1OmDRSZ462I
09MoQ9iwL4RWsyilW8gk
=xcfh
-----END PGP SIGNATURE-----

--Tu1r0fDTWBBSsF59tDigX5gR6w1EONLAR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
