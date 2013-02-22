From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Date: Fri, 22 Feb 2013 11:50:21 +1100
Message-ID: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/ulp/ipoib/ipoib_ethtool.c between commit 7826d43f2db4
("ethtool: fix drvinfo strings set in drivers") from the  tree and commit
4b48680b5572 ("IPoIB: Add version and firmware info to ethtool
reporting") from the infiniband tree.

I fixed it up (using the latter version as it included the change to use
strlcpy) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJsDNAAoJEECxmPOUX5FEACYP/RRPtGKSumNo17bMH1UnF6Kv
qs0jvTUjtMSTubS9RgSGg27yDmEAYuCCIz2lVCmVUHr7K5QrNQchs/OeIOK4jjIb
Svmd7qYVxmeJJNn+8YhZ1WYqDH4pzAoaActMPrKM7YPoTS1POQmbyWwY1+tPkkP5
LrMe8FHyM+pX3M7cfcd6WuGxKX4LReCjQXNr8t9iajUltdrKv0m+CeMxe5A0m/CJ
kWjvaGejEPXBUabHrB+rg2VEDmshW6ZAuV8HAKidImGpjNAMpLfnEKZAX7nSU09+
iaRcSmYTyoihru8GrCxuXGN3EC8R3J5VniDORLqg5fU84wZd0cAjULmlFPO5EOB1
qK3tMoLfF7/NpngLlbasv9gwtkiGE5c1DB7KK/PWXwwzlKVskfxdCbDzQXBjLQk0
HZQNXK6XNI0Q+u2D40pqSBc406YuGIMImSONSq4aD7oVDbdQq13CFkWRyLdwuh+P
hucVIDzi/3sXMCImHXUshVKHVYcSYBoGIvpEbXZq3lb6NV2QJaVSf7nPlQJ+UBnq
3oPbmjGD7MdAnTZaUC347CKiQZSuboH4dEvuUh1FMUKWMlyVhmyg3vWaMeo/6tUU
A+EZ7LsZp/vs5arSfskcE7yPd86F5dpbjldVqESjuoXlwsshqyodroV/61p8n+pe
VMMC2rjISyvrcYGT2mxp
=zhpp
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_11_50_21_+1100_2Gtkc=8F04L1Z0xu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
