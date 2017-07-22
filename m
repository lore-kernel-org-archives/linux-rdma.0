From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix reference count leak when no ipv4 addresses
 are set
Date: Sat, 22 Jul 2017 14:16:13 -0400
Message-ID: <201c2ea5-3ed7-c61e-8d81-88529773df26@redhat.com>
References: <1499372531-25392-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H651eQwlA6va6Db0Jm1Ng9UK8rPk1esqo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499372531-25392-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, ariel.elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H651eQwlA6va6Db0Jm1Ng9UK8rPk1esqo
Content-Type: multipart/mixed; boundary="DhSBSrf1Sc7gbuTLqGcWdFTHcWwafKlar";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, ariel.elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
Message-ID: <201c2ea5-3ed7-c61e-8d81-88529773df26-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix reference count leak when no ipv4 addresses
 are set
References: <1499372531-25392-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1499372531-25392-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--DhSBSrf1Sc7gbuTLqGcWdFTHcWwafKlar
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/6/2017 4:22 PM, Michal Kalderon wrote:
> Once in_dev_get is called to receive in_device pointer, the
> in_device reference counter is increased, but if there are
> no ipv4 addresses configured on the net-device the ifa_list
> will be null, resulting in a flow that doesn't call in_dev_put
> to decrease the ref_cnt.
> This was exposed when running RoCE over ipv6 without any ipv4
> addresses configured
>=20
> Fixes: commit 8e3867310c90 ("IB/cma: Fix a race condition in iboe_addr_=
get_sgid()")
>=20
> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--DhSBSrf1Sc7gbuTLqGcWdFTHcWwafKlar--

--H651eQwlA6va6Db0Jm1Ng9UK8rPk1esqo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5ZtAAoJELgmozMOVy/dffYP/2P/ffh+JHc18pNo5hOqmzYe
1jfNBk7Mq9f+E+R5E4pglhFXpop6Ys7Hz02hsiJVNnNqBF8ZDDOTyN6JR43HEo2W
gE2BVuB3KRDDCG1oZhqv/j9LJ+uaOi0a+5Dj5AbVBzfDm2J8OReeRJiGIY0uacQc
V5/y//VrwJzU6MNUnuJk2I0IS+jiZ6d74crZ8uEPaxwaABxSk7/Xgal6imisiXdk
0bpafHsvyGiSs5WLQ5bT2Iew/qHyO8iatjN9gPSK4oJpCAzg+bYciqKI0oIushki
eIkHFUzqTO6wNa82881tZz3jX8nbZH/xRFKq01CkCHf8Ro10aWvZxdUJTJ1As6vN
ntwDT4cIy+3l96Dswc2ebBZXn5epJzvr/rKc8910aZzxXfyMtcx3eHI6y/U1Q/sA
vhIjrphwKNf1I1Gg6845mh/Z0834qzbTk72rcWS0BODKThjAAXwyLS4tfkMD22ms
+CwWiUBArffN28XLiPXjItsWmVUmcZhnYiijsXx5zsz5J6PcieOBLfNhvkfSGSvb
2bp70LA6PsqQ4d9WIBYfZeMzfI0D0z8cuR+BZL8bZEM0koP26uu+LROwsoTCslEq
kwdMgJtKOuAP1b5T3bnke2kSqn1mfHzK4H38wtM8D3tREmiKDA1GThVbyOtTpJyy
AjV03uHi8k6k/D2cj0Ce
=nrUT
-----END PGP SIGNATURE-----

--H651eQwlA6va6Db0Jm1Ng9UK8rPk1esqo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
