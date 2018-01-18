From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs for
 multiple transports
Date: Thu, 18 Jan 2018 10:10:59 +0200
Message-ID: <20180118081059.GX13639@mtr-leonro.local>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-3-leon@kernel.org>
 <20180115222215.GA18795@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YnIutncTLXsDZs5t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180115222215.GA18795-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YnIutncTLXsDZs5t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 15, 2018 at 03:22:15PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 09, 2018 at 01:10:57PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch introduces an API that allows legacy applications to query
> > GIDs for a rdma_cm_id which is used during connection establishment.
> >
> > GIDs are stored and created differently for IB, RoCE and iWARP transports.
> > Therefore rdma_read_gids() returns GID for all the transports hiding
> > such internal details to caller. It is usable for client side and server
> > side connections.
> >
> > The rdma_read_gids() should not be used by any new ULPs.
>
> This is weird statement. Why can't we change the few callers to do
> whatever is correct now?
>
> > +void rdma_read_gids(struct rdma_cm_id *cm_id, union ib_gid *sgid,
> > +		    union ib_gid *dgid)
> > +{
> > +	struct rdma_addr *addr = &cm_id->route.addr;
> > +
> > +	if (!cm_id->device)
> > +		return;
>
> Nope. I looked at only one caller and saw this return leaks uninited
> kernel stack memory to userspace. Probably best to zero the sgid/dgid
> in the error case??
>
> > diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> > index fa809a7b48e7..edb1cdf2a892 100644
> > +++ b/include/rdma/ib_addr.h
> > @@ -165,6 +165,9 @@ static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
> >
> >  static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
> >  {
> > +	if (!gid)
> > +		return 0;
> > +
> >  	switch (addr->sa_family) {
> >  	case AF_INET:
> >  		ipv6_addr_set_v4mapped(((struct sockaddr_in *)
> > @@ -205,6 +208,9 @@ static inline void rdma_gid2ip(struct sockaddr *out, const union ib_gid *gid)
> >  static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr,
> >  				      union ib_gid *gid)
> >  {
> > +	if (!gid)
> > +		return;
>
> I think it would be clearer to put this test in the rdma_read_gids.
> It makes no sense to have a function with one output where the output
> is optional. Particularly when it is inlined..

Actually, I changed Parav's original code in this patch to be the construction
as you commented now. For me, rdma_read_gids() looked so ugly with sgid, dgid
checks so i didn't want to show it to anybody, you will see it in v1.

>
> And the prior patch makes a bit more sense after looking here, but the
> series seems in the wrong order -> the patch to break
> rdma_addr_get_sgid should go after the only rocee code path in ucma is
> switched to use rdma_read_gids which hopefully does something similar
> to what it did before?
>
> Jason

--YnIutncTLXsDZs5t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpgVpMACgkQ5GN7iDZy
WKfcxA/8Di9TR4RFZa4LA2XVV4XbuLw1oEPkiKrIIOMhc2PJQsx/qqc7ykaz57Cx
ua8ZbTz+1RuJRQZYKgLZZrRK/sswMXVKVebeJTaFXX2IF06H6WkS9BW7XGAk/wSG
4imojPIMInuLjvE89yyHrNJiAuUgXKdl0pxjHqQA0SRIG6Cc6cRSzMsVEhQSHehZ
VMnvtnCpTceU7BvgnicCHesp7w3gQ19BGCpdvD6SFzeiWRkZhfb/yiHr9iI6/AzM
FVXzJONViKPVt4jYl651qNtNttSLdBzkny9skWZcBIf36U8cGDo5fsfvqj27EXke
cTFQ3GfM+tpHl+98KF2qdQ07tcgeMjjI8n5G0ysUv8U2CKvynPC5KGDvA9KpH6Lx
riodMQJD5rrjFcNMFG31GSEf7S8T98xx6tUJExiRsnw+rGVsiIxIW20wLgdk2UCQ
5Un2C32wzp9hYJ+Gi6TGP3XS/NEnAazB9o7VT50dlYnj5DtMOFDAOvMGscksyjcP
joFpAaNk8fZdO2C6jkgQ/bAbT7Q85YyAsO5Q0013FXhObdujtVFBNUW6v7bnup+F
Y253VrmGPWGZoIXxjz6Akm9lwPSEHAvjQEmMcGCCdPAnhiyQ39QiOLhccUGs3Rjo
02oAidDvGHmVzzoxxPSclhATEwf2vYpE8gmWlPQld1QATwxRupo=
=v7FH
-----END PGP SIGNATURE-----

--YnIutncTLXsDZs5t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
