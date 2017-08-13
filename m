From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 08/22] RDMA/core: Delete BUG() from unreachable flow
Date: Sun, 13 Aug 2017 14:00:17 +0300
Message-ID: <20170813110017.GX24282@mtr-leonro.local>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-9-leon@kernel.org>
 <20170813102115.GH3924@yuvallap>
 <20170813102904.GV24282@mtr-leonro.local>
 <20170813105139.GA5286@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BuGwuXnZwGGQ9GEc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813105139.GA5286@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BuGwuXnZwGGQ9GEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2017 at 01:51:41PM +0300, Yuval Shaia wrote:
> On Sun, Aug 13, 2017 at 01:29:04PM +0300, Leon Romanovsky wrote:
> > On Sun, Aug 13, 2017 at 01:21:17PM +0300, Yuval Shaia wrote:
> > > On Fri, Aug 11, 2017 at 01:49:49PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > Remove call to BUG() in case wrong node_type was provided.
> > > > This flow is unreachable, because node_types are supplied
> > > > from specific enum.
> > > >
> > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/core/verbs.c | 14 +++++---------
> > > >  1 file changed, 5 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > > > index 21fef6b6d4f3..0d359a482b13 100644
> > > > --- a/drivers/infiniband/core/verbs.c
> > > > +++ b/drivers/infiniband/core/verbs.c
> > > > @@ -180,17 +180,13 @@ EXPORT_SYMBOL(ib_rate_to_mbps);
> > > >  __attribute_const__ enum rdma_transport_type
> > > >  rdma_node_get_transport(enum rdma_node_type node_type)
> > > >  {
> > > > -	switch (node_type) {
> > > > -	case RDMA_NODE_IB_CA:
> > > > +	if (node_type == RDMA_NODE_IB_CA)
> > > >  		return RDMA_TRANSPORT_IB;
> > > > -	case RDMA_NODE_RNIC:
> > > > +
> > > > +	if (node_type == RDMA_NODE_RNIC)
> > > >  		return RDMA_TRANSPORT_IWARP;
> > >
> > > Looking at for-next, there is case for RDMA_NODE_USNIC.
> > > Which branch this patch is based on?
> >
> > for-next, in case of RDMA_NODE_USNIC, we are using the
> > RDMA_TRANSPORT_USNIC_UDP return type.
>
> I see, but then i would expect to see these lines in the patch:
> -	case RDMA_NODE_USNIC:
> -		return RDMA_TRANSPORT_USNIC;

Please see patch #7 from this series.

Thanks

--BuGwuXnZwGGQ9GEc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmQMUEACgkQ5GN7iDZy
WKeGcQ//X1ZzfbbtY5zckbHdNzuTgQo8Ey8ApCPnuN/t93wqqnMa4MkFHJhmCO1F
bMDqFqBKY/rc/AbWx43SV5dmTXp6y4U0CIAPeIzF9wyVABshw52hfpr1BXZHlA5+
ZWxrLFW8iFo7CfSuUdr4vdjiGnT5sV7MY6p3jNCsXOPrD6TKwoAuzSvtq0mEnU0S
2J2Hw3I2L5+RFySArH85J0ipB2D2rhGMS+0XbWzIjmc7cCVOi5Lo02bM1qUFxs4s
i9JFFGo6ibLQSgP0vyHgXKhAB55WMq7HCU3AsOur9vwul1qEbUPvEdKcWhn5tF+d
VBqMyrQVqzzwEvfpwWjjf+GtjilEt+rqeTt+mNpliwlhZoHLfPJ7unApRcKjzv/E
vqchAVMyetBhdNWht9AfkXx5jKgWl+15Htj3OedHMcRsd6OkWwARup2ZXmk8hTcr
owCbeBsbyTMgBiOF2AMmWA8nYZrMWro6pO3BdfMcd49tEmwlj9ZMyJOVjCBX+ASK
N/l4yK7lL1yeU2+5Gm0p7n9H77rSCRBfVZ6qPTgIMcHlUs6zqrMZsZyMsAsKWBlj
rJflbYL+wManGxjwntsNOdRVGw0VP6sIjjnkrYx257pS4efAk4u+c+XhQSR+nvy0
9u2f/Q/xMEIrVR3opi8LzbUHH4lLrxNBrHNObsGtU6PWka/mL0o=
=FzBx
-----END PGP SIGNATURE-----

--BuGwuXnZwGGQ9GEc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
