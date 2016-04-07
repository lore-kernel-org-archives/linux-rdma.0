From: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Thu, 7 Apr 2016 20:39:53 +0300
Message-ID: <20160407173953.GB5808@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
 <20160407163100.GA5808@leon.nu>
 <DB5PR05MB111169883324ADC42E52C4D6C4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB111169883324ADC42E52C4D6C4900-8IvNv+8VlcBJTpKhoUy7I9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 05:03:50PM +0000, Daniel Jurgens wrote:
> On 4/7/2016 11:31 AM, Leon Romanovsky wrote:
> > On Thu, Apr 07, 2016 at 02:33:54AM +0300, Dan Jurgens wrote:
> >> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> +		kfree(qp->qp_sec);
> >> +
> >> +	return err;
> >> +}
> >> +EXPORT_SYMBOL(ib_security_create_qp_security);
> >> +
> >> +void ib_security_destroy_qp(struct ib_qp_security *sec)
> >> +{
> >> +	security_ib_qp_free_security(sec);
> >> +	kfree(sec);
> >> +}
> >=20
> > Did you want to EXPORT_SYMBOL here too?
> >=20
>=20
> It's not called from outside ib_core, I only exported the functions that
> are. ib_security_modify_qp and ib_security_create_qp security are called
> from ib_core and ib_uverbs.  ib_security_enforce_mad_agent_pkey_access
> is called from ib_mad.

So, how are you releasing the memory which is taken by
ib_security_create_qp_security ?

>=20
>=20

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBptpAAoJEORje4g2clinAz8P/0pPeudrXU+i2q3JsG4X6dPV
VCzDjvOvagT5yLcM1vLgsu8DJNmUVcwdopBkbbVlipVN6mxOXUJspTbECmD64HOo
PbEqJvAuustVAY1OrTUhm/JL6loONNDE6kXDI5zx/xQr+arMqZfWjRu0v1Alff+7
NMwfPUzNj182t6sscnhtjPsRsjfDivUSPB1q8+MjlYEM7nKy3PovSqARtBP75RvO
KqcgWOoog1IbMyCK9QO9sYdxe1tTosB+iFJr9UV7MLylYEMPVk5/jwKr77Llfdp7
uEIWY/hK/ckRB4t6mdV4bvBJ1LD7zpyTniVzCI9XAC3TI6zOe6pN2O/L7MvP66Dk
BbO2PlLOykg4b/oZY1rVF9paKkVdiX7ZUkEMk3qriHrsIWpv8b99YlM3HCEzLsDN
XHF8MGNNkcbaTW4EenCCyDkOJeULBEVZy6x2kdtONSwF/He1PgfDNXd247i+mzsA
lRN1+KDKo0/+fFSKQ7aPA01PoCy8X8aP5ILluEl3nsjkVCMjK1KtyuvR62FMEqUZ
MIO5m483II28b6p5xts9TXwVRA5S0eknvD+gEaZMFYBmxE+wrosbGD/DW4xZoxbO
iPUi9ex/kTIkuJRXqDWSeK5rg6vxnSztvmKEp6z5vGQ42EV4qJSsqGpSX+YOW391
y2j0Ud8j6UTDs/ge2sJS
=g5/8
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
