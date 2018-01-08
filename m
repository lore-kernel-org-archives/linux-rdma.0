From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] IB/srp: Add RDMA/CM support
Date: Mon, 08 Jan 2018 15:53:41 -0500
Message-ID: <1515444821.3403.92.camel@redhat.com>
References: <20180108185549.30377-1-bart.vanassche@wdc.com>
         <20180108185549.30377-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gTCpu89w5nLFFhRzz/Xp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108185549.30377-5-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-gTCpu89w5nLFFhRzz/Xp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-08 at 10:55 -0800, Bart Van Assche wrote:
> Since the SRP_LOGIN_REQ defined in the SRP standard is larger than
> what fits in the RDMA/CM login request private data, introduce a new
> login request format for the RDMA/CM.
>=20
> Note: since srp_daemon and ibsrpdm rely on the subnet manager and
> since there is no equivalent of the IB subnet manager in non-IB
> networks, login has to be performed manually for non-IB networks.
>=20

[ snip ]

> @@ -3390,18 +3757,29 @@ static ssize_t srp_create_target(struct device *d=
ev,
>  	if (ret < 0)
>  		goto put;
> =20
> -	ret =3D srp_parse_options(buf, target);
> +	ret =3D srp_parse_options(current->nsproxy->net_ns, buf, target);

OK, so you make the parse options stuff pass around the current
process' namespace, but earlier you have this:

> +static int srp_new_rdma_cm_id(struct srp_rdma_ch *ch)
> +{
> +	struct srp_target_port *target =3D ch->target;
> +	struct rdma_cm_id *new_cm_id;
> +	char src_addr[64], dst_addr[64];
> +	int ret;
> +
> +	new_cm_id =3D rdma_create_id(&init_net, srp_rdma_cm_handler,
ch,
> +				   RDMA_PS_TCP, IB_QPT_RC);

which clearly drops whatever namespace we are supposed to be in and
creates new cm_ids in the init namespace.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-gTCpu89w5nLFFhRzz/Xp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT2lUACgkQuCajMw5X
L90qew/7Bbn83OsZfton3Y1p05BqLAgPM9zBO9N8Q/KVVkh/YM87yNWEIjjJQeEe
U+PcKP+WBd21MNdP2R6w6mj0SJZdcYHpqm+OTRdKSm+3LcCKC02uKonc4OUYqVka
Y5rX+tows4blgdxMHhC5UWfKH3zI61lm7sv+PRjE4MY9uwfXQLW6+PtUcOUao6cZ
eSaI3Fkc9cn61nU+LiqMAbrEEiUxA22fKSsEfI6W0ICcVZnobxCbYzqM1KQcM1xS
9QKhIiLBYtwiwm3vjGyKrn97nZ/cWhlp6X3UMo6mvIbNCZYYVeDa+Z81GcKYCvIx
JxU83IZ9mq2RYvhikYeOLk+s/81LfJ2qlwCSvzqHL+mKCizoD6CnMv4mRwHagLR4
sTmraTLeOAwdCGIB1nsHVKEdbycMBxYgn+Ltgk1U7lik476nNSqH2jiDSv/9Jm3+
lyRos1Ns+ODDyET6YI2YFXfYUg4Xfnl0/C96AShRw+0ayjU6nhpduWONDDfkrBaL
VLcAP9qRSca+ZQgGI6oh4CjoATIOPPP1X/EslGFm1WoSB7dSfcyXFipK7dKX8iKL
zbimme5AfeRCaDawCIT/bBcOIMMubHqx1RIw86jIc6uLLVdsrWvr/6gj6amEKtJP
SbTF/iWCVvNHRfJMWStKZFGX11VYNgd4nl048oQx745LyWp32mQ=
=lGiU
-----END PGP SIGNATURE-----

--=-gTCpu89w5nLFFhRzz/Xp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
