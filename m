From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 10 Jun 2015 14:37:26 -0400
Message-ID: <1433961446.71666.26.camel@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
	 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>
	 <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5X4hrF7i6nE+LvsxgRgg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-5X4hrF7i6nE+LvsxgRgg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 06:30 +0000, Liran Liss wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Hi Ira,
>=20
> OPA cannot impersonate IB; OPA node and link types have to be designated =
as such.
> In terms of MAD processing flows, both explicit (as in the handle_opa_smi=
() call below) and implicit code paths (which share IB flows - there are se=
veral cases) must make this distinction.

As far as in the kernel is concerned, the individual capability bits are
much more important.  I would actually like to do away with the
node_type variable from struct ib_device eventually.  As for user space,
where we have to maintain ABI, node_type can be IB_CA (after all, the
OPA devices are just like RoCE devices in that they implement IB VERBS
as their user visible transport, and only addressing/management is
different from link layer IB devices), link layer needs to be OPA.

> > +static enum smi_action
> > +handle_opa_smi(struct ib_mad_port_private *port_priv,
> > +	       struct ib_mad_qp_info *qp_info,
> > +	       struct ib_wc *wc,
> > +	       int port_num,
> > +	       struct ib_mad_private *recv,
> > +	       struct ib_mad_private *response)
> > +{
> ...
> > +	} else if (port_priv->device->node_type =3D=3D RDMA_NODE_IB_SWITCH)  =
<----
>=20
> --Liran


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-5X4hrF7i6nE+LvsxgRgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeIPmAAoJELgmozMOVy/dlvoQAIfQkoYOa5f7iymZ6wxQfV5x
sQVzEfjoewrDlHktb9NBhch211Hi2XN4DR+UP8IgkCf0kTP0NzUN1tMajZXAUvkR
DmkClieY0LE0X6ogJk1gwczJ/ZymKUrrss8ICgfofhBeWK1FAf8hkqv8An6YlE3k
zZRtjaf/O7qWsEfcmXwiYzLP6TQVZkadOBd00WfM8mDwPIv0x5UnQfDcAAzjfOaO
zPjSHvLeAmGn3E4fyN6UKCRmosUnu6XfaKpyE/l+jLJRAAADTEQl2VCAsR7QXqK8
E3C05MGmgUwnzg2QNV6Kakh+izlHlhqi/7GjJJkpEdWCuKh6feGgvud0cqIx4YCv
AHy56KDArXzK/VJlqZABsIF3PRB2uZjcEVeGnoiobqEW2Z5x5mHtPukIjV4geqTj
VFcv2SP9Cio0CjDBZhlwaveZmQORVcQ7ZPzNdjH6NHBNU6+qkBjgeNdNXNlFKrTb
ZFCp2SExr4l1Ib55L07yqAC8Sn9R990njrzVUxLsii8Ru3VWBHvb6xobSxywt17i
P7m34W6LBzQko9o09nA3zyuj1qyRCwkR5yiiAySucPBGAHkzCxcD3NBpClI69zgr
dYmnOHQdrWgWkJa0Y4V2n+v8qQW4lS3XBesW2lFlIjzReBmLEICAzYRMntAynQCh
2MsdNqptWjAkGcKBv5Lk
=lvlz
-----END PGP SIGNATURE-----

--=-5X4hrF7i6nE+LvsxgRgg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
