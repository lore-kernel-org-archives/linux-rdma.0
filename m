From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 10/13] ib/core: Enforce PKey security on
 management datagrams
Date: Thu, 7 Apr 2016 23:39:56 +0300
Message-ID: <20160407203956.GA12844@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-11-git-send-email-danielj@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459985638-37233-11-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 02:33:55AM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Allocate and free a security context when creating and destroying a MAD
> agent.  This context is used for controlling access to PKeys.
>=20
> When sending or receiving a MAD check that the agent has permission to
> access the PKey for the Subnet Prefix of the port.
>=20
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/core_priv.h     |   14 +++++++
>  drivers/infiniband/core/core_security.c |   17 ++++++++
>  drivers/infiniband/core/mad.c           |   65 +++++++++++++++++++++++++=
++---
>  3 files changed, 89 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/cor=
e/core_priv.h
> index 27f2fa8..2759a18 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -142,6 +142,11 @@ int ib_get_cached_subnet_prefix(struct ib_device *de=
vice,
>  				u64              *sn_pfx);
> =20
>  #ifdef CONFIG_SECURITY_INFINIBAND
> +int ib_security_enforce_mad_agent_pkey_access(struct ib_device *dev,

We need to find a way to shorten the name. It is insane to use such long
name.

> +					      u8 port_num,
> +					      u16 pkey_index,
> +					      struct ib_mad_agent *mad_agent);
> +

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBsWcAAoJEORje4g2clinFOMP/3elOtvZtrZHfUPIkCoTGf/W
qAVwJ/Ans4SO0d5XI1KM/LXCBEGuSttG0GBloCCDFoVJpkMP7RHr2atXl5yevgjx
e9Fm2KLJt6LLBCHO+EKbt+lUaeEBf9zeeJtfR24ZednabV0wa7dcSceGB6tX5DnS
xx/1p5jupXr237Oe4FqNVw9hAzYVPxBfmfzWY/Y8DeKY2cj0vM8XkErPDkxlCkDW
ZowJ3I3YLbfJ2C02Xh7En4U1+juUMSj92lGmuJbsJTZSQlETASNof2LdSyUZ4x3z
Bs5EF1xoH+7wlXTaL08OwrDmmH+coxuLxAWqQoDoix9GZZDJL6kSKXgaiV3kWdCr
0GtiZMOhkNGPmCpPmdoMRDUxukRFRi8qrTSz15ByPCbsjV0jaftzKAzsq/dU0DfS
Wg4kjLKooeLCHDIpeQA9a6ZASaN5nMrEDLGYcW4bO8U1tc1kEpqYHxh+j6i3avm4
YOOOFHDJn+pZIF5kXYtLKy7lCtIT1FxwdY4sCGsJBRXIPdHUsJQr4Qo6wDCENi5w
fOIq2y/Lw0ApXsyAlh/ZZfud/Bdoyw0sNaBwsyA3aXy2cnMkie1Q3f38ECky9zJR
kLquLpm0UI2uKL8/6xlfmdEr2QGCgsO1qT5MyAqdCkEMPZtVjQmVfHINnKeLRo36
CFaQCqHlatZL7NZzU20q
=lWsf
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
