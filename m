From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 07/22] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Fri, 11 Aug 2017 21:13:22 +0300
Message-ID: <20170811181322.GI24282@mtr-leonro.local>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-8-leon@kernel.org>
 <36aea320-a018-040d-c44a-3a23d54771cd@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <36aea320-a018-040d-c44a-3a23d54771cd-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 11, 2017 at 12:46:26PM -0400, Hal Rosenstock wrote:
> On 8/11/2017 6:49 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > There is no need to carry code, which is not implemented in any
> > underlying hardware. This patch removes unimplemented node_types and
> > their respective node transport layers.
>
> We have supported IB switches and routers since day 1 of OpenIB and
> linux-rdma. Although not the original intent, there are still no in-tree
> consumers, but there are several out of tree ones. Every time this issue
> has come up in the past, it has been decided to continue to support
> them. Effectively, IB routers and switches are grandfathered.

If from day 1, they didn't care to provide such implementation, I don't
feel any obligations to care about them now.

>
> Rather than doing this, perhaps a better approach would be to supply
> some skeleton drivers for IB switch and router.

Feel free to revert this patch, once you introduce such skeleton, till
when it is dead code and should be removed.

>
> -- Hal
>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/sysfs.c |  3 ---
> >  drivers/infiniband/core/verbs.c |  5 -----
> >  include/rdma/ib_verbs.h         | 16 ++++++----------
> >  3 files changed, 6 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> > index abc5ab581f82..c43280f8d5b3 100644
> > --- a/drivers/infiniband/core/sysfs.c
> > +++ b/drivers/infiniband/core/sysfs.c
> > @@ -1146,10 +1146,7 @@ static ssize_t show_node_type(struct device *device,
> >  	switch (dev->node_type) {
> >  	case RDMA_NODE_IB_CA:	  return sprintf(buf, "%d: CA\n", dev->node_type);
> >  	case RDMA_NODE_RNIC:	  return sprintf(buf, "%d: RNIC\n", dev->node_type);
> > -	case RDMA_NODE_USNIC:	  return sprintf(buf, "%d: usNIC\n", dev->node_type);
> >  	case RDMA_NODE_SNIC_UDP: return sprintf(buf, "%d: usNIC UDP\n", dev->node_type);
> > -	case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_type);
> > -	case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_type);
> >  	default:		  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
> >  	}
> >  }
> > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > index 3d1de62de839..21fef6b6d4f3 100644
> > --- a/drivers/infiniband/core/verbs.c
> > +++ b/drivers/infiniband/core/verbs.c
> > @@ -182,13 +182,9 @@ rdma_node_get_transport(enum rdma_node_type node_type)
> >  {
> >  	switch (node_type) {
> >  	case RDMA_NODE_IB_CA:
> > -	case RDMA_NODE_IB_SWITCH:
> > -	case RDMA_NODE_IB_ROUTER:
> >  		return RDMA_TRANSPORT_IB;
> >  	case RDMA_NODE_RNIC:
> >  		return RDMA_TRANSPORT_IWARP;
> > -	case RDMA_NODE_USNIC:
> > -		return RDMA_TRANSPORT_USNIC;
> >  	case RDMA_NODE_USNIC_UDP:
> >  		return RDMA_TRANSPORT_USNIC_UDP;
> >  	default:
> > @@ -207,7 +203,6 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
> >  	case RDMA_TRANSPORT_IB:
> >  		return IB_LINK_LAYER_INFINIBAND;
> >  	case RDMA_TRANSPORT_IWARP:
> > -	case RDMA_TRANSPORT_USNIC:
> >  	case RDMA_TRANSPORT_USNIC_UDP:
> >  		return IB_LINK_LAYER_ETHERNET;
> >  	default:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 6cd2b91b8fc8..7aabec3a8a19 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -95,12 +95,9 @@ struct ib_gid_attr {
> >
> >  enum rdma_node_type {
> >  	/* IB values map to NodeInfo:NodeType. */
> > -	RDMA_NODE_IB_CA 	= 1,
> > -	RDMA_NODE_IB_SWITCH,
> > -	RDMA_NODE_IB_ROUTER,
> > -	RDMA_NODE_RNIC,
> > -	RDMA_NODE_USNIC,
> > -	RDMA_NODE_USNIC_UDP,
> > +	RDMA_NODE_IB_CA		= 1,
> > +	RDMA_NODE_RNIC		= 4,
> > +	RDMA_NODE_USNIC_UDP	= 6,
> >  };
> >
> >  enum {
> > @@ -109,10 +106,9 @@ enum {
> >  };
> >
> >  enum rdma_transport_type {
> > -	RDMA_TRANSPORT_IB,
> > -	RDMA_TRANSPORT_IWARP,
> > -	RDMA_TRANSPORT_USNIC,
> > -	RDMA_TRANSPORT_USNIC_UDP
> > +	RDMA_TRANSPORT_IB		= 0,
> > +	RDMA_TRANSPORT_IWARP		= 1,
> > +	RDMA_TRANSPORT_USNIC_UDP	= 3,
> >  };
> >
> >  enum rdma_protocol_type {
> >

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmN88IACgkQ5GN7iDZy
WKcEaRAAmJPXPpIyfPh3iU8hDzhyQhVCz/uZY3LvZiTP7/OKlm3bjTUKHFBrA/gk
MpdR5y+Al7pyj7G7XfO6/OBCI2h4sHYv0AijJbRou8aFU9TUEHLfn9KQQgFjVQ+K
q0p1e7PZHhrvfVin5bjrfx0v2Ww9toDIHQoCpR2rrPgrhqc5wI4kKCKwFfuIEszn
KM3X4Itv69cEsutgUD4GVhq4ZiMzI/a8Ef+zRcsur4YJgTROAgT5zCDEI5hsHFkB
Wb6/uRRDss/6FfrIofUeVSzSeLG4Mg/L0MLsHdn503ar+lmPMY4X6H/GNbPwuGD8
PcTy/UuK5fimthVQij7MY/Q1l9RXzhW0hsUa8QTyxgsI9nxet0bovEvUrqHIooC6
gH1w0iKVgqgYdWV5t/g1k6k/+ffpQUPmnY7NbFQox3SlBBJHk+7HY7tbC/Af9SKA
TpUG2eq9Yl0Eh5RyYN07zB5+vFy/HGqEV5eHBWCgynLOtWFrfUw0LksZjEIiynPL
8fIQBH6tc9sud3X/p9oCJDcfsKhXy2BQbRpVNPdMgDWHIjCTt6VJbMS+C3B+ypT2
/PdUHAD5dY7Sdi7rxuBOjB8CX5utYWaXQgBka4c99kJeZ62bbMvuJe4oNu9potNT
lXgkiqhm8pdFeURTR64GiqfI2+0Bb4qLO1qCXb9NbuH2A/fYayo=
=Wy14
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
