From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/13] ib/core: Enforce Infiniband device SMI
 security
Date: Thu, 7 Apr 2016 23:44:56 +0300
Message-ID: <20160407204456.GB12844@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-12-git-send-email-danielj@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-12-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 02:33:56AM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> During MAD and snoop agent registration for SMI QPs check that the
> calling process has permission to access the SMI.
>=20
> When sending and receiving MADs check that the agent has access to the
> SMI if it's on an SMI QP.  Because security policy can change it's
> possible permission was allowed when creating the agent, but no longer
> is.
>=20
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c |   52 +++++++++++++++++++++++++++++++++++=
+++++-
>  1 files changed, 51 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 907f8ee..b5f42ad 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -349,6 +349,21 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib=
_device *device,
>  		goto error3;
>  	}
> =20
> +	if (qp_type =3D=3D IB_QPT_SMI) {
> +		ret2 =3D security_ibdev_smi(device->name,
> +					  port_num,
> +					  &mad_agent_priv->agent);
> +		if (ret2) {
> +			dev_err(&device->dev,
> +				"%s: Access Denied. Err: %d\n",

Please convert it to lower case.
Can malicious user flood the system with this print?

> +				__func__,
> +				ret2);
> +
> +			ret =3D ERR_PTR(ret2);
> +			goto error4;
> +		}
> +	}
> +
>  	if (mad_reg_req) {
>  		reg_req =3D kmemdup(mad_reg_req, sizeof *reg_req, GFP_KERNEL);
>  		if (!reg_req) {
> @@ -535,6 +550,22 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib=
_device *device,
>  		goto error2;
>  	}
> =20
> +	if (qp_type =3D=3D IB_QPT_SMI) {
> +		err =3D security_ibdev_smi(device->name,
> +					 port_num,
> +					 &mad_snoop_priv->agent);
> +
> +		if (err) {
> +			dev_err(&device->dev,
> +				"%s: Access Denied. Err: %d\n",

The same as above.

> +				__func__,
> +				err);
> +
> +			ret =3D ERR_PTR(err);
> +			goto error3;
> +		}
> +	}
> +
>  	/* Now, fill in the various structures */
>  	mad_snoop_priv->qp_info =3D &port_priv->qp_info[qpn];
>  	mad_snoop_priv->agent.device =3D device;
> @@ -1248,6 +1279,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_b=
uf,
> =20
>  	/* Walk list of send WRs and post each on send list */
>  	for (; send_buf; send_buf =3D next_send_buf) {
> +		int err =3D 0;
> =20
>  		mad_send_wr =3D container_of(send_buf,
>  					   struct ib_mad_send_wr_private,
> @@ -1255,6 +1287,16 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_=
buf,
>  		mad_agent_priv =3D mad_send_wr->mad_agent_priv;
>  		pkey_index =3D mad_send_wr->send_wr.pkey_index;
> =20
> +		if (mad_agent_priv->agent.qp->qp_type =3D=3D IB_QPT_SMI)
> +			err =3D security_ibdev_smi(mad_agent_priv->agent.device->name,
> +						 mad_agent_priv->agent.port_num,
> +						 &mad_agent_priv->agent);
> +
> +		if (err) {
> +			ret =3D err;
> +			goto error;
> +		}
> +
>  		ret =3D ib_security_enforce_mad_agent_pkey_access(
>  					mad_agent_priv->agent.device,
>  					mad_agent_priv->agent.port_num,
> @@ -1997,7 +2039,15 @@ static void ib_mad_complete_recv(struct ib_mad_age=
nt_private *mad_agent_priv,
>  	struct ib_mad_send_wr_private *mad_send_wr;
>  	struct ib_mad_send_wc mad_send_wc;
>  	unsigned long flags;
> -	int ret;
> +	int ret =3D 0;
> +
> +	if (mad_agent_priv->agent.qp->qp_type =3D=3D IB_QPT_SMI)
> +		ret =3D security_ibdev_smi(mad_agent_priv->agent.device->name,
> +					 mad_agent_priv->agent.port_num,
> +					 &mad_agent_priv->agent);
> +
> +	if (ret)
> +		goto security_error;
> =20
>  	ret =3D ib_security_enforce_mad_agent_pkey_access(
>  					      mad_agent_priv->agent.device,
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBsbIAAoJEORje4g2clinncUQAIGrRlCkJfxExQuOUhmSItee
2ARnQdlp+/FVCDpinLdLmQpthssZvwEu+iZ2DxJkygdOaO5gYft+XcWzSDtn/D7D
/BDveG8PmJCa+EvD8Fcw00SP0ZMh9Dad5oZfJjTpYnDodcLTlAM7AbuquKI+aVTv
Ods34ONGJLI8R+bbswvBaMB/HEGWigAfs94soBV/4w3qtP2elvjtOt38ZzDO/SCg
h7D8Zr+X/kFX0tT3zRkR4eX6LJyaq9VgC5oNcUh9PSlmDWhpfDSralXXaoMylt59
xWRd/8+aw9neF7tCMHUi9jgxRrRUQqWAjCKQZzhhlSZtDhYuNYmhV6IQyWrMfJky
R12mFmeA4KkpDv065gruk0bvLM25Bhd1zCc3cQhQ2/BRnH4A2xF109KJLXHMjBt3
hcOp652jakQfl5p4AcpZlnfd5kTJ9EZWNsBhlBvu88DpvqmzwVhpN31ObL/Y4Q/R
z9Vu93Btt9DUSInPS1DtJmN2Wr5yhRBIPETO/Jt+TWKW0D08Q1Ot2bQWX3AO4jhi
8CPrhTKhyp3s+s4gJCjbQnUsmYwB8meyt/P+7vEV1ebmFQWmZJqp/3ZcsI3BcSLH
LJlE37xwPb8hHFVn5RAuE0HuvCwYuqrTRSinlniOqeoUTDr/DrsF4zvcovN9FhA+
NGfMAKTo3GwFjahFwUsu
=4cY+
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
