From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/rxe: remove unnecessary skb_clone in xmit
Date: Mon, 08 Jan 2018 17:46:13 -0500
Message-ID: <1515451573.3403.123.camel@redhat.com>
References: <1515388465-9307-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CQxcfBvR/BXLOR/rWwq9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515388465-9307-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-CQxcfBvR/BXLOR/rWwq9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-08 at 00:14 -0500, Zhu Yanjun wrote:
> In xmit, there is a skb_clone. This function copies the struct sk_buff.
> And some parameters are changed to the new skb. Then the new skb is sent
> while the old skb is freed.
>=20
> While the function skb_clone is removed, the parameter changes are made o=
n
> the old skb, then the old skb is sent. It can also work well.
>=20
> The following tests are made.
>=20
>  server                       client
> ---------                    ---------
> > 1.1.1.1|<----rxe-channel--->|1.1.1.2|
>=20
> ---------                    ---------
>=20
> On server: rping -s -a 1.1.1.1 -v -C 1000 -S 512
> On client: rping -c -a 1.1.1.1 -v -C 1000 -S 512
>=20
> The kernel config CONFIG_DEBUG_KMEMLEAK is enabled on both server
> and client.
>=20
> This test runs for several hours. There is no memory leak and the whole
> system can work well.
>=20
> As the above network, the following tests are made.
>=20
> Server: ibv_rc_pingpong -d rxe0 -g 1
> Client: ibv_rc_pingpong -d rxe0 -g 1 1.1.1.1
>=20
> The result on Server.
> Before:
> 8192000 bytes in 0.88 seconds =3D 74.36 Mbit/sec
> 1000 iters in 0.88 seconds =3D 881.30 usec/iter
>=20
> After:
> 8192000 bytes in 0.81 seconds =3D 81.15 Mbit/sec
> 1000 iters in 0.81 seconds =3D 807.62 usec/iter
>=20
> The throughput is enhanced and the latency is reduced.
>=20
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-CQxcfBvR/BXLOR/rWwq9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT9LYACgkQuCajMw5X
L924eA//ckummDbY12cdD0M+wyGARaXkNqH34Jp7Q5xHhEi6+LzsrEcP1SmJjhIp
yxSb+P3VSMk/W1nR5Vp/+UrdBKIPiEMfENOZdFGPQynpOC8/3oVHyoTZTy0talZ9
7w14xFhMyT1Yfvsgv0GCawgoXmYLP9Zarrka0odFnN80v/HvPegjVi7O2u+bCvoJ
ZtvY3V80vgWd7NJNnRTunueTaPTi+0+Ove6nk7flKxP04prZS9sFWdOPeaMT6YBV
82ValMRMpKc8sfxLtkJGMINRzuvnJSQVQcKIVYD3npckPnzUO8UznAmIWvijmJPL
XiHeDS4ycQzIiXA2tqU0vQbhjQIU4dmYHzvrzfogCbx6CfCeGU2z/VW1+hz8Wq7H
K2q4ytqzisDksulUtMvdl+rdRAoEMx1QaWxL+G0TBIwTrOHIfycg68Uy6waKbhSj
cj5uRsPTFDiPYa+PnO47FjAuZKO4VaJ1e3OvN0C42P9qm1TlZ0RBMVjgl1146eh4
MyIR1nqjsD1ym3IWhLPiGP4zYmI3QO6K8O+ARuPVS6uAbddKLfERoHcEg9w6mthL
xfNQWcRkjVvHaScZ7xAAxXAdPZFsAiSpG9JYKf6vMBhd04XpZXKJu7MipX8I5EGZ
qcX+ijAmZn9ViKSHrGJyda2YAmcJ9lUBAxJ97A7hKX9ux0o9FVY=
=yzEz
-----END PGP SIGNATURE-----

--=-CQxcfBvR/BXLOR/rWwq9--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
