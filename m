From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: libhns: userspace library for hns
Date: Wed, 16 Nov 2016 09:58:36 +0200
Message-ID: <20161116075836.GG4240@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wayzTnRSUXKNfBqd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--wayzTnRSUXKNfBqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Lijun,

I realized that didn't send this notice, while accepted your libhns into
rdma-core, so I'm sending it now to be sure that it is not missed by any
future reviewers.

---

We accepted your libhns code and didn't continue to pursue you to
correctly parse DT strings [1], mainly for the following reasons:
1. It is your private library and support of angry customers will be on you.
2. We won't accept hacks and you will be required to implement it correctly
and handle all incompatibility in out-of-tree code.
3. Once your new hns2 arrive, it should be implemented in the scope of existing
libhns. We wouldn't allow to create libhns2 without real reason (different HW).

Hope it clears now.

[1] http://marc.info/?l=linux-rdma&m=147879905628034&w=2

Thanks

--wayzTnRSUXKNfBqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLBGsAAoJEORje4g2clin+TgQAK15nJccsb+LgREENEkEizw/
Lrdf1fPQwTyCjjEzIa1o+wYXwang0alWs6Cdf9Yi7lhtDzYXcl8IuY5nvGaJdraE
5VBVV+kD7aY2uTrV0LZ2OC3jYiuzyqw2lx3QONldHSMLdd1MwlYnYkHkIyahUoSL
kuTQewvrcubCusLzr+irFwvv72cmHCe6usULm0j908lgi1FYeIsHbtN43EQZmC9e
Sri1RWzXC1R0K7jNNvO1YJzxwTBgrjTQ3+OYkkRUCyzlH4PedMoT111LF++EynXl
YNfVay/T/yt0/4AJi7/PU2ZzQiBNngnDWpzqLwoMJZn4vNOF92v5vGtM4cWYE+SL
BNvO+BapX3HTMTQ9lpA2N71fXvt/wsAi8mbfLFlZuKQg9mB70TCNK+GhQ5fF4Itt
JdbjAjKkUzUaI5G7PuUjipMK8yy9J36vXlgYyO5iuHj5vK7K/To619GQ9w6nHEp1
vmoxZxgwJtnqfFB5t2QFT9eSpIpRsBQYEJ2PQRHWC22xeLbC01qWDgszR9gjH+Br
dRmsOtn+0YKRg78B1E9np/lzQ/tukHPfuMjgJZWgJhrUV7+VRnXcx4gtlVuQWmT3
2zvftTmJ+BwMyOof5SMWEmCU0bXwfausvC5CNj1LDMvUgj4IKSD5pP6A7BPy63wm
Tyrb0QhZHOMF36xkP4O+
=f7l1
-----END PGP SIGNATURE-----

--wayzTnRSUXKNfBqd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
