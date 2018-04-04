From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2 rdma: Ignore unknown netlink attributes
Date: Wed, 4 Apr 2018 08:42:11 +0300
Message-ID: <20180404054211.GN25411@mtr-leonro.local>
References: <20180403072842.32153-1-leon@kernel.org>
 <016b01d3cb50$3adc88b0$b0959a10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fNagykWcDoSVAmSd"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <016b01d3cb50$3adc88b0$b0959a10$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Stephen Hemminger' <stephen@networkplumber.org>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'David Ahern' <dsahern@gmail.com>
List-Id: linux-rdma@vger.kernel.org


--fNagykWcDoSVAmSd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 03, 2018 at 08:32:36AM -0500, Steve Wise wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, April 3, 2018 2:29 AM
> > To: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> > <netdev@vger.kernel.org>; RDMA mailing list <linux-
> > rdma@vger.kernel.org>; David Ahern <dsahern@gmail.com>; Steve Wise
> > <swise@opengridcomputing.com>
> > Subject: [PATCH iproute2 rdma: Ignore unknown netlink attributes
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > The check if netlink attributes supplied more than maximum supported
> > is to strict and may lead to backward compatibility issues with old
> > application with a newer kernel that supports new attribute.
> >
> > CC: Steve Wise <swise@opengridcomputing.com>
> > Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  rdma/utils.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/rdma/utils.c b/rdma/utils.c
> > index a2e08e91..5c1e736a 100644
> > --- a/rdma/utils.c
> > +++ b/rdma/utils.c
> > @@ -399,7 +399,8 @@ int rd_attr_cb(const struct nlattr *attr, void *data)
> >  	int type;
> >
> >  	if (mnl_attr_type_valid(attr, RDMA_NLDEV_ATTR_MAX) < 0)
> > -		return MNL_CB_ERROR;
> > +		/* We received uknown attribute */
> > +		return MNL_CB_OK;
> >
> >  	type = mnl_attr_get_type(attr);
> >
>
> Hey Leon,
>
> So the resource parsing functions correctly ignore the unkown attrs and
> print everything else?

Yes.

>
> Looks good.
>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>

Thanks a lot.

--fNagykWcDoSVAmSd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrEZbMACgkQ5GN7iDZy
WKcuxA/6AnsfEu8V9WOLN+6v7hDjViZ//nTdi9hFwPeL/3i84vJGOST7YgXfFMsh
45mCo3gk5ucchVbWeUi9Vnf0rRDww7S8AcnWSTshsTDtcYeBb/SsR6iE+/CpU5EN
Xk7ZJ6Z5qD71xxXSfKPSuLnmS+TOyo5v/aAJs6WbIL3rHKZjEPrfui+0VrfJfqIa
MPMmGROgrNiAyhJ5/T4YPe4NSYZUHNN3pyflxV3LgsnHOkMljVzwMIHcOjeL93i4
81h9X+3k0ZBOPlYEZZkFNFZnaAldDOl1VOC0WmSlj4BpUk9bA+0EO4DSFHetNGcB
fVYuVvDK30X3wKoRdpC2XEQAlCfH0TyyO1CwQG37qerP7g1LkVfF09VZamKm8onE
uOC9+PxqiQFFH0GsTaHeGY1ng7IhdtmzbMGqqWLyNNDEm8LXftBm4PDdRuBCjpsR
/dxdMf+Ax44nlP9rcyF6/FSvowh6FIGbKaQ1AqrsGYTu0JAE7YGLWIB2ixoiIt87
i2NpWc4SQSCQiHFg7hyBRb2jObFbnDtm13nkkN/1XetejJy0WbXij+BxjdN+k7Th
O1WQl8S2fKV51mB+xUKOuE+EliADYB8GGIZ8wPAGaEXkKADgmpTmJiEsXt9JngiX
OAWVma9Jvh1CyPhLjr5uskx4MIvV9QHmNpfpBgHOELxbIDH+uo4=
=4bL+
-----END PGP SIGNATURE-----

--fNagykWcDoSVAmSd--
