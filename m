From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] IB/rxe: avoid double kfree_skb
Date: Thu, 19 Apr 2018 22:19:54 -0400
Message-ID: <1524190794.11756.18.camel@redhat.com>
References: <1524146512-4188-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iXNr0tRF++UfrqDA956J"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524146512-4188-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, monis@mellanox.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Cc: netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-iXNr0tRF++UfrqDA956J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-19 at 10:01 -0400, Zhu Yanjun wrote:
> When skb is dropped by iptables rules, the skb is freed at the same time
> -EPERM is returned. So in softroce, it is not necessary to free skb again=
.
> Or else, crash will occur.
>=20
> The steps to reproduce:
>=20
>      server                       client
>     ---------                    ---------
>     |1.1.1.1|<----rxe-channel--->|1.1.1.2|
>     ---------                    ---------
>=20
> On server: rping -s -a 1.1.1.1 -v -C 10000 -S 512
> On client: rping -c -a 1.1.1.1 -v -C 10000 -S 512
>=20
> The kernel configs CONFIG_DEBUG_KMEMLEAK and
> CONFIG_DEBUG_OBJECTS are enabled on both server and client.
>=20
> When rping runs, run the following command in server:
>=20
> iptables -I OUTPUT -p udp  --dport 4791 -j DROP
>=20
> Without this patch, crash will occur.
>=20
> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

I have no reason to doubt your analysis, but if there are a bunch of
error paths for net_xmit and they all return with your skb still being
valid and holding a reference, and then one oddball that returns with
your skb already gone, that just sounds like a mistake waiting to happen
(not to mention a bajillion special cases sprinkled everywhere to deal
with this apparent inconsistency).

Can we get a netdev@ confirmation on this being the right solution?

> ---
>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +++
>  drivers/infiniband/sw/rxe/rxe_req.c  | 5 +++--
>  drivers/infiniband/sw/rxe/rxe_resp.c | 9 ++++++---
>  3 files changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/=
rxe/rxe_net.c
> index 9da6e37..2094434 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -511,6 +511,9 @@ int rxe_send(struct rxe_pkt_info *pkt, struct sk_buff=
 *skb)
> =20
>         if (unlikely(net_xmit_eval(err))) {
>                 pr_debug("error sending packet: %d\n", err);
> +               /* -EPERM means the skb is dropped and freed. */
> +               if (err =3D=3D -EPERM)
> +                       return -EPERM;
>                 return -EAGAIN;
>         }
> =20
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 7bdaf71..9d2efec 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -727,8 +727,9 @@ int rxe_requester(void *arg)
> =20
>                 rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
> =20
> -               if (ret =3D=3D -EAGAIN) {
> -                       kfree_skb(skb);
> +               if ((ret =3D=3D -EAGAIN) || (ret =3D=3D -EPERM)) {
> +                       if (ret =3D=3D -EAGAIN)
> +                               kfree_skb(skb);
>                         rxe_run_task(&qp->req.task, 1);
>                         goto exit;
>                 }
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index a65c996..6bdf9b2 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -742,7 +742,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>         err =3D rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
>         if (err) {
>                 pr_err("Failed sending RDMA reply.\n");
> -               kfree_skb(skb);
> +               if (err !=3D -EPERM)
> +                       kfree_skb(skb);
>                 return RESPST_ERR_RNR;
>         }
> =20
> @@ -956,7 +957,8 @@ static int send_ack(struct rxe_qp *qp, struct rxe_pkt=
_info *pkt,
>         err =3D rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
>         if (err) {
>                 pr_err_ratelimited("Failed sending ack\n");
> -               kfree_skb(skb);
> +               if (err !=3D -EPERM)
> +                       kfree_skb(skb);
>         }
> =20
>  err1:
> @@ -1141,7 +1143,8 @@ static enum resp_states duplicate_request(struct rx=
e_qp *qp,
>                         if (rc) {
>                                 pr_err("Failed resending result. This flo=
w is not handled - skb ignored\n");
>                                 rxe_drop_ref(qp);
> -                               kfree_skb(skb_copy);
> +                               if (rc !=3D -EPERM)
> +                                       kfree_skb(skb_copy);
>                                 rc =3D RESPST_CLEANUP;
>                                 goto out;
>                         }
> --=20
> 2.7.4
>=20
--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-iXNr0tRF++UfrqDA956J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrZTkoACgkQuCajMw5X
L90SaA/6AslJcXursPUjNFc3NjYTQHQyaoXir0ZoeKfgJ1oAiKPRIPEM5lFGljXz
GlNZj3gvcd1aaRWzWfJ4OgeP/MsPEhM5+2lPCBrQr0RVvlwYlrTbE707S+6qMjDS
xO+eM3OiOV3u0HDOKx6Ok1d/ZxlZTxXj/4eUEMlmmBG2N0ipkkC8O/BhtFrKNoXD
9jh9YzfjxICtT/jKMs3hP7FX8BgRwAwmO2skz+8gKb/85qdRGyzSts6M8Cvg5UDY
lmZfb3CMgU+QFbV/6YpikVX99ayWpexQwtL9G5KwAB+GzjDthzrzze8Dak3C729h
G/Nrpz2sVSxt44pWd45UR3xPxHenazMcmZH1FwAEE6Qz9XSkoBp8V+XsHScq0FRW
H42iXl/Ibw0FnzmxlZNXFqoHQTMJjtZP4nlqjjqQXuSgMcgx4yhQNoI0N4Sw7I4v
4tmRFR0G2wWSf+Bcc/3940z582zyr02Oo/PoDsr7bkJPRq0R0hE0io9FKZrkClwt
ei9XXJYFcx5sFJV5SznqCtLeK0P7JjacEVBZlqt/iojYPI8ragobWTZfS8ofrgyz
dUoS78NgPOqrDO/oVuUC0rswIYNvAM59FMY8LbhI+MSWlAUOGCGQitJTCzI1rzVo
xHfWXY1zolG1MTnF93UX8kKhcChqfMqKK9IRPFl5SQnH9D5q2aY=
=1l4w
-----END PGP SIGNATURE-----

--=-iXNr0tRF++UfrqDA956J--
