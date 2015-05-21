From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/IPoIB: Support SRIOV standard configuration
Date: Thu, 21 May 2015 17:05:31 -0400
Message-ID: <1432242331.28905.67.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	 <1432225447-6536-2-git-send-email-ogerlitz@mellanox.com>
	 <20150521184613.GD6771@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4PnHCEVlZ5G0d6mlsio1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150521184613.GD6771-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-4PnHCEVlZ5G0d6mlsio1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 12:46 -0600, Jason Gunthorpe wrote:
> On Thu, May 21, 2015 at 07:24:05PM +0300, Or Gerlitz wrote:
> > Standard configuration of SRIOV VFs through the host is done over the
> > following chain of calls: libvirt --> netlink --> PF netdevice
> >=20
> > When this comes to IB/IPoIB we should normalize this into the verbs
> > framework so we further go: PF IPoIB --> verbs API --> PF HW driver
> >=20
> > Virtualization systems assign VMs 48 bits mac, to allow working with
> > non-modified SW layers (open-stack, libvirt, etc), we can safely
> > extend this mac to unique 64 bits GUID. Hence the IPoIB ndo_set_vf_mac
> > entry calls the set_vf_guid verb.
> >=20
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c |   39 +++++++++++++++++++++=
++++++++
> >  include/rdma/ib_verbs.h                   |    4 +++
> >  2 files changed, 43 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infini=
band/ulp/ipoib/ipoib_main.c
> > index 9e1b203..8f82870 100644
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -1357,6 +1357,43 @@ void ipoib_dev_cleanup(struct net_device *dev)
> >  	priv->tx_ring =3D NULL;
> >  }
> > =20
> > +static int ipoib_get_vf_config(struct net_device *dev, int vf, struct =
ifla_vf_info *ivf)
> > +{
> > +	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> > +
> > +	if (priv->ca->get_vf_config)
> > +		return priv->ca->get_vf_config(priv->ca, priv->port, vf, ivf);
> > +	else
> > +		return -EINVAL;
> > +}
> > +
> > +static int ipoib_set_vf_mac(struct net_device *dev, int queue, u8 *mac=
)
> > +{
> > +	char *raw_guid;
> > +	u64 guid =3D 0;
>=20
> This doesn't seem right at all.
>=20
> It makes no sense that a IPoIB interface with a 20 byte LLADDR would
> accept an 8 byte LLADDR only for 'ip link set vf mac'

It has to be the 8byte guid, the next 8bytes are the subnet prefix which
is set by the SM and not under driver control, and the final 4bytes are
specific to the IPoIB connection.  You could pass in all 20bytes, but
you would only be able to set 8 of them.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-4PnHCEVlZ5G0d6mlsio1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXkibAAoJELgmozMOVy/dEf4P/3omoEjDr+dQqACeMwLOYUGd
vealIAxekCS2ga0tAPgUebbxlOW7+OYgUL6l+ooFn2fAabbF+Bgb0NMo6Hbf2Tz6
Zlf06lUyDviE4HPcf7okyGbkx5zMHtNKQW/PswNoVxoVJRfAk7axSEcVYWMQfpTK
28cT6ajAd5eMlxWGhfThTboP0LRXoxDW4DxHzZyv2lsQXkNjUYoDIZJeC3ESEizZ
ZuoxO/kqdpYQ7wgDbZszBmVi/PX6h5J7z1GqAxws7Ujl5FzNkt1Ec2ajf3q4mtI/
d7X85o/TAXEk+uutkfVfv86yILz4kNLubMgjiBoAxCSYanSjJvBXRZnQHwFc4wVZ
Hw7Gujt15ANsYcsQ5dwfeO/Ved+mvM05DVQnngByfFgWD/pydlNb5/QJL72pDp+Z
N5C1CohVjq8y6rVplUJUyZxMQvYMqS0UFtmvHq+HXe7A5vMRrAQeHxG/jTO9jsep
0uB2LdDmoNz9qII9xtSX7hn/y7tISTJ/bXdGmgzTNjxEIKt8yAXa7YGJOr6If2lH
kr3P7Ah7dtroDYgB1Azg2feBo6B04Tnfv7Q11CjfDxUfPomHpiuQjCFnLtCsLIQs
ee2EZ2QCujJxa0zU3KbaEStswJgc70uo1Zx1HUobf0pjwvFeEQCshBaP2WB7BOwS
UmjlCk9JUtodXZrnKqAX
=JcWR
-----END PGP SIGNATURE-----

--=-4PnHCEVlZ5G0d6mlsio1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
