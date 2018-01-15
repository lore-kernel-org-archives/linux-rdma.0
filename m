From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs for
 multiple transports
Date: Mon, 15 Jan 2018 22:43:31 +0000
Message-ID: <VI1PR0502MB30082F945F147FF434835DF3D1EB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-3-leon@kernel.org> <20180115222215.GA18795@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115222215.GA18795-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Monday, January 15, 2018 4:22 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Parav Pandi=
t
> <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs f=
or
> multiple transports
>=20
> On Tue, Jan 09, 2018 at 01:10:57PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch introduces an API that allows legacy applications to query
> > GIDs for a rdma_cm_id which is used during connection establishment.
> >
> > GIDs are stored and created differently for IB, RoCE and iWARP transpor=
ts.
> > Therefore rdma_read_gids() returns GID for all the transports hiding
> > such internal details to caller. It is usable for client side and
> > server side connections.
> >
> > The rdma_read_gids() should not be used by any new ULPs.
>=20
> This is weird statement. Why can't we change the few callers to do whatev=
er is
> correct now?
>=20
Because rdmacm doesn't expose the GIDs. Rdmacm works on IP addresses.
It uses GIDs to internally do the binding and attachment to right ib device=
.
But GIDs are not UAPIs from rdmacm perspective.
Therefore it should not be exposed for any new ULPs/users.

> > +void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
> > +		    union ib_gid *dgid)
> > +{
> > +	struct rdma_addr *addr =3D &cm_id->route.addr;
> > +
> > +	if (!cm_id->device)
> > +		return;
>=20
> Nope. I looked at only one caller and saw this return leaks uninited kern=
el stack
> memory to userspace. Probably best to zero the sgid/dgid in the error cas=
e??
Ok. That can be done.

>=20
> > diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h index
> > fa809a7b48e7..edb1cdf2a892 100644
> > +++ b/include/rdma/ib_addr.h
> > @@ -165,6 +165,9 @@ static inline u16 rdma_vlan_dev_vlan_id(const
> > struct net_device *dev)
> >
> >  static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid
> > *gid)  {
> > +	if (!gid)
> > +		return 0;
> > +
> >  	switch (addr->sa_family) {
> >  	case AF_INET:
> >  		ipv6_addr_set_v4mapped(((struct sockaddr_in *) @@ -205,6
> +208,9 @@
> > static inline void rdma_gid2ip(struct sockaddr *out, const union
> > ib_gid *gid)  static inline void rdma_addr_get_sgid(struct rdma_dev_add=
r
> *dev_addr,
> >  				      union ib_gid *gid)
> >  {
> > +	if (!gid)
> > +		return;
>=20
> I think it would be clearer to put this test in the rdma_read_gids.
> It makes no sense to have a function with one output where the output is
> optional. Particularly when it is inlined..
Ok. Make sense to me.
>=20
> And the prior patch makes a bit more sense after looking here, but the se=
ries
> seems in the wrong order -> the patch to break rdma_addr_get_sgid should =
go
rdma_addr_get_sgid() worked only in very limited case.
Since all patches are in same series, I don't see order breaks anything. Bu=
t changing order is fine in revised series.

> after the only rocee code path in ucma is switched to use rdma_read_gids =
which
> hopefully does something similar to what it did before?
>=20
Yes, it returns IP based GID for multiple missing cases and previous simple=
 case too.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
