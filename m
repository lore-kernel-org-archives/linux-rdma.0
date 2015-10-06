From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RESEND] IB/cma: Accept connection without a valid netdev
 on RoCE
Date: Tue, 6 Oct 2015 14:27:35 -0400
Message-ID: <56141297.7010707@redhat.com>
References: <5607AC87.7070504@mellanox.com>
 <1444143360-18549-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K29S3grK9fxxu9JBJ5axvWKG5iAqovpLu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444143360-18549-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K29S3grK9fxxu9JBJ5axvWKG5iAqovpLu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/06/2015 10:56 AM, Haggai Eran wrote:
> The netdev checks recently added to RDMA CM expect a valid netdev to be=

> found for both InfiniBand and RoCE, but the code that find a netdev is
> only implemented for InfiniBand.
>=20
> Currently RoCE doesn't provide an API to find the netdev matching a
> given set of parameters, so this patch just disables the netdev enforce=
ment
> for each incoming connections when the link layer is RoCE.
>=20
> Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RD=
MA CM")
> Reported-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

> ---
> I accidentally forgot to send this to the list, so I'm sending again.
>=20
>  drivers/infiniband/core/cma.c | 54 ++++++++++++++++++++++++++++++++---=
--------
>  1 file changed, 40 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
> index b92a3c2c060b..f163ac680841 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1232,14 +1232,32 @@ static bool cma_match_private_data(struct rdma_=
id_private *id_priv,
>  	return true;
>  }
> =20
> +static bool cma_protocol_roce_dev_port(struct ib_device *device, int p=
ort_num)
> +{
> +	enum rdma_link_layer ll =3D rdma_port_get_link_layer(device, port_num=
);
> +	enum rdma_transport_type transport =3D
> +		rdma_node_get_transport(device->node_type);
> +
> +	return ll =3D=3D IB_LINK_LAYER_ETHERNET && transport =3D=3D RDMA_TRAN=
SPORT_IB;
> +}
> +
> +static bool cma_protocol_roce(const struct rdma_cm_id *id)
> +{
> +	struct ib_device *device =3D id->device;
> +	const int port_num =3D id->port_num ?: rdma_start_port(device);
> +
> +	return cma_protocol_roce_dev_port(device, port_num);
> +}
> +
>  static bool cma_match_net_dev(const struct rdma_id_private *id_priv,
>  			      const struct net_device *net_dev)
>  {
>  	const struct rdma_addr *addr =3D &id_priv->id.route.addr;
> =20
>  	if (!net_dev)
> -		/* This request is an AF_IB request */
> -		return addr->src_addr.ss_family =3D=3D AF_IB;
> +		/* This request is an AF_IB request or a RoCE request */
> +		return addr->src_addr.ss_family =3D=3D AF_IB ||
> +		       cma_protocol_roce(&id_priv->id);
> =20
>  	return !addr->dev_addr.bound_dev_if ||
>  	       (net_eq(dev_net(net_dev), &init_net) &&
> @@ -1294,6 +1312,10 @@ static struct rdma_id_private *cma_id_from_event=
(struct ib_cm_id *cm_id,
>  		if (PTR_ERR(*net_dev) =3D=3D -EAFNOSUPPORT) {
>  			/* Assuming the protocol is AF_IB */
>  			*net_dev =3D NULL;
> +		} else if (cma_protocol_roce_dev_port(req.device, req.port)) {
> +			/* TODO find the net dev matching the request parameters
> +			 * through the RoCE GID table */
> +			*net_dev =3D NULL;
>  		} else {
>  			return ERR_CAST(*net_dev);
>  		}
> @@ -1593,11 +1615,16 @@ static struct rdma_id_private *cma_new_conn_id(=
struct rdma_cm_id *listen_id,
>  		if (ret)
>  			goto err;
>  	} else {
> -		/* An AF_IB connection */
> -		WARN_ON_ONCE(ss_family !=3D AF_IB);
> -
> -		cma_translate_ib((struct sockaddr_ib *)cma_src_addr(id_priv),
> -				 &rt->addr.dev_addr);
> +		if (!cma_protocol_roce(listen_id) &&
> +		    cma_any_addr(cma_src_addr(id_priv))) {
> +			rt->addr.dev_addr.dev_type =3D ARPHRD_INFINIBAND;
> +			rdma_addr_set_sgid(&rt->addr.dev_addr, &rt->path_rec[0].sgid);
> +			ib_addr_set_pkey(&rt->addr.dev_addr, be16_to_cpu(rt->path_rec[0].pk=
ey));
> +		} else if (!cma_any_addr(cma_src_addr(id_priv))) {
> +			ret =3D cma_translate_addr(cma_src_addr(id_priv), &rt->addr.dev_add=
r);
> +			if (ret)
> +				goto err;
> +		}
>  	}
>  	rdma_addr_set_dgid(&rt->addr.dev_addr, &rt->path_rec[0].dgid);
> =20
> @@ -1635,13 +1662,12 @@ static struct rdma_id_private *cma_new_udp_id(s=
truct rdma_cm_id *listen_id,
>  		if (ret)
>  			goto err;
>  	} else {
> -		/* An AF_IB connection */
> -		WARN_ON_ONCE(ss_family !=3D AF_IB);
> -
> -		if (!cma_any_addr(cma_src_addr(id_priv)))
> -			cma_translate_ib((struct sockaddr_ib *)
> -						cma_src_addr(id_priv),
> -					 &id->route.addr.dev_addr);
> +		if (!cma_any_addr(cma_src_addr(id_priv))) {
> +			ret =3D cma_translate_addr(cma_src_addr(id_priv),
> +						 &id->route.addr.dev_addr);
> +			if (ret)
> +				goto err;
> +		}
>  	}
> =20
>  	id_priv->state =3D RDMA_CM_CONNECT;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--K29S3grK9fxxu9JBJ5axvWKG5iAqovpLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFBKXAAoJELgmozMOVy/dmmUP/2qF6VxQjYC2mg06qvkTx2Jm
9gmRBjDD4UaOjoeSYAlaR/W3TKJ7vv9Ufy+E+YkKAVBvBVm1ERUDKzPUigbKFPZE
sQp1t8YglbbGlb1MbbT1wdlkDAC48hyd7fb9zpyOC3caUrgr9QrHnU1VHUuzLB43
yAucHdxZIwCKhn68Nc8ZhUKJrM3FCUrw7KzXeoImMqP8mIu8gwrM5o0wZCCejBRt
D8RuED+b8j3ztzZag20grvzBNCSlMMS3XyyoSxlhbQS6B0uuyJ3q/rinn5698LFk
K+8Xry6xUdM1zeL/7o3iKoFatvKyDMpGD1uWwInRn5qszukY2FZuL5ImFwkjZSAH
Ndu5P2oKsf+huS7SpnE9hkTn9f5M/wLa+ck8cpwUdSsOTAA6GVCY7FEK55pQM34Z
iDvBsTByNqVYwTnemOow6JlcHNbQ0TsAjERgJ/jMnk/hXiBh350ehybtTMpg9srq
mHQvVDO559a0kY5nOJla2Kr4nS14NbuVLj/e7DShXUJ8ikemNcyinSHYwyvRqN80
uTUeKk/K0MIX/QI/BmWlNH+sLBd1txyqLXOx+GsPI4K40l7+wjawdR5ZUcKDGd98
dJzOzkmLE5kiu227wpZ1rDi9yZMhUWDbhwjFYJe/ojc1nUwJ32nmEHvOIl8PRFXJ
vn7kNQKeVSRhtbWcSMda
=pmuF
-----END PGP SIGNATURE-----

--K29S3grK9fxxu9JBJ5axvWKG5iAqovpLu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
