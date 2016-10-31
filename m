From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/6] IB/core: Set routable RoCE gid type for
 ipv4/ipv6 networks
Date: Mon, 31 Oct 2016 07:50:56 +0200
Message-ID: <20161031055056.GW3617@leon.nu>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
 <1477575391-20134-4-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3wyj3Xt2kUWLNC5K"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477575391-20134-4-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3wyj3Xt2kUWLNC5K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2016 at 04:36:28PM +0300, Leon Romanovsky wrote:
> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> If the underlying netowrk type is ipv4 or ipv6 and the device supports
> routable RoCE, prefer it so the traffic could cross subnets.
>
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---

Hi Doug,

Please take the following v1 of this patch where I fixed spelling error
=66rom "netowrk" to be "network".

Thanks.

=46rom 09f96ba3e9b4442cfb44dca04c6726e55525c9c3 Mon Sep 17 00:00:00 2001
=46rom: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 11 Sep 2016 06:25:10 +0000
Subject: [PATCH rdma-rc v1 3/6] IB/core: Set routable RoCE gid type for ipv=
4/ipv6
 networks

If the underlying network type is ipv4 or ipv6 and the device supports
routable RoCE, prefer it so the traffic could cross subnets.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Changed from v0:
 - fix spelling
---
 drivers/infiniband/core/cma.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 36bf50e..9ca0da0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2436,6 +2436,18 @@ static int iboe_tos_to_sl(struct net_device *ndev, i=
nt tos)
 	return 0;
 }

+static enum ib_gid_type cma_route_gid_type(enum rdma_network_type network_=
type,
+					   unsigned long supported_gids,
+					   enum ib_gid_type default_gid)
+{
+	if ((network_type =3D=3D RDMA_NETWORK_IPV4 ||
+	     network_type =3D=3D RDMA_NETWORK_IPV6) &&
+	    test_bit(IB_GID_TYPE_ROCE_UDP_ENCAP, &supported_gids))
+		return IB_GID_TYPE_ROCE_UDP_ENCAP;
+
+	return default_gid;
+}
+
 static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 {
 	struct rdma_route *route =3D &id_priv->id.route;
@@ -2461,6 +2473,8 @@ static int cma_resolve_iboe_route(struct rdma_id_priv=
ate *id_priv)
 	route->num_paths =3D 1;

 	if (addr->dev_addr.bound_dev_if) {
+		unsigned long supported_gids;
+
 		ndev =3D dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
 		if (!ndev) {
 			ret =3D -ENODEV;
@@ -2484,7 +2498,12 @@ static int cma_resolve_iboe_route(struct rdma_id_pri=
vate *id_priv)

 		route->path_rec->net =3D &init_net;
 		route->path_rec->ifindex =3D ndev->ifindex;
-		route->path_rec->gid_type =3D id_priv->gid_type;
+		supported_gids =3D roce_gid_type_mask_support(id_priv->id.device,
+							    id_priv->id.port_num);
+		route->path_rec->gid_type =3D
+			cma_route_gid_type(addr->dev_addr.network,
+					   supported_gids,
+					   id_priv->gid_type);
 	}
 	if (!ndev) {
 		ret =3D -ENODEV;
--
2.7.4


--3wyj3Xt2kUWLNC5K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFtu/AAoJEORje4g2clinrzQP/iSDgrH2N8td+G9/xcmpnl+k
e1DXcRbOxmYVZmOPfEGCtwJl9CTwCbVOSP9UCCi+TCfEiDifN/talgm08WBqwyO2
SQzVHylKdUoYN+1QCXV9zmgopbT+bktDxXrfiM2Cwsm4Y3PuDeWqzYgVCjOFt/iI
juYmPezDuT5EmVyTrTHc4DDDNmg7gQx0JiE3PAoRdhjuLeAgqOf8mjKIhLPJ1PJK
qgbPmPjIdbK8Em+Z0gYv/qgIRf6Tw/gRvgqrqcZb3LVZrkVa7Wy54ttQTZYjd1aR
CTPx/EDpXUYt/ZpD+rY/LACcOf/YHyj0BxtAcLp3YA7n1UTrRdLdztvQCqQ8Ps28
k3FPauxkuizH3DXjaqzRKFaZFWV6P7DSWBGzPRu5NIClaVtt4jrlZwD3YaM4jOU5
0Pkl5pSY+S0gqEpXVshyiNxO/xRFsy0/9z5TQDptWsXIInO0YGpZgDhckqeFJRHV
WHqOJppuBY5yetzyqLHgyMgd7Bb8Sb7JaD6o4YbyFYT5jS+aCymZ7Rx/VleOsGz4
jZn9VakLIpJpcseNcjxsTIYIHrmUl05j908QyLKVFH/1Q/yuFSI0vXEkqdNcM+PX
5acypQjXgtvV4pOsXXV3O7FoRtolIa/8RlfBOuRfErOFNyvf8ssEEmV1fvPiRzrn
aGfCuXL4V9dnVuzIso2w
=uIW/
-----END PGP SIGNATURE-----

--3wyj3Xt2kUWLNC5K--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
