From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] RDMA/bnxt_re: report vlan_id and sl in qp1 recv
 completion
Date: Mon, 13 Nov 2017 16:28:13 -0500
Message-ID: <1510608493.3735.42.camel@redhat.com>
References: <1510127325-26879-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LNYQ4NyDz1VIvW8fKxbN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510127325-26879-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-LNYQ4NyDz1VIvW8fKxbN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-11-08 at 02:48 -0500, Devesh Sharma wrote:
> In a real RoCE v2 network it is possible to have two
> Sections of network have same IP hence same gid. However
> those may have different vlans. During connection resolution
> it is important to report the actual vlan on which the
> MAD packet was received instead of relying on other means
> to resolve vlan-id. ib_find_gid_index should not be used
> to resolve the vlan-id using sgid of the local system
> where the packet was received.
>=20
> Our device has the capability to report the actual VLAN-ID
> in the GSI qp completions. Since we have the capability our
> driver should move away from resolving the vlan-id with the
> help of SGID at the destination port.
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-LNYQ4NyDz1VIvW8fKxbN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKDm0ACgkQuCajMw5X
L93VrxAAo7gTtjyZnBOF9p0y8yYyzUtBxbG5qjRf3xw8efR2JeOU2IsEwpiTYGD2
n6GMnsCNxN3IJ5T/8JpY5ohrdCcoL6cbs2ApHbe1BvBKx10gjB8WDRu1JuNNjfEJ
w11UM06Xg3BVnZ/NMLXYRgue92d8YCQUTR+tmbEDzFksTcHGzhBVEiCMpRUeb76N
6jxSg+OYTEALrJ7E68btC3U9jwbrJlrVE1R6WpQ6HwsZw+7sA+a+Nxoaa5xsHS9k
eko+QpYxlfN8JyAArNQloKaZ2VJi6ZSnIQ4ESzHUqTAhi30e+Eayfd0BSm3N098g
7wcYXSuwTG+TFeYle6SqYlGN1dUeS/b53tUBsvBAI6TzEAVT9ZKU2u0wf9Imwtjp
vwsz6O5LGzzJ65U9wQdBhHOFuFhy8I7N88/AT6HvzXyK6JOuh67Qk2d1vBD55i0y
ojS4MMyTEsUMVpWhBF+ARg3wLZ+sSR8yoswvAuoXchIqJiPox0kbwaE38ccwizpV
cZ4fvYnSCQGbd6+e5BHybnafuTJydusbb7MiA4DTNmuNgXalNSGwqn2NC6Uzfn5b
1dzKRguhgMbBmV0pSSt25mk6wPEVnLv58KFH/IAwUCJ6h9WK9HDH3Avi7RLRdjCA
6QV2Wk9IoOo53nAx4ae3dgik66niyTL6LjrpIlBDpIIGfI5JQO4=
=V8MJ
-----END PGP SIGNATURE-----

--=-LNYQ4NyDz1VIvW8fKxbN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
